import { api, wire, LightningElement, track } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';

import ID_FIELD from '@salesforce/schema/Contact.Id';
import DATE_ENTREE_CLIENT_ACTIF_HAPPE__FIELD from '@salesforce/schema/Contact.HP_Date_entree_client_actif_happe__c';

import getAllContractsOfClient from '@salesforce/apex/HP_SM068_AncienneteClientController.getAllContractsOfClient';
import getAllCodeOffres from '@salesforce/apex/HP_SM068_AncienneteClientController.getAllCodeOffres';

import { ShowAncienneteToastEvent } from 'lightning/platformShowToastEvent';

export default class Hp_ancienneteClient extends LightningElement {
    @api idtiers;
    @api contactid;
    @track ancienneteClient;
    @track codeOffres = [];

    @wire(getAllContractsOfClient, { idXdataPersonne: '$idtiers' })
    wiredBody({ error, data }) {
        if (data) {
            // console.log(data.length);
            // console.log(JSON.stringify(data));
        
            getAllCodeOffres().then(codeOffres => {
                this.codeOffres = codeOffres;
                
            var seniorActifContrat = this.getSeniorActifContrat(data);
            console.log('Final seniorActifContrat :', seniorActifContrat);
            
            this.ancienneteClient = this.getAncienneteClient(seniorActifContrat);
            console.log('Anciennete Client :', this.ancienneteClient);

            this.updateContact(this.contactid, seniorActifContrat);
            });
        }
    }

    getSeniorActifContrat(data) {
        var validActifContrat = this.getValidActifContrat(data);
        if(!validActifContrat){
            return undefined;
        }

        return this.getSeniorActifContractRecursive(data, validActifContrat, new Date(Date.now()));;
    }

    getValidActifContrat(contrats) {
        var actifContrat;
        var now = new Date(Date.now());
        var beforeTwoMounths = new Date(new Date(Date.now()).setMonth(new Date(Date.now()).getMonth() - 2));
        
        for( var i = 0; i < contrats.length; i++){ 
            if ((contrats[i].dateDebutValidite != undefined) && (contrats[i].dateFinValidite != undefined) && (contrats[i].statut == 'Actif') && this.isHapp(contrats[i].codeOffre)) {
                if ((new Date(contrats[i].dateFinValidite) >= beforeTwoMounths) && (new Date(contrats[i].dateDebutValidite) <= now)) {
                    actifContrat = contrats[i];
                    // console.log('The new firstActifContrat :', actifContrat);
                }
            }
        }

        return actifContrat;
    }

    getSeniorActifContractRecursive(contrats, currentSeniorContract, dateCible) {
        var l = [...contrats]
        var seniorContrat = currentSeniorContract;
        var beforeTwoMounths = new Date(dateCible.setMonth(dateCible.getMonth() - 2));

        for( var i = 0; i < contrats.length; i++){ 
            if ((contrats[i].dateDebutValidite != undefined) && (contrats[i].dateFinValidite != undefined) && this.isHapp(contrats[i].codeOffre)) {
                if ( (new Date(contrats[i].dateFinValidite) >= beforeTwoMounths) && (new Date(contrats[i].dateDebutValidite) <= new Date(seniorContrat.dateDebutValidite))) {
                    seniorContrat = contrats[i];
                    l.splice(i, 1); 
                    // console.log('The new seniorContrat :', seniorContrat);
                    return this.getSeniorActifContractRecursive(l, seniorContrat, new Date(seniorContrat.dateDebutValidite));
                }
            }
        }

        return seniorContrat;
    }

    getAncienneteClient(contrat) {
        if(!contrat) {
            return '';
        }
        const now = new Date(Date.now());
        const ancienneteDate = new Date(contrat.dateDebutValidite);
        let diffMounths = now.getMonth() - ancienneteDate.getMonth();
        let diffYears = (now.getFullYear() - ancienneteDate.getFullYear());


        if (diffMounths < 0) {
            diffYears--;
            diffMounths += 12;
        }

        const yearsPart = diffYears > 0 ? ' ' + diffYears + ' an' + (diffYears > 1 ? 's' : '') : '';
        const monthsPart = diffMounths > 0 ? ' ' + diffMounths + ' mois' : '';

        if((yearsPart == '') && (monthsPart == '')) {
            return 'depuis 1 mois';
        } else {
            return 'depuis' + yearsPart + ((yearsPart != '') && (monthsPart != '') ? ' et' : '') + monthsPart;
        }
    }

    updateContact(contactId, seniorActifContrat) {
        const dateEntreeClientActif = seniorActifContrat ? seniorActifContrat.dateDebutValidite: null;
        
        const fields = {};
        fields[ID_FIELD.fieldApiName] = contactId;
        fields[DATE_ENTREE_CLIENT_ACTIF_HAPPE__FIELD.fieldApiName] = dateEntreeClientActif;
    
        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                console.log('Field DATE_ENTREE_CLIENT_ACTIF_HAPPE__FIELD updated successfully');
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowAncienneteToastEvent({
                        title: 'Erreur',
                        message: "Field DATE_ENTREE_CLIENT_ACTIF_HAPPE__FIELD update failed",
                        variant: 'error'
                    })
                );
                console.log('Field DATE_ENTREE_CLIENT_ACTIF_HAPPE__FIELD update throw an error');
            });
    }

    formatDate(date) {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }

    isHapp(contratCode) {
        let isHapp = false;
        this.codeOffres.forEach(coddeOffre => {
            if(coddeOffre.offreCode__c == contratCode) {
                isHapp = true;
            }
        })
        return isHapp;
    }

}