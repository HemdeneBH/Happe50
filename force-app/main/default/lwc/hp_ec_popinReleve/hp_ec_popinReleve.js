/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 07-15-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import HP_EC_icon_photo from '@salesforce/resourceUrl/HP_EC_icon_photo';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';

import agilabEnvoiIndexBase from '@salesforce/apex/HP_EC_LoadCustomerData.agilabEnvoiIndexBase';
import agilabEnvoiIndexHPHC from '@salesforce/apex/HP_EC_LoadCustomerData.agilabEnvoiIndexHPHC';

import { publishMC, subscribeMC, unsubscribeMC } from 'c/hp_ec_utl_lightningMessageManager';
import { MessageContext } from 'lightning/messageService';

export default class Hp_ec_releve extends NavigationMixin(LightningElement) {
    typeOptions = [
        {
            value: 'Electricité',
            label: "Élec",
            checked: true
        },
        {
            value: 'Gaz Naturel',
            label: "Gaz",
            checked: false
        }
    ];

    @wire(MessageContext) messageContext;

    // Values received from [hp_ec_releve] component 
    // @api idclient;
    @api contractgaz;
    @api contractelec;
    @api isperiodeargaz;
    @api isperiodearelec;
    @api typecomptage;
    @api pdl;
    @api pce;
    @api lastestindexelec;
    @api lastestindexhpelec;
    @api latestindexgaz;

    @api titlePopinReleve;
    @api messageIndexError;
    @api messageIndexNoValidError;
    @api customUrlPopinReleve;
    @api customUrlLabelPopinReleve;
    

    // Properties
    @track currentEnergy;
    @track isDual;
    @track isHPHC;
    @track isElec;
    @track isGaz;
    @track disableValidation;
    @track showIndexError;
    @track showIndexNoValidError;
    @track showAgilabKoError;

    @track BASE_0;@track BASE_1;@track BASE_2;@track BASE_3;@track BASE_4;@track BASE_5;
    @track HC_0;@track HC_1;@track HC_2;@track HC_3;@track HC_4;@track HC_5;
    @track HP_0;@track HP_1;@track HP_2;@track HP_3;@track HP_4;@track HP_5;
    
    @api titleText = 'Ma relève';
    @api customUrl;
    @api customUrlLabel = 'Où trouver ces informations?';

    iconPhoto = HP_EC_icon_photo;
    iconClose = HP_EC_close_icon_light;

    @track test =null;

    async populateContractInfo() {
        console.log('Voici currentEnergy choisit : '+ this.currentEnergy);

        if(this.pdl && !this.currentEnergy) {this.handleType({detail :'Electricité'});return;}
        if(this.pce && !this.currentEnergy) {this.handleType({detail :'Gaz Naturel'});return;}

        this.initializeComponantProperties();

        if(this.isElec) {
            console.log('isHPHC : '+ this.isHPHC);
            // console.log('Voici pdl : '+ this.pdl);
            console.log('Voici lastest index elec : '+ this.lastestindexelec);
            console.log('Voici lastest indexhp elec : '+ this.lastestindexhpelec);

            if(!this.lastestindexelec)
                this.lastestindexelec = 0;
            if(!this.lastestindexhpelec)
                this.lastestindexhpelec = 0;
        }

        if(this.isGaz) {
            // console.log('Voici pce : '+ this.pce);
            console.log('Voici latest index gaz : '+ this.latestindexgaz);
            if(!this.latestindexgaz)
                this.latestindexgaz = 0;
            
        }
    }

    handleValidation() {
        this.showAgilabKoError = false;
        if(this.currentEnergy === 'Gaz Naturel') {
            const indexSaisie = this.getIndexFromValues(this.BASE_0,this.BASE_1,this.BASE_2,this.BASE_3,this.BASE_4,this.BASE_5);
            console.log('indexSaisie gaz in validation method : '+indexSaisie);

            agilabEnvoiIndexBase({ idContratXdata : this.contractgaz.id, type_releve : 1, indexhc : indexSaisie})
                .then(response => {
                    console.log('agilabEnvoiIndexBase gaz response : '+JSON.stringify(response));

                    if(response.status === 'SUCCESS') {
                        const envoieIndexEvent = new CustomEvent("envoieindexevent", {
                            detail: {
                                isGaz : true,
                                status : response.status,
                                message : response.message,
                                prochaine_releve_debut : response.prochaine_releve_debut,
                                prochaine_releve_fin : response.prochaine_releve_fin
                            }
                        });
                        this.dispatchEvent(envoieIndexEvent);
                    } else {
                        this.disableValidation = true;
                        this.showAgilabKoError = true;
                    }

                    // const Fake_Response = JSON.parse('{"status": "SUCCESS", "message": null, "prochaine_releve_debut": "2022-06-11", "prochaine_releve_fin": "2022-06-20"}');
                    // console.log('agilabEnvoiIndexBase gaz Fake_Response : '+JSON.stringify(Fake_Response));

                    // if(Fake_Response.status === 'SUCCESS') {
                    //     const envoieIndexEvent = new CustomEvent("envoieindexevent", {
                    //         detail: {
                    //             isGaz : true,
                    //             status : Fake_Response.status,
                    //             message : Fake_Response.message,
                    //             prochaine_releve_debut : Fake_Response.prochaine_releve_debut,
                    //             prochaine_releve_fin : Fake_Response.prochaine_releve_fin
                    //         }
                    //     });
                    //     this.dispatchEvent(envoieIndexEvent);
                    // } else {
                    //     this.disableValidation = true;
                    // }
                })
                .catch(error => {
                    console.log('***ExId Error: ' + JSON.stringify(error));
                    this.showAgilabKoError = true;
                });
        }

        if(this.currentEnergy === 'Electricité') {
            if(!this.isHPHC) { 
                const indexSaisie = this.getIndexFromValues(this.BASE_0,this.BASE_1,this.BASE_2,this.BASE_3,this.BASE_4,this.BASE_5);
                console.log('indexSaisie elec in validation elec method : '+indexSaisie);
    
                agilabEnvoiIndexBase({ idContratXdata : this.contractelec.id,  indexhc : indexSaisie, type_releve : 1})
                    .then(response => {
                        console.log('agilabEnvoiIndexBase response : '+JSON.stringify(response));

                        if(response.status === 'SUCCESS') {
                            const envoieIndexEvent = new CustomEvent("envoieindexevent", {
                                detail: {
                                    isElec : true,
                                    status : response.status,
                                    message : response.message,
                                    prochaine_releve_debut : response.prochaine_releve_debut,
                                    prochaine_releve_fin : response.prochaine_releve_fin
                                }
                            });
                            this.dispatchEvent(envoieIndexEvent);
                        } else {
                            this.disableValidation = true;
                            this.showAgilabKoError = true;
                        }
                    })
                    .catch(error => {
                        console.log('***ExId Error: ' + JSON.stringify(error));
                        this.showAgilabKoError = true;
                    });
            
            } 
            
            if(this.isHPHC) {
                const indexSaisieHC = this.getIndexFromValues(this.HC_0,this.HC_1,this.HC_2,this.HC_3,this.HC_4,this.HC_5);
                const indexSaisieHP = this.getIndexFromValues(this.HP_0,this.HP_1,this.HP_2,this.HP_3,this.HP_4,this.HP_5);

                console.log('indexSaisieHC sent : '+indexSaisieHC);
                console.log('indexSaisieHP sent : '+indexSaisieHP);
                
    
                agilabEnvoiIndexHPHC({ idContratXdata : this.contractelec.id, type_releve : 1, indexhc : indexSaisieHC,  indexhp : indexSaisieHP})
                    .then(response => {
                        console.log('agilabEnvoiIndexHPHC response : '+JSON.stringify(response));

                        if(response.status === 'SUCCESS') {
                            const envoieIndexEvent = new CustomEvent("envoieindexevent", {
                                detail: {
                                    isElec : true,
                                    status : response.status,
                                    message : response.message,
                                    prochaine_releve_debut : response.prochaine_releve_debut,
                                    prochaine_releve_fin : response.prochaine_releve_fin
                                }
                            });
                            this.dispatchEvent(envoieIndexEvent);
                        } else {
                            this.disableValidation = true;
                            this.showAgilabKoError = true;
                        }
                    })
                    .catch(error => {
                        console.log('***ExId Error: ' + JSON.stringify(error));
                        this.showAgilabKoError = true;
                    });
            }
        }
    }

    getIndexFromValues(_0_value,_1_value,_2_value,_3_value,_4_value,_5_value) {
        if(_0_value == '' && _1_value == '' && _2_value == '' && _3_value == '' && _4_value == '' && _5_value == '')
            return null;
            
        return Number.parseInt(_0_value + _1_value + _2_value + _3_value + _4_value + _5_value);
    }

    validateIndex() {
        this.hideValidationFormError();
        this.hideIndexError();
        
        if(this.isGaz) {
            let isFirstIndex = true;
            this.BASE_0 = this.template.querySelector('[data-id="BASE_0"]').value;

            this.BASE_1 = this.template.querySelector('[data-id="BASE_1"]').value;
            if(this.BASE_0 != '') { isFirstIndex = false};
            if(this.BASE_0 == '' && this.BASE_1 != '' && !isFirstIndex) {this.showValidationFormError();return;};

            this.BASE_2 = this.template.querySelector('[data-id="BASE_2"]').value;
            if(this.BASE_1 != '') { isFirstIndex = false};
            if(this.BASE_1 == '' && this.BASE_2 != '' && !isFirstIndex) {this.showValidationFormError();return;};

            this.BASE_3 = this.template.querySelector('[data-id="BASE_3"]').value;
            if(this.BASE_2 != '') { isFirstIndex = false};
            if(this.BASE_2 == '' && this.BASE_3 != '' && !isFirstIndex) {this.showValidationFormError();return;};

            this.BASE_4 = this.template.querySelector('[data-id="BASE_4"]').value;
            if(this.BASE_3 != '') { isFirstIndex = false};
            if(this.BASE_3 == '' && this.BASE_4 != '' && !isFirstIndex) {this.showValidationFormError();return;};


            this.BASE_5 = this.template.querySelector('[data-id="BASE_5"]').value;
            if(this.BASE_4 != '') { isFirstIndex = false};
            if(this.BASE_4 == '' && this.BASE_5 != '' && !isFirstIndex) {this.showValidationFormError();return;};

            const indexSaisie = this.getIndexFromValues(this.BASE_0,this.BASE_1,this.BASE_2,this.BASE_3,this.BASE_4,this.BASE_5);
            console.log('indexSaisie base : '+indexSaisie);

            if(indexSaisie == null) {
                this.showIndexErrorr();
            }

            if(indexSaisie <= this.latestindexgaz) {
                this.showIndexError = true;
                this.disableValidation = true;
            } else {
                this.showIndexError = false;
                this.disableValidation = false;
            }
        }
        if(this.isElec) {
            if(this.isHPHC) {
                let isFirstIndex = true;

                this.HC_0 = this.template.querySelector('[data-id="HC_0"]').value;

                this.HC_1 = this.template.querySelector('[data-id="HC_1"]').value;
                if(this.HC_0 != '') { isFirstIndex = false};
                if(this.HC_0 == '' && this.HC_1 != '' && !isFirstIndex) {this.showValidationFormError();return;};
                
                this.HC_2 = this.template.querySelector('[data-id="HC_2"]').value;
                if(this.HC_1 != '') { isFirstIndex = false};
                if(this.HC_1 == '' && this.HC_2 != '' && !isFirstIndex) {this.showValidationFormError();return;};


                this.HC_3 = this.template.querySelector('[data-id="HC_3"]').value;
                if(this.HC_2 != '') { isFirstIndex = false};
                if(this.HC_2 == '' && this.HC_3 != '' && !isFirstIndex) {this.showValidationFormError();return;};


                this.HC_4 = this.template.querySelector('[data-id="HC_4"]').value;
                if(this.HC_3 != '') { isFirstIndex = false};
                if(this.HC_3 == '' && this.HC_4 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.HC_5 = this.template.querySelector('[data-id="HC_5"]').value;
                if(this.HC_4 != '') { isFirstIndex = false};
                if(this.HC_4 == '' && this.HC_5 != '' && !isFirstIndex) {this.showValidationFormError();return;};

    
                const indexSaisieHC = this.getIndexFromValues(this.HC_0,this.HC_1,this.HC_2,this.HC_3,this.HC_4,this.HC_5);
                console.log('indexSaisieHC : '+indexSaisieHC);
                if(indexSaisieHC == null) {
                    this.showIndexErrorr();
                }
                

                isFirstIndex = true;
    
                this.HP_0 = this.template.querySelector('[data-id="HP_0"]').value;
            
                this.HP_1 = this.template.querySelector('[data-id="HP_1"]').value;
                if(this.HP_0 != '') { isFirstIndex = false};
                if(this.HP_0 == '' && this.HP_1 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.HP_2 = this.template.querySelector('[data-id="HP_2"]').value;
                if(this.HP_1 != '') { isFirstIndex = false};
                if(this.HP_1 == '' && this.HP_2 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.HP_3 = this.template.querySelector('[data-id="HP_3"]').value;
                if(this.HP_2 != '') { isFirstIndex = false};
                if(this.HP_2 == '' && this.HP_3 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.HP_4 = this.template.querySelector('[data-id="HP_4"]').value;
                if(this.HP_3 != '') { isFirstIndex = false};
                if(this.HP_3 == '' && this.HP_4 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.HP_5 = this.template.querySelector('[data-id="HP_5"]').value;
                if(this.HP_4 != '') { isFirstIndex = false};
                if(this.HP_4 == '' && this.HP_5 != '' && !isFirstIndex) {this.showValidationFormError();return;};

    
                const indexSaisieHP = this.getIndexFromValues(this.HP_0,this.HP_1,this.HP_2,this.HP_3,this.HP_4,this.HP_5);
                console.log('indexSaisieHP : '+indexSaisieHP);
                if(indexSaisieHP == null) {
                    this.showIndexErrorr();
                }

                if(indexSaisieHC <= this.lastestindexelec || indexSaisieHP <= this.lastestindexhpelec) {
                    this.showIndexError = true;
                    this.disableValidation = true;
                } else {
                    this.showIndexError = false;
                    this.disableValidation = false;
                }
            } 
            else if(!this.isHPHC) { 
                let isFirstIndex = true;

                this.BASE_0 = this.template.querySelector('[data-id="BASE_0"]').value;

                this.BASE_1 = this.template.querySelector('[data-id="BASE_1"]').value;
                if(this.BASE_0 != '') { isFirstIndex = false};
                if(this.BASE_0 == '' && this.BASE_1 != '' && !isFirstIndex) {this.showValidationFormError();return;};
                
                this.BASE_2 = this.template.querySelector('[data-id="BASE_2"]').value;
                if(this.BASE_1 != '') { isFirstIndex = false};
                if(this.BASE_1 == '' && this.BASE_2 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.BASE_3 = this.template.querySelector('[data-id="BASE_3"]').value;
                if(this.BASE_2 != '') { isFirstIndex = false};
                if(this.BASE_2 == '' && this.BASE_3 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.BASE_4 = this.template.querySelector('[data-id="BASE_4"]').value;
                if(this.BASE_3 != '') { isFirstIndex = false};
                if(this.BASE_3 == '' && this.BASE_4 != '' && !isFirstIndex) {this.showValidationFormError();return;};

                this.BASE_5 = this.template.querySelector('[data-id="BASE_5"]').value;
                if(this.BASE_4 != '') { isFirstIndex = false};
                if(this.BASE_4 == '' && this.BASE_5 != '' && !isFirstIndex) {this.showValidationFormError();return;};
    
                const indexSaisie = this.getIndexFromValues(this.BASE_0,this.BASE_1,this.BASE_2,this.BASE_3,this.BASE_4,this.BASE_5);
                console.log('indexSaisie base : '+indexSaisie);

                if(indexSaisie == null) {
                    this.showIndexErrorr();
                }

                if(indexSaisie <= this.lastestindexelec) {
                    this.showIndexError = true;
                    this.disableValidation = true;
                } else {
                    this.showIndexError = false;
                    this.disableValidation = false;
                }
            } 
        }  
    }

    showValidationFormError() {
        this.showIndexNoValidError = true;
        this.disableValidation = true;
    }

    hideValidationFormError() {
        this.showIndexNoValidError = false;
        this.disableValidation = false;
    }

    showIndexErrorr() {
        this.showIndexError = true;
        this.disableValidation = true;
    }

    hideIndexError() {
        this.showIndexError = false;
        this.disableValidation = false;
    }

    initializeComponantProperties() {
        this.isElec = false;this.isGaz = false; this.isHPHC = false;

        if(this.isperiodeargaz == false) {
            this.contractgaz = null;
            this.pce = null;
            this.latestindexgaz = null;
        }
        if(this.isperiodearelec == false) {
            this.contractelec = null;
            this.pdl = null;
            this.lastestindexelec = null;
            this.lastestindexhpelec = null;
        }


        this.contractelec && this.contractgaz ? this.isDual = true: this.isDual = false;
        this.currentEnergy == 'Electricité' ? this.isElec = true: this.isElec = false;
        this.currentEnergy == 'Gaz Naturel' ? this.isGaz = true: this.isGaz = false;
        (this.currentEnergy == 'Electricité' && this.typecomptage === 'Comptage HPHC') ? this.isHPHC = true : this.isHPHC = false;

        this.disableValidation = true;
        this.showIndexError = false;
        this.showAgilabKoError = false;
            
        this.BASE_0 = null;this.BASE_1 = null;this.BASE_2 = null;this.BASE_3 = null;this.BASE_4 = null;this.BASE_5 = null;
        this.HP_0 = null;this.HP_1 = null;this.HP_2 = null;this.HP_3 = null;this.HP_4 = null;this.HP_5 = null;
        this.HC_0 = null;this.HC_1 = null;this.HC_2 = null;this.HC_3 = null;this.HC_4 = null;this.HC_5 = null;
    }

    closePopinReleve(event){
        this.dispatchEvent(new CustomEvent('openpopinreleve', { detail: false}));
    }

    handleType (event) {
        this.typeOptions = updateOptionsArray(this.typeOptions, event.detail);
        this.handlePublish(event.detail);
    }

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;

        this.populateContractInfo();
    }

    connectedCallback() {
        this.handleSubscription(); 
    }

    handleSubscription() {
        if (!this.subscription) {
            subscribeMC(this,this.messageContext, this.handleLightningMessage);
        }
    } 

    handleLightningMessage(self,subscription, message) {
        // if(message.messageType == 'SelectedPortfolio'){
        //     self.idPortefeuilleContrat = message.messageData.message;
        //     self.populateContractInfo();
        // }
        if(message.messageType == 'SelectedEnergy'){
            self.currentEnergy = message.messageData.message;
            self.populateContractInfo();
        }
    }
    
    handlePublish(message) {
        publishMC(this.messageContext, message, 'SelectedEnergy');
    }

    handleNavigateCustomUrl() {
        console.log('this.customURl : '+this.customUrlPopinReleve);
        console.log('this.customURlLabel : '+this.customUrlLabelPopinReleve);
        const config = {
            type: 'standard__webPage',
            attributes: {
                url: this.customUrlPopinReleve
            }
        };
        this[NavigationMixin.Navigate](config);
    }
}

function updateOptionsArray(array, value) {
    return array.map(option => {
        if (option.value == value) {
            return {...option, checked: true};
        }
        return {...option, checked: false};
    });
}

function isValidNumber(value) {
    const validNumbers = ['0','1','2','3','4','5','6','7','8','9'];
    if(validNumbers.includes(value))
        return true;
    return false;
}