import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';

export default class CardPaiementFacturation extends NavigationMixin(LightningElement) {
@api listrecord;
@api index;
@api selecteditem;
@track selecteditem;
@api recordid;
@api notesdebitscredits;
@api iswarning;
@api listBlocage=[];
@api NoBlocage=false;
@api dossierrecouvrement;
@api BoolanAideClient="NON";
@api soldeEnCoursValue="--€";
@api dateProchaineFactureSoldeValue="--";
@api typeBlocageSoldeValue="--";
@api isBlocageRelance="NON";
@api MensualisationSoldeValue="NON";
@api MontantCumuleEcheanceValue="--€";

//FT2-1765 Ajustement mensualité V2 : Récupération des adresses (écran Localisation du logement (1/2))
@api listorderedadresses;

dataFlyout = null;
initData = true;
isGaz;
isElec;
isService1;
isService2;
numberPas = 0;

@api idplanpaiement;//FT2-1278 INTEGRATION - InitierAjustement

//FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764
//Vérifier si le client est résilié
get isResilie(){
    let isResilieTrue = (!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS && (this.listrecord[this.index].contratinactifelecWS || this.listrecord[this.index].contratinactifgazWS)) ? true : false
    return isResilieTrue;
}

get noteDebitCreditWarning() {
    return this.listrecord[this.index].iswarning;
}
get showSpinner() {
    return this.selecteditem && (this.selecteditem.loadFacture || this.selecteditem.errorContratWs);
}
get isMensualisee() {
    return this.selecteditem && this.selecteditem.modePaiement === 'mensualisé';
}
get isClientAide() {	
    return this.selecteditem.solde && this.selecteditem.solde.clientAide === true ;	
}
get isPrelevee() {
    return this.selecteditem && this.selecteditem.modePaiement === 'Prélevé';
}
get noDataPlanMesualisee () {
    return (this.selecteditem && (!this.selecteditem.lirePlanMensualisationResponse || !this.selecteditem.dernierPlanMensualisation) && this.selecteditem.loadMensualisee) || this.isResilie != false; //FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764 - La variable est misé également à true si le client est résilié
}
get isNonPrelevee() {
    return this.selecteditem && this.selecteditem.modePaiement === 'Non prélevé';
}
get isNotNothing() {
    return this.selecteditem && this.selecteditem.modePaiement !== 'Non prélevé' && this.selecteditem.modePaiement !== 'Prélevé' && this.selecteditem.modePaiement !== 'mensualisé';
}
get isDRPIndisponible(){
    return this.selecteditem && this.selecteditem.conditionPaiementMaj === 'Information DRP indisponible'
}
get isStatutMondatColture() {
    return this.selecteditem && this.selecteditem.codeStatutMandat === '6' && this.selecteditem.libelleStatutMandat === 'Clôturé';
}
get isStatutMondatConfirmer() {
    return this.selecteditem && this.selecteditem.codeStatutMandat === '2' && this.selecteditem.libelleStatutMandat === 'A Confirmer';
}
get isStatutMondatError() {
    return this.selecteditem && this.selecteditem.libelleStatutMandat === 'error';
}
get transformDateComptable () {
    return this.selecteditem.dateComptable.split("-")[2] + '/' + this.selecteditem.dateComptable.split("-")[1] + '/' + this.selecteditem.dateComptable.split("-")[0]
}
get transformDateEcheance () {
    if(this.selecteditem && this.selecteditem.dateEcheance) {
        return this.selecteditem.dateEcheance.split("-")[2] + '/' + this.selecteditem.dateEcheance.split("-")[1] + '/' + this.selecteditem.dateEcheance.split("-")[0];
    }
    return '';
}
// FT2-1711 -> Ajustement de Mens : Mensualité remonte à 0 pour les BP qui ont deux contrats pour la même énergie
get categorie(){
    if(this.selecteditem && this.selecteditem.contratactifgazWS && this.selecteditem.contratactifelecWS) 
       return "D";
    
    else if(this.selecteditem && ((this.selecteditem.contratactifgazWS && !this.selecteditem.contratactifelecWS) || (this.selecteditem.contratactifelecWS && !this.selecteditem.contratactifgazWS)))
    return "M";
}

//FT2-1263 -> affichage du pictogramme sur la vue 360 dès lors qu'il a un dossier solidarité de moins d’un an
get dossierSolidariteIconName() {	
    if(this.listrecord[0] && this.listrecord[0].hasDossiersAffaire)	
    return 'utility:warning';	
    return 'utility:info';	
}	

//FT2-1263 -> affichage du pictogramme sur la vue 360 dès lors qu'il a un dossier solidarité de moins d’un an
get dossierSolidariteVariant(){	
    if(this.listrecord[0] && this.listrecord[0].hasDossiersAffaire)	
    return 'warning';	
    return 'info';	
}
get showBtnMens() {
    let isShow = false;
    if( this.selecteditem && this.selecteditem.modePaiement === 'mensualisé' 
    && ((this.selecteditem.contratactifelecWS
    && (this.selecteditem.contratactifelecWS.statutCode === 'E0004' 
    || this.selecteditem.contratactifelecWS.statutCode === 'E0005' 
    || this.selecteditem.contratactifelecWS.statutCode === 'E0006'
    || this.selecteditem.contratactifelecWS.statutCode === 'E0007'
    || this.selecteditem.contratactifelecWS.statutCode === 'E0008')) 
    || ( this.selecteditem.contratactifgazWS 
    && (this.selecteditem.contratactifgazWS.statutCode === 'E0004' 
    || this.selecteditem.contratactifgazWS.statutCode === 'E0005' 
    || this.selecteditem.contratactifgazWS.statutCode === 'E0006'
    || this.selecteditem.contratactifgazWS.statutCode === 'E0007'
    || this.selecteditem.contratactifgazWS.statutCode === 'E0008')))) {
        isShow = true;
    }
    return isShow;
} 

get defineColorSolde() {
    return this.selecteditem  && this.listrecord[this.index] && this.listrecord[this.index].solde !== undefined;
}
get getDateSolde() {
    let tempDate;
    if (this.defineColorSolde) {
        if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualisee) {
            tempDate = new Date(this.dateEcheanceMensualisee.split('/')[2], this.dateEcheanceMensualisee.split('/')[1], this.dateEcheanceMensualisee.split('/')[0]);
        } else if (this.selecteditem.modePaiement === "mensualisé" && this.isDateEcheanceMensualiseeAvecRegul) {
            tempDate = new Date(this.selecteditem.factureRegul.dateEcheance);
        } else {
            tempDate = new Date(this.transformDateEcheance.split('/')[2], this.transformDateEcheance.split('/')[1], this.transformDateEcheance.split('/')[0]);
        }
    }
    return tempDate;
}
get isDateEcheanceMensualiseeAvecRegul () {
    return this.defineColorSolde && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance;
}
get dateEcheanceMensualiseeAvecRegul () {
    if (this.defineColorSolde) {
        let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-');
        return tempDate[2] + '/' + tempDate[1] + '/' + tempDate[0];
    }
    return '';
}
get isDateEcheanceMensualisee () {
    return this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.dateEcheance && this.isResilie != true //FT2-1839 - [PROD][VUE 360] - Données financières incorrectes - FI01204764 - La variable est misé également à true si le client n'est pas résilié
}
get dateEcheanceMensualisee() {
    let tempDate = this.selecteditem.dernierPlanMensualisation.dateEcheance.split('/')
    return tempDate[1] + '/' + tempDate[0] + '/' + tempDate[2];
}
get isMensualisationClose() {
    return this.selecteditem && !this.selecteditem.closemensualisation;
}
get isMensualisationOpen() {
    return this.selecteditem && this.selecteditem.closemensualisation;
}
get montantGlobal() {
    let montantGlobal = "0,00 €";
    if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
        montantGlobal = parseFloat(this.selecteditem.mensualisations[0].montantGlobal).toFixed(2).replace('.', ',') + " €";
    }
    return montantGlobal;
}

get montantGlobalOriginal() {
    let montantGlobalOriginal = 0;
    if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
        montantGlobalOriginal = this.selecteditem.mensualisations[0].montantGlobal;
    }
    return montantGlobalOriginal;
}

get montantPaye() {
    let montantPaye = "0,00 €";
    if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
        montantPaye = 0;
        for (let i = 0; i < this.selecteditem.mensualisations.length ; i++) {
            if(this.selecteditem.mensualisations[i].code === "9") {
                montantPaye += parseFloat(this.selecteditem.mensualisations[i].montantEcheance);
            }
        }
        montantPaye = montantPaye.toFixed(2).replace('.', ',') + " €";
    }
    return montantPaye;
}
get getMontantTotal() {
    if (this.selecteditem && this.selecteditem.montantTotal) {
        return this.selecteditem.montantTotal.toFixed(2).replace('.', ',') + '€';
    }
    return '';
}
get showCumule() {
    return this.numberPas === 1;
}
get getDateComptablePrelevee() {
    if( this.selecteditem && this.selecteditem.dateComptable ) {
        let tempDate = this.selecteditem.dateComptable.split('-');
        return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
    }
    return '';
}
get getDateComptable() {
    if( this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateComptable ) {
        let tempDate = this.selecteditem.factureRegul.dateComptable.split('-');
        return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
    }
    return '';
}
get getDateEcheance() {
    if( this.selecteditem && this.selecteditem.factureRegul && this.selecteditem.factureRegul.dateEcheance ) {
        let tempDate = this.selecteditem.factureRegul.dateEcheance.split('-');
        return tempDate[2]  + '/' + tempDate[1] + '/' + tempDate[0];
    }
    return '';
}
//True Si la couleur du solde est bleu
get isBlueSolde() {
    if ( this.defineColorSolde && this.selecteditem.solde && this.selecteditem.solde.solde < 0) {
        return true;
    }
    return false;
}
//True Si la couleur du solde est rouge
get isRedSolde() {
    let toDay = new Date();
    if(this.defineColorSolde && this.selecteditem.solde && this.selecteditem.solde.solde > 0 && this.getDateSolde < toDay){
        return true;
    }
    return false;
}
get getiBAN() {
    if(this.selecteditem && this.selecteditem.iBAN) {
        return this.selecteditem.iBAN.substring(0, 4) + '...' +this.selecteditem.iBAN.substring(this.selecteditem.iBAN.length - 4 ,this.selecteditem.iBAN.length);
    }
    return '';
}
get getMontantCumuleEcheance (){
    if(this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance) {
        return parseFloat(this.selecteditem.dernierPlanMensualisation.montantCumuleEcheance).toFixed(2).replace(".", ",") + ' €';
    }
    return '';
}

//FT2-1855 Recuperation du nombre de mensualites dues
get getIsPlanMensValid(){
    let nbMensDues = 0;
    let lastDateEcheance='';
    if(this.selecteditem?.lirePlanMensualisationResponse!=null){
        for(let i=0; i < this.selecteditem?.lirePlanMensualisationResponse?.length; i++){
            if(this.selecteditem.lirePlanMensualisationResponse[i]?.code==="OCT_02" && this.selecteditem.lirePlanMensualisationResponse[i]?.dateEcheance!=lastDateEcheance){
                nbMensDues=nbMensDues+1;
                lastDateEcheance = this.selecteditem.lirePlanMensualisationResponse[i]?.dateEcheance;
            }
        }
    }
    let isPlanMensValid = false;
    if(nbMensDues>=2){
        isPlanMensValid = true;
    }
    return isPlanMensValid;
}

// FT2-1275 Recuperation du montantEcheance
get getMontantEcheance (){
    let montantEcheanceMens = "0,00 €";
    if(this.selecteditem && this.selecteditem.dernierPlanMensualisation && this.selecteditem.dernierPlanMensualisation.montantEcheance) {
        montantEcheanceMens = parseFloat(this.selecteditem.dernierPlanMensualisation.montantEcheance).toFixed(2).replace(".", ",") + ' €';  
    }
    
    return montantEcheanceMens;
    
}

get soldeFormater() {
    if(this.selecteditem && this.selecteditem.solde && this.selecteditem.solde.solde) {
        let input = this.selecteditem.solde.solde;
        let decimal = "00"
        let entier = "";
        input = input.toString();
        let decArr=input.split(".");
        if(decArr.length>1){
            let dec = decArr[1].length;
            if(dec === 1) {
                decimal = decArr[1] + "0";
            } else {
                decimal = decArr[1];
            }
        }
        if(decArr[0].length > 3) {
            let j = 0
            for ( let i = decArr[0].length - 1; i >= 0; i-- ) {
                if ( j > 0 && j % 3 === 0) {
                    entier= decArr[0][i] + " " + entier;
                } else {
                    entier= decArr[0][i] + entier;
                }
                j++;
            }
        } else {
            entier= decArr[0];
        }
        return entier.concat(',', decimal);
    } else if( this.selecteditem && (this.selecteditem.solde === {} || (this.selecteditem.solde && this.selecteditem.solde.solde === 0)) ){
        return "0,00";
    }
    return "";
}
get isblocage(){
    return this.listrecord[this.index].blocageRelance || this.listrecord[this.index].blocageFacturation || this.listrecord[this.index].blocageDecaissement || this.listrecord[this.index].blocagePrevelement;
}



//fonction de formatage de date a dd-mm-yyyy
@api DateFormaterF(inputDate){
    let FormaterDateV=new Date(inputDate);
              const DateFC = new Intl.DateTimeFormat('fr', {
                
                day: '2-digit',
  
                month: '2-digit',
  
                year: 'numeric'
                  
                })
              const [{value: dd}, , {value: mm}, , {value: yy}] = DateFC.formatToParts(FormaterDateV);
              FormaterDateV=`${dd}-${mm}-${yy}`;
              return FormaterDateV;
  }

@api TransferBooleanAideClient(){
    let boolV=this.selecteditem.solde.clientAide;

    if(boolV==true){
        this.BoolanAideClient="OUI";
    }
    return this.BoolanAideClient;

}

@api soldeEnCours(){
    if(this.selecteditem.solde.soldeEnCours!=null){
    let solde=this.selecteditem.solde.soldeEnCours;
    this.soldeEnCoursValue=parseFloat(solde).toFixed(2).replace(".", ",") + ' €';
}
    return this.soldeEnCoursValue;
}

@api dateProchaineFactureSolde(){
 
    if(this.selecteditem.solde.dateProchaineFacture!=null){
  
   this.dateProchaineFactureSoldeValue=this.DateFormaterF(this.selecteditem.solde.dateProchaineFacture);
}

return this.dateProchaineFactureSoldeValue;
}

//MontantCumuleEcheance
@api MontantCumuleEcheanceMensualisation (){

    if(this.selecteditem.lirePlanMensualisationResponse!= null && this.selecteditem.lirePlanMensualisationResponse!= '') {
        let  arraySortedL = JSON.parse(JSON.stringify(this.selecteditem.lirePlanMensualisationResponse));
        arraySortedL = arraySortedL.sort((a, b) => new Date(b.dateEcheanceNonFormatted).valueOf()-new Date(a.dateEcheanceNonFormatted).valueOf())
        if(arraySortedL != null && arraySortedL.length > 0){
        let lastItem = arraySortedL[0];
        this.MontantCumuleEcheanceValue =parseFloat(lastItem.montantCumuleEcheance).toFixed(2).replace(".", ",") + ' €';
        }
    }
   return this.MontantCumuleEcheanceValue;

}
//Mensualisation :Si(serviceSouscrit_serviceGestion_code=ZMENS et serviceSouscrit_statutService_libelleCourt=Actif) alors afficher “OUI” sinon afficher “NON”
@api MensualisationSolde(){
    if(this.selecteditem.solde.serviceSouscritMensActif==true && this.selecteditem.solde.statutserviceLibelle=="Actif"){
this.MensualisationSoldeValue="OUI";
    }
    return this.MensualisationSoldeValue;
    
}

@api TransformBooleanToFR(inputBool){
    if(inputBool==true){
return "OUI";
    }else{
        return "NON";
    }
}
//FT2-1616 -> Migration Vlocity de la Synthèse des Blocages
get listSyntheseBlocage(){
    this.listBlocage =[];
    //Aucun blocage pour ce client
    if(this.listrecord[this.index].blocageRelance===false&&this.listrecord[this.index].blocageFacturation===false&&this.listrecord[this.index].blocageDecaissement===false&&this.listrecord[this.index].blocagePrevelement===false){
        this.NoBlocage=true;
        }else{
        this.NoBlocage=false;

        //blocageRelance
        if(this.listrecord[this.index].blocageRelance===true){
            this.listBlocage.push({
                type:'Relance',
                motif:this.listrecord[this.index].libelleMotifBlocageRelance,
                dateDebut:this.listrecord[this.index].dateDebutBlocageRelance,
                dateFin:this.listrecord[this.index].dateFinBlocageRelance});
        }
        //blocageFacturation
        if(this.listrecord[this.index].blocageFacturation===true){
            this.listBlocage.push({
                type:'Facturation',
                motif:this.listrecord[this.index].libelleMotifBlocageFacturation,
                dateDebut:this.listrecord[this.index].dateDebutBlocageFacturation,
                dateFin:this.listrecord[this.index].dateFinBlocageFacturation});
        }
        
        if(this.listrecord[this.index].blocagePrevelement===true){
            this.listBlocage.push({
                type:'Encaissement',
                motif:this.listrecord[this.index].libelleMotifBlocagePrevelement,
                dateDebut:this.listrecord[this.index].dateDebutBlocagePrevelement,
                dateFin:this.listrecord[this.index].dateFinBlocagePrevelement});
        }
        
        //blocageDecaissement
        if(this.listrecord[this.index].blocageDecaissement===true){
            this.listBlocage.push({
                type:'Decaissement',
                motif:this.listrecord[this.index].libelleMotifBlocageDecaissement,
                dateDebut:this.listrecord[this.index].dateDebutBlocageDecaissement,
                dateFin:this.listrecord[this.index].dateFinBlocageDecaissement});
        }
    }
    
    return JSON.stringify(this.listBlocage);

   
}

navigateToBlocage() {
    const eventName = 'openSyntheseBlocage'
    const inputMap= {
        numeroVoie: this.listrecord[this.index].numeroVoie,
        libelleVoie: this.listrecord[this.index].libelleVoie,
        complementAdresse: this.listrecord[this.index].complementAdresse,
        codePostal: this.listrecord[this.index].codePostal,
        ville: this.listrecord[this.index].ville,
        recordId: this.recordid,
        blocageRelance: this.listrecord[this.index].blocageRelance,
        libelleMotifBlocageRelance: this.listrecord[this.index].libelleMotifBlocageRelance,
        dateDebutBlocageRelance: this.listrecord[this.index].dateDebutBlocageRelance,
        dateFinBlocageRelance: this.listrecord[this.index].dateFinBlocageRelance,
        blocageFacturation: this.listrecord[this.index].blocageFacturation,
        libelleMotifBlocageFacturation: this.listrecord[this.index].libelleMotifBlocageFacturation,
        dateDebutBlocageFacturation: this.listrecord[this.index].dateDebutBlocageFacturation,
        dateFinBlocageFacturation: this.listrecord[this.index].dateFinBlocageFacturation,
        blocageDecaissement: this.listrecord[this.index].blocageDecaissement,
        libelleMotifBlocageDecaissement: this.listrecord[this.index].libelleMotifBlocageDecaissement,
        dateDebutBlocageDecaissement: this.listrecord[this.index].dateDebutBlocageDecaissement,
        dateFinBlocageDecaissement: this.listrecord[this.index].dateFinBlocageDecaissement,
        blocagePrevelement: this.listrecord[this.index].blocagePrevelement,
        libelleMotifBlocagePrevelement: this.listrecord[this.index].libelleMotifBlocagePrevelement,
        dateDebutBlocagePrevelement: this.listrecord[this.index].dateDebutBlocagePrevelement,
        dateFinBlocagePrevelement: this.listrecord[this.index].dateFinBlocagePrevelement,
        NoCompteContrat: this.listrecord[this.index].NoCompteContrat ? this.listrecord[this.index].NoCompteContrat.toString() : '', 
        listSyntheseBlocage:this.listSyntheseBlocage
    };
    const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
    this.dispatchEvent(event);
}

// Added by RJM FT2-668
get isBlocageRelance(){

    let today = new Date();
    if(this.selecteditem.firstBlocage && this.selecteditem.firstBlocage.dateDebutBlocage && this.selecteditem.firstBlocage.dateFinBlocage
     ){
       
        let tempToday = today.toISOString().split("T")[0].split('-');
        tempToday = new Date(tempToday[0] + '-' + tempToday[1] + '-' + tempToday[2] + 'T00:00:00.0');
        if(tempToday >= new Date(this.selecteditem.firstBlocage.dateDebutBlocage) && tempToday <= new Date(this.selecteditem.firstBlocage.dateFinBlocage) ){
             return 'OUI';
         }
     }
     return 'NON';
}

 get isRecouvrement() {
        if(this.selecteditem 
            && this.selecteditem.LireCompteClientReturn 
            && this.selecteditem.LireCompteClientReturn.DossierRecouvrement === 'true'){ return 'OUI';}
            return 'NON';
    }

//FT2-1307 Afficher présence Payeur divergent sur vue 360    
get isPayeurDivergent () {
   
    if(this.selecteditem.payeurdivergent ){
       if((this.selecteditem.payeurdivergent.idPersonneDivergentPayeur !== 0 && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur   !== undefined && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur  !== null && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur  !== '') || 
       (this.selecteditem.payeurdivergent.idPersonneDivergentRelance   !== 0 && this.selecteditem.payeurdivergent.idPersonneDivergentRelance  !== undefined && this.selecteditem.payeurdivergent.idPersonneDivergentRelance !== null && this.selecteditem.payeurdivergent.idPersonneDivergentRelance !== '') || 
       (this.selecteditem.payeurdivergent.idPersonneDivergentFacture   !== 0 && this.selecteditem.payeurdivergent.idPersonneDivergentFacture  !== undefined && this.selecteditem.payeurdivergent.idPersonneDivergentFacture !== null && this.selecteditem.payeurdivergent.idPersonneDivergentFacture !== '')){
            return true;
        }else{
            return false;
        }
    }
    
}  

//FT2-1374 Gestion des coordonnées bancaire du payeur divergent sur vue 360
get isRolePayeurDivergent () {
    if(this.selecteditem.payeurdivergent ){
       if(this.selecteditem.payeurdivergent.idPersonneDivergentPayeur !== 0 && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur !== undefined && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur !== null && this.selecteditem.payeurdivergent.idPersonneDivergentPayeur !== ''){
            return true;
        }else{
            return false;
        }
    }    
}  

navigateToDossierSolidarite(){	
    
    let listAdresses = [];	
    for( const adresse of this.listrecord ) {	
        let adresseTemp = {};	
        adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;	
        adresseTemp.NoCompteContrat = adresse.NoCompteContrat;	
        adresseTemp.libelleVoie = adresse.libelleVoie;	
        adresseTemp.numeroVoie = adresse.numeroVoie;	
        adresseTemp.complementAdresse = adresse.complementAdresse;	
        adresseTemp.codePostal = adresse.codePostal;	
        adresseTemp.ville = adresse.ville;	
        listAdresses.push(adresseTemp);	
    }	
    if(this.listrecord[this.index].contratactifelecWS){
        this.isElec = true;
    }
    if(this.listrecord[this.index].contratactifgazWS){
        this.isGaz = true;
    }
    console.log(this.dossierrecouvrement);
    this[NavigationMixin.Navigate]({	
        type: 'standard__component',	
        attributes: {	
            componentName: 'c__SM_Dossier_Solidarite'	
        },	
        state: {	
          //  c__dossierRecouvrement:this.TransformBooleanToFR(this.dossierrecouvrement.DossierRecouvrement),


            c__idDossierRecouvrement: this.dossierrecouvrement ? JSON.stringify(this.dossierrecouvrement.idDossierRecouvrement) : '',

            c__dossierRecouvrement:this.isRecouvrement,
            c__dernierPlanMensualisation : JSON.stringify(this.listrecord[this.index].dernierPlanMensualisation),	
            c__lirePlanMensualisationResponse : JSON.stringify(this.selecteditem.lirePlanMensualisationResponse),	
            c__numeroVoie: this.listrecord[this.index].numeroVoie ? this.listrecord[this.index].numeroVoie.toString() : '',	
            c__libelleVoie: this.listrecord[this.index].libelleVoie ? this.listrecord[this.index].libelleVoie.toString() : '',
            c__complementAdresse: this.listrecord[this.index].complementAdresse ? this.listrecord[this.index].complementAdresse.toString() : '',
            c__codePostal: this.listrecord[this.index].codePostal ? this.listrecord[this.index].codePostal.toString() : '',	
            c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat ? this.listrecord[this.index].NoCompteContrat.toString() : '',  
            c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj ? this.listrecord[this.index].NoCompteContratMaj.toString() : '',  
            c__ville: this.listrecord[this.index].ville ? this.listrecord[this.index].ville.toString() : '', 
            c__IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,	
            c__IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,	
            c__recordId: this.recordid,	
            c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),	
            c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),	
            c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),	
            c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),	
            c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,	
            c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,	
            c__AccountId: this.selecteditem.AccountId,	
            c__listAdresses: JSON.stringify(listAdresses),	
            c__solde: this.soldeFormater,	
            c__DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',	
            c__soldeColor: this.isRedSolde ? '%23c10e24' : ((this.isBlueSolde) ? '%231E90FF' : '%23000000')	,
            c__dateAideFSL:this.selecteditem.solde.dateAideFSL,
            c__typeDeBlocage : (this.selecteditem.firstBlocage && this.selecteditem.firstBlocage.motifBlocage ) ? this.selecteditem.firstBlocage.motifBlocage.libelleCourt : '',
            c__blocageRelance : this.isBlocageRelance,
            c__clientAide: this.TransferBooleanAideClient(),
            c__soldeEnCours: this.soldeEnCours(),
            c__dateProchaineFactureSolde: this.dateProchaineFactureSolde(),
            c__MensualisationSolde:this.MensualisationSolde(),
            c__MontantCumuleEcheanceMensualisation: this.MontantCumuleEcheanceMensualisation(),
            c__iBAN: this.listrecord[this.index].iBAN,
            c__nomInstitutBancaire: this.listrecord[this.index].nomInstitutBancaire,
            c__soldeDelaiPaiement :  this.selecteditem.solde ? this.selecteditem.solde.solde : '',
            c__isContratGaz : this.isGaz,
            c__isContratElec : this.isElec,
            c__isPrelevee: this.isPrelevee,
            c__isMensualisee: this.isMensualisee,
            c__EnqSat:JSON.stringify(this.listrecord[this.index].EnqSat)

        }	
    });	
}

//KDI FT2-1403: Affichage de l'écran payeur divergent au clic sur crayon
navigateToPayeurDivergent(){
    const eventName = 'openPayeurDivergent';
	const inputMap = {
            recordId: this.recordid,
            NoCompteContrat: this.listrecord[this.index].NoCompteContrat,
            idPersonneDivergentPayeur: this.selecteditem.payeurdivergent.idPersonneDivergentPayeur,
            idPersonneDivergentRelance: this.selecteditem.payeurdivergent.idPersonneDivergentRelance,
            idPersonneDivergentFacture: this.selecteditem.payeurdivergent.idPersonneDivergentFacture,
            isPayeurDivergent: this.isPayeurDivergent,
            numeroVoie: this.listrecord[this.index].numeroVoie,
            libelleVoie: this.listrecord[this.index].libelleVoie,
            complementAdresse: this.listrecord[this.index].complementAdresse,
            CP: this.listrecord[this.index].codePostal,
            city: this.listrecord[this.index].ville,
            IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            AccountId: this.selecteditem.AccountId,
            isMensualisee:this.isMensualisee,	
            factureEnLigne: this.listrecord[this.index].factureEnLigne
     };
	 const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: inputMap });
     this.dispatchEvent(event);	
}

navigateToModePaiement(){
    let isResilie = (!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS && (this.listrecord[this.index].contratinactifelecWS || this.listrecord[this.index].contratinactifgazWS)) ? true : false
    let isMensualisation = true;

    if(!this.listrecord[this.index].contratactifelecWS && !this.listrecord[this.index].contratactifgazWS) {
        isMensualisation = false;
    } else if(this.listrecord[this.index].contratactifelecWS && 
        ( this.listrecord[this.index].contratactifelecWS.statutCode === 'E0009' ||
            this.listrecord[this.index].contratactifelecWS.statutCode === 'E0007' ||
            this.listrecord[this.index].contratactifelecWS.statutCode === 'E0008')) {
        isMensualisation = false;
    } else if (this.listrecord[this.index].contratactifgazWS && 
        ( this.listrecord[this.index].contratactifgazWS.statutCode === 'E0009' ||
            this.listrecord[this.index].contratactifgazWS.statutCode === 'E0007' ||
            this.listrecord[this.index].contratactifgazWS.statutCode === 'E0008')) {
        isMensualisation = false;
    }
    let listAdresses = [];
    let listAdressesPrel = [];
    for( const adresse of this.listrecord ) {
        console.log(adresse.NoCompteContrat + adresse.modePaiement);
        if(adresse.modePaiement === 'Prélevé' || adresse.modePaiement ===  'mensualisé'){
        let adresseTemp = {};
        adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
        adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
        adresseTemp.libelleVoie = adresse.libelleVoie;
        adresseTemp.numeroVoie = adresse.numeroVoie;
        adresseTemp.complementAdresse = adresse.complementAdresse;
        adresseTemp.codePostal = adresse.codePostal;
        adresseTemp.ville = adresse.ville;
        listAdressesPrel.push(adresseTemp);
        }
    }

    for( const adresse of this.listrecord ) {
        if(adresse.NoCompteContrat !== this.listrecord[this.index].NoCompteContrat){
        let adresseTemp = {};
        adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
        adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
        adresseTemp.libelleVoie = adresse.libelleVoie;
        adresseTemp.numeroVoie = adresse.numeroVoie;
        adresseTemp.complementAdresse = adresse.complementAdresse;
        adresseTemp.codePostal = adresse.codePostal;
        adresseTemp.ville = adresse.ville;
        listAdresses.push(adresseTemp);
        }
    }
        // FT2-1280 préparation du json du tableau d'échéancier qui est envoyé à l'ajustement de mens
        var tableDataMensString= '';
        if(this.showBtnMens){ 
            this.transformData();
            var tableDataMens = this.dataFlyout;
            var flexcardParams = new Object(); // paramètre utilisé sur la flexcard SM_AjustementMensualite_Echeancier
            flexcardParams.isHeader = true;
            flexcardParams.isGaz  = this.isGaz;
            flexcardParams.isElec = this.isElec;
            flexcardParams.isService1 = this.isService1;
            flexcardParams.isService2 = this.isService2;
            flexcardParams.montantGlobal = this.montantGlobal;
            flexcardParams.montantPaye = this.montantPaye;
        
            if (tableDataMens != null) {
                tableDataMens.unshift(flexcardParams);
            }
            var tableDataMensString= JSON.stringify(tableDataMens);
        }
    this[NavigationMixin.Navigate]({
        type: 'standard__component',
        attributes: {
            componentName: 'c__SM_Mode_Paiement'
        },
        state: {
            c__numeroVoie: this.listrecord[this.index].numeroVoie,
            c__libelleVoie: this.listrecord[this.index].libelleVoie,
            c__complementAdresse: this.listrecord[this.index].complementAdresse,
            c__codePostal: this.listrecord[this.index].codePostal,
            c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat,
            c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj,
            c__ville: this.listrecord[this.index].ville,
            c__recordId: this.recordid,
            c__isPrelevee: this.isPrelevee,
            c__isNonPrelevee: this.isNonPrelevee,
            c__isMensualisee: this.isMensualisee,
            c__conditionPaiement: this.listrecord[this.index].conditionPaiement,
            c__idCoordonneeBancaire: this.listrecord[this.index].idCoordonneeBancaire,
            c__iBAN: this.listrecord[this.index].iBAN,
            c__nomInstitutBancaire: this.listrecord[this.index].nomInstitutBancaire,
            c__titulaireCompte: this.listrecord[this.index].titulaireCompte,
            c__codeStatutMandat: this.listrecord[this.index].codeStatutMandat,
            c__libelleStatutMandat: this.listrecord[this.index].libelleStatutMandat,
            c__numeroMandat: this.listrecord[this.index].numeroMandat,
            c__codeINSEE: this.listrecord[this.index].codeINSEE,
            c__IdBusinessPartner: this.selecteditem.IdBusinessPartner,
            c__isResilie: isResilie,
            c__listAdresses: JSON.stringify(listAdresses),
            c__isMensualisation: isMensualisation,
            c__solde: this.soldeFormater,
            c__dateImpression: this.listrecord[this.index].dateImpression,
            c__conditionPaiementMaj: this.listrecord[this.index].conditionPaiementMaj,
            c__conditionPaiement: this.listrecord[this.index].conditionPaiement,
            c__factureEnLigne: this.listrecord[this.index].factureEnLigne,
            c__libelleFactureEnLigne: this.listrecord[this.index].libelleFactureEnLigne,
            c__dateProchaineFacture: this.listrecord[this.index].dateProchaineFacture,
            c__numeroLocal: this.listrecord[this.index].numeroLocal,
            c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
            c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
            c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
            c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
            c__idContratGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idContrat : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.idContrat : ''),
            c__idContratElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.idContrat : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.idContrat : ''),
            //FT2-1724 Ajustement mensualité V2 : Récupération du montant estimée depuis l’Outil d’estimation
            c__idPackElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.idPack : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.idPack : ''),
            c__idPackGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idPack : (this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.idPack : ''),
            c__idOfferElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.codeOffre : (this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.codeOffre : ''),
            c__idOfferGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.codeOffre : (this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.codeOffre : ''),
            c__effectiveDateElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.dateDebutContrat : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.dateDebutContrat : ''),
            c__effectiveDateGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.dateDebutContrat : (this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.dateDebutContrat : ''),
            //
            c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
            c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
            c__dateTheoriqueReleve: this.listrecord[this.index].dateTheoriqueReleve,
            c__listAdressesPrel : JSON.stringify(listAdressesPrel),
            c__AccountId: this.selecteditem.AccountId,
            c__montantEcheance: this.getMontantEcheance,
            c__montantCumuleEcheance: this.getMontantCumuleEcheance,
            c__eDocument : this.listrecord[this.index].eDocument ? true : false,
            // FT2-1280 envoie du json du tableau d'échéancier et infos necessaires au LWC Modepaiement  
            c__tableDataMens : tableDataMensString,
            c__showCumuleMens : this.showCumule,
            c__isGaz : this.isGaz,
            c__isElec : this.isElec,
            c__isService1 : this.isService1,
            c__isService2 : this.isService2,
            c__montantGlobal : this.montantGlobal,
            c__montantPaye : this.montantPaye,
            //FT2-1278 INTEGRATION - InitierAjustement
            c__idPlanDePaiement : this.idplanpaiement,
            //FT2-1765 Ajustement mensualité V2 : Récupération des adresses (écran Localisation du logement (1/2))
            c__listorderedadresses : JSON.stringify(this.listorderedadresses),
            c__categorie : this.categorie,
            c__montantGlobalOriginal : this.montantGlobalOriginal,
            c__EnqSat: JSON.stringify(this.selecteditem.EnqSat),
            //FT2-1855 Recuperation du nombre de mens dues
            c__isPlanMensValid : this.getIsPlanMensValid
        }
        
    });
   
}
navigateToHistoriqueFacture(){
    let listAdresses = [];
    for( const adresse of this.listrecord ) {
        let adresseTemp = {};
        adresseTemp.IdPortefeuilleContrat = adresse.IdPortefeuilleContrat;
        adresseTemp.NoCompteContrat = adresse.NoCompteContrat;
        adresseTemp.libelleVoie = adresse.libelleVoie;
        adresseTemp.numeroVoie = adresse.numeroVoie;
        adresseTemp.complementAdresse = adresse.complementAdresse;
        adresseTemp.codePostal = adresse.codePostal;
        adresseTemp.ville = adresse.ville;
        listAdresses.push(adresseTemp);
    }
    this[NavigationMixin.Navigate]({
        type: 'standard__component',
        attributes: {
            componentName: 'c__SM_Historique_Factures'
        },
        state: {
            c__numeroVoie: this.listrecord[this.index].numeroVoie ? this.listrecord[this.index].numeroVoie.toString() : '',	
            c__libelleVoie: this.listrecord[this.index].libelleVoie ? this.listrecord[this.index].libelleVoie.toString() : '',
            c__complementAdresse: this.listrecord[this.index].complementAdresse ? this.listrecord[this.index].complementAdresse.toString() : '',
            c__codePostal: this.listrecord[this.index].codePostal ? this.listrecord[this.index].codePostal.toString() : '',	
            c__NoCompteContrat: this.listrecord[this.index].NoCompteContrat ? this.listrecord[this.index].NoCompteContrat.toString() : '',  
            c__NoCompteContratMaj: this.listrecord[this.index].NoCompteContratMaj ? this.listrecord[this.index].NoCompteContratMaj.toString() : '',  
            c__ville: this.listrecord[this.index].ville ? this.listrecord[this.index].ville.toString() : '', 
            c__IdBusinessPartner: this.listrecord[this.index].IdBusinessPartner,
            c__IdPortefeuilleContrat: this.listrecord[this.index].IdPortefeuilleContrat,
            c__recordId: this.recordid,
            c__pce: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.numeroPointDeLivraison : ''),
            c__pdl: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.numeroPointDeLivraison : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.numeroPointDeLivraison : ''),
            c__uniteReleveGaz: this.listrecord[this.index].contratactifgazWS ? this.listrecord[this.index].contratactifgazWS.uniteReleve : (this.listrecord[this.index].contratinactifgazWS ? this.listrecord[this.index].contratinactifgazWS.uniteReleve : ''),
            c__uniteReleveElec: this.listrecord[this.index].contratactifelecWS ? this.listrecord[this.index].contratactifelecWS.uniteReleve : (this.listrecord[this.index].contratinactifelecWS ? this.listrecord[this.index].contratinactifelecWS.uniteReleve : ''),
            c__dateTechniqueProchaineFacture: this.listrecord[this.index].dateTechniqueProchaineFacture,
            c__dateReelleProchaineFacture: this.listrecord[this.index].dateReelleProchaineFacture,
            c__AccountId: this.selecteditem.AccountId,
            c__listAdresses: JSON.stringify(listAdresses),
            c__solde: this.soldeFormater,
            c__DLP: (this.transformDateEcheance)?this.transformDateEcheance:(this.isDateEcheanceMensualiseeAvecRegul)?this.dateEcheanceMensualiseeAvecRegul:'',
            c__soldeColor: this.isRedSolde ? '%23c10e24' : ((this.isBlueSolde) ? '%231E90FF' : '%23000000'),
            c__EnqSat: JSON.stringify(this.selecteditem.EnqSat)

        }
    });
}
navigateToNoteDebitCredit(){
    this[NavigationMixin.Navigate]({
        type: 'standard__component',
        attributes: {
            componentName: 'c__smNoteDebitCredit_cont'
        },
        state: {
            c__listnotedebitcredit: JSON.stringify(this.listrecord[this.index].notesDebitsCredits),
            c__recordId: this.recordid,
            c__AccountId: this.selecteditem.AccountId,
            c__IdBusinessPartner: this.selecteditem.IdBusinessPartner,
            c__EnqSat:JSON.stringify(this.selecteditem.EnqSat)
            //c__idtier: JSON.stringify(listAdresses)
        }
    });
}
transformData() {
    this.initData = false;
    if(this.selecteditem && this.selecteditem.mensualisations && this.selecteditem.mensualisations.length ) {
        this.dataFlyout = [];
        let tempData = JSON.parse(JSON.stringify(this.selecteditem.mensualisations));
        let pas = 1;
        if(tempData.length > 0) {
            if((tempData[1] && tempData[0].dateEcheance !== tempData[1].dateEcheance) || !tempData[1]) {
                if (tempData[0].secteurActivite === "5G") {
                    this.isGaz = true;
                } else if (tempData[0].secteurActivite === "5E") {
                    this.isElec = true;
                } 
            }
            if(tempData[1] && tempData[0].dateEcheance === tempData[1].dateEcheance) {
                pas++;
                if (tempData[0].secteurActivite === "5G") {
                    this.isGaz = true;
                } else if (tempData[0].secteurActivite === "5E") {
                    this.isElec = true;
                }
                if (tempData[1].secteurActivite === "5G") {
                    this.isGaz = true;
                } else if (tempData[1].secteurActivite === "5E") {
                    this.isElec = true;
                } else if (tempData[1].secteurActivite === "5S") {
                    this.isService1 = true;
                }
            } 
            if(tempData[2] && tempData[0].dateEcheance === tempData[2].dateEcheance) {
                pas++;
                if (tempData[2].secteurActivite === "5S" && this.isService1) {
                    this.isService2 = true;
                } else {
                    this.isService1 = true;
                }
            }
            if(tempData[3] && tempData[0].dateEcheance === tempData[3].dateEcheance) {
                pas++;
                this.isService2 = true;
            }
            this.numberPas = pas;
        }
        let i = 0
        while(i < tempData.length) {
            let tempObj = {};
            tempObj.key = i;
            tempObj.montantCumuleEcheance = parseFloat(tempData[i].montantCumuleEcheance).toFixed(2);
            tempObj.montantGlobal = tempData[i].montantGlobal;
            let date = tempData[i].dateEcheance.split('/')
            tempObj.dateEcheance = date[1] + '/' + date[0] + '/' + date[2];
            // this.dataFlyout.push({key: i});
            switch (tempData[i].code) {
                case 'OCT_01':
                    tempObj.codeTranscode = 'rejeté';
                    tempObj.colorClass = 'red-reject';
                    tempObj.colorBoldClass = 'red-reject-bold';
                    tempObj.isRejected = true;
                    break;
                case 'OCT_02':
                    tempObj.codeTranscode = 'prevu';
                    tempObj.colorClass = 'disabled-color';
                    tempObj.colorBoldClass = 'disabled-color';
                    tempObj.isToApprouved = true;
                    break;
                case '9':
                    tempObj.codeTranscode = 'prélevé';
                    tempObj.colorClass = 'normal-color';
                    tempObj.colorBoldClass = 'normal-color';
                    tempObj.isApprouved = true;
                    break;
                default:
                    tempObj.codeTranscode = '';
                    tempObj.colorClass = 'normal-color';
                    tempObj.colorBoldClass = 'normal-color';
            }
            for(let j=0; j< pas; j++) {
                let k = i+j;
                if(j === (pas-1) && this.isService2) {
                    tempObj.S2 = tempData[k];
                } else {
                    tempObj[tempData[k].secteurActivite[1]] = tempData[k];
                }
            }
            this.dataFlyout.push(tempObj);
            i = i + pas ;
        }
    }
}
handleOpenRecordClick(){
    //if(this.initData) {
        this.transformData();
    //}
    let eventName = 'popupevent';
    const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type: 'mensualisation'} });
    this.dispatchEvent(event);
}


}