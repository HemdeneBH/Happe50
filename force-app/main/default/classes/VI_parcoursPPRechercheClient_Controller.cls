/*
* @Author: Paul Ghoussoub
*@Description: Controlleur Apex du LWC parcoursPurePlayersContent
*@CreatedDate: 15/12/2020
*@LastModified: 22/12/2020
*/

public without sharing class VI_parcoursPPRechercheClient_Controller {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList(String testName) {
        return [SELECT Id, FirstName, LastName, Title, Phone, Email FROM Contact where FirstName=:testName];
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Recherche dans la base de données Salesforce les clients existants en se basant sur les règles validées par le métier
* @param lastName, phoneNumber, email, commune, codePostal, referenceClient, prenom
* @return List of contacts
*/
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactListNew(String lastName,String phoneNumber, String email, String commune, String codePostal, String referenceClient, String prenom) {
        //Ticket Jira - DDPCM-25
        system.debug('phoneNumber '+phoneNumber);
        String idContactSmile=VI_ObjectUtils.getRecordTypeId('Contact','Contact_Smile');
        if( isNotNull(phoneNumber) || isNotNull(email) || ( isNotNull(LastName) && isNotNull(Commune) && isNotNull(codePostal)) || isNotNull(referenceClient)){
            String nom = '%'+ lastName+'%';
            String query = 'SELECT Id, FirstName, LastName, Email, Adresse_Mail_2__c, Adresse_Mail_3__c, MobilePhone, Mobile_2__c,'+ 
                'Mobile_3__c, reference_client_f__c, Identifiant_Buisness_Partener__c, MailingPostalCode, VI_Contact_Emails__c, MailingCity, Phone, Tel_Fixe_2__c, Tel_Fixe_3__c, '+
                'VI_Contact_Mobile__c, VI_Contact_Tel_Fixes__c ' +
                'FROM Contact ';
            Boolean whereClauseExist = false;
            if(isNotNull(email)){
                query = query+ 'WHERE (Email =:email OR Adresse_Mail_2__c = :email OR Adresse_Mail_3__c =: email) ';
                query = query + continueQuery( lastName, phoneNumber,  null,  commune,  codePostal,  referenceClient, prenom);
                whereClauseExist = true;
            }
            system.debug('phoneNumber '+phoneNumber);
            if(isNotNull(phoneNumber)){
                phoneNumber='+33'+phoneNumber.substring(1,phoneNumber.length());
                system.debug('phoneNumber '+phoneNumber);
                query = query+ (whereClauseExist? ' AND ': ' WHERE ');
                query = query+ '(MobilePhone =: phoneNumber OR Mobile_2__c =: phoneNumber OR Mobile_3__c=: phoneNumber OR Phone=: phoneNumber OR Tel_Fixe_2__c=: phoneNumber OR Tel_Fixe_3__c=: phoneNumber) ';
                query = query + continueQuery( lastName, null,  email,  commune,  codePostal,  referenceClient, prenom);
                whereClauseExist = true;
            }
            if(isNotNull(referenceClient)){
                query = query+ (whereClauseExist? ' AND ': ' WHERE ');
                query = query+ 'reference_client_f__c = : referenceClient ';
                query = query + continueQuery( lastName, phoneNumber,  email,  commune,  codePostal,  null, prenom);
                whereClauseExist = true;
            }
            if(isNotNull(LastName) &&  isNotNull(codePostal) && isNotNull(Commune)){
                query = query+ (whereClauseExist? ' AND ': ' WHERE ');
                query = query+ '(LastName like :nom AND MailingPostalCode = :codePostal AND MailingCity=:Commune) ';
                query = query + continueQuery( null, phoneNumber,  email,  null,  null,  referenceClient, prenom);
                whereClauseExist = true;
            }
            query = query+ (whereClauseExist? ' AND ': ' WHERE ');
            query = query+ '(Recordtypeid=\''+idContactSmile+'\' AND SM_isArchive__c=false)';
            whereClauseExist = true;
            
            query = query+ ' LIMIT 1000';
            system.debug('query '+query);
            return database.query(query);
        }
        else{
            return null;
        }
        
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Construction de la where condition de la query de la méthode précédente
* @param lastName, phoneNumber, email, commune, codePostal, referenceClient, prenom
* @return String ( where condition)
*/
    @AuraEnabled(cacheable=true)
    public static String continueQuery(String lastName,String phoneNumber, String email, String commune, String codePostal, String referenceClient, String prenom){
        String query = '';
        Boolean andClauseExist = false;
        String nom = '%'+ lastName+'%';
        if(isNotNull(LastName)){
            //query = query+ (andClauseExist? ' AND ': ' WHERE ');
            query = ' AND LastName like :nom ' ;
        }
        
        nom = '%'+ prenom+'%';
        if(isNotNull(prenom)){
            query = ' AND firstName like \'%'+prenom+'%\' ' ; 
        }
        if(isNotNull(phoneNumber)){
            query = ' AND (MobilePhone = :phoneNumber OR Mobile_2__c = :phoneNumber OR Mobile_3__c= :phoneNumber) ' ;
        }
        if(isNotNull(email)){
            query = ' AND (Email = :email OR Adresse_Mail_2__c = :email OR Adresse_Mail_3__c = :email) ' ;
        }
        if(isNotNull(Commune)){
            query = ' AND MailingCity= :Commune ' ;
        } 
        if(isNotNull(codePostal)){
            query = ' AND MailingPostalCode = :codePostal ' ;
        } 
        if(isNotNull(referenceClient)){
            query = ' AND reference_client_f__c = :referenceClient ' ;
        } 
        
        return query;
    }   
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Vérification si le string est null ou pas
* @param String 
* @return Boolean ( true if not empty)
*/
    
    @AuraEnabled(cacheable=true)
    public static Boolean isNotNull(String s){
        return ((s != null && s != '')?true:false);
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Vérification DQE d'un numéro de telephone
* @param parcours, tel
* @return RechercheClientResponseWrapper ( Wrapper defini dans cette classe)
*/ 
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper verifTel(VI_Parcours__c parcours, String tel){
        if(tel != null && tel != ''){
            String responseVerifyTel = VI_SM001_EmailPhoneVerificationService.verifyPhoneNumber(tel, 'VI', 'local.VIToken');
            if(responseVerifyTel == 'KO'){return new RechercheClientResponseWrapper(parcours, tel + ' n existe pas');
                                         }
            if(responseVerifyTel == 'OK'){
                return new RechercheClientResponseWrapper(parcours, 'success');
            }
            
            return new RechercheClientResponseWrapper(parcours, responseVerifyTel);
        }
        return new RechercheClientResponseWrapper(parcours, 'champs vide');
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Vérification DQE d'une adresse Mail
* @param parcours, tel
* @return RechercheClientResponseWrapper ( Wrapper defini dans cette classe)
*/ 
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper verifMail(VI_Parcours__c parcours, String mail){
        if(string.isNotBlank(mail)){
            String responseVerifyMail = VI_SM001_EmailPhoneVerificationService.verifyEmail(mail, 'VI', 'local.VIToken');
            if(responseVerifyMail == 'OK'){
                return new RechercheClientResponseWrapper(parcours, 'success');
            }
            if(responseVerifyMail == 'KO'){ return new RechercheClientResponseWrapper(parcours, mail + ' n\'existe pas');
                                          }
            return new RechercheClientResponseWrapper(parcours, responseVerifyMail);
        }
        return new RechercheClientResponseWrapper(parcours, 'champs vide');
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Vérification DQE des adresses mail et numéro de telephone du client
* @param parcours, email1, email2, fixe1, fixe2, mobile1, mobile2
* @return RechercheClientResponseWrapper ( Wrapper defini dans cette classe)
*/ 
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper verifyDQE(VI_Parcours__c parcours, String email1,String email2,String fixe1, String fixe2,String mobile1, String mobile2){
        String mess = '';
        RechercheClientResponseWrapper fix1 = verifTel(parcours, fixe1);
        mess = fix1.message;
        if(fix1.message == 'success' || fix1.message == 'champs vide'){
            RechercheClientResponseWrapper fix2 = verifTel(parcours, fixe2);
            mess = fix2.message;
            if(fix2.message == 'success' || fix2.message == 'champs vide'){
                RechercheClientResponseWrapper mob1 = verifTel(parcours, mobile1);
                mess = mob1.message;
                if(mob1.message == 'success' || mob1.message == 'champs vide'){
                    RechercheClientResponseWrapper mob2 = verifTel(parcours, mobile2);
                    mess = mob2.message;
                    if(mob2.message == 'success' || mob2.message == 'champs vide'){
                        RechercheClientResponseWrapper mail1 = verifMail(parcours, email1);
                        mess = mail1.message;
                        if(mail1.message == 'success' || mail1.message == 'champs vide'){
                            RechercheClientResponseWrapper mail2 = verifMail(parcours, email2);
                            mess = mail2.message;
                            if(mail2.message == 'success' || mail2.message == 'champs vide'){
                                return new RechercheClientResponseWrapper(parcours, 'success');
                            }
                        }
                    }
                }
                
            }
        }
        
        return new RechercheClientResponseWrapper(parcours, mess);
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description  vérification DQE des champs adresse mail et téléphone puis la création du contact
* @param parcours, tous le champs necessaires à la création 
* @return RechercheClientResponseWrapper ( Wrapper defini dans cette classe)
*/ 
    
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper createContactFromLWC(VI_Parcours__c parcours,String firstName, String lastName, String civilite, Boolean refusEmail, String email1,
                                                                      String email2, String emailPrefere, Boolean refusFixe, String fixe1, String fixe2,
                                                                      String fixePrefere, Boolean refusMobile,String mobile1, String mobile2, String mobilePrefere,
                                                                      String numeroRue, String rue, String commune,String codePostal, String consentementEngie,
                                                                      String consentementPartenaire)
    {
        
        RechercheClientResponseWrapper wrapper =verifyDQE( parcours,  email1, email2, fixe1,  fixe2, mobile1, mobile2);
        system.debug('##ACH: wrapper.message' + wrapper.message);
        if(wrapper.message == 'success' || wrapper.message == 'champs vide'){
            system.debug('##ACH: inside');
            RechercheClientWrapper clientWrapper=new RechercheClientWrapper( firstName,  lastName,civilite,  refusEmail,  email1,
                                                                            email2,  emailPrefere,  refusFixe,  fixe1,  fixe2,
                                                                            fixePrefere,  refusMobile, mobile1,  mobile2,  mobilePrefere,
                                                                            numeroRue,  rue,  commune, codePostal,  consentementEngie,
                                                                            consentementPartenaire);
            RechercheClientResponseWrapper responseForLWC = createContact(parcours,clientWrapper);
            return responseForLWC;
        }
        else{
            return wrapper;
        }    
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Création d'un contact dans SAP, dans SF + mise à jour ou création des consentements
* @param parcours, RechercheClientWrapper
* @return RechercheClientResponseWrapper ( Wrapper defini dans cette classe)
*/ 
    
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper createContact(VI_Parcours__c parcours, RechercheClientWrapper clientWrapper){
        String contactId;
        String referenceClient;
        String responseStatus;
        String responseSF;
        String emailEspaceClient;
        String mobileEspaceClient;
        //Verify phone numbers
        //Verify emails
        if(parcours!= null && parcours.VI_IDReferenceClient__c != null){
            //Update personne in SAP
            String responseSAP = majPersonneSAP( clientWrapper,parcours.VI_IDReferenceClient__c);
            if(responseSAP.contains('An error occured')){
                return new RechercheClientResponseWrapper(parcours, responseSAP);
            }
            
            if(parcours.VI_Contact__c != null){
                //update contact
                responseSF=updatePersonneSF( clientWrapper, parcours.VI_IDReferenceClient__c, parcours.VI_Contact__c);
                if(responseSF.contains('An error occured')){return new RechercheClientResponseWrapper(parcours, responseSF);
                                                           }
            }
            else{
                //Create contact
                if(Label.VI_useEspacePrive=='true'){
                    if(parcours.VI_Espace_client__c == false){
                        emailEspaceClient=checkPreferedEmail(parcours);
                        if (clientWrapper.mobilePrefere == 'Mobile 1'){ mobileEspaceClient= '+33'+ clientWrapper.mobile1.substring(1, clientWrapper.mobile1.length()); 
                                                                      }
                        if (clientWrapper.mobilePrefere == 'Mobile 2'){ mobileEspaceClient= '+33'+ clientWrapper.mobile2.substring(1, clientWrapper.mobile2.length());
                                                                      }
                        
                        /*String espaceClientResponse=VI_SM016_EspaceClientService.creerEspaceClient(parcours.VI_PrenomClient__c,parcours.VI_NomClient__c,parcours.VI_CiviliteClient__c,
emailEspaceClient,'0'+parcours.VI_IDReferenceClient__c,'VI','local.VIToken');
if(!espaceClientResponse.contains('Le client a déjà créé son Espace Client via un Réseau Social')&&
!espaceClientResponse.contains('Une erreur technique est survenue') && !espaceClientResponse.contains('Service Temporarily Unavailable'))
{
parcours.VI_Espace_client__c=true;
clientWrapper.statutInternaute='Oui';
}*/
                        
                        VI_SM052_EspacesPrives.Response espaceClientResponse=VI_SM052_EspacesPrives.creerEspaceClient(parcours.VI_PrenomClient__c,parcours.VI_NomClient__c,mobileEspaceClient,
                                                                                                                      emailEspaceClient,'0'+parcours.VI_IDReferenceClient__c,'VI','local.VITokenB2C');
                        system.debug('espaceClientResponse.statusCreation '+espaceClientResponse.statusCreation);
                        system.debug('espaceClientResponse.status '+espaceClientResponse.status);
                        if(espaceClientResponse.statusCreation!=null && !espaceClientResponse.statusCreation.contains('EXISTANT')&& espaceClientResponse.status==null )
                        {
                            system.debug('paul updating VI_Espace_client__c');
                            parcours.VI_Espace_client__c=true;
                            clientWrapper.statutInternaute='Oui';
                        }
                    } 
                }
                responseSF = createPersonneSF(  clientWrapper, parcours.VI_IDReferenceClient__c);
                if(!responseSF.contains('Erreur')){
                    parcours.VI_Contact__c = responseSF;
                    parcours.VI_Email_CPV__c=(parcours.VI_EmailPrincipalCreationClient__c=='Email 1'?parcours.VI_Email1Client__c:parcours.VI_Email2Client__c);
                }else{
                    return new RechercheClientResponseWrapper(parcours, responseSF);
                } 
            }
            
        }
        else{
            system.debug('##ACH: Create SAP');
            //create personne dans SAP
            String responseSAP = createPersonneSAP( clientWrapper);
            if(!responseSAP.contains('An error occured')){
                referenceClient = responseSAP;
                parcours.VI_IDReferenceClient__c = responseSAP.substring(1, responseSAP.length());
            }
            else{
                return new RechercheClientResponseWrapper(parcours, responseSAP);
            }

            //CreateContact
            if(referenceClient != null){
                if(Label.VI_useEspacePrive=='true'){
                    if(parcours.VI_Espace_client__c == false){
                        emailEspaceClient=checkPreferedEmail(parcours);
                        if (clientWrapper.mobilePrefere == 'Mobile 1'){ mobileEspaceClient= '+33'+ clientWrapper.mobile1.substring(1, clientWrapper.mobile1.length()); 
                                                                      }
                        if (clientWrapper.mobilePrefere == 'Mobile 2'){ mobileEspaceClient= '+33'+ clientWrapper.mobile2.substring(1, clientWrapper.mobile2.length());
                                                                      }
                        /*String espaceClientResponse=VI_SM016_EspaceClientService.creerEspaceClient(parcours.VI_PrenomClient__c,parcours.VI_NomClient__c,parcours.VI_CiviliteClient__c,
emailEspaceClient,'0'+parcours.VI_IDReferenceClient__c,'VI','local.VIToken');
if(!espaceClientResponse.contains('Le client a déjà créé son Espace Client via un Réseau Social')&&
!espaceClientResponse.contains('Une erreur technique est survenue'))
{
parcours.VI_Espace_client__c=true;
clientWrapper.statutInternaute='Oui';
}*/
                        VI_SM052_EspacesPrives.Response espaceClientResponse=VI_SM052_EspacesPrives.creerEspaceClient(parcours.VI_PrenomClient__c,parcours.VI_NomClient__c,mobileEspaceClient,
                                                                                                                      emailEspaceClient,'0'+parcours.VI_IDReferenceClient__c,'VI','local.VITokenB2C');
                        system.debug('espaceClientResponse.statusCreation '+espaceClientResponse.statusCreation);
                        system.debug('espaceClientResponse.status '+espaceClientResponse.status);
                        if(espaceClientResponse.statusCreation!=null && !espaceClientResponse.statusCreation.contains('EXISTANT')&& espaceClientResponse.status==null )
                        {
                            system.debug('paul updating VI_Espace_client__c');
                            parcours.VI_Espace_client__c=true;
                            clientWrapper.statutInternaute='Oui';
                        }
                    }
                }
                responseSF = createPersonneSF( clientWrapper,  referenceClient);
                if(!responseSF.contains('Erreur:')){
                    System.debug('responseSF - no error');
                    parcours.VI_Contact__c = responseSF;
                    parcours.VI_Email_CPV__c=(parcours.VI_EmailPrincipalCreationClient__c=='Email 1'?parcours.VI_Email1Client__c:parcours.VI_Email2Client__c);
                    
                }
                else{return new RechercheClientResponseWrapper(parcours, responseSF);
                    }
            }
        }
        return new RechercheClientResponseWrapper(parcours, 'Success');
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Création d'un contact dans SAP
* @param parcours, RechercheClientWrapper
* @return String ( reference client ou error message)
*/ 
    
    @AuraEnabled(cacheable=false)
    public static String createPersonneSAP(RechercheClientWrapper clientWrapper){
        gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt creerPersonneInput = new gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt();
        List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
        if(!String.isBlank(clientWrapper.email1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(clientWrapper.email1,true,null));
        }
        if(!String.isBlank(clientWrapper.email2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(clientWrapper.email2, false,null));
        }
        if(!String.isBlank(clientWrapper.mobile1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone(VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.mobile1), null,'ZTM',true,null));
        }
        if(!String.isBlank(clientWrapper.mobile2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.mobile2), null, 'ZTM' , false,null));
        }
        if(!String.isBlank(clientWrapper.fixe1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.fixe1), null, 'TEL' , true,null));
        }
        if(!String.isBlank(clientWrapper.fixe2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.fixe2), null, 'TEL' , false,null));
        }
        List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> profileMarketingList = new List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element>();
        profileMarketingList.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('stopPhoning', clientWrapper.refusFixe?'true': 'false'));
        profileMarketingList.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('stopEmailing', clientWrapper.refusEmail?'true': 'false'));
        gdfsuezComBefCalypsoPersonneV8.adresseDt adresse = VI_SM003_PersonneOctopus.prepareAdresse(clientWrapper.numeroRue, clientWrapper.rue, clientWrapper.codePostal,clientWrapper.commune, null, null, 'FR');
        String civilite ;
        if(clientWrapper.civilite == 'Madame'){civilite = 'MME';
                                              }
        else if(clientWrapper.civilite == 'Monsieur'){  civilite = 'MR';
                                                     }
        else if(clientWrapper.civilite == '' || clientWrapper.civilite=='Co-Titulaire'){ civilite = 'MR et MME';
                                                                                       }
        else{
            civilite = clientWrapper.civilite;
        }
        creerPersonneInput.personne = VI_SM003_PersonneOctopus.preparePersonne(null,adresse, clientWrapper.firstName,clientWrapper.lastName, civilite, canaux, profileMarketingList );
        gdfsuezComBefChpPivotV8.contextDt context = VI_SM003_PersonneOctopus.initContext('VI'/*'Smile'*/, 'v8');
        gdfsuezBefCalypsoPersonneV8.PersonnePort port = VI_SM003_PersonneOctopus.buildPortWSPersonne();
        gdfsuezBefCalypsoPersonneV8.creerPersonneResponse_element response;
        try {
            if(!Test.isRunningTest()){response = VI_SM003_PersonneOctopus.CreerPersonne(creerPersonneInput,context, port,'local.VIToken', 'callout:VI_AuthOctopus');
                                     }else if(Test.isRunningTest()) {
                                         Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
                                         gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
                                         response = porttest.CreerPersonne_Http(creerPersonneInput, context);
                                     }
            if ( response != null  && response.creerPersonneOutput != null && response.creerPersonneOutput.personne != null) {return response.creerPersonneOutput.personne.idPersonne;
                                                                                                                             }
            
            else if(response != null && response.messageRetours != null && response.messageRetours.retourTraitementMessage != null && response.messageRetours.retourTraitementMessage[0] != null){
                // creerPersonneRetour_code
                if (response.messageRetours.retourTraitementMessage[0].libelle != '') { return 'An error occured: '+ response.messageRetours.retourTraitementMessage[0].libelle;
                                                                                      } else { return 'An error occured';
                                                                                             }
            }
        }
        catch(exception e){
            return 'An error occured: '+e.getMessage();
        }
        return 'An error occured';
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Mise à jour d'un contact dans SAP
* @param parcours, RechercheClientWrapper
* @return String ( reference client ou error message)
*/ 
    
    @AuraEnabled(cacheable=false)
    public static String majPersonneSAP(RechercheClientWrapper clientWrapper,String idPersonne){
        gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
        List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
        if(!String.isBlank(clientWrapper.email1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(clientWrapper.email1,true,null));
        }
        if(!String.isBlank(clientWrapper.email2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(clientWrapper.email2, false,null));
        }
        if(!String.isBlank(clientWrapper.mobile1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone(VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.mobile1), null,'ZTM',true,null));
        }
        if(!String.isBlank(clientWrapper.mobile2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.mobile2), null, 'ZTM' , false,null));
        }
        if(!String.isBlank(clientWrapper.fixe1)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.fixe1), null, 'TEL' , true,null));
        }
        if(!String.isBlank(clientWrapper.fixe2)){
            canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommPhone( VI_UTIL002_Utilities.formatPhoneNumber(clientWrapper.fixe2), null, 'TEL' , false,null));
        }
        List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element> profileMarketingList = new List<gdfsuezComBefCalypsoPersonneV8.Personne_profilMarketing_element>();
        profileMarketingList.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('stopPhoning', clientWrapper.refusFixe?'true': 'false'));
        profileMarketingList.add(VI_SM003_PersonneOctopus.prepareProfileMarketing('stopEmailing', clientWrapper.refusEmail?'true': 'false'));
        gdfsuezComBefCalypsoPersonneV8.adresseDt adresse = VI_SM003_PersonneOctopus.prepareAdresse(clientWrapper.numeroRue, clientWrapper.rue, clientWrapper.codePostal,clientWrapper.commune, null, null, 'FR');
        String civilite ;
        if(clientWrapper.civilite == 'Madame'){civilite = 'MME';
                                              }
        else if(clientWrapper.civilite == 'Monsieur'){ civilite = 'MR';
                                                     }
        else if(clientWrapper.civilite == '' || clientWrapper.civilite=='Co-Titulaire'){ civilite = 'MR et MME';
                                                                                       }
        else{
            civilite = clientWrapper.civilite;
        }
        majPersonneInput.personne = VI_SM003_PersonneOctopus.preparePersonne(null,adresse, clientWrapper.firstName,clientWrapper.lastName, civilite, canaux, profileMarketingList );
        majPersonneInput.personne.idPersonne=idPersonne;
        gdfsuezComBefChpPivotV8.contextDt context = VI_SM003_PersonneOctopus.initContext('VI', 'v8');
        gdfsuezBefCalypsoPersonneV8.PersonnePort port = VI_SM003_PersonneOctopus.buildPortWSPersonne();
        gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
        try {
            if(!Test.isRunningTest()){
                response = VI_SM003_PersonneOctopus.MajPersonne(majPersonneInput,context, port,'local.VIToken', 'callout:VI_AuthOctopus');
                if(response.retourTraitementMessage[0].type_x.contains('Erreur')){ return response.retourTraitementMessage[0].libelle;
                                                                                 }
                return 'Success';
            }else if(Test.isRunningTest()) {
                Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
                gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
                response = porttest.MajPersonne_Http(majPersonneInput, context);
            }
        }
        catch(exception e){
            return 'An error occured: '+e.getMessage();
        }
        return 'An error occured';
    }
    
    /**
* @author Paul Ghoussoub
* @date 17/8/2021
* @description MAJ email personne
* @param clientWrapper, referenceClient
* @return String ( id du contact ou Error message)
*/
    //START DDPCM-381
    @AuraEnabled(cacheable=false)
    public static String majEmailPersonne(VI_Parcours__c parcours){
        system.debug('in majEmailPersonne');
        system.debug('parcours '+parcours);
        system.debug('parcours.VI_Email_CPV__c '+parcours.VI_Email_CPV__c);
        List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element> canaux = new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
        if(!String.isBlank(parcours.VI_Email_CPV__c)){
            Contact parcoursContact=[SELECT id,Email,Adresse_Mail_2__c,Adresse_Mail_3__c,Adresse_Mail_Principale__c
                                     FROM Contact 
                                     WHERE id=:parcours.VI_Contact__c limit 1];
            if(parcoursContact.email==null){
                if(parcoursContact.Adresse_Mail_2__c!=null){
                    if(parcoursContact.Adresse_Mail_2__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 2';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,true,2));
                    }
                    else{
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                    }
                }
                if(parcoursContact.Adresse_Mail_3__c!=null){
                    if(parcoursContact.Adresse_Mail_3__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 3';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_3__c,true,3));
                    }
                    else{
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_3__c,false,3));
                    }
                }
                if(parcoursContact.Adresse_Mail_2__c!=parcours.VI_Email_CPV__c && parcoursContact.Adresse_Mail_3__c!=parcours.VI_Email_CPV__c){
                    canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,true,1));
                    parcoursContact.email=parcours.VI_Email_CPV__c;
                    parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 1';
                }
            }
            else if(parcoursContact.Adresse_Mail_2__c==null)
            {
                if(parcoursContact.email!=null){
                    if(parcoursContact.email==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 1'; canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.email,true,1));
                    }
                    else{
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.email,false,1));
                    }
                }
                if(parcoursContact.Adresse_Mail_3__c!=null){
                    if(parcoursContact.Adresse_Mail_3__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 3'; canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_3__c,true,3));
                    }
                    else{ canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_3__c,false,3));
                        }
                }
                if(parcoursContact.email!=parcours.VI_Email_CPV__c && parcoursContact.Adresse_Mail_3__c!=parcours.VI_Email_CPV__c){
                    canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,true,2));
                    parcoursContact.Adresse_Mail_2__c=parcours.VI_Email_CPV__c;
                    parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 2';
                }
            }
            else if(parcoursContact.Adresse_Mail_3__c==null){
                if(parcoursContact.email!=null){
                    if(parcoursContact.email==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 1';canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.email,true,1));
                    }
                    else{
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.email,false,1));
                    }
                }
                if(parcoursContact.Adresse_Mail_2__c!=null){
                    if(parcoursContact.Adresse_Mail_2__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 2';canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,true,2));
                    }
                    else{
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                    }
                }
                if(parcoursContact.email!=parcours.VI_Email_CPV__c && parcoursContact.Adresse_Mail_2__c!=parcours.VI_Email_CPV__c){
                    canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,true,3));
                    parcoursContact.Adresse_Mail_3__c=parcours.VI_Email_CPV__c;
                    parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 3';
                }
            }
            else if(parcoursContact.email!=null && parcoursContact.Adresse_Mail_2__c!=null && parcoursContact.Adresse_Mail_3__c!=null){
                if(parcoursContact.email==parcours.VI_Email_CPV__c || parcoursContact.Adresse_Mail_2__c==parcours.VI_Email_CPV__c || parcoursContact.Adresse_Mail_3__c==parcours.VI_Email_CPV__c)
                {
                    if(parcoursContact.email==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 1';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,true,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,false,3));
                    }
                    else if(parcoursContact.Adresse_Mail_2__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 2';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,false,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,true,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,false,3));
                    }
                    else if(parcoursContact.Adresse_Mail_3__c==parcours.VI_Email_CPV__c){
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 3';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,false,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,true,3));
                    }
                }
                else{
                    if(parcoursContact.Adresse_Mail_Principale__c=='Adresse Mail 1'){
                        parcoursContact.Adresse_Mail_2__c=parcours.VI_Email_CPV__c;
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 2';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,false,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,true,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,false,3));
                    }
                    else if(parcoursContact.Adresse_Mail_Principale__c=='Adresse Mail 2'){
                        parcoursContact.Adresse_Mail_3__c=parcours.VI_Email_CPV__c;
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 3';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,false,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,true,3));
                    }
                    else if(parcoursContact.Adresse_Mail_Principale__c=='Adresse Mail 3'){
                        parcoursContact.email=parcours.VI_Email_CPV__c;
                        parcoursContact.Adresse_Mail_Principale__c='Adresse Mail 1';
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Email,true,1));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcoursContact.Adresse_Mail_2__c,false,2));
                        canaux.add(VI_SM003_PersonneOctopus.prepareCanalCommMail(parcours.VI_Email_CPV__c,false,3));
                    }
                }
            }
            
            gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
            majPersonneInput.personne=new gdfsuezComBefCalypsoPersonneV8.Personne();
            majPersonneInput.personne.correspondance=new gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_element();
            majPersonneInput.personne.correspondance.canalCommunication=new List<gdfsuezComBefCalypsoPersonneV8.Personne_correspondance_canalCommunication_element>();
            majPersonneInput.personne.correspondance.canalCommunication=canaux;
            majPersonneInput.personne.idPersonne=parcours.VI_IDReferenceClient__c;
            gdfsuezComBefChpPivotV8.contextDt context = VI_SM003_PersonneOctopus.initContext('VI', 'v8');
            gdfsuezBefCalypsoPersonneV8.PersonnePort port = VI_SM003_PersonneOctopus.buildPortWSPersonne();
            gdfsuezComBefChpPivotV8.retourTraitementMessagesDt response;
            try {
                if(!Test.isRunningTest()){
                    response = VI_SM003_PersonneOctopus.MajPersonne(majPersonneInput,context, port,'local.VIToken', 'callout:VI_AuthOctopus');
                    if(response.retourTraitementMessage[0].type_x.contains('Erreur')){ return response.retourTraitementMessage[0].libelle;
                                                                                     }
                    update parcoursContact;
                    return 'Success';
                }else if(Test.isRunningTest()) {
                    Test.setMock(HttpCalloutMock.class, new gdfsuezBefCalypsoPersonneV8HttpMock());
                    gdfsuezBefCalypsoPersonneV8.PersonnePort porttest = new gdfsuezBefCalypsoPersonneV8.PersonnePort();
                    response = porttest.MajPersonne_Http(majPersonneInput, context);
                }
            }
            catch(exception e){
                return 'An error occured: '+e.getMessage();
            }
            return 'An error occured';
        }
        return 'An error occured : Email CPV Vide';
    }
    //END DDPCM-381
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Creation d'un contact dans SF
* @param clientWrapper, referenceClient
* @return String ( id du contact ou Error message)
*/
    @AuraEnabled(cacheable=false)
    public static String createPersonneSF(RechercheClientWrapper clientWrapper, String referenceClient)
    {
        id consumerRecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Consumer').getRecordTypeId();
        Account acc = new Account(Name = 'ACC_Technique', RecordTypeId = consumerRecordTypeId );
        insert acc;
        //TO ADD recordType & Account   
        Id smileRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','Contact_Smile'); 
        Contact contactToCreate = new contact(FirstName = clientWrapper.firstName,LastName = clientWrapper.lastName, Salutation = clientWrapper.civilite, 
                                              RecordtypeId=smileRecordTypeid,
                                              Refus_Email__c = clientWrapper.refusEmail, Email = clientWrapper.email1,Adresse_Mail_2__c = clientWrapper.email2, 
                                              Refus_Fixe__c = clientWrapper.refusFixe, Refus_Mobile__c = clientWrapper.refusMobile, 
                                              MailingPostalCode = clientWrapper.codepostal, MailingCity = clientWrapper.commune, MailingStreet = clientWrapper.rue, No_Voie__c = clientWrapper.numeroRue, 
                                              MailingCountry = 'France', Identifiant_Buisness_Partener__c = referenceClient, AccountId = acc.Id);
        if(clientWrapper.fixe1 != null && clientWrapper.fixe1 != ''){
            contactToCreate.Phone = '+33'+ clientWrapper.fixe1.substring(1, clientWrapper.fixe1.length());  
            if (clientWrapper.fixePrefere == 'Téléphone 1'){ contactToCreate.Tel_Fixe_Principal__c = 'Tel Fixe 1';
                                                           }
        }
        if(clientWrapper.fixe2 != null && clientWrapper.fixe2 != ''){
            contactToCreate.Tel_Fixe_2__c = '+33'+ clientWrapper.fixe2.substring(1, clientWrapper.fixe2.length());  
            if(clientWrapper.fixePrefere == 'Téléphone 2'){ contactToCreate.Tel_Fixe_Principal__c = 'Tel Fixe 2';
                                                          }
        }
        if(clientWrapper.mobile1 != null && clientWrapper.mobile1 != ''){
            contactToCreate.MobilePhone = '+33'+ clientWrapper.mobile1.substring(1, clientWrapper.mobile1.length()); 
            if (clientWrapper.mobilePrefere == 'Mobile 1'){
                contactToCreate.Mobile_Principal__c = 'Mobile 1';
            }
        }
        if(clientWrapper.mobile2 != null && clientWrapper.mobile2 != ''){
            contactToCreate.Mobile_2__c = '+33'+ clientWrapper.mobile2.substring(1, clientWrapper.mobile2.length());
            if(clientWrapper.mobilePrefere == 'Mobile 2'){ contactToCreate.Mobile_Principal__c = 'Mobile 2';
                                                         }
        }
        
        if (clientWrapper.EmailPrefere == 'Email 1' && clientWrapper.email1 != null && clientWrapper.email1 != ''){ contactToCreate.Adresse_Mail_Principale__c = 'Adresse Mail 1';
                                                                                                                  }
        else if(clientWrapper.EmailPrefere == 'Email 2' && clientWrapper.email2 != null && clientWrapper.email2 != ''){contactToCreate.Adresse_Mail_Principale__c = 'Adresse Mail 2';
                                                                                                                      }
        
        if(clientWrapper.statutInternaute!=null){ contactToCreate.Statut_Internaute__c=clientWrapper.statutInternaute;
                                                }
        
        Try{
            //create consentement
            insert contactToCreate;
            return contactToCreate.Id;
        }
        catch(exception e){
            String message = (e.getMessage().contains('DUPLICATES_DETECTED')?'Doublon détecté, la(es) fiche(s) suivante(s) existe(nt) déjà':e.getMessage());
            return 'Erreur:'+ message;            
        }
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Mise à jour d'un contact dans SF
* @param RechercheClientWrapper, referenceClient, idContact
* @return String ( reference client ou error message)
*/ 
    
    @AuraEnabled(cacheable=false)
    public static String updatePersonneSF(RechercheClientWrapper clientWrapper, String referenceClient, String IdContact)
    {
        //TO ADD recordType & Account    
        Contact contactToCreate = new contact(FirstName = clientWrapper.firstName,LastName = clientWrapper.lastName, Salutation = clientWrapper.civilite, 
                                              Refus_Email__c = clientWrapper.refusEmail, Email = clientWrapper.email1,Adresse_Mail_2__c = clientWrapper.email2, 
                                              Refus_Fixe__c = clientWrapper.refusFixe, Refus_Mobile__c = clientWrapper.refusMobile, 
                                              MailingPostalCode = clientWrapper.codepostal, MailingCity = clientWrapper.commune, MailingStreet = clientWrapper.rue, No_Voie__c = clientWrapper.numeroRue, 
                                              MailingCountry = 'France', Identifiant_Buisness_Partener__c = referenceClient);
        contactToCreate.Id = IdContact;
        if(clientWrapper.fixe1 != null && clientWrapper.fixe1 != ''){
            contactToCreate.Phone = '+33'+ clientWrapper.fixe1.substring(1, clientWrapper.fixe1.length());  
            if (clientWrapper.fixePrefere == 'Téléphone 1'){ contactToCreate.Tel_Fixe_Principal__c = 'Tel Fixe 1';}
        }
        else{ contactToCreate.Phone = null;
            }
        if(clientWrapper.fixe2 != null && clientWrapper.fixe2 != ''){
            contactToCreate.Tel_Fixe_2__c = '+33'+ clientWrapper.fixe2.substring(1, clientWrapper.fixe2.length());  
            if(clientWrapper.fixePrefere == 'Téléphone 2'){ contactToCreate.Tel_Fixe_Principal__c = 'Tel Fixe 2';}
        }
        else{  contactToCreate.Tel_Fixe_2__c = null;
            }
        if(clientWrapper.mobile1 != null && clientWrapper.mobile1 != ''){
            contactToCreate.MobilePhone = '+33'+ clientWrapper.mobile1.substring(1, clientWrapper.mobile1.length()); 
            if (clientWrapper.mobilePrefere == 'Mobile 1'){
                contactToCreate.Mobile_Principal__c = 'Mobile 1';
            }
        }
        else{  contactToCreate.MobilePhone = null;
            }
        
        if(clientWrapper.mobile2 != null && clientWrapper.mobile2 != ''){
            contactToCreate.Mobile_2__c = '+33'+ clientWrapper.mobile2.substring(1, clientWrapper.mobile2.length());
            if(clientWrapper.mobilePrefere == 'Mobile 2'){contactToCreate.Mobile_Principal__c = 'Mobile 2';
                                                         }
        }
        else{  contactToCreate.Mobile_2__c = null;
            }
        
        if (clientWrapper.EmailPrefere == 'Email 1' && clientWrapper.email1 != null && clientWrapper.email1 != ''){contactToCreate.Adresse_Mail_Principale__c = 'Adresse Mail 1';
                                                                                                                  }
        else if(clientWrapper.EmailPrefere == 'Email 2' && clientWrapper.email2 != null && clientWrapper.email2 != ''){contactToCreate.Adresse_Mail_Principale__c = 'Adresse Mail 2';
                                                                                                                      }
        
        Try{
            //create consentement
            update contactToCreate;
            return contactToCreate.Id;
        }
        catch(exception e){String message = (e.getMessage().contains('DUPLICATES_DETECTED')?'Doublon détecté, la(es) fiche(s) suivante(s) existe(nt) déjà':e.getMessage());
                           return 'Erreur:'+ message;            
                          }
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Mise à jour du parcours suite à la création ou mise à jour d'un contact
* @param RechercheClientWrapper, parcours
* @return VI_Parcours__c 
*/     
    
    @AuraEnabled(cacheable=false)
    public static VI_Parcours__c updateParcours(VI_Parcours__c parcours, RechercheClientWrapper clientWrapper) {
        if(parcours == null){ parcours = new VI_Parcours__c(); }
        parcours.VI_PrenomClient__c = clientWrapper.firstName;
        parcours.VI_NomClient__c = clientWrapper.lastName;
        parcours.VI_CiviliteClient__c = clientWrapper.civilite;
        parcours.VI_RefusEmailCreationClient__c = clientWrapper.refusEmail;
        parcours.VI_Email1Client__c = clientWrapper.email1;
        parcours.VI_Email2Client__c = clientWrapper.email2;
        parcours.VI_EmailPrincipalCreationClient__c = clientWrapper.EmailPrefere;
        parcours.VI_RefusTelephoneCreationClient__c =clientWrapper.refusFixe;
        parcours.VI_TelephoneFixe1Client__c = clientWrapper.fixe1;
        parcours.VI_TelephoneFixe2Client__c = clientWrapper.fixe2;
        parcours.VI_TelephonePrincipalCreationClient__c = clientWrapper.fixePrefere;
        parcours.VI_Mobile1Client__c = clientWrapper.mobile1;
        parcours.VI_Mobile2Client__c = clientWrapper.mobile2;
        parcours.VI_RefusMobile__c = clientWrapper.refusMobile;
        parcours.VI_MobilePrincipalCreationClient__c = clientWrapper.mobilePrefere;
        parcours.VI_CommuneClient__c = clientWrapper.commune;
        parcours.VI_CodePostalClient__c = clientWrapper.codepostal;
        parcours.VI_RueCreationClient__c = clientWrapper.rue;
        parcours.VI_Numero_de_la_rue__c = clientWrapper.numeroRue;
        parcours.VI_ConsentProspectionEngieNonAnalogue__c = clientWrapper.consentementEngie;
        parcours.VI_ConsentProspectionPartenaire__c = clientWrapper.consentementPartenaire;
        return parcours;
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description Mise à jour du parcours 
* @param referenceClient, parcours, contactId
* @return RechercheClientResponseWrapper 
*/     
    @AuraEnabled(cacheable=false)
    public static RechercheClientResponseWrapper updateParcoursClient(VI_Parcours__c parcours, String referenceClient, String contactId) {
        Try{
            if(referenceClient != null ){
                parcours.VI_IDReferenceClient__c = referenceClient;
                if(contactId != null ){
                    parcours.VI_Contact__c = contactId;
                    if(parcours.VI_Case__c != null ){update new case(id = parcours.VI_Case__c, ContactId = contactId);  
                                                    }
                    else{
                        case caseToInsert = new case(ContactId = contactId, Status = 'En Traitement',Type = 'Acquisition', Sous_type__c = parcours.VI_ChoixParcours__c == 'EM'? 'Emménagement': 'Changement de fournisseur', 
                                                     Subject = parcours.VI_ChoixParcours__c, Origin = 'Partner Community');
                        insert caseToInsert;
                        parcours.VI_Case__c = caseToInsert.Id;
                    }
                    
                }
            }
            if(parcours.Id == null){
                insert parcours;
                return new RechercheClientResponseWrapper(parcours, 'Success');
            }
            else{
                update parcours;
                return new RechercheClientResponseWrapper(parcours, 'Success');
            } 
        }        
        Catch(exception e){
            return new RechercheClientResponseWrapper(parcours, e.getMessage());
        }
    }
    
    @AuraEnabled
    public static VI_Parcours__c updateConsentementParcours(VI_Parcours__c parcours){
        List<VI_SM011_ConsentementAnswers_API.consentementAnswer> listAnswers=VI_SM011_ConsentementAnswers_API.getConsentementAnswersData(parcours.VI_IDReferenceClient__c,'VI', 'local.VIToken');
        if(listAnswers!=null && listAnswers.size()>0){
            for (VI_SM011_ConsentementAnswers_API.consentementAnswer answer: listAnswers){ 
                if(answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionNonAnalogue)){
                    if(answer.consent){parcours.VI_ConsentProspectionEngieNonAnalogue__c='Oui'; 
                                      }
                    else{parcours.VI_ConsentProspectionEngieNonAnalogue__c='Non'; 
                        }
                }
                if(answer.idQuestion == Integer.ValueOf(Label.VI_NumeroQuestionPartenaire)){
                    if(answer.consent){ parcours.VI_ConsentProspectionPartenaire__c='Oui'; 
                                      }
                    else{parcours.VI_ConsentProspectionPartenaire__c='Non'; 
                        }
                }
            }
        }
        return parcours;
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description afficher les villes à partir du codePostal 
* @param codePostal
* @return List<String> 
*/   
    @AuraEnabled(cacheable=false)
    public static List<String> getVilles(String codePostal){
        Set<String> villesSet = VI_SM002_AdresseDQE.getSuggestionsCodePostal(codePostal, 'VI', 'local.VIToken'); 
        List<String> villes = new List<String>();
        villes.addAll(villesSet);
        return villes;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String,String> getMapVilles(String codePostal){
        Map<String,String> villesMap = VI_SM002_AdresseDQE.getSuggestionsCodePostalMap(codePostal, 'VI', 'local.VIToken'); 
        return villesMap;
    }
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description afficher les villes à partir du codePostal 
* @param codePostal
* @return List<VI_SM002_AdresseDQE.AdressesWrapper>
*/  
    @AuraEnabled(cacheable=false)
    public static List<VI_SM002_AdresseDQE.AdressesWrapper> getVillesCodePostal(String codePostal){
        List<VI_SM002_AdresseDQE.AdressesWrapper> adresseWrapper = VI_SM002_AdresseDQE.getSuggestionsCodePostalWrapper(codePostal, 'VI', 'local.VIToken'); 
        List<RechercheClientWrapper> villes = new List<RechercheClientWrapper>();
        //  villes.addAll(villesSet);
        return adresseWrapper;
    }
    
    @AuraEnabled(cacheable=false)
    public static Map<String,VI_SM002_AdresseDQE.AdressesWrapper> getVillesCodePostalMap(String codePostal){
        Map<String,VI_SM002_AdresseDQE.AdressesWrapper> adresseWrapper = VI_SM002_AdresseDQE.getSuggestionsCodePostalWrapperMap(codePostal, 'VI', 'local.VIToken'); 
        List<RechercheClientWrapper> villes = new List<RechercheClientWrapper>();
        //  villes.addAll(villesSet);
        return adresseWrapper;
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description afficher les adresses possible à partir du texte saisi dans le lwc 
* @param adresse
* @return List<VI_SM002_AdresseDQE.AdressesWrapper>
*/ 
    
    @AuraEnabled(cacheable=false)
    public static List<VI_SM002_AdresseDQE.AdressesWrapper> getAdresseList(String adresse){
        List<VI_SM002_AdresseDQE.AdressesWrapper> adresses = VI_SM002_AdresseDQE.getSuggestionsAdresseDQE(adresse, 'VI', 'local.VIToken'); 
        return adresses;
    }
    
    public class RechercheClientResponseWrapper{
        @AuraEnabled
        public VI_parcours__c parcours;
        @AuraEnabled
        public String message;
        
        public RechercheClientResponseWrapper(VI_parcours__c parcours, string message){
            this.parcours = parcours;
            this.message = message;
        }
    }
    
    public class Question{
        @AuraEnabled
        public VI_SM011_ConsentementAnswers_API.consentementAnswer answer;
        @AuraEnabled
        public String libelleQuestion;
        public Question(VI_SM011_ConsentementAnswers_API.consentementAnswer answer, String libelleQuestion ){
            this.answer = answer;
            this.libelleQuestion =libelleQuestion;
        }
    }
    
    public class RechercheClientWrapper{
        @AuraEnabled
        public String firstName{get;private set;}
        @AuraEnabled
        public String lastName{get;private set;}
        @AuraEnabled
        public String civilite{get;private set;}
        @AuraEnabled
        public Boolean refusEmail{get;private set;}
        @AuraEnabled
        public String email1{get;private set;}
        @AuraEnabled
        public String email2{get;private set;}
        @AuraEnabled
        public String emailPrefere{get;private set;}
        @AuraEnabled
        public Boolean refusFixe{get;private set;}
        @AuraEnabled
        public String fixe1{get;private set;}
        @AuraEnabled
        public String fixe2{get;private set;}
        @AuraEnabled
        public String fixePrefere{get;private set;}
        @AuraEnabled
        public Boolean refusMobile{get;private set;}
        @AuraEnabled
        public String mobile1{get;private set;}
        @AuraEnabled
        public String mobile2{get;private set;}
        @AuraEnabled
        public String mobilePrefere{get;private set;}
        @AuraEnabled
        public String numeroRue{get;private set;}
        @AuraEnabled
        public String rue{get;private set;}
        @AuraEnabled
        public String commune{get;private set;}
        @AuraEnabled
        public String codePostal{get;private set;}
        @AuraEnabled
        public String consentementEngie{get;private set;}
        @AuraEnabled
        public String consentementPartenaire{get;private set;}
        @AuraEnabled
        public String statutInternaute{get;private set;}
        
        public RechercheClientWrapper(String firstName, String lastName, String civilite, Boolean refusEmail, String email1,
                                      String email2, String emailPrefere, Boolean refusFixe, String fixe1, String fixe2,
                                      String fixePrefere, Boolean refusMobile,String mobile1, String mobile2, String mobilePrefere,
                                      String numeroRue, String rue, String commune,String codePostal, String consentementEngie,
                                      String consentementPartenaire){
                                          this.firstName = firstName;
                                          this.lastName = lastName;
                                          this.civilite = civilite;
                                          this.refusEmail = refusEmail;
                                          this.email1 = email1;
                                          this.email2 = email2;
                                          this.emailprefere = emailprefere;
                                          this.refusFixe = refusFixe;
                                          this.fixe1 = fixe1;                             
                                          this.fixe2 = fixe2;
                                          this.fixePrefere = fixePrefere;
                                          this.refusMobile = refusMobile;  
                                          this.mobile1 = mobile1;                             
                                          this.mobile2 = mobile2; 
                                          this.mobilePrefere = mobilePrefere;
                                          this.numeroRue = numeroRue;
                                          this.rue = rue;
                                          this.commune = commune;
                                          this.codePostal = codePostal;
                                          this.consentementEngie = consentementEngie;
                                          this.consentementPartenaire = consentementPartenaire;
                                          
                                      }
    }
    
    /**
* @author Amal Chreiteh
* @date 15/12/2020
* @description choisir l'adresse email préférée
* @param parcours
* @return l'adresse email préférée
*/ 
    
    public static String checkPreferedEmail(VI_Parcours__c parcours){
        String emailToReturn;
        if (parcours.VI_EmailPrincipalCreationClient__c=='Email 1'){
            emailToReturn=parcours.VI_Email1Client__c;
        }
        else if (parcours.VI_EmailPrincipalCreationClient__c=='Email 2'){ emailToReturn=parcours.VI_Email2Client__c;   
                                                                        }
        return emailToReturn;
    }
    
}