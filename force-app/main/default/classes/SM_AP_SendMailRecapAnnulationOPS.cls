/*
* @Author: Raouaa Jmour
* @Date: 10/01/2020
* @Description: Classe qui permet l'envoi d'un email au contact à la fin du parcours Annulation OPS
*/


global class SM_AP_SendMailRecapAnnulationOPS implements vlocity_cmt.VlocityOpenInterface {
    
    global SM_AP_SendMailRecapAnnulationOPS() {

    }

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

            if (methodName.equals('SendRecapMail')) {
                try {
                SendRecapMail(inputMap, outMap, options);

                    }
                catch (Exception e) {
                    if(!Test.isRunningTest()) {
                        system.debug('error '+e.getMessage());
                        system.debug('error '+e.getStackTraceString());
                        if(!(e instanceof SM_AP_SendMailRecapAnnulationOPS.IOException)) {
                            // exception non generée
                            e.setMessage('Erreur technique !');
                        }

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
                String TypeCard =((String) inputMap.get('TypeCard')) ;
                    system.debug('TypeCard'+TypeCard);
                    String num =((String) inputMap.get('num')) ;
                    system.debug('num'+num);
                    String rue =((String) inputMap.get('rue')) ;
                    system.debug('rue'+rue);
                    String cplt =((String) inputMap.get('cplt')) ;
                    system.debug('cplt'+cplt);
                     String cp =((String) inputMap.get('cp')) ;
                    system.debug('cp'+cp);
                     String ville =((String) inputMap.get('ville')) ;
                    system.debug('ville'+ville);
                    String dateRDV =((String) inputMap.get('dateRDV')) ;
                    system.debug('dateRDV'+dateRDV);
                     String Creneau =((String) inputMap.get('Creneau')) ;
                    system.debug('Creneau'+Creneau);
                     String Presence =((String) inputMap.get('presence')) ;
                    system.debug('presence'+presence);
                    String fraisPrestation =((String) inputMap.get('fraisPrestation')) ;
                    system.debug('fraisPrestation'+fraisPrestation);
                     String contactName =((String) inputMap.get('contactName')) ;
                    system.debug('contactName'+contactName);
                     String contactEmail =((String) inputMap.get('contactEmail')) ;
                    system.debug('contactEmail'+contactEmail);
                    String contactSalutation =((String) inputMap.get('contactSalutation')) ;
                    system.debug('contactSalutation'+contactSalutation);
                    String situationDeVente = ((String) inputMap.get('OPSSituationDeVente')) ;
                    system.debug('situationDeVente'+situationDeVente);
                    Integer deltaFrais = ((Integer) inputMap.get('deltaFrais'));
                    System.debug('deltaFrais' + deltaFrais);
                    String heureDebut = ((String) inputMap.get('heureDebut'));
                    System.debug('heureDebut' + heureDebut);
                    String heureFin = ((String) inputMap.get('heureFin'));
                    System.debug('heureFin' + heurefin);
                    String creneauHorairee = ((String) inputMap.get('creneauHoraire'));

                     List<EmailTemplate> emailTemplateList = [SELECT Id, Subject, HtmlValue, Body 
                                                    FROM EmailTemplate 
                                                    WHERE developerName = 'SM_ET05_Confirmation_AnnulationRDV'];
            if (emailTemplateList.size() > 0) {

                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                EmailTemplate emailTemplate = emailTemplateList[0];
                
                String ENEDISPARAM = '';
                String MISEENSERVICEPARAM  = '';
                String ELECTRICITEPARAM = '';
                String ADRESSEPARAM = '';
                String DATERDVPARAM = '';
                String CRENEAUPARAM = '';
                String PRESENCEPARAM = '';
                String FRAISPARAM = '';
                String CRENEAUHORAIRE = '';
                
                if(TypeCard == 'GAZ'){
                    ENEDISPARAM = 'GRDF';
                    ELECTRICITEPARAM = 'du Gaz';
                }
                else{
                    ENEDISPARAM = 'ENEDIS';
                    ELECTRICITEPARAM = 'de l\'electricité';
                }
                
                ADRESSEPARAM = (!String.isblank(cplt))  ? num+ ' '+rue+' '+cplt+',' +cp+' '+ville : num+ ' '+rue+',' +cp+' '+ville;
                DATERDVPARAM = dateRDV ;
                CRENEAUHORAIRE = (!String.isblank(heureDebut) && !String.isblank(heureFin)) ? '(' + heureDebut + '-' + heureFin + ')' : '';
                CRENEAUPARAM = (creneauHorairee != 'null') ? creneauHorairee : '';
                PRESENCEPARAM = (Presence == '1') ? 'Votre présence n\'est plus nécessaire' : '';
                FRAISPARAM = (!String.isblank(fraisPrestation) && deltaFrais <= 2 ) ? 'Des frais d’annulation de '+fraisPrestation+'€ TTC vous seront facturés' : '';
                if(!String.isblank(situationDeVente)){
                    if(situationDeVente.equalsIgnoreCase('Emménagement')){
                        MISEENSERVICEPARAM = 'la Mise en service';
                    }
                    else if(situationDeVente.equalsIgnoreCase('Changement de fournisseur')){
                        MISEENSERVICEPARAM = 'le Changement de fournisseur';
                }
                    else if(situationDeVente.equalsIgnoreCase('Resiliation')){
                        MISEENSERVICEPARAM = 'la Résiliation';
                        
                    }
                }

                 String htmlBody = emailTemplate.HtmlValue.replace('SALUTATION', contactSalutation).replace('NAME', contactName );
                htmlBody = htmlBody.replace('ENEDIS', ENEDISPARAM).replace('ELECTRICITE', ELECTRICITEPARAM);
                htmlBody = htmlBody.replace('ADRESSE', ADRESSEPARAM).replace('DATERDV', DATERDVPARAM).replace('CRENEAU', CRENEAUPARAM);
                htmlBody = htmlBody.replace('PRESENCE', PRESENCEPARAM).replace('FRAIS', FRAISPARAM);
                htmlBody = htmlBody.replace('MISEENSERVICE', MISEENSERVICEPARAM);
                        

                List<String> toAddresses = new List<String>();
                // toAddresses.add('raoua.jmour@talan.com');
                toAddresses.add(contactEmail); 
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
    
    global static Id getOrgWideEmail() {
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName = 'ENGIE-PARTICULIERS'];
        
        if (owea.size() > 0) {
            return owea.get(0).Id;
        } else {
            return null;
        }
        
    }

}