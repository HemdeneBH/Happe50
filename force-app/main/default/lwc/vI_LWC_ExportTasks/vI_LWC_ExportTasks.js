import {api,LightningElement,track,wire} from 'lwc';
import fetchRecs from '@salesforce/apex/VI_ExportController.fetchRecs';
import exportTasks from '@salesforce/apex/VI_ExportController.exportTasks';
import {NavigationMixin} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class customListView extends NavigationMixin(LightningElement) {

    @track listRecs;
    @track initialListRecs;
    @track error;
    @track columns;

    @api recordTypeName = "";
		@api Externe = false;
    @api TableColumns;
    @api Title;

    @track sortBy;
    @track sortDirection;

    _title = 'Erreur';
    message = 'Erreur';
    variant = 'error';

    connectedCallback() {

        this.TableColumns = "[{label:'Site / Prestataire',fieldName:'VI_Site_prestataire__c',sortable:true},";
        if (this.recordTypeName === "PurePlayerTask") {
            this.TableColumns = this.TableColumns + "{type: 'url',label:'Attribué à',fieldName:'VI_OwnerIdURL__c',sortable:true,typeAttributes:{label:{fieldName:'VI_OwnerName__c'}}},";
        }
        this.TableColumns = this.TableColumns + "{label:'Date de création du parcours',fieldName:'VI_DateDeCreationDuParcours__c',sortable:true},";
        if (this.recordTypeName === "PurePlayerTask") {
            this.TableColumns = this.TableColumns + "{label:'Echéance',fieldName:'ActivityDate',sortable:true},";
        }
        this.TableColumns = this.TableColumns + "{type: 'url',label:'Objet',fieldName:'VI_TaskId__c',sortable:true,typeAttributes:{label:{fieldName:'Subject'}}},{type: 'url',label:'Associé à',fieldName:'VI_WhatIdUrl__c',sortable:true,typeAttributes:{label:{fieldName:'VI_WhatName__c'}}},{label:'Nom Client',fieldName:'VI_NomClient__c',sortable:true},{label:'Téléphone Principal',fieldName:'VI_TelephonePrincipal__c',sortable:true},{label:'Statut du parcours',fieldName:'VI_StatutDuParcours__c',sortable:true},{label:'Statut du case',fieldName:'VI_StatutDuCase__c',sortable:true},{label:'Aperçu du commentaire',fieldName:'VI_ApercuDuCommentaire__c',sortable:true}]";
        console.log('Columns are ' + this.TableColumns);
        this.columns = JSON.parse(this.TableColumns.replace(/([a-zA-Z0-9]+?):/g, '"$1":').replace(/'/g, '"'));
        console.log('Columns are ' + this.columns);
    }

    get vals() {
        return this.recordTypeName;
    }
		get externeValue() {
        return this.Externe;
    }

    @wire(fetchRecs, {
        recordTypeName: '$vals',
				isExterne: '$externeValue'

    })
    wiredRecs({
        error,
        data
    }) {
        if (data) {
            console.log('Records are ' + JSON.stringify(data));
            this.listRecs = data;
            this.initialListRecs = data;

        } else if (error) {

            this.listRecs = null;
            this.initialListRecs = null;
            this.error = error;
            console.log("error" + error);
            console.log(error.body);
            //this.error = error.message;
            this._title = 'Erreur';
            this.message = error.body.message;
            this.variant = 'error';
            console.log(error.body.message);
        }
    }

    handleKeyChange(event) {
				console.log('event.target.value '+event.target.value);
        const searchKey = event.target.value.toString().toLowerCase();
        console.log('Search Key is ' + searchKey);
        if (searchKey) {
            this.listRecs = this.initialListRecs;
            if (this.listRecs) {
                let recs = [];
                for (let rec of this.listRecs) {
                    console.log('Rec is ' + JSON.stringify(rec));
                    let valuesArray = Object.values(rec);
                    console.log('valuesArray is ' + valuesArray);

                    for (let val of valuesArray) {
												console.log('val '+val);

                        if (val.toString().toLowerCase().includes(searchKey)) {
                            recs.push(rec);
                            break;
                        }
                    }
                }
                console.log('Recs are ' + JSON.stringify(recs));
                this.listRecs = recs;
            }
        } else {
            this.listRecs = this.initialListRecs;
        }
    }

    exportTasks() {

        var el = this.template.querySelector('lightning-datatable');
        var selected = el.getSelectedRows();
        console.log('selected length ' + selected.length);
        if (selected.length === 0) {
            this._title = 'Erreur';
            this.message = 'Veuillez sélectionner au moins une tâche';
            this.variant = 'error';
            this.showNotification();
        } else {
            exportTasks
                ({
                    listTasks: selected,
                    recordTypeName: this.recordTypeName
                }).then(result => {
										this._title = 'Succès';
                    this.message = 'Un mail contenant les tâches sélectionnées vous a été envoyé';
                    this.variant = 'success';
								this.showNotification();
                })
                .catch(error => {
                    console.log("error" + error);
                    console.log(error.body);
                    //this.error = error.message;
                    this._title = 'Erreur';
                    this.message = error.body.message;
                    this.variant = 'error';
                    console.log(error.body.message);
										this.showNotification();
                });
        }
    }

    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;
        // sort direction
        this.sortDirection = event.detail.sortDirection;
        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }

    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.listRecs));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };
        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1 : -1;
        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });
        // set the sorted data to data table data
        this.listRecs = parseData;
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }

}