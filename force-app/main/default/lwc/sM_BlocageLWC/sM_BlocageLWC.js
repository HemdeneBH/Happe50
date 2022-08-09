import { LightningElement,api } from 'lwc';
export default class SM_Blocage extends LightningElement  {
    @api numeroVoie;
    @api ville;
    @api libelleVoie;
    @api complementAdresse;
    @api codePostal;
    @api recordId;
    //blocageRelance
    @api blocageRelance
    @api libelleMotifBlocageRelance
    @api dateDebutBlocageRelance
    @api dateFinBlocageRelance
    //blocageFacturation
    @api blocageFacturation
    @api libelleMotifBlocageFacturation
    @api dateDebutBlocageFacturation
    @api dateFinBlocageFacturation
    //blocageDecaissement
    @api blocageDecaissement
    @api libelleMotifBlocageDecaissement
    @api dateDebutBlocageDecaissement
    @api dateFinBlocageDecaissement
    //blocagePrevelement
    @api blocagePrevelement
    @api libelleMotifBlocagePrevelement
    @api dateDebutBlocagePrevelement
    @api dateFinBlocagePrevelement
     NoBlocage=false
     listBlocage=[];
     //ADE:FT1-2458
    // initialize component
    connectedCallback() {
        //Aucun blocage pour ce client
        if(this.blocageRelance===false&&this.blocageFacturation===false&&this.blocageDecaissement===false&&this.blocagePrevelement===false){
        this.NoBlocage=true;
        }else{
        this.NoBlocage=false;
        //blocageRelance
        if(this.blocageRelance===true){
            this.listBlocage.push({
                type:'Relance',
                motif:this.libelleMotifBlocageRelance,

                dateDebut:this.formatDate(this.dateDebutBlocageRelance),
                dateFin:this.formatDate(this.dateFinBlocageRelance)});

        }
        //blocageFacturation
        if(this.blocageFacturation===true){
            this.listBlocage.push({
                type:'Facturation',
                motif:this.libelleMotifBlocageFacturation,

                dateDebut:this.formatDate(this.dateDebutBlocageFacturation),
                dateFin:this.formatDate(this.dateFinBlocageFacturation)});

        }
        //blocagePrevelement
        if(this.blocagePrevelement===true){
            this.listBlocage.push({
                type:'Encaissement',
                motif:this.libelleMotifBlocagePrevelement,

                dateDebut:this.formatDate(this.dateDebutBlocagePrevelement),
                dateFin:this.formatDate(this.dateFinBlocagePrevelement)});

        }
        //blocageDecaissement
        if(this.blocageDecaissement===true){
            this.listBlocage.push({
                type:'Decaissement',
                motif:this.libelleMotifBlocageDecaissement,

                dateDebut:this.formatDate(this.dateDebutBlocageDecaissement),
                dateFin:this.formatDate(this.dateFinBlocageDecaissement)});

        }
        }
    }
        // close TAB
        closeBlocageLWCTab(){
            var close = true;
            const closeclickedevt = new CustomEvent('closeTabBlocage', {
                detail: close 
            });
             // Fire the custom event
             this.dispatchEvent(closeclickedevt); 
        }

    formatDate(adate){
        try {
            const d = adate.split('-');                   
            return d[2]+'/'+d[1]+'/'+d[0];
        } catch (error) {
            console.error(adate+'  '+error);
            return '';
        }
    }

}