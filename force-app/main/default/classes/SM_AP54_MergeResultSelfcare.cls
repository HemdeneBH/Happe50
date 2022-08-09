/***************************************** 
* @author : MMA
*   @description : L'objectif de cette classe est de concaténer les données provenant de plusieurs appels API / WS et de le restituer sous un seul bloc. Utilisé sur le selfcare
*   @CreatedDate : 16/01/2019
*/
global with sharing class SM_AP54_MergeResultSelfcare implements vlocity_cmt.VlocityOpenInterface {
	
   
    Static final String code01LirePrestaElec = 'OCTOPUS_LirePrestationServiceElectricite_01';
    Static final String code01LirePrestaGaz = 'OCTOPUS_LirePrestationServiceGaz_01';
    Static final String code99LirePrestaElec = 'OCTOPUS_LirePrestationServiceElectricite_99';
    Static final String code99LirePrestaGaz = 'OCTOPUS_LirePrestationServiceGaz_99';

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('merge')) {
            try {
                mergeResult(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                system.debug(e.getStackTraceString());
                return false;
            }
        } else if(methodName.equals('userValues')){
            try{
                userValues(inputMap, outMap, options);
            } catch (Exception e){
                system.debug(e);
                system.debug(e.getStackTraceString());
                return false;
            }
        }

        return true;
    }

    /*
    *   @description Récupère certaines infos du user connecté pour les pousser à l'OS du selfcare
    *   @date 03/05
    *   @author Mickaël
    */
    public static void userValues(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options){
        System.debug('*** IN userValues');
        Id userId = UserInfo.getUserId();
        User currentUser = [SELECT Id, Contact.Identifiant_Buisness_Partener__c, ContactId FROM User WHERE Id =: userId];
        outMap.put('idBp', currentUser.Contact.Identifiant_Buisness_Partener__c);
        outMap.put('ContactId', currentUser.ContactId);
        system.debug('ContextId'+currentUser.ContactId);
        System.debug('*** OUT userValues with idBp = ' + outMap.get('idBp'));
    }


    public static void mergeResult(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        System.debug('*** IN merge');
        
        system.debug('inputmap '+ inputMap);
        Map<String, Object> inAdr = (Map<String, Object>) inputMap.get('Adresses');
       	List<Object> inAdrList = (	List<Object>) inAdr.get('data');
        system.debug('inAdr' + inAdrList);
        
        Map<String, Object> inLireOpsElec = (Map<String, Object>) inputMap.get('LirePrestationElec');
        System.debug('*** inLireOpsElec: ' + inLireOpsElec);
        inLireOpsElec = (Map<String, Object>) inLireOpsElec.get('ops');
        System.debug('*** inLireOpsElec: ' + inLireOpsElec);
        
        Map<String, Object> inLireOpsGaz = (Map<String, Object>) inputMap.get('LirePrestationGaz');
        System.debug('*** inLireOpsGaz: ' + inLireOpsGaz);
        inLireOpsGaz = (Map<String, Object>) inLireOpsGaz.get('ops');
        System.debug('*** inLireOpsGaz: ' + inLireOpsGaz);
        
        List<AddrSelfcare> adresses = new List<AddrSelfcare>();
        Boolean allReadOnlineKO = true;
        
        if(inAdrList != null )
        {
            for(Object objAdr : inAdrList){
                
               SM_AP07_AdressesApiService.AdresseModel adr = (SM_AP07_AdressesApiService.AdresseModel) objAdr;
				
                
             	if(String.isBlank(adr.idBan)){
                    continue;
                }
                /*System.debug('idBan : ' + idBan);
                Object objAdr = (Object) inAdr.get(idBan);
                System.debug('objAdr : ' + objAdr);
                SM_AP07_AdressesApiService.AdresseModel adr = (SM_AP07_AdressesApiService.AdresseModel) objAdr;
                System.debug('adr : ' + adr);*/
                String idBan = adr.idBan;
                String ville = adr.ville;
                String rue = adr.valueChb;
                String cp = adr.postcode;
                String cplt = adr.complementAdresse;
                
                String pdl = '';
                String pce = '';
                Boolean emptyPdlPce = true;
                
                SM_AP07_AdressesApiService.PdlPceModel pdlPceObj = adr.pointLivraison;
                
                if(pdlPceObj != null){
                    pdl = pdlPceObj.vPDL;
                    pce = pdlPceObj.vPCE;
                }
                
                AddrSelfcare adrOps = new AddrSelfcare(idBan, rue, cplt, cp, ville);
                
                //System.debug('*** Adresse : ' + adrOps);
                //System.debug('*** pdl : ' + pdl);
                //System.debug('*** pce : ' + pce);
                //System.debug('*** inLireOpsElec.containsKey(pdl) : ' + inLireOpsElec);
                //system.debug('!String.isBlank(pdl)' +(!String.isBlank(pdl) && inLireOpsElec.containsKey(pdl)));
                // Recherche d'un PDL associé
                if(!String.isBlank(pdl)){
                    if(inLireOpsElec != null && ! inLireOPSElec .isEmpty() && inLireOpsElec.containsKey(pdl)){
                        System.debug('*** Ops Elec found for : ' + pdl);
                        Map<String, Object> opsFound = (Map<String, Object>) inLireOpsElec.get(pdl);
                        
                        system.debug('opsFound' +opsFound);
                        system.debug('pdl' +opsFound.get('libelle'));
                        //if(!String.isBlank((String)opsFound.get('libelle'))) {
                        OpsSelfcare ops = new OpsSelfcare(opsFound);
                        system.debug('noIntervention ' + opsFound.get('noIntervention'));
                        if(ops.code_retour_ops != code01LirePrestaElec  ){
                            system.debug('ops' + ops);
                            adrOps.addOpsElec(ops);
                            emptyPdlPce = false;
                        }
                        else if(opsFound.get('noIntervention') != null && opsFound.get('noIntervention')== false){
                            //IF distrib code 01 verif verif les champs date , libelle , et creneau
                            system.debug('Ce pdl à une intervention' + opsFound.get('pdl'));
                            if(ops.code_retour_ops == code01LirePrestaElec && checkOPS(ops,'elec')  ){
                                allReadOnlineKO = false;
                                adrOps.addOpsElec(ops);
                                emptyPdlPce = false;
                            }
                        }
                         
                    }
                }
                
                // Recherche d'un PCE associé
                if(!String.isBlank(pce)){
                    if(inLireOpsGaz != null && !inLireOpsGaz.isEmpty() && inLireOpsGaz.containsKey(pce)){
                        
                        System.debug('*** Ops Gaz found for : ' + pce);
                        System.debug('*** inLireOpsGaz : ' + inLireOpsGaz);
                        Map<String, Object> opsFound = (Map<String, Object>) inLireOpsGaz.get(pce);
                        system.debug('pce' +opsFound.get('pdl'));
                        
                        OpsSelfcare ops = new OpsSelfcare(opsFound);
                        //IF distrib code 01 verif les champs date , libelle , et creneau
                        if(ops.code_retour_ops == code01LirePrestaGaz && checkOPS(ops,'gaz')){
                            allReadOnlineKO = false;
                            adrOps.addOpsGaz(ops);
                            emptyPdlPce = false;
                        }
                        else if(ops.code_retour_ops != code01LirePrestaGaz  ){
                            system.debug('ops' + ops);
                            adrOps.addOpsGaz(ops);
                            emptyPdlPce = false;
                        }
                    }
                }
                   
                
                system.debug('emptyPdlPce'+emptyPdlPce);
                
                if(!emptyPdlPce){
                    adresses.add(adrOps);
                }              
            }
            
            if(adresses.size() > 0){
                outMap.put('adresses', adresses);
                if(allReadOnlineKO){
                    outMap.put('status','allReadOnlineKO');
                }
            }
            else{
                
                outMap.put('adresses', 'emptyOPS');
            }
        }
        else {
            outMap.put('adresses','errorWS');
        }
        
       
        System.debug('*** OUT merge');
    }
    
    

     /*
    *   @description Get ops object and check label , date , time slot
    *   If false the OPS will not be added on output list, for technical error need to be true
    *   @date 22/11/2019
    *   @author Omar Mohamad
    * 
    * 	@input
    * 	OpsSelfcare ops
    *   String energie

    * 	@output
    * 	Boolean  true/false 
    *
    *   
    *   
    */
    public static boolean checkOPS(OpsSelfcare ops,String energie){
        System.debug('check OPS libelle:'+ ops.libelle + '-datePrevue:'+ops.datePrevue+'-presenceObligatoire:'+ops.presenceObligatoire+'-heureDebut:'+ops.heureDebut+'-heureFin:'+ops.heureFin);
        
        // First check if date exist and not past
        if(String.isBlank(ops.datePrevue) ){
            setOPSError99(ops,energie);
            return true;
        }
        else if(!checkPastDate(ops.datePrevue)){
            return false;
        }
		
        system.debug('check libelle');
        //Dans tous les cas verifier libellé et date comportement similaire à WSKO
        if(String.isBlank(ops.libelle) ){
            setOPSError99(ops,energie);
            return true;
        }

        if(!String.isBlank(ops.intervention) && ops.intervention == 'true'){
            if(String.isBlank(ops.heureDebut) || String.isBlank(ops.heureFin)){
                setOPSError99(ops,energie);
                return true;
            }

            if(String.isBlank(ops.presenceObligatoire)){
                setOPSError99(ops,energie);
                return true;
            }
        }
       
        return true;
    }

     /*
    *   @description Set technical error for current OPS
    *   @date 09/03/2020
    *   @author Omar Mohamad
    * 
     * 	@input
    * 	OpsSelfcare ops
    *   String energie
    * 
    * 	@output 
    * 	 
    */
    public Static void setOPSError99(OpsSelfcare ops,String energieOPS){
        ops.intervention = '';
        ops.moins48h='';
        if(energieOPS.equals('elec'))
            ops.code_retour_ops = code99LirePrestaElec;
        if(energieOPS.equals('gaz'))
            ops.code_retour_ops = code99LirePrestaGaz;
    }

    /*
    *   @description Get Date in String format and check if it's in the past 
    *   @date 22/11/2019
    *   @author Omar Mohamad
    * 
    * 	@input
    * 	String dateTocheck
    * 
    * 	@output 
    * 	Boolean 
    */
    public static boolean checkPastDate(String dateTocheck){
        
        //Check if date is older than 2 days
        Integer nbrDaybefore = 2;
        
        if(dateToCheck.contains('/')){
            dateTocheck = dateTocheck.replace('/','-');
            Date formatDate = Date.valueOf(dateTocheck);
            Date compareDate = Date.today()-nbrDaybefore;
            System.debug('formatDate' + formatDate);
            System.debug('compareDate' + compareDate);
            if(formatDate < compareDate)
                return false;
            else if(formatDate >= compareDate)
                return true;
        }
        
        return false;
    }

    public class AddrSelfcare{
        public String idBan;
        public String rue;
        public String cplt;
        public String cp;
        public String ville;
        public List<OpsSelfcare> opsElecList;
        public List<OpsSelfcare> opsGazList;

        public AddrSelfcare(String idBanP, String rueP, String cpltP, String cpP, String villeP){
            this.idBan = idBanP;
            this.rue = rueP;
            this.cplt = cpltP;
            this.cp = cpP;
            this.ville = villeP;
            opsElecList = new List<OpsSelfcare>();
            opsGazList = new List<OpsSelfcare>();
        }

        public void addOpsElec(OpsSelfcare opsP){
            opsElecList.add(opsP);
        }

        public void addOpsGaz(OpsSelfcare opsP){
            opsGazList.add(opsP);
        }
    }

    public class OpsSelfcare{
        public String idDistrib;
        public String idFournisseur;
        public String datePrevue;
        public String disponibilite;
        public String libelle;
        public String typePrestation;
        public String numPdlPce;
        public String creneau;
        public String creneauCode;
        public String civilite;
        public String nom;
        public String prenom;
        public String tel;
        public String presenceObligatoire;
        public String moins48h;
        public String commentaire;
        public String heureDebut ;
        public String heureFin;
        public String intervention;
        public String code_retour_ops;
 
        public OpsSelfcare(Map<String, Object> objectOps){
            this.idDistrib = (String) objectOps.get('idPrestationDistributeur');
            this.idFournisseur = (String) objectOps.get('idPrestationFournisseur');
            this.datePrevue = (String) objectOps.get('datePrevue');
            this.disponibilite = (String) objectOps.get('disponibilite');
            this.libelle = (String) objectOps.get('libelle');
            this.typePrestation = (String) objectOps.get('typePrestation');
            this.numPdlPce = (String) objectOps.get('pdl');
            this.creneau = (String) objectOps.get('creneauRetenu');
            this.creneauCode = (String) objectOps.get('creneauRetenuCode');
            this.civilite = (String) objectOps.get('civilite');
            this.nom = (String) objectOps.get('nom');
            this.prenom = (String) objectOps.get('prenom');
            this.tel = (String) objectOps.get('tel');
            this.presenceObligatoire = (String) objectOps.get('presence');
            this.moins48h = (String) objectOps.get('moins48h');
            this.commentaire = (String) objectOps.get('commentaires');
            this.heureDebut = (String) objectOps.get('heureDebut');
            this.heureFin = (String) objectOps.get('heureFin');
            this.intervention = (String) objectOps.get('intervention');
            this.code_retour_ops = (String) objectOps.get('code_retour_ops');
            
        }
    }

}