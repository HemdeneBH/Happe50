import { LightningElement, api, track } from 'lwc';
//import callIP from "@salesforce/apex/SM_AP77_CallIPApiService.callIP";
//import getAssuranceFacture from "@salesforce/apex/SM_AP53_ContratWS.rechercherContratLightning";


export default class TargetLwcComponent extends LightningElement {

    @api propertyValue;
    @track civilite;
    @track nom;
    @track prenom;
    @track numRue;
    @track rue;
    @track codePostal;
    @track telDomicile; 
    @track email;
    @track ville;
    @track complementAdresse;
    @track values;
    @track listServices = []
  
    
    connectedCallback(){
   this.values = JSON.parse(this.propertyValue)
   this.listServices = this.values.listTranquilityServices;
   this.getCivilite ();
   this.getNom ();
   this.getPrenom ();
   this.getEmail ();
   this.getCodePostal ();
   this.getTelDomicile ();
   this.getNumeroVoie ();
   this.getLibelleVoie ();
   this.getVille();
   this.getComplementAdresse();

 

   } 
 
getCivilite (){
    
    if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.civilite ){
      this.civilite=this.values.listTranquilityServices[0].client.civilite
      return this.civilite;
    }
   else return "" ;
}
getNom (){

  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.nom ){
    this.nom=this.values.listTranquilityServices[0].client.nom;
    return this.nom;
  }
 else return "" ;
}
getPrenom (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.prenom){
    this.prenom=this.values.listTranquilityServices[0].client.prenom;
    return this.prenom;
  }
 else return "" ;
}
getEmail (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.email){
    this.email=this.values.listTranquilityServices[0].client.email;
    return this.email;
  }
 else return "" ;
}
getCodePostal (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.codePostal){
    this.codePostal=this.values.listTranquilityServices[0].client.codePostal;
    return this.codePostal;
  }
 else return "" ;
}
getTelDomicile (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.telDomicile){
    this.telDomicile=this.values.listTranquilityServices[0].client.telDomicile;
    return this.telDomicile;
  }
 else return "" ;
}
getNumeroVoie (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.numRue){
    this.numRue=this.values.listTranquilityServices[0].client.numRue;
    return this.numeRue;
  }
 else return "" ;
}
getLibelleVoie (){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].client.rue){
    this.rue=this.values.listTranquilityServices[0].client.rue;
    return this.rue;
  }
 else return "" ;
}
getVille(){
  if (this.values.listTranquilityServices && this.values.listTranquilityServices[0] && this.values.listTranquilityServices[0].client && this.values.listTranquilityServices[0].commune){
    this.ville=this.values.listTranquilityServices[0].client.commune;
    return this.ville;
  }
 else return "" ;
}
getComplementAdresse(){
  if (this.values.vcomplementAdresse){
    this.complementAdresse=this.values.listTranquilityServices[0].client.complementAdresse;
    return this.complementAdresse;
  }
 else return "" ;
}
   renderedCallback(){
    //do something
    } 
    
}