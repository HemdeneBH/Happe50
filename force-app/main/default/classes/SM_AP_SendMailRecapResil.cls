/**
Classe apex qui sert à envoyer un email recap à la fin du parcours Résil
used by Omniscript Resil 

*/
global class SM_AP_SendMailRecapResil  implements vlocity_cmt.VlocityOpenInterface  {
    public SM_AP_SendMailRecapResil() {
        
    }
    
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('SendRecapMail')) {
            try {   // creation de la prestation en mode online 
                SendRecapMail(inputMap, outMap, options);
                
            } 
            catch (Exception e) {
                if(!Test.isRunningTest()) {
                    system.debug('error '+e.getMessage());
                    system.debug('error '+e.getStackTraceString());
                    if(!(e instanceof SM_AP_SendMailRecapResil.IOException)) {
                        // exception non generée
                        e.setMessage('Erreur technique !');
                    }
                    // remonter l'erreur à l'IP
                    // outMap.put('raisedExceptionElec',e.getMessage());
                    throw e;
                }
                // return false;
            }
        }
        return true ;
    }
    
    public class IOException extends Exception {
        
    }
    
    
    
    private void SendRecapMail(Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options){
        
        
        
        Boolean Gaz =((Boolean) inputMap.get('ResilGazActif'))  && ((Boolean) inputMap.get('isActiveGaz'))    ;
        system.debug('ResilGazActif'+Gaz);
        Boolean Elec =((Boolean) inputMap.get('ResilElecActif')) && ((Boolean) inputMap.get('isActiveElec'))     ;
        system.debug('Elec'+Elec);
        
 
        String contactMail = (String)inputMap.get('ContactMail')  ;
        system.debug('contactMail'+contactMail);
        if(String.isBlank(contactMail)){
            throw new IOException('Veuillez saisir un email Valide !') ;
        }
        
        String SM_ADDRESSE = (String)inputMap.get('ChercherAdresseFormula')  ; 
        system.debug('SM_ADDRESSE'+SM_ADDRESSE);
        String SM_IDBP = (String)inputMap.get('getIdBP') ;  
        system.debug('SM_IDBP'+SM_IDBP);
        String SM_CIVILITE = (String)  inputMap.get('getCivilite') ;
        
        system.debug('SM_CIVILITE'+SM_CIVILITE);
        String SM_NOM  =(String)  inputMap.get('getNom') ;
        
        system.debug('SM_NOM'+SM_NOM);
        String SM_TODAY =  String.valueOf(Datetime.now().format('dd-MM-yyyy')) ;
        
        String SM_BlOC_ELEC =''  ;
        String SM_BLOC_GAZ = '';
        String SM_TypeContrat ='' ;
        
        
        List<EmailTemplate> emailTemplateList = [SELECT Id, Subject, HtmlValue, Body 
                                                 FROM EmailTemplate 
                                                 WHERE developerName = 'SM_ET01_Resilliation_recap'];
        if (emailTemplateList.size() > 0) {
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            EmailTemplate emailTemplate = emailTemplateList[0];
            
            if(Elec){
                if(Gaz){
                    SM_TypeContrat = 'vos contrats de gaz et d\'électricité.' ;
                    SM_BlOC_ELEC = '<b>Concernant l\'électricité,</b> <br><br>';
                }else {
                    SM_TypeContrat = 'votre contrat d\'électricité.' ;
                    SM_BLOC_GAZ  = '' ;
                }
                String choixProcedure = ((String) inputMap.get('ChoixProcedureAutoItv')) ;
                system.debug('AutoreleveElec'+choixProcedure);
                String DateInterventionElec = (String) inputMap.get('DateInterventionElec');
                system.debug('DateInterventionElec'+DateInterventionElec);
                String CreneauElecHeureDebut = (String) inputMap.get('CreneauElecHeureDebut');
                system.debug('CreneauElecHeureDebut'+CreneauElecHeureDebut);
                String CreneauElecHeureFin = (String) inputMap.get('CreneauElecHeureFin');
                system.debug('CreneauElecHeureFin'+CreneauElecHeureFin);   
                Boolean CommunicantElec  = ((Boolean) inputMap.get('LINKYlv1')) ||((Boolean) inputMap.get('LINKYlv2')) ;
                system.debug('CommunicantElec'+CommunicantElec);    
                Boolean isNotRecollementElec = (Boolean) inputMap.get('isNotRecollementElec') ;
               
               
                if(choixProcedure.equalsIgnoreCase('Intervention') && isNotRecollementElec ){
                    if(!String.isBlank(CreneauElecHeureFin) &&   !String.isBlank(CreneauElecHeureDebut)  && !String.isBlank(DateInterventionElec)  ){
                        SM_BlOC_ELEC = SM_BlOC_ELEC+ 'Celle-ci sera effective à partir de l’intervention du technicien à votre domicile, <br>le '+DateInterventionElec+' entre '+CreneauElecHeureDebut+ ' et '+CreneauElecHeureFin +'. <br><br>L\'abonnement et les consommations seront donc dus jusqu\'à cette date. ';
                    }else{
                        SM_BlOC_ELEC =  SM_BlOC_ELEC + 'Celle-ci sera effective à partir de l\'intervention du technicien à votre domicile. Il prendra contact avec vous pour prendre rendez-vous dans les meilleurs délais. L\'abonnement et les consommations seront donc dus jusqu\'à cette date.';
                        
                    }
                    
                } else if(choixProcedure.equalsIgnoreCase('Autorelève') && isNotRecollementElec  ){
                    SM_BlOC_ELEC = SM_BlOC_ELEC + 'Celle-ci sera effective sur la base du relevé de compteur que vous m’avez communiqué.' ;
                }else if(CommunicantElec  && isNotRecollementElec  ){
                    SM_BlOC_ELEC = SM_BlOC_ELEC + 'Celle-ci sera effective sur la base du relevé transmis par votre compteur communicant.' ;
                } else {
                    // recollement elec
                    SM_BlOC_ELEC = SM_BlOC_ELEC + 'Celle-ci sera effective à partir de l\'intervention du technicien à votre domicile. Il prendra contact avec vous pour prendre rendez-vous dans les meilleurs délais. L\'abonnement et les consommations seront donc dus jusqu\'à cette date.';
        
                }           
            }
            
            if(Gaz){
                if(Elec){
                    SM_BLOC_GAZ = '<b>Concernant le gaz naturel,</b> <br><br>';
                }else {
                    SM_TypeContrat = 'votre contrat de gaz.' ;
                    SM_BlOC_ELEC  = '' ;
                }
                Boolean CommunicantGaz = ((String) inputMap.get('typeCompteur')).equalsIgnoreCase('Communicant') ;
                system.debug('CommunicantGaz'+CommunicantGaz);
                String CreneauGazHeureDebut = (String) inputMap.get('CreneauGazHeureDebut');
                system.debug('CreneauGazHeureDebut'+CreneauGazHeureDebut);
                String CreneauGazHeureFin = (String) inputMap.get('CreneauGazHeureFin');
                system.debug('CreneauGazHeureFin'+CreneauGazHeureFin);
                String DateInterventionGaz = (String) inputMap.get('DateInterventionGaz');
                system.debug('DateInterventionGaz'+DateInterventionGaz);        
                Boolean isNotRecollement = (Boolean) inputMap.get('isNotRecollement') ;      
                if(!String.isBlank(DateInterventionGaz)  && isNotRecollement){
                    if(!String.isBlank(CreneauGazHeureFin) && !String.isBlank(CreneauGazHeureDebut) ){
                        SM_BLOC_GAZ = SM_BLOC_GAZ+ 'Celle-ci sera effective à partir de l’intervention du technicien à votre domicile, <br>le '+DateInterventionGaz+' entre '+CreneauGazHeureDebut+ ' et '+CreneauGazHeureFin +' . <br><br>L\'abonnement et les consommations seront donc dus jusqu\'à cette date. ';
                    }else{
                        SM_BLOC_GAZ =  SM_BLOC_GAZ + 'Celle-ci sera effective à partir de l\'intervention du technicien à votre domicile.<br>Il prendra contact avec vous pour prendre rendez-vous dans les meilleurs délais. L\'abonnement et les consommations seront donc dus jusqu\'à cette date.';
                        
                    }
                    
                } 

                else if(CommunicantGaz  && isNotRecollement  ){
                    SM_BLOC_GAZ = SM_BLOC_GAZ + 'Celle-ci sera effective sur la base du relevé transmis par votre compteur communicant' ;       
                } else {
                    
                    // Recollement
                    SM_BLOC_GAZ =  SM_BLOC_GAZ + 'Celle-ci sera effective à partir de l\'intervention du technicien à votre domicile.<br> Il prendra contact avec vous pour prendre rendez-vous dans les meilleurs délais. L\'abonnement et les consommations seront donc dus jusqu\'à cette date.';
                    
                    
                }
           
            }
            
     
            String htmlBody = emailTemplate.HtmlValue.replace('SM_ADDRESSE', SM_ADDRESSE).replace('SM_CIVILITE', +'<center>'+SM_CIVILITE );
            htmlBody = htmlBody.replace('SM_NOM', SM_NOM+'</center>').replace('SM_IDBP', SM_IDBP).replace('SM_TODAY', SM_TODAY).replace('SM_TypeContrat', SM_TypeContrat)
                .replace('SM_BlOC_ELEC', SM_BlOC_ELEC).replace('SM_BLOC_GAZ', SM_BLOC_GAZ);            
            // 
            htmlBody = htmlBody.replace('<![CDATA[','').replace(']]>', '') ;
            system.debug('htmlBody'+htmlBody ) ;
            List<String> toAddresses = new List<String>();
            // toAddresses.add('ramata.wath@talan.com');
            toAddresses.add(contactMail);
            // Sets the paramaters of the email
            email.setSubject(emailTemplate.Subject);
            Id OweaId = getOrgWideEmail();
            if (OweaId != null)
                email.setOrgWideEmailAddressId(OweaId);
            email.setToAddresses(toAddresses);
            email.setHtmlBody(htmlBody);
            
            
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            
            
            
        } 
    }
    
    
    private static Id getOrgWideEmail() {
         List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName = 'ENGIE-PARTICULIERS'];//List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName = 'monprojetpv'];  //  'ENGIE-PARTICULIERS'];
        if (owea.size() > 0) {
            return owea.get(0).Id;
        } else {
            return null;
        }
        
    }
    
}