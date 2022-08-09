import { LightningElement, api} from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class SM_vlocity_recherche_manuelle extends OmniscriptBaseMixin(LightningElement) {
    ville = "";
    codePostal="";
    rue="";
    numero="";
    listVilles=[];
    listCodesPostaux=[];
    isCodePostalFieldEmpty = false;
    isCityFieldEmpty = false;
    isStreetFieldEmpty = false;
    listRues = null;
    listNumeros = null;
    selectedVille = false;
    selectedCodePostal = false;
    selectedRue = false;
    disabled = true;
    secondStep = false;
    cacherechercheAuto = null;
    connectedCallback() {
        this.selectedCodePostal = this.omniJsonData.postcodeOct ? true : false;
        this.codePostal = this.omniJsonData.postcodeOct ? this.omniJsonData.postcodeOct : "";
        this.selectedVille = this.omniJsonData.cityOct ? true : false;
        this.ville = this.omniJsonData.cityOct ? this.omniJsonData.cityOct: "";
        this.selectedRue = this.omniJsonData.streetOct ? true : false;
        this.rue = this.omniJsonData.streetOct ? this.omniJsonData.streetOct : "";
        this.numero = this.omniJsonData.housenumberOct ? this.omniJsonData.housenumberOct : "";
        this.disabled = !(this.selectedVille && this.selectedCodePostal);
        this.secondStep = !this.disabled;
        this.omniValidate(false);
    }

    /**
     * Permet de selectionner un code postal
     * @param {*} event evenement déclencheur
     */
    selectCodePostalValue (event) {
        this.omniApplyCallResp({"postcodeOct" : event.currentTarget.dataset.value});
        this.template.querySelector('[data-id="codePostal"]').value = event.currentTarget.dataset.value;
        this.codePostal = event.currentTarget.dataset.value;
        this.isCodePostalFieldEmpty = false;
        this.changeCodePostal(true);
        this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.add('slds-hide');
    }

    /**
     * Permet d'afficher la liste des codesPostaux directement lors du clique sur le champs
     * @param {*} event evenement déclencheur
     */
    checkListCodesPostaux() {
        if(this.listCodesPostaux && this.listCodesPostaux.length > 0) {
            this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.remove('slds-hide');
        }
    }

    /**
     * Permet de selectionner un code postal
     * @param {*} event evenement déclencheur
     */
    selectVilleValue (event) {
        this.ville = event.currentTarget.dataset.value;
        this.isCityFieldEmpty = false;
        this.template.querySelector('[data-id="ville"]').value = event.currentTarget.dataset.value;
        this.omniApplyCallResp({"cityOct" : event.currentTarget.dataset.value});
        this.changeVille(true);
        this.template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
    }

    /**
     * Permet de selectionner un la rue de l'adresse
     * @param {*} event evenement déclencheur
     */
    selectRueValue (event) {
        this.rue = event.currentTarget.dataset.value;
        this.isStreetFieldEmpty = false;
        this.template.querySelector('[data-id="rue"]').value = event.currentTarget.dataset.value;
        this.omniApplyCallResp({"streetOct" : event.currentTarget.dataset.value});
        this.changeRue(true);
        this.template.querySelector('[data-id="listRuesSuggested"]').classList.add('slds-hide');
    }

    selectNumeroValue (event) {
        this.numero = event.currentTarget.dataset.value;
        this.omniApplyCallResp({"housenumberOct" : event.currentTarget.dataset.value});
        this.template.querySelector('[data-id="numeroRue"]').value = event.currentTarget.dataset.value;
        this.template.querySelector('[data-id="listNumerosSuggested"]').classList.add('slds-hide');
    }

    /**
     * Permet d'afficher la liste des ville directement lors du clique sur le champs
     * @param {*} event evenement déclencheur
     */
    checkListVille() {
        if(this.listVilles && this.listVilles.length > 0) {
            this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
        }
    }

    checkListNumero() {
        if(this.listNumeros && this.listNumeros.length > 0) {
            this.template.querySelector('[data-id="listNumerosSuggested"]').classList.remove('slds-hide');
        }
    }


    closeTabsAdressManuelle () {
        let template = this.template;
        setTimeout(function () {
            if (template.querySelector('[data-id="listCodesPostauxSuggested"]')) {
                template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.add('slds-hide');
            }
            if (template.querySelector('[data-id="listVillesSuggested"]')) {
                template.querySelector('[data-id="listVillesSuggested"]').classList.add('slds-hide');
            }
            if (template.querySelector('[data-id="listRuesSuggested"]')) {
                template.querySelector('[data-id="listRuesSuggested"]').classList.add('slds-hide');
            }
            if (template.querySelector('[data-id="listNumerosSuggested"]')) {
                template.querySelector('[data-id="listNumerosSuggested"]').classList.add('slds-hide');
            }
        }, 500);
        
    }

    @api
    checkValidity() {
        let isValid = this.selectedVille && this.selectedCodePostal && this.selectedRue;
        return isValid;
    }

    /**
    * Recherche manuelle code postal
    * @param {*} 
    */
    changeCodePostal(selection) {
        this.codePostal = this.template.querySelector('[data-id="codePostal"]').value;
        if(selection === true) {
            this.selectedCodePostal = true; 
        } else {
            this.selectedCodePostal = false;
            this.omniApplyCallResp({"postcodeOct" : ''});
        }
        if(this.codePostal.length === 0) {
            this.isCodePostalFieldEmpty = true;
        }
        this.omniValidate();
        this.disabled = !(this.selectedVille && this.selectedCodePostal);
        this.listRues = [];
        this.listNumeros = [];
        this.numero = "";
        this.rue = "";
        this.secondStep = false;                   
        let ipName = 'IP_SM_CodesPostauxVilles_APISET';
        if(this.template.querySelector('[data-id="codePostal"]').value && this.template.querySelector('[data-id="codePostal"]').value.toString().length === 5) {
            let inputMap;
            if( this.ville.length < 3 ) {
                inputMap = {
                    codePostal: this.codePostal.toString()
                };
            } else {
                inputMap = {
                    ville: this.ville,
                    codePostal: this.codePostal,
                    villeSelectionnee: this.selectedVille ? 1 : 0
                };
            }
            this.template.querySelector('[data-id="listCodesPostauxSuggested"]').classList.remove('slds-hide');
            this.callIP(inputMap, ipName, true);
        } else if(!this.codePostal && this.ville.length > 2) {
            let inputMap = {
                ville: this.ville
            };
            this.callIP(inputMap, ipName, true);            
        }
    }

    changeVille(selection) {
        if(selection === true) {
            this.selectedVille = true; 
        } else {
            this.selectedVille = false;
            this.omniApplyCallResp({"cityOct" : ''});
        }
        this.ville = this.template.querySelector('[data-id="ville"]').value;
        if(this.ville.length === 0) {
            this.isCityFieldEmpty = true;
        }
        this.omniValidate();
        this.disabled = !(this.selectedVille && this.selectedCodePostal);
        this.listRues = [];
        this.listNumeros = [];
        this.numero = "";
        this.rue = "";
        this.secondStep = false;                   
        let ipName = 'IP_SM_CodesPostauxVilles_APISET';
        if(this.template.querySelector('[data-id="ville"]').value.length > 2) {
            let inputMap;
            if( !this.codePostal || this.codePostal.toString().length !== 5) {
                inputMap = {
                    ville: this.ville,
                    villeSelectionnee: this.selectedVille ? 1 : 0 
                };
            } else {
                inputMap = {
                    ville: this.ville,
                    codePostal: this.codePostal,
                    villeSelectionnee: this.selectedVille ? 1 : 0
                };
            }
            this.template.querySelector('[data-id="listVillesSuggested"]').classList.remove('slds-hide');
            this.callIP(inputMap, ipName, true);
        } else if(this.ville.length === 0 && this.codePostal && this.codePostal.length === 5) {
            let inputMap = {
                codePostal: this.codePostal
            };
            this.callIP(inputMap, ipName, true);            
        }
    }

    changeRue(selection) {
        if(selection === true) {
            this.selectedRue = true; 
        } else {
            this.selectedRue = false;
            this.omniApplyCallResp({"streetOct" : ''});
        }
        this.rue = this.template.querySelector('[data-id="rue"]').value;
        this.omniValidate();
        if(this.rue.length === 0) {
            this.isStreetFieldEmpty = true;
        }
        var ipName = 'IP_SM_AdressesRues_Smile';
        if(this.template.querySelector('[data-id="rue"]').value.length > 2 && this.codePostal.toString().length === 5 && this.ville) {
            let inputMap = {
                ville: this.ville,
                codePostal: this.codePostal,
                libelleVoie: this.rue               
            };
            
            this.template.querySelector('[data-id="listRuesSuggested"]').classList.remove('slds-hide');
            if(selection === true) {
                this.callIP(inputMap, ipName, true);
            } else {
                this.callIP(inputMap, ipName);               
            } 
        }
    };

    changeNumero() {
        this.isDisabledAddressModified = false;
        this.numero = this.template.querySelector('[data-id="numeroRue"]').value;
        this.omniApplyCallResp({"housenumberOct" : this.template.querySelector('[data-id="numeroRue"]').value});
    }

    loadNumero () {
        let ipName = 'IP_SM_AdressesNumeros_Smile';
        if(this.rue.length > 2 && this.codePostal.toString().length === 5 && this.ville) {
                var inputMap = {
                    ville: this.ville,
                    codePostal: this.codePostal,
                    libelleVoie: this.rue               
                };
            
            this.callIP(inputMap, ipName);
        }
    }


    setNextStep(){
        this.secondStep = !this.disabled;
    }


    /**
    * traitement de la data pour generer deux lists une pour les ville et une pour les codes postaux
    * @param {*} 
    */
    getListsVillesCodesPostaux (list) {
        if(list) {
            this.listVilles = [];
            this.listCodesPostaux = [];
            for (var i = 0 ; i < list.length; i++) {
                this.listVilles.push(this.removeExtraSpace(list[i].ville));
                this.listCodesPostaux.push(list[i].codePostal);
            }
            this.listVilles = this.supressionDoublon(this.listVilles);
            this.listCodesPostaux = this.supressionDoublon(this.listCodesPostaux);
        }
        
    };

    /**
    * suppression des ville et code postal en doublon
    * @param {*} 
    */
    supressionDoublon (list) {
        let newList = [];
        let temp = false;
        for (let i = 0 ; i < list.length; i++) {
            if(i === 0) {
                newList.push(list[i]);
            } else {
                temp = false;
                for(let j = 0; j < newList.length; j++) {
                    if(list[i] === newList[j]) {
                        temp = true;
                    }
                }
                if(!temp) {
                    newList.push(list[i]);
                }
            }
        }
        return newList;
    }

    /**
    * Suppression des espaces de plus sur l'attribut ville
    * @param {*} 
    */
    removeExtraSpace (str) {
        str = str.replace(/[\s]{2,}/g," "); // Enlève les espaces doubles, triples, etc.
        str = str.replace(/^[\s]/, ""); // Enlève les espaces au début
        str = str.replace(/[\s]$/,""); // Enlève les espaces à la fin
        return str;    
    }

    /**
    * function d'appel vers les IP vlocity
    * @param {*} 
    */

    callIP(input, name, callback) {
        let params = {
            input: JSON.stringify(input),
            sClassName: 'vlocity_cmt.IntegrationProcedureService',
            sMethodName: name,
            options: '{}'
        };
        this.omniRemoteCall(params).then(result => {
            if(result && result.result && result.result.IPResult) {
                if(name === 'IP_SM_CodesPostauxVilles_APISET') {
                    this.codesPostauxVilles = result.result.IPResult._data;
                    if (callback) {
                        this.getListsVillesCodesPostaux(this.codesPostauxVilles);
                    }
                } else if(name === 'IP_SM_AdressesRues_Smile') {
                    this.listRues = result.result.IPResult._data;
                    if (callback) {
                        this.loadNumero();
                    }
                } else {
                    this.listNumeros = result.result.IPResult._data;
                }
            }
            
        })
        .catch(error => {
        console.log("got error callIP ", name , error);
        });
    }
}