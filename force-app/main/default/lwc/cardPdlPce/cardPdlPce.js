import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';
import getFlayoutPCEData from '@salesforce/apex/SM_FlayoutPCE.getFlayoutPCEData';
import getFlayoutPDLData from '@salesforce/apex/SM_FlayoutPDL.lirePdl';
import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";

export default class CardPdlPce extends NavigationMixin(LightningElement) {
    @api listrecord;
    @track listrecord;
    @api selecteditem;
    @track selecteditem;
    @api index;
    @track index;
    @api type;
    @track flayoutData;
    @track numCopied;
    @track typeCompteur = '';
    @track error = false;
    
    get getType() {
        return this.type.toUpperCase();
    }
    
    //Récuper les numéro PCE ou PDL
    get numeroContrat(){
        if(this.type === 'pce' && this.selecteditem.contratactifgazWS) {
            return this.selecteditem.contratactifgazWS.numeroPointDeLivraison;
        } else if(this.type === 'pce' && this.selecteditem.contratinactifgazWS) {
            return this.selecteditem.contratinactifgazWS.numeroPointDeLivraison;
        } else if (this.type === 'pdl' && this.selecteditem.contratactifelecWS) {
            return this.selecteditem.contratactifelecWS.numeroPointDeLivraison;
        } else if (this.type === 'pdl' && this.selecteditem.contratinactifelecWS) {
            return this.selecteditem.contratinactifelecWS.numeroPointDeLivraison;
        }
        return '';
    }

    get imageCompteur(){
        if(this.type === 'pce' && this.flayoutData) {    
            return this.getTypecompteur({typeCompteur: this.flayoutData.TypeCompteur?this.flayoutData.TypeCompteur.split(' ')[1].toUpperCase():''},'PCE');
        } else if(this.type === 'pce' && this.selecteditem.contratactifgazWS) {
            return this.getTypecompteur(this.selecteditem.contratactifgazWS,'PCE');
        } else if(this.type === 'pce' && this.selecteditem.contratinactifgazWS) {
            return this.getTypecompteur(this.selecteditem.contratinactifgazWS,'PCE');
        } else if (this.type === 'pdl' && this.flayoutData) {
            return this.getTypecompteur(
                {
                    codeNiveauService: this.flayoutData.niveauServices ? this.flayoutData.niveauServices.split(' ')[1]:'',
                    systemeInfoContractuel: this.flayoutData.systemeInfoContractuel ? this.flayoutData.systemeInfoContractuel.toUpperCase(): '',
                    TypeCompteur: this.flayoutData.typeCompteur? this.flayoutData.typeCompteur.toUpperCase(): ''
                },
                'PDL');
        } else if (this.type === 'pdl' && this.selecteditem.contratactifelecWS) {
            return this.getTypecompteur(this.selecteditem.contratactifelecWS,'PDL');
        } else if (this.type === 'pdl' && this.selecteditem.contratinactifelecWS) {
            return this.getTypecompteur(this.selecteditem.contratinactifelecWS,'PDL');
        }
        return '';
    }


    //Mettre le type de compteur
    //TODO à finaliser
    get iconCard(){
        return 'custom:custom29';
    }

    //Visibilité Flyout
    get showHideFlyout () {
        return this.selecteditem['close'+this.type];
    }

    //Si le Flyout est pour le Gaz
    get isPceFlyout() {
        return this.flayoutData && this.type === 'pce';
    } 
    
    //Si le Flyout est pour l'elec
    get isPdlFlyout() {
        return this.flayoutData && this.type === 'pdl';
    }

    get showSpinner() {
        return this.flayoutData || this.error;
    }

    get ftaCodeLibelle() {
        if (this.flayoutData && this.flayoutData.ftaCode && this.flayoutData.TranscoLibelleFTA) {
            return this.flayoutData.TranscoLibelleFTA;
        } else if (this.flayoutData && this.flayoutData.ftaCode) {
            return this.flayoutData.ftaCode;
        }
        return '-'
    }
    
    //Ouverture ou ferméture d'un flyout
    handleOpenRecordClick() {
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type:this.type} });
        this.dispatchEvent(event);
        if(this.selecteditem['close'+this.type]) {
            let inputMap = null;
            if (this.type === "pce") {
                let perimetre = this.selecteditem.perimetrePCE ? this.selecteditem.perimetrePCE : false;
                inputMap = {
                    PCEIdentifier: this.selecteditem.contratactifgazWS ? this.selecteditem.contratactifgazWS.numeroPointDeLivraison : this.selecteditem.contratinactifgazWS.numeroPointDeLivraison,
                    PerimetrePCE: perimetre
                }
                getFlayoutPCEData(inputMap).then(result => {
                    if(result) {
                        this.flayoutData = result;
                        console.log(this.flayoutData);
                    }
                })
                .catch(error => {
                    this.error = true;
                    console.log('erreur ouverture flyout '+ this.type, error);
                });
            } else {
                inputMap = {
                    pdlElc: this.selecteditem.contratactifelecWS ? this.selecteditem.contratactifelecWS.numeroPointDeLivraison : this.selecteditem.contratinactifelecWS.numeroPointDeLivraison
                }
                getFlayoutPDLData(inputMap).then(result => {
                    if(result) {
                        this.flayoutData = result;
                        console.log(this.flayoutData);
                        if (this.flayoutData.ftaCode) {
                            callIP({ inputMap: {CodeFTA: this.flayoutData.ftaCode}, NameIntergation: 'IP_SM_TranscoLibelleFTA_IP_SM' }).then(value => {
                                if(value) {
                                    this.flayoutData = {...this.flayoutData, ...value};
                                }
                            })
                            .catch(error => {
                                console.log('erreur ouverture flyout '+ this.type, error);
                            });
                        }
                        
                        
                        //TODO cache
                        // this.selecteditem['flayoutData'+this.type] = result;
                    }
                })
                .catch(error => {
                    console.log('erreur ouverture flyout '+ this.type, error);
                    this.error = true;
                });
            }
            
        }
    }

    //Copy Num PDL PCE
    copyPCEPDL(e) {
        e.stopPropagation();
        let textToCopy = e.currentTarget.innerText;
        let input = document.createElement('input');
        e.currentTarget.appendChild(input);
        input.value = textToCopy;

        // 2) Select the text
        input.focus();
        input.select();

        // 3) Copy text to clipboard
        let isSuccessful = document.execCommand('copy');
        //remove input
        e.currentTarget.removeChild(input);
        // 4) Catch errors
        if (!isSuccessful) {
            console.error('Failed to copy text.');
        } else {
            this.numCopied = true;
            setTimeout(() => {
                this.numCopied = false;
            }, 2000);
        }
    }

    getTypecompteur (item, typePL) {
        let imgCompteur = '';
        if (typePL === 'PCE') {
            if (item.typeCompteur === 'GAZPAR') {
                imgCompteur = '/resource/EngieCustomResources/images/Compteur_GAZ_gazpar.svg';
            } else {
                imgCompteur = '/resource/EngieCustomResources/images/Compteur_GAZ_ordinaire.svg';
            }
        } else if (typePL === 'PDL') {
          if (item.systemeInfoContractuel === 'GINKO') {
            if (item.codeNiveauService === '2') {
              imgCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_communiquant.svg';
            } else if (item.codeNiveauService === '1') {
              imgCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_non_communiquant.svg';
            }
          } else if ((item.systemeInfoContractuel === 'DISCO' && item.codeNiveauService === '1')) {
            imgCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_non_communiquant.svg';
          } else if (item.TypeCompteur === 'LINKY' && item.codeNiveauService === '0') {
            imgCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_linky_non_communiquant.svg';
          } else if (item.TypeCompteur !== 'LINKY' && item.codeNiveauService === '0') {
            imgCompteur = '/resource/EngieCustomResources/images/Compteur_ELEC_ordinaire.svg';
          }   
        }
        return imgCompteur;
    }
}