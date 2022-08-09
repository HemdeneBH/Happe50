import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import loadLog from '@salesforce/apex/HP_UTIL_LogConsoleController.loadLog';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chartJs';
import getConfigurationGenerique from "@salesforce/apex/HP_SM003_MetadataManager.getConfigurationGenerique";
const generateRandomNumber = () => {
    return Math.round(Math.random() * 100);
};
export default class HP_UTIL_LogConsole extends LightningElement {
    @api vue360;
    @api transactionid;
    @track startDate;
    @track endDate;
    @track username;
    @track endPoint;
    @track method ='';
    @track status = '';
    @track direction = 'INOUT';
    @track popupModal = false;
    @track logSelected={};
    @track keyWord;
    @track resultListLog = [];
    @track isLoad = false;
    @track totalApiDuration = 0;
    @track numberAPICall = 0;
    @track quickSearch;
    @track popupModalGlobalStatistic = false;
    @track showLogLimitMessage = false;
    limiteJour;
    allResultListLog;
    d3Initializing = false;
    d3Initialized = false;
    error;
    chart;
    @track
    methodOptions = [
        {value: '', label: 'ALL'},
        {value: 'GET', label: 'GET'},
        {value: 'POST', label: 'POST'},
        {value: 'PUT', label: 'PUT'}
    ];
    @track
    statusOptions = [
        {value: '', label: 'ALL'},
        {value: 'OK', label: 'OK'},
        {value: 'KO', label: 'KO'}
    ];
    @track
    directionOptions = [
        {value: 'INOUT', label: 'Input/Output'},
        {value: 'IN', label: 'Input'},
        {value: 'OUT', label: 'Output'}
    ];
    get hasData() {
        if(this.resultListLog == null || this.resultListLog.length == 0) {
            return false;
        }
        return true;
    }
    intl = new Intl.DateTimeFormat("en-GB",  
                {
                  hour12: false,
                  hour: "2-digit",
                  minute: "2-digit",
                  second:"2-digit",
                  day:"2-digit",
                  month:"2-digit",
                  year:"numeric"
                });
    renderedCallback() {
        if (this.d3Initializing) {
            return;
        }
        this.d3Initializing = true;
        Promise.all([
            loadScript(this, chartjs + '/Chart.min.js'),
            loadStyle(this, chartjs + '/Chart.min.css')
        ])
            .then(() => {
                this.d3Initialized = true;
            })
            .catch(error => {});
}
connectedCallback() {
        if(this.vue360) { 
            this.isLoad = true;
            let now  = new Date();
            now.setHours(now.getHours() - 1);
            console.info('@@ this.transactionIdListffff ' + this.transactionid);
            loadLog({
                startDate : now,
                endDate : new Date(),
                username : '',
                endPoint : '', 
                method: '',
                status : '',
                direction : 'INOUT', 
                keyWord: this.transactionid
            }).then(result => {
                this.resultListLog = JSON.parse(JSON.stringify(result));
                this.numberAPICall = this.resultListLog.length;
                for(let i = 0; i < this.resultListLog.length; i ++) {
                    this.resultListLog[i].dataFormetter = this.intl.format(new Date(this.resultListLog[i].dateCall));
                    this.totalApiDuration += this.resultListLog[i].timeExecution;
                    this.resultListLog[i].endPointTruncate = this.resultListLog[i].endPoint.length > 37
                    ? this.resultListLog[i].endPoint.substring(0, 35) + '...': this.resultListLog[i].endPoint;
                }
                this.isLoad = false;
                this.allResultListLog = this.resultListLog;
            }).catch(error => {
                console.log('@@ result error : ' + JSON.stringify(error));
                this.isLoad = false;
            });
        }
    }
    handleChange(event){
        if( event.target.name === 'startDate' ){
            this.startDate = event.target.value;
        } else if( event.target.name === 'endDate' ){
            this.endDate = event.target.value;
        }else if( event.target.name === 'username' ){
            this.username = event.target.value;
        }else if( event.target.name === 'endPoint' ){
            this.endPoint = event.target.value;
        }else if( event.target.name === 'method' ){
            this.method = event.target.value;
        }else if( event.target.name === 'status' ){
            this.status = event.target.value;
        }else if( event.target.name === 'direction' ){
            this.direction = event.target.value;
        }else if( event.target.name === 'keyWord' ){
            this.keyWord = event.target.value;
        }else if( event.target.name === 'quickSearch' ){
            this.quickSearch = event.target.value;
            this.totalApiDuration = 0;
            if(this.quickSearch == null || this.quickSearch == '') {
                this.resultListLog = this.allResultListLog;
                for(let record of this.allResultListLog) {
                    this.totalApiDuration += record.timeExecution;
                }
                this.numberAPICall = this.resultListLog.length;
                return;
            }
            this.resultListLog = [];
            for(let record of this.allResultListLog) {
                try{
                    if(record.endPoint.toLowerCase().indexOf(this.quickSearch.toLowerCase()) != -1) {
                        this.resultListLog.push(record);
                        this.totalApiDuration += record.timeExecution;
                    }
                    this.numberAPICall = this.resultListLog.length;
                } catch(e) {
                    console.log('@@ Exception ' + JSON.stringify(e));
                }
            }
            console.log('@@ result ' + this.resultListLog.length);
        }
    }
    viewDetails(event){
        for(let i = 0; i < this.resultListLog.length; i++) {
            if(this.resultListLog[i].dateCall === event.target.dataset.id) {
                this.logSelected = this.resultListLog[i];
                if(this.logSelected.responseBody != null) {
                    try{
                        this.logSelected.responseBody =  JSON.stringify( JSON.parse(this.logSelected.responseBody), null, 2);
                    }catch(e){}
                    try{
                        if(this.logSelected.responseBody != null){
                            this.logSelected.responseBody =  this.xmlFormatter(this.logSelected.responseBody);
                        }
                    } catch(e) {}  
                }
                try{
                if(this.logSelected.requestBody != null){
                    this.logSelected.requestBody =  JSON.stringify( JSON.parse(this.logSelected.requestBody), null, 2);
                }
                } catch(e) {}  
                try{
                    if(this.logSelected.requestBody != null){
                        this.logSelected.requestBody =  this.xmlFormatter(this.logSelected.requestBody);
                    }
                } catch(e) {}  
                break;
            }
        }
        this.popupModal = true;
        console.log('id => ' + event.target.dataset.id);
    }
    getIndent(level) {
        var result = '',
            i = level * 2;
        if (level < 0) {
            throw "Level is below 0";
        }
        while (i--) {
            result += ' ';
        }
        return result;
    }
    xmlFormatter(html) {
        html = html.trim();
        var result = '',
            indentLevel = 0,
            tokens = html.split(/</);
        for (var i = 0, l = tokens.length; i < l; i++) {
            var parts = tokens[i].split(/>/);
            if (parts.length === 2) {
                if (tokens[i][0] === '/') {
                    indentLevel--;
                }
                result += this.getIndent(indentLevel);
                if (tokens[i][0] !== '/') {
                    indentLevel++;
                }
                if (i > 0) {
                    result += '<';
                }
                result += parts[0].trim() + ">\n";
                if (parts[1].trim() !== '') {
                    result += this.getIndent(indentLevel) + parts[1].trim().replace(/\s+/g, ' ') + "\n";
                }
                if (parts[0].match(/^(img|hr|br)/)) {
                    indentLevel--;
                }
            } else {
                result += this.getIndent(indentLevel) + parts[0] + "\n";
            }
        }
        return result;
    }
    closePopupModal(){
        this.popupModal = false;
    }
    searchLog() {
        if(this.startDate == null || this.endDate == null){
            let evt = new ShowToastEvent({
                title: 'Error',
                message: 'Start date and end date are required !!!',
                variant: 'error'
            });
            this.dispatchEvent(evt);
            return;
        }
        let ecartDate = Math.abs(new Date(this.endDate)-(new Date(this.startDate)))/(1000*60*60*24);
        getConfigurationGenerique({ cleConfiguration:'HP_LIMITE_JOUR_LOG'})
            .then((result) => {
                this.limiteJour = result;
                if(ecartDate > this.limiteJour) {
                    let evt = new ShowToastEvent({
                        title: 'Error',


                        message: 'L\'intervalle de temps maximal entre les deux dates doit être de ' + this.limiteJour + ' jours.',
                        variant: 'error'
                    });
                    this.dispatchEvent(evt);
                    return;
                } 
                this.isLoad = true;
                loadLog({
                    startDate:this.startDate,
                    endDate:this.endDate,
                    username:this.username,
                    endPoint : this.endPoint, 
                    method: this.method,
                    status : this.status,
                    direction: this.direction,
                    keyWord: this.keyWord
                }).then(result => {
                    this.resultListLog = JSON.parse(JSON.stringify(result));
                    for(let i = 0; i < this.resultListLog.length; i ++) {
                        this.resultListLog[i].dataFormetter = this.intl.format(new Date(this.resultListLog[i].dateCall));
                        this.totalApiDuration += this.resultListLog[i].timeExecution;
                        this.resultListLog[i].endPointTruncate = this.resultListLog[i].endPoint.length > 52
                        ? this.resultListLog[i].endPoint.substring(0, 50)+ '...': this.resultListLog[i].endPoint;
                    }
                    this.isLoad = false;
                    this.allResultListLog = this.resultListLog;
                    getConfigurationGenerique({ cleConfiguration:'HP_LIMITE_NOMBRE_LOG'}).then((result) => 
                    {
                            this.showLogLimitMessage = (this.resultListLog.length == result);                    
                    })
                }).catch(error => {
                    console.log('@@ result error : ' + JSON.stringify(error));
                    this.isLoad = false;
                });
            }).catch(error => {
                console.log('error',JSON.stringify(error))
                this.isLoad = false;
        });
    } 
    closePopupModalGlobalStatistic(){
        this.popupModalGlobalStatistic = false;
    }
    openPopupModalGlobalStatistic(){
        this.popupModalGlobalStatistic = true;
        let OK = 0;
        let KO = 0;
        let timeout = 0;
        let stat = {};
        for(let data of this.resultListLog) {
            if(data.status == 408) {
                timeout ++;
            }else if(data.classCssError == 'error-log') {
                KO++;
            } else {
                OK ++;
            }
            let endpoint = data.endPoint;
            if(data.method == 'GET' || data.method == 'PUT') {
                let pos = data.endPoint.lastIndexOf("?");
                if(pos == -1) {
                    pos = data.endPoint.lastIndexOf("/");
                }
                if(pos != -1) {
                    endpoint = endpoint.substring(0, pos);
                }
            }
            if(endpoint.length > 30){
                endpoint = endpoint.substring(endpoint.length - 30);
            }
            let key = data.method + '-' + endpoint;
            let currentData = stat[key];
            if(currentData == null) {
                currentData = {max :0, totalTime :0, count : 0, ok : {totalTime :0, count : 0},
                 ko : {totalTime :0, count : 0}, timeout : {totalTime :0, count : 0}};
                stat[key] = currentData;
            }
            if(currentData.max < data.timeExecution) {
                currentData.max = data.timeExecution;
            }
            if(data.status == 408) {
                currentData.timeout.totalTime += data.timeExecution;
                currentData.timeout.count ++;
            }else if(data.classCssError == 'error-log') {
                currentData.ko.totalTime += data.timeExecution;
                currentData.ko.count ++;
            } else {
                currentData.ok.totalTime += data.timeExecution;
                currentData.ok.count ++;
            }
            currentData.totalTime += data.timeExecution;
            currentData.count ++;
        }
        console.log('@@@ stat' + JSON.stringify(stat));
        setTimeout(() => {
            this.viewChartKOKKO(OK, KO, timeout);  
        }, 500);
        setTimeout(() => {
            this.viewChartAvrageTime(stat);
        }, 800);
        setTimeout(() => {
            this.viewChartOKKOByApi(stat);
        }, 1100);
        setTimeout(() => {
            this.viewChartByHour();
        }, 1400);
    }
    viewChartAvrageTime(stat)  {
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement('canvas');
        this.template.querySelector('div.chartavrage').appendChild(canvas);
        const ctx = canvas.getContext('2d');
        let config = {};
        config.type = 'bar'; 
        config.options = {};
        config.options.responsive = true;
        config.options.legend = {};
        config.options.legend.position = 'bottom';
        config.options.animation = {};
        config.options.animation.animateScale = true;
        config.options.animation.animateRotate = true;
        config.options.title={display : true, text: 'Call API avrage & max by endpoint'};
        config.options.tooltips = {
            position: 'nearest',
            mode: 'index',
            intersect: false,
        };
        config.data= {};
        config.data.datasets=[];
        config.data.datasets[0] = {};
        config.data.datasets[0].data = [];
        config.data.datasets[0].backgroundColor = [];
        config.data.datasets[1] = {};
        config.data.datasets[1].data = [];
        config.data.datasets[1].backgroundColor = [];
        config.data.labels = [];
        let keys = Object.keys(stat);
        for(let key of keys) {
            let val = stat[key].totalTime / stat[key].count;
            config.data.datasets[0].data.push(val);
            config.data.labels.push(key);
            config.data.datasets[0].backgroundColor .push(['rgb(75, 192, 192)']);
            config.data.datasets[1].data.push(stat[key].max);
            config.data.datasets[1].backgroundColor .push(['rgb(255, 99, 132)']);
        }
        config.data.datasets[0].label = 'Avrage Time API';
        config.data.datasets[1].label = 'Max Time API';
        this.chart = new window.Chart(ctx, config);
    }
    viewChartOKKOByApi(stat) {
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement('canvas');
        this.template.querySelector('div.chartOKKOByApi').appendChild(canvas);
        const ctx = canvas.getContext('2d');
        let config = {};
        config.type = 'bar';
        config.options = {};
        config.options.responsive = true;
        config.options.legend = {};
        config.options.legend.position = 'bottom';
        config.options.animation = {};
        config.options.animation.animateScale = true;
        config.options.animation.animateRotate = true;
        config.options.title={display : true, text: 'Call API number by endpoint and status'};
        config.options.scales = {
            xAxes: [{ stacked: true }],
            yAxes: [{ stacked: true }]
          };
        config.options.tooltips = {
            position: 'nearest',
            mode: 'index',
            intersect: false,
        };
        config.data= {};
        config.data.datasets=[];
        config.data.datasets[0] = {};
        config.data.datasets[0].data = [];
        config.data.datasets[0].backgroundColor = [];
        config.data.datasets[1] = {};
        config.data.datasets[1].data = [];
        config.data.datasets[1].backgroundColor = [];
        config.data.datasets[2] = {};
        config.data.datasets[2].data = [];
        config.data.datasets[2].backgroundColor = [];
        config.data.labels = [];
        let keys = Object.keys(stat);
        for(let key of keys) {
            let val = stat[key].totalTime / stat[key].count;
            config.data.datasets[0].data.push(stat[key].ok.count);
            config.data.labels.push(key);
            config.data.datasets[0].backgroundColor .push(['rgb(75, 192, 192)']);
            config.data.datasets[1].data.push(stat[key].ko.count);
            config.data.datasets[1].backgroundColor .push(['rgb(255, 99, 132)']);
            config.data.datasets[2].data.push(stat[key].timeout.count);
            config.data.datasets[2].backgroundColor .push(['rgb(0, 0, 0)']);
        }
        config.data.datasets[0].label = 'OK';
        config.data.datasets[1].label = 'KO';
        config.data.datasets[2].label = 'Timeout';
        this.chart = new window.Chart(ctx, config);
    }
    viewChartKOKKO(ok, ko, timeout)  {
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement('canvas');
        this.template.querySelector('div.chartokko').appendChild(canvas);
        const ctx = canvas.getContext('2d');
        let config = {};
        config.type = 'doughnut';
        config.options = {};
        config.options.responsive = true;
        config.options.legend = {};
        config.options.legend.position = 'bottom';
        config.options.animation = {};
        config.options.animation.animateScale = true;
        config.options.animation.animateRotate = true;
        config.options.title={display : true, text: 'Call API Status'};
        config.options.tooltips = {
            callbacks: {
                label: function(tooltipItem, data) {
                  let dataset = data.datasets[tooltipItem.datasetIndex];
                  let total = dataset.data.reduce(function(previousValue, currentValue, currentIndex, array) {
                    return previousValue + currentValue;
                  });
                  let currentValue = dataset.data[tooltipItem.index];
                  let percentage = Math.floor(((currentValue/total) * 100)+0.5);
                  return percentage + "%";
                }
        }};
        config.data= {};
        config.data.datasets=[];
        config.data.datasets[0] = {};
        config.data.datasets[0].data = [ok, ko, timeout];
        config.data.datasets[0].backgroundColor = ['rgb(75, 192, 192)', 'rgb(255, 99, 132)', 'rgb(0, 0, 0)'];
        config.data.datasets[0].label = 'OK/KO';
        config.data.labels= ['OK', 'KO', 'Timeout'];
        this.chart = new window.Chart(ctx, config);
    }
    viewChartByHour(){
        let keys = [];
        let dataMap = {};
        for(let data of this.resultListLog) {
            let d = new Date( data.dateCall);
            let key =  d.getFullYear() + '/'+ (d.getMonth() + 1) +'/'+d.getDate()+ '-' + d.getHours() + 'h';
            if(dataMap[key] == null) {
                dataMap[key] = {ok : 0, ko : 0, timeout : 0};
                keys.push(key);
            }
            if(data.status == 408) {
                dataMap[key].timeout ++;
            } else if(data.classCssError == 'error-log') {
                dataMap[key].ko ++;
            } else {
                dataMap[key].ok ++;
            }
        }
        window.Chart.platform.disableCSSInjection = true;
        const canvas = document.createElement('canvas');
        this.template.querySelector('div.chartLineTime').appendChild(canvas);
        const ctx = canvas.getContext('2d');
        let config = {};
        config.type = 'line';
        config.options = {};
        config.options.responsive = true;
        config.options.legend = {};
        config.options.legend.position = 'bottom';
        config.options.animation = {};
        config.options.animation.animateScale = true;
        config.options.animation.animateRotate = true;
        config.options.title={display : true, text: 'Call API nu mber by Hour'};
        config.options.tooltips = {
            position: 'nearest',
            mode: 'index',
            intersect: false,
        };
        config.data= {};
        config.data.datasets=[];
        config.data.datasets[0] = {};
        config.data.datasets[0].data = [];
        config.data.labels = [];
        config.data.datasets[1] = {};
        config.data.datasets[1].data = [];
        config.data.datasets[0].borderColor = 'rgb(75, 192, 192)';
        config.data.datasets[1].borderColor = 'rgb(255, 99, 132)';
        config.data.datasets[1].backgroundColor = 'rgba(255, 99, 132,0.5)';
        config.data.datasets[0].backgroundColor = 'rgba(75, 192, 192,0.5)';
        config.data.datasets[2] = {};
        config.data.datasets[2].data = [];
        config.data.datasets[2].borderColor = 'rgb(0, 0, 0)';
        config.data.datasets[2].backgroundColor = 'rgba(0, 0, 0,0.5)';
        for(let key of keys) {
            config.data.datasets[0].data.push(dataMap[key].ok);
            config.data.labels.push(key);
            config.data.datasets[1].data.push(dataMap[key].ko);
            config.data.datasets[2].data.push(dataMap[key].timeout);
        }
        config.data.datasets[0].label = 'OK Time Evolution';
        config.data.datasets[1].label = 'KO Time Evolution';
        config.data.datasets[2].label = 'Timeout Time Evolution';
        this.chart = new window.Chart(ctx, config);
    }
}