/* eslint-disable no-console */
/* eslint-disable eqeqeq */
import { LightningElement, api, track, wire } from 'lwc';
import MandatWrapper from './mandat';
import getIDTiers from '@salesforce/apex/MP_LWC03_ResumePrelevement.getIDTiers';
import getMandat from '@salesforce/apex/MP_LWC03_ResumePrelevement.getMandat'; 
import getAllPrelevements from '@salesforce/apex/MP_LWC03_ResumePrelevement.getAllPrelevements';
import getRefusPrelevements from '@salesforce/apex/MP_LWC03_ResumePrelevement.getRefusPrelevements';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const colPrelevement = [
    { label: 'Numéro de Mandat', fieldName: 'subscriptionCode', type: 'text'},
    { label: 'Type', fieldName: 'serviceInstanceCode', type: 'text'},
    { label: 'Montant d\'échéance', fieldName: 'amount', type: 'text'},
	/*{ label: 'Date Début', fieldName: 'startDate', type: 'text'},
	{ label: 'Date Fin', fieldName: 'endDate', type: 'text'},*/
	{ label: 'Paiement le', fieldName: 'dueDate', type: 'text'},
	{ label: 'Echéancier', fieldName: 'echeancier', type: 'text'}
	/*{ label: 'Payé', fieldName: 'paid', type: 'text'},
	{ label: 'Dernier Paiement', fieldName: 'last', type: 'text'}*/
];
 
const colRefusPrelevement = [
    { label: 'Date d\'échéance', fieldName: 'dateEcheance', type: 'text'},
	{ label: 'Montant d\'échéance', fieldName: 'montantEcheance', type: 'text'},
	{ label: 'Motif Refus', fieldName: 'motifRefus', type: 'text'},
	{ label: 'Payé', fieldName: 'paye', type: 'text'}
];
export default class Mp_resume_prelevement extends LightningElement {

    @api recordId;
    @track showLoadingSpinner = false;
	@track colPrelevement = colPrelevement;
	@track colRefusPrelevement = colRefusPrelevement;
    @track AllMandats = [];
	@track AllPrelevements = [];
	@track AllRefusPrelevements = [];

	idPersonne;
	idtiers;
    numeroMandats = [];
	filters = {};
	filtersRefus = {};

    @wire(getIDTiers, { contactId: '$recordId' })
		wiredIDTiers(result) {
			if(result.data) {
				this.idPersonne = result.data;
				if(this.idPersonne == 'Pas d\'IDTiers') {
					this.showToast('Erreur ID Tiers', 'Il n\'y a pas d\'ID Tiers lié à ce contact', 'error');
					this.showLoadingSpinner = false;
				}
			}else if (result.error) {
				if(result.error.body.message == 'List has no rows for assignment to SObject'){
					this.showToast('Erreur ID Tiers', '', 'error');
				}else{
					this.showToast('Erreur ID Tiers', result.error.body.message, 'error');
				}	
			}
        }
    
    @wire(getMandat, { contactId: '$recordId' })
		wiredMandats(result) {
			this.showLoadingSpinner = true;
			if (result.data) {
				let mandat_list = [];
				for(let m of Object.values(result.data)){
					mandat_list.push(new MandatWrapper(m.id, 
						m.numeroMandat, 
						m.statut, 
						m.codeFournisseur, 
						m.dateSignature, 
						m.dateValidation, 
						m.dateModification, 
						m.idPersonne, 
						m.idBusinessPartner, 
                        m.coordonneesBancaire));
                    this.numeroMandats.push(m.numeroMandat);
				}
				this.filters =  this.numeroMandats.join(",");
				this.showLoadingSpinner = false;
				this.AllMandats = mandat_list;
			} else if (result.error) {
				this.showLoadingSpinner = false;
				console.log('wiredMandats : '+result.error.body.message);
			}
		}

	@wire(getAllPrelevements, { fil: '$filters' })
		wiredPrelevements(result) {
			this.showLoadingSpinner = true;
			if (result.data) {
				let jsonPrev = [];
				let json = result.data.message;
				for(let i = 0; i<json.instance.length; i++){
					for(let j = 0; j<json.instance[i].item.length; j++){
						let Npaid;
						if(json.instance[i].item[j].hasOwnProperty('recordedInvoice ')){
							Npaid = 'OUI';
						}else{
							Npaid = 'NON';
						}
						let tempJson = {
                            "id": json.instance[i].id,
							"endDate": this.timeConverter(json.instance[i].endDate),
							"startDate": this.timeConverter(json.instance[i].startDate),
							"amount": parseFloat(json.instance[i].amount).toFixed(2),
							"dueDateDays": this.timeConverter(json.instance[i].dueDateDays),
							"serviceInstanceCode": json.instance[i].serviceInstanceCode == 'SE_ACOMPTE'?'ACOMPTE':'SOLDE',
							"subscriptionCode": json.instance[i].subscriptionCode,
							//"paid": json.instance[i].item[j].paid == false? 'NON':'OUI',
							"paid": Npaid,
							"last": json.instance[i].item[j].last == false? 'NON':'OUI',
							"dueDate": this.timeFormat(json.instance[i].item[j].dueDate),
							"status": json.instance[i].status,
							"nbEcheance":json.instance[i].item.length
						};
						jsonPrev.push(tempJson);
						console.log('jsonPrev : '+ JSON.stringify(jsonPrev));
					}
				}
				this.showLoadingSpinner = false;
				//this.AllPrelevements = jsonPrev.sort(this.custom_sort);
				let tempSort = jsonPrev.sort(this.custom_sort);
				let tempFinal = [];
				let numEch = 0;
				for(let k = 0; k<tempSort.length; k++){
					let tempElem = {};
					console.log('this.timeConverter(tempSort[k].dueDate) : '+ this.timeConverter(tempSort[k].dueDate));
					console.log('tempSort[k].serviceInstanceCode : '+ tempSort[k].serviceInstanceCode);
					if (tempSort[k].serviceInstanceCode == 'ACOMPTE'){
						tempElem = {
							"id": tempSort[k].id,
							"subscriptionCode": tempSort[k].subscriptionCode,
							"serviceInstanceCode": tempSort[k].serviceInstanceCode,
							"amount": tempSort[k].amount,
							"dueDate": this.timeConverter(tempSort[k].dueDate),
							"echeancier": '1/1'
						};
					}else{
						numEch = numEch+1;
						tempElem = {
							"id": tempSort[k].id,
							"subscriptionCode": tempSort[k].subscriptionCode,
							"serviceInstanceCode": tempSort[k].serviceInstanceCode,
							"amount": tempSort[k].amount,
							"dueDate": this.timeConverter(tempSort[k].dueDate),
							"echeancier": numEch+'/'+tempSort[k].nbEcheance
						};
						
					}
				tempFinal.push(tempElem);	
				}
			this.AllPrelevements = tempFinal;

			} else if (result.error) {
				this.showLoadingSpinner = false;
				console.log('wiredPrelevements : '+result.error.body.message);
			}
		}
    // refus de prélevement
	@wire(getRefusPrelevements, { idtiers: '$idPersonne' })
		wiredRefusPrelevements(result) {
			console.log('start here');
			this.showLoadingSpinner = true;
			if (result.data) {
				let jsonPrev = [];
				let json = result.data.message;
				console.log('json : '+ JSON.stringify(json));
				for(let i = 0; i<json.resultList.length; i++){
					let tempJson = {
						"motifRefus": json.resultList[i].motifRefus,
						"dateEcheance": this.timeConverter(json.resultList[i].dateEcheance),
						"montantEcheance": parseFloat(json.resultList[i].montantEcheance).toFixed(2),
						"paye": json.resultList[i].paye
					};
					jsonPrev.push(tempJson); 
				}
				this.showLoadingSpinner = false;
				this.AllRefusPrelevements = jsonPrev;
			} else if (result.error) {
				this.showLoadingSpinner = false;
				console.log('wiredRefusPrelevements : '+result.error.body.message);
			}
		}

    showToast(titre, texte, type){
		this.dispatchEvent(new ShowToastEvent({
			title: titre, 
			message: texte, 
			variant: type
		}),);
	}

    timeConverter(UNIX_timestamp){
		var a = new Date(UNIX_timestamp);
		var months = ['Jan','Fév','Mar','Avr','Mai','Jun','Jul','Aoû','Sep','Oct','Nov','Déc'];
		var year = a.getFullYear();
		var month = months[a.getMonth()];
		var date = a.getDate();
		var time = date + ' ' + month + ' ' + year ;
		return time;
	}
	timeFormat(UNIX_timestamp){
		var a = new Date(UNIX_timestamp);
		var year = a.getFullYear();
		var month = a.getMonth()+1;
		var date = a.getDate();
		var time = year + '-' + month + '-' + date ;
		return time;
	}
	custom_sort(a, b) {
		return new Date(a.dueDate).getTime() - new Date(b.dueDate).getTime();
	}
}