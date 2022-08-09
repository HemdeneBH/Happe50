import { LightningElement, track, api } from 'lwc';
import EngieCommunityResource from '@salesforce/resourceUrl/EngieCommunityResources';

export default class ParcoursPPInfoComplementaires extends LightningElement {
    iconInformation = EngieCommunityResource + '/EngieAssets/pictures/icon-information.png';
    iconQuestion = EngieCommunityResource + '/EngieAssets/pictures/icon-question.png';
    Astuce = EngieCommunityResource + '/EngieAssets/pictures/picto-astuce.png';
    infoReleveBlanc = EngieCommunityResource + '/EngieAssets/pictures/info-releve-blanc.png';
    infoReleveBleu = EngieCommunityResource + '/EngieAssets/pictures/info-releve-bleu.png';
    closeImage = EngieCommunityResource + '/EngieAssets/pictures/close-icon.png';
    infosGaz = EngieCommunityResource + '/EngieAssets/pictures/infos-gaz.png';
    infosElec = EngieCommunityResource + '/EngieAssets/pictures/infos-elec.png';

    HasReleveCompteur;
    miseAJourUrgente;
    isHPHC = false;
    isGaz = false;
    isElectricite = false;
    isGazEtElectricite = false;
    isModalOpenBackgroundGaz = false;
    isModalOpenBackgroundElec = false;
    isModalGazOpen = false;
    isModalElecOpen = false;
    dateAnterieur = false;
		isEM = false;
		
    date;

    dateMinimumContrat;
    dateMaximumContrat;
    dateMinimumContratFormatDate;
    dateMaximumContratFormatDate;
    releveCompteurCompleted = false;
    releveCompteurInitialized = false;
    allFieldsNotFilled = true;
    showErrorMessage = false;

    redLabelIndexElec = false;
    redLabelIndexGaz = false;
    redLabelHC = false;
    redLabelHP = false;

    boolCallBack = false;


    @api stepsdone;

    @api
    get record() {
        return this._record;
    }
    set record(value) {
        if (value) {
            this._record = { ...value };
            
            this.handleUndefinedValues('VI_ChoixEnergie__c');
            if (this._record.VI_ChoixEnergie__c === 'Gaz') {
                this.isGaz = true;
                this.isElectricite = false;
                this.isGazEtElectricite = false;
            }
            else if (this._record.VI_ChoixEnergie__c === 'Electricité') {
                this.isElectricite = true;
                this.isGaz = false;
                this.isGazEtElectricite = false;
            }
            else if (this._record.VI_ChoixEnergie__c === 'Electricité + Gaz') {
                this.isGazEtElectricite = true;
                this.isElectricite = false;
                this.isGaz = false;
            }
						this.handleUndefinedValues('VI_ChoixParcours__c');
						if (this._record.VI_ChoixParcours__c === 'EM') {
                this.isEM = true;
            }
            else if (this._record.VI_ChoixParcours__c === 'CHF') {
                this.isEM = false;
            }

            if(this.isEM){
                var today = new Date();
                var todayDatePlus42 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                todayDatePlus42.setDate(todayDatePlus42.getDate() + 42);
                this.dateMinimumContrat=today;
                var monthMinimum=this.dateMinimumContrat.getMonth()+1;
                var dayMinimum=this.dateMinimumContrat.getDate();
                console.log("monthMinimum.length "+String(monthMinimum).length);
                console.log("dayMinimum.length "+String(dayMinimum).length);
                if(String(monthMinimum).length===1){
                    monthMinimum="0"+monthMinimum;
                }
                if(String(dayMinimum).length===1){
                    dayMinimum="0"+String(dayMinimum);
                }
                
                console.log("dayMinimum "+dayMinimum);
                console.log("monthMinimum "+monthMinimum);
                this.dateMinimumContratFormatDate=this.dateMinimumContrat.getFullYear()+"-"+monthMinimum+"-"+dayMinimum;

                this.dateMaximumContrat=todayDatePlus42;
                var monthMaximum=this.dateMaximumContrat.getMonth()+1;
                var dayMaximum=this.dateMaximumContrat.getDate();
                console.log("monthMaximum.length "+String(monthMaximum).length);
                console.log("day.length "+String(dayMaximum).length);
                if(String(monthMaximum).length===1){
                    monthMaximum="0"+monthMaximum;
                }
                if(String(dayMaximum).length===1){
                    dayMaximum="0"+String(dayMaximum);
                }
                console.log("dayMaximum "+dayMaximum);
                console.log("monthMaximum "+monthMaximum);
                this.dateMaximumContratFormatDate=this.dateMaximumContrat.getFullYear()+"-"+monthMaximum +"-"+dayMaximum;
                console.log("this.dateMinimumContrat "+this.dateMinimumContrat);
                console.log("this.dateMaximumContray "+this.dateMaximumContray);
                console.log("this.dateMinimumContratFormatDate "+this.dateMinimumContratFormatDate);
                console.log("this.dateMaximumContratFormatDate "+this.dateMaximumContratFormatDate);
            }
            else{
                var today = new Date();
                var todayDatePlus14 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                todayDatePlus14.setDate(todayDatePlus14.getDate() + 14);
                var todayDatePlus42 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                todayDatePlus42.setDate(todayDatePlus42.getDate() + 42);
                this.dateMinimumContrat=todayDatePlus14;
                var monthMinimum=this.dateMinimumContrat.getMonth()+1;
                var dayMinimum=this.dateMinimumContrat.getDate();
                console.log("monthMinimum.length "+String(monthMinimum).length);
                console.log("dayMinimum.length "+String(dayMinimum).length);
                if(String(monthMinimum).length===1){
                    monthMinimum="0"+monthMinimum;
                }
                if(String(dayMinimum).length===1){
                    dayMinimum="0"+String(dayMinimum);
                }
                
                console.log("dayMinimum "+dayMinimum);
                console.log("monthMinimum "+monthMinimum);
                this.dateMinimumContratFormatDate=this.dateMinimumContrat.getFullYear()+"-"+monthMinimum+"-"+dayMinimum;

                this.dateMaximumContrat=todayDatePlus42;
                var monthMaximum=this.dateMaximumContrat.getMonth()+1;
                var dayMaximum=this.dateMaximumContrat.getDate();
                console.log("monthMaximum.length "+String(monthMaximum).length);
                console.log("day.length "+String(dayMaximum).length);
                if(String(monthMaximum).length===1){
                    monthMaximum="0"+monthMaximum;
                }
                if(String(dayMaximum).length===1){
                    dayMaximum="0"+String(dayMaximum);
                }
                console.log("dayMaximum "+dayMaximum);
                console.log("monthMaximum "+monthMaximum);
                this.dateMaximumContratFormatDate=this.dateMaximumContrat.getFullYear()+"-"+monthMaximum +"-"+dayMaximum;
                console.log("this.dateMinimumContrat "+this.dateMinimumContrat);
                console.log("this.dateMaximumContray "+this.dateMaximumContray);
                console.log("this.dateMinimumContratFormatDate "+this.dateMinimumContratFormatDate);
                console.log("this.dateMaximumContratFormatDate "+this.dateMaximumContratFormatDate);
            }
            this.handleUndefinedValues('VI_InfosCompl_DateContratEffectif__c');
            if (this._record.VI_InfosCompl_DateContratEffectif__c !== null) {
                this.date = this._record.VI_InfosCompl_DateContratEffectif__c;
                /* Start DDPCM - 848 New Canaux */
                if (this._record.VI_ChoixParcours__c === 'CHF') {
                    if(this._record.VI_TypeParcours__c != 'PURE PLAYERS'){
                        this.dateMinimumContratFormatDate = this.date;
                        this.dateMaximumContratFormatDate = this.date;
                        console.log('this date > '+ this.date);
                        console.log('this dateMinimumContratFormatDate > '+ this.dateMinimumContratFormatDate);
                        console.log('this dateMaximumContratFormatDate > '+ this.dateMaximumContratFormatDate);
                    }
                }
                /* End DDPCM - 848 New Canaux */
            }
            else {
                /* Start DDPCM - 848 New Canaux */
                if (this._record.VI_ChoixParcours__c === 'CHF') {
                    if (this._record.VI_TypeParcours__c === 'VENTE DIRECTE' || this._record.VI_TypeParcours__c === 'STORE'){
                        var today = new Date();
                        var todayDatePlus20 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                        todayDatePlus20.setDate(todayDatePlus20.getDate() + 20);
                        var monthdate = todayDatePlus20.getMonth()+1;
                        var daydate = todayDatePlus20.getDate();
                        if(String(monthdate).length===1){
                            monthdate="0"+monthdate;
                        }
                        if(String(daydate).length===1){
                            daydate="0"+String(daydate);
                        }
                        this._record.VI_InfosCompl_DateContratEffectif__c = todayDatePlus20.getFullYear() + '-' + monthdate + '-' + daydate;
                        console.log('this._record.VI_InfosCompl_DateContratEffectif__c > '+ this._record.VI_InfosCompl_DateContratEffectif__c);
                    }
                    else if (this._record.VI_TypeParcours__c === 'DISTRIBUTION'){
                        var today = new Date();
                        var todayDatePlus30 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
                        todayDatePlus30.setDate(todayDatePlus30.getDate() + 30);
                        var monthdate = todayDatePlus30.getMonth()+1;
                        var daydate = todayDatePlus30.getDate();
                        if(String(monthdate).length===1){
                            monthdate="0"+monthdate;
                        }
                        if(String(daydate).length===1){
                            daydate="0"+String(daydate);
                        }
                        this._record.VI_InfosCompl_DateContratEffectif__c = todayDatePlus30.getFullYear() + '-' + monthdate + '-' + daydate;
                        console.log('this._record.VI_InfosCompl_DateContratEffectif__c > '+ this._record.VI_InfosCompl_DateContratEffectif__c);
                    }
                    if (this._record.VI_InfosCompl_DateContratEffectif__c !== null) {
                        this.date = this._record.VI_InfosCompl_DateContratEffectif__c;
                        console.log('this date > '+ this.date);
                        this.dateMinimumContratFormatDate = this.date;
                        this.dateMaximumContratFormatDate = this.date;
                    }
                }
                /* End DDPCM - 848 New Canaux */
            }
            this.handleUndefinedValues('VI_InfosCompl_MiseEnServiceUrgente__c');
            if (this._record.VI_InfosCompl_MiseEnServiceUrgente__c === true) {
                this.miseAJourUrgente = true;
            }
            this.handleUndefinedValues('VI_InfosCompl_PremiereMiseEnService__c');
            this.handleUndefinedValues('VI_InfosCompl_IndexElec__c');
            this.handleUndefinedValues('VI_InfosCompl_IndexGaz__c');
            this.handleUndefinedValues('VI_InfosCompl_HP_HC__c');
            if (this._record.VI_InfosCompl_HP_HC__c === true) {
                this.isHPHC = true;
            }
            else {
                this.isHPHC = false;
            }
            this.handleUndefinedValues('VI_InfosCompl_HeuresPleinesElec__c');
            this.handleUndefinedValues('VI_InfosCompl_HeuresCreusesElec__c');
            this.handleUndefinedValues('VI_InfosCompl_ChoixReleveCompteur__c');
            if (this._record.VI_InfosCompl_ChoixReleveCompteur__c === 'Saisir mes relevés') {
                this.HasReleveCompteur = true;
            }
            else if (this._record.VI_InfosCompl_ChoixReleveCompteur__c === 'Passer cette étape') {
                this.HasReleveCompteur = false;
            }
        }
        else {
            this._record = {};
        }
    }

    @api
    get recordupdated() {
        return this._recordupdated;
    }
    set recordupdated(value) {
        this._recordupdated = value;
    }

    @api
    handleRecentrer() {
        if (this.HasReleveCompteur) {
            this.template.querySelector('[data-id="RelevesCompteur"]').scrollIntoView(true);
        }
        else{
            this.template.querySelector('[data-id="infoReleve"]').scrollIntoView(true);
        }
    }

    @api
    handleInfoComp() {
        this.template.querySelector('[data-id="infoComp"]').scrollIntoView(true);
    }

    renderedCallback() {
        console.log('renderedCallback');
        let x = this.template.querySelector('[data-id="date-echeance"]').childElement;
        console.log('x'+ x);
        console.log(x);
        let y = this.template.querySelector('lightning-button-icon');
        console.log('y'+ y);
        console.log(y);
    }

    handleUndefinedValues(recordField) {
        if (typeof this._record[recordField] === "undefined") {
            this._record[recordField] = null;
        }
    }

    handleButtonClick() {
        this.recordupdated = true;
        this.HasReleveCompteur = true;
        this.checkReleveValues();
        this._record.VI_InfosCompl_ChoixReleveCompteur__c = 'Saisir mes relevés';
    }

    checkvalidity(event) {
        var charval = String.fromCharCode(event.keyCode);
        if (isNaN(charval)) {
            return false;
        }
        return false;
    }

    handleInfosComplementairesChange(event) {

        console.log(this.getElementsByClassName('slds-day'));

        this.allFieldsNotFilled = false;
        this.recordupdated = true;
        let field = event.target.name;
        if (field === 'VotreIndex1') {
            if (event.target.value !== null) {
                event.target.value = event.target.value.replace(/[^0-9]*/g, '');
                this._record.VI_InfosCompl_IndexElec__c = event.target.value.slice(0, 5);
                if (this.isElectricite) {
                    this.template.querySelector('[data-id="IndexElec1"]').value = this._record.VI_InfosCompl_IndexElec__c;
                }
                else if (this.isGazEtElectricite) {
                    this.template.querySelector('[data-id="IndexElec2"]').value = this._record.VI_InfosCompl_IndexElec__c;
                }
            }
        }
        if (field === 'HeuresPleines') {
            if (event.target.value !== null) {
                event.target.value = event.target.value.replace(/[^0-9]*/g, '');
                this._record.VI_InfosCompl_HeuresPleinesElec__c = event.target.value.slice(0, 5);
                if (this.isElectricite) {
                    this.template.querySelector('[data-id="HeuresPleines1"]').value = this._record.VI_InfosCompl_HeuresPleinesElec__c;
                }
                else if (this.isGazEtElectricite) {
                    this.template.querySelector('[data-id="HeuresPleines2"]').value = this._record.VI_InfosCompl_HeuresPleinesElec__c;
                }
            }
        }
        if (field === 'HeuresCreuses') {
            if (event.target.value !== null) {
                event.target.value = event.target.value.replace(/[^0-9]*/g, '');
                this._record.VI_InfosCompl_HeuresCreusesElec__c = event.target.value.slice(0, 5);
                if (this.isElectricite) {
                    this.template.querySelector('[data-id="HeuresCreuses1"]').value = this._record.VI_InfosCompl_HeuresCreusesElec__c;
                }
                else if (this.isGazEtElectricite) {
                    this.template.querySelector('[data-id="HeuresCreuses2"]').value = this._record.VI_InfosCompl_HeuresCreusesElec__c;
                }
            }
        }
        if (field === 'VotreIndex2') {
            if (event.target.value !== null) {
                event.target.value = event.target.value.replace(/[^0-9]*/g, '');
                this._record.VI_InfosCompl_IndexGaz__c = event.target.value.slice(0, 5);
                if (this.isGaz) {
                    this.template.querySelector('[data-id="IndexGaz1"]').value = this._record.VI_InfosCompl_IndexGaz__c;
                }
                else if (this.isGazEtElectricite) {
                    this.template.querySelector('[data-id="IndexGaz2"]').value = this._record.VI_InfosCompl_IndexGaz__c;
                }
            }
        }
        this.checkReleveValues();
        if (field === 'MiseEnServiceUrgente') {
            this._record.VI_InfosCompl_MiseEnServiceUrgente__c = event.target.checked;
        }
        if (field === 'PremiereMiseEnService') {
            this._record.VI_InfosCompl_PremiereMiseEnService__c = event.target.checked;
        }
        if (field === 'DateContrat') {
            var inputValidity = this.template.querySelector('[data-id="date-echeance"]');
            inputValidity.setCustomValidity("");
            this.dateAnterieur = false;
            var today = new Date();
            var todayDate = new Date(today.getFullYear(), today.getMonth(), today.getDate());
            todayDate.setHours(23);
            var todayDatePlus1 = new Date(today.getFullYear(), today.getMonth(), today.getDate());
            todayDatePlus1.setDate(todayDatePlus1.getDate() + 2);
            todayDatePlus1.setHours(23);
            this.date = new Date(event.target.value);
            this.date.setHours(23);
            console.log("this.date " + this.date);
            console.log("validity " + inputValidity.validity.valid);
            if (inputValidity.validity.valid) {
                if (todayDate > this.date) {
                    console.log("is anterieur")
                    this.dateAnterieur = true;
                    inputValidity.setCustomValidity("Vous ne pouvez pas saisir une date antérieure à la date du jour.");
                }
                else {
                    console.log("is not anterieur")
                    inputValidity.setCustomValidity("");
                }


                if (this.dateAnterieur === false) {
                    this._record.VI_InfosCompl_DateContratEffectif__c = event.target.value;
                    if (this.HasReleveCompteur === true) {
                        this.template.querySelector('[data-id="RelevesCompteur"]').scrollIntoView(true);
                    }
                    const dispatchEventSearch = new CustomEvent('datecontratremplie');
                    this.dispatchEvent(dispatchEventSearch);
                    this.date=event.target.value;
                }
                else {
                    const dispatchEventSearch = new CustomEvent('datecontratvide');
                    this.dispatchEvent(dispatchEventSearch);
                }
            }
            else {
                const dispatchEventSearch = new CustomEvent('datecontratvide');
                this.dispatchEvent(dispatchEventSearch);
            }
        }
        if (event.target.dataset.id === 'passerEtape') {
            this.HasReleveCompteur = false;
            this._record.VI_InfosCompl_ChoixReleveCompteur__c = event.target.dataset.current;
            const dispatchEventSearch = new CustomEvent('passeretape');
            this.dispatchEvent(dispatchEventSearch);
        }

    }

    removeNumberScroll(event) {
        event.target.blur();
    }

    handleHPHCClick(event) {
        this.recordupdated = true;
        this.redLabelIndexGaz = false;
        this.redLabelIndexElec = false;
        this.redLabelHC = false;
        this.redLabelHP = false;
        this.showErrorMessage = false;
        if (event.target.dataset.id === 'HP/HC') {
            this._record.VI_InfosCompl_HP_HC__c = event.target.checked;
            this.isHPHC = event.target.checked;
            this.checkReleveValues();
        }
    }

    handleContinuer(event) {
        this.recordupdated = true;

        this.redLabelIndexGaz = true;
        this.redLabelIndexElec = true;
        this.redLabelHC = true;
        this.redLabelHP = true;
        this.showErrorMessage = false;
        this.checkReleveValues();
console.log("this.allFieldsNotFilled "+this.allFieldsNotFilled);

        if (this.allFieldsNotFilled) {
            if (!this.isGaz) {
                let indexElecDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexElec__c);
                let heuresPleinesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresPleinesElec__c);
                let heuresCreusesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresCreusesElec__c);

                if (this._record.VI_InfosCompl_IndexElec__c !== null && this._record.VI_InfosCompl_IndexElec__c !== ""
                     && indexElecDifferenZero) {
                    this.redLabelIndexElec = false;
                }
                if (this.isHPHC) {
                    if (this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && this._record.VI_InfosCompl_HeuresPleinesElec__c !== "" 
                        && heuresPleinesDifferenZero) {
                        this.redLabelHP = false;
                    }
                    if (this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && this._record.VI_InfosCompl_HeuresCreusesElec__c !== "" 
                        && heuresCreusesDifferenZero) {
                        this.redLabelHC = false;
                    }
                }
            }
            if (!this.isElectricite) {
                let indexGazDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexGaz__c);

                if (this._record.VI_InfosCompl_IndexGaz__c !== null && this._record.VI_InfosCompl_IndexGaz__c !== "" 
                    && indexGazDifferenZero) {
                    this.redLabelIndexGaz = false;
                }
            }
            this.showErrorMessage = true;
        }
        else {
            this.redLabelIndexGaz = false;
            this.redLabelIndexElec = false;
            this.redLabelHP = false;
            this.redLabelHC = false;

            const dispatchEventSearch = new CustomEvent('passeretape');
            this.dispatchEvent(dispatchEventSearch);
        }
    }

    checkReleveValues() {
        if (this.isGaz) {
            if (this._record.VI_InfosCompl_IndexGaz__c !== null) {
                let indexGazDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexGaz__c);
                if (this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1 &&
                    indexGazDifferenZero) {
                    this.releveCompteurCompleted = true;
                }
                else {
                    this.releveCompteurInitialized = true;
                }
            }
        }
        else if (this.isElectricite) {
            let heuresPleinesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresPleinesElec__c);
            let heuresCreusesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresCreusesElec__c);

            if (this.isHPHC) {
                if ((this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero) ||
                    (this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero)) {
                    this.releveCompteurInitialized = true;
                }
                if (this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero &&
                    this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero) {
                    if (this._record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
                        this._record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1) {
                        this.releveCompteurCompleted = true;
                    }
                }
            }
            else {
                if (this._record.VI_InfosCompl_IndexElec__c !== null) {
                    let indexElecDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexElec__c);
                    if (this._record.VI_InfosCompl_IndexElec__c.toString().length >= 1 &&
                        indexElecDifferenZero) {
                        this.releveCompteurCompleted = true;
                    }

                    else {

                        this.releveCompteurInitialized = true;
                    }
                }
            }
        }
        else if (this.isGazEtElectricite) {
            let indexGazDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexGaz__c);
            let indexElecDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_IndexElec__c);
            let heuresPleinesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresPleinesElec__c);
            let heuresCreusesDifferenZero = this.checkDifferentThanZero(this._record.VI_InfosCompl_HeuresCreusesElec__c);

            if (this.isHPHC) {
                if ((this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero) ||
                    (this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero) ||
                    (this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero)) {
                    this.releveCompteurInitialized = true;
                }

                if (this._record.VI_InfosCompl_HeuresPleinesElec__c !== null && heuresPleinesDifferenZero &&
                    this._record.VI_InfosCompl_HeuresCreusesElec__c !== null && heuresCreusesDifferenZero &&
                    this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero) {
                    if (this._record.VI_InfosCompl_HeuresPleinesElec__c.toString().length >= 1 &&
                        this._record.VI_InfosCompl_HeuresCreusesElec__c.toString().length >= 1 &&
                        this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
                        this.releveCompteurCompleted = true;
                    }
                }
            }
            else {
                if ((this._record.VI_InfosCompl_IndexElec__c !== null && indexElecDifferenZero) ||
                    (this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero)) {
                    this.releveCompteurInitialized = true;
                }
                if (this._record.VI_InfosCompl_IndexElec__c !== null && indexElecDifferenZero &&
                    this._record.VI_InfosCompl_IndexGaz__c !== null && indexGazDifferenZero) {
                    if (this._record.VI_InfosCompl_IndexElec__c.toString().length >= 1 &&
                        this._record.VI_InfosCompl_IndexGaz__c.toString().length >= 1) {
                        this.releveCompteurCompleted = true;
                    }
                }
            }
        }
        if (this.releveCompteurCompleted === true) {
            this.allFieldsNotFilled = false;
            const dispatchEventSearch = new CustomEvent('detailsreleveremplis');
            this.dispatchEvent(dispatchEventSearch);
            this.releveCompteurCompleted = false;
        }
        else if (this.releveCompteurCompleted === false && this.releveCompteurInitialized === true) {
            this.allFieldsNotFilled = true;
            const dispatchEventSearch = new CustomEvent('detailsrelevesinities');
            this.dispatchEvent(dispatchEventSearch);
            this.releveCompteurInitialized = false;
        }
        else {
            this.allFieldsNotFilled = true;
            const dispatchEventSearch = new CustomEvent('detailsrelevesinities');
            this.dispatchEvent(dispatchEventSearch);
        }
    }

    checkDifferentThanZero(valueToCompare) {
        if (valueToCompare !== "0" && valueToCompare !== "00" &&
            valueToCompare !== "000" && valueToCompare !== "0000" &&
            valueToCompare !== "00000") {
            return true;
        }
        return false;
    }

    // Open / close Modal1
    openModalGaz() {
        this.isModalOpenBackgroundGaz = true;
        this.isModalGazOpen = true;
    }

    closeModalGaz() {
        this.isModalOpenBackgroundGaz = false;
        this.isModalGazOpen = false;
    }

    openModalElec() {
        this.isModalOpenBackgroundElec = true;
        this.isModalElecOpen = true;
    }

    closeModalElec() {
        this.isModalOpenBackgroundElec = false;
        this.isModalElecOpen = false;
    }
    handleDecimal(event) {
        if (event.key === ',' || event.key === '.') {
            event.preventDefault();
        }
    }
    handlePrecedent() {
        console.log("### précédent : ");
        const dispatchEventSearch = new CustomEvent('precedent');
        this.dispatchEvent(dispatchEventSearch);
        console.log("### précédent FIN : ");
    }
}