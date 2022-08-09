/*
*@Author: André NGUEMA
*@Description: Controller classe pour le lightning web componenet parcoursPPSaisiePaiements
*@CreatedDate: 01/02/2021
*@LastModified: 23/03/2021
*/

public without sharing class VI_ParcoursPPMPaiement_Controller {
    
    
/**
* @author André NGUEMA
* @date 01/02/2021
* @description Récupération des coordonnées bancaires du client
* @param parcours provenant du lwc qui contient idBP utilisé pour l'appel
* @return IbanClientWrapper wrapper qui contient les coordonnées bancaires ou le message d'erreur en cas d'erreur
*/
    @AuraEnabled(cacheable=false)
    public static IbanClientWrapper getCoobClient(VI_parcours__c parcours){

        String idCompteContrat = '0'+parcours.VI_IDReferenceClient__c;
        try{  
            List<VI_SM027_CoordonneesBancaires.Coordonnees>  coobs = VI_SM027_CoordonneesBancaires.getCoordonneesBancaires(idCompteContrat, 'VI', 'local.VIToken');
            return new IbanClientWrapper(coobs, null);
            
        }
        catch (Exception e) {
            return new IbanClientWrapper(null, 'Une erreur s  est produite lors de la récupération des coordonnées');
        }
        
    }
    //
/**
* @author André NGUEMA
* @date 01/02/2021
* @description création de coordonnées bancaires, du compte client et du compte dans SF
* @param parcours provenant du lwc qui contient idBP, IBAN, Nom du titulaire utilisés pour l'appel
* @return saisieIbanWrapper wrapper qui contient les coordonnées bancaires (existantes + nouvelles), le parcours, et le message d'erreur en cas d'erreur
*/
    @AuraEnabled(cacheable=false)
    public static saisieIbanWrapper createCoobClientLWC(VI_parcours__c parcours){ 
        List<Contact> parcoursContact = [SELECT Id, AccountId, FirstName, LastName, account.No_Compte_contrat__c
                                         FROM Contact
                                         WHERE Id = : parcours.VI_Contact__c];
        
        saisieIbanWrapper siw = new saisieIbanWrapper(parcours,null, null);
        IbanClientWrapper wrapper = new IbanClientWrapper(null, null);
        String idCompteContrat = parcours.VI_idCompteClient__c;
        VI_SM027_CoordonneesBancaires.Coordonnees responseCreatecoobClient = createCoobClient(parcours);
        String message = '';
        
        if(responseCreatecoobClient.message != null){
            message = responseCreatecoobClient.message;
            return new saisieIbanWrapper(parcours, message, null);
        }
        else{
            system.debug('responseCreatecoobClient.idCoordonneeBancaire'+ responseCreatecoobClient.idCoordonneeBancaire);
            parcours.VI_Id_coordonnees_bancaires__c = responseCreatecoobClient.idCoordonneeBancaire;
            system.debug('Before getCoobClient');
            //siw.ibanClientWrapper = getCoobClient(parcours);
            //siw.parcours = parcours;
            wrapper= getCoobClient(parcours);
            wrapper.coordonnees.add(responseCreatecoobClient);
            system.debug('After getCoobClient');
            system.debug('wrapper'+ wrapper);
            
        }
        
         system.debug('parcours.VI_Id_coordonnees_bancaires__c'+ parcours.VI_Id_coordonnees_bancaires__c);       
        if(parcours.VI_Id_coordonnees_bancaires__c != null){
            String responseCreateAccount = createAccount(parcours, idCompteContrat);
            if(responseCreateAccount.contains('Erreur')){
                //siw.message = responseCreateAccount;
                return new saisieIbanWrapper(parcours, responseCreateAccount,wrapper);
            }
            else{
                parcours.VI_idCompteClient__c = responseCreateAccount;
                system.debug('parcours.VI_idCompteClient__c'+ parcours.VI_idCompteClient__c);
                String responseCreateAccountSF = createAccountSF(parcours, parcours.VI_idCompteClient__c, parcoursContact[0]);
                if(responseCreateAccountSF.contains('Erreur')){
                    return new saisieIbanWrapper(parcours, responseCreateAccountSF,wrapper);
                    
                }
                else{
                    parcours.VI_CompteClient__c = responseCreateAccountSF;
                }
            }
            
            
        }
		
        siw.parcours = parcours;
        siw.ibanClientWrapper = wrapper;
        system.debug('parcours'+ parcours);
        system.debug('siw'+ siw);
        return siw;
    }
    
    @AuraEnabled(cacheable=false)
    public static  saisieIbanWrapper chooseIBANexistant(VI_parcours__c parcours){ 
        List<Contact> parcoursContact = [SELECT Id, AccountId, FirstName, LastName, account.No_Compte_contrat__c
                                         FROM Contact
                                         WHERE Id = : parcours.VI_Contact__c];
        String responseCreateAccount = createAccount(parcours, parcours.VI_idCompteClient__c);
            if(responseCreateAccount.contains('Erreur')){
                //siw.message = responseCreateAccount;
                return new saisieIbanWrapper(parcours, responseCreateAccount,null);
            }
            else{
                parcours.VI_idCompteClient__c = responseCreateAccount;
                system.debug('parcours.VI_idCompteClient__c'+ parcours.VI_idCompteClient__c);
                String responseCreateAccountSF = createAccountSF(parcours, parcours.VI_idCompteClient__c, parcoursContact[0]);
                system.debug('responseCreateAccountSF'+ responseCreateAccountSF);
                if(responseCreateAccountSF.contains('Erreur')){
                    return new saisieIbanWrapper(parcours, responseCreateAccountSF,null);
                    
                }
                else{
                    parcours.VI_CompteClient__c = responseCreateAccountSF;
                    system.debug('parcours.VI_CompteClient__c'+ parcours.VI_CompteClient__c);
                }
            }
        return new saisieIbanWrapper(parcours, null,null);
    }
    
    
/**
* @author André NGUEMA
* @date 01/02/2021
* @description création de coordonnées bancaires
* @param parcours provenant du lwc qui contient idBP utilisés pour l'appel
* @return VI_SM027_CoordonneesBancaires.Coordonnees wrapper qui contient les details des coordonnées bancaires crées ou le message d'erreur en cas d'erreur
*/
    @AuraEnabled(cacheable=false)
    public static VI_SM027_CoordonneesBancaires.Coordonnees createCoobClient(VI_parcours__c parcours){   
        
        String idPersonne = '0'+ parcours.VI_IDReferenceClient__c;
        String IbanNumber = parcours.VI_IBANMoyendePaiement__c;
        String TitulaireCompte = parcours.VI_NomTitulaireMoyendePaiement__c;
        try{
            VI_SM029_CoordonneesBancaires.InfosCompteBancaire coob = VI_SM029_CoordonneesBancaires.creerCompteBancaire(idPersonne,IbanNumber, TitulaireCompte, 'VI', 'local.VIToken'); 
            system.debug('coob'+ coob);
            if(coob.message != null){ 
                VI_SM027_CoordonneesBancaires.Coordonnees rcc = new VI_SM027_CoordonneesBancaires.Coordonnees();
                rcc.message =coob.message;
                return rcc;
                
            }
            else{
                VI_SM027_CoordonneesBancaires.Coordonnees responseCreateCoob = new VI_SM027_CoordonneesBancaires.Coordonnees();
                
                responseCreateCoob.idCoordonneeBancaire = coob.idCoordonneeBancaire;
                responseCreateCoob.Nombanque = coob.NomBanque;
                responseCreateCoob.IbanNumber = coob.IbanNumber;
                responseCreateCoob.IbanNumberX = 'XXXXXXXXXXXXXXXXXXXXXXX'+ coob.IbanNumber.substring(coob.IbanNumber.length()-4,coob.IbanNumber.length());
                responseCreateCoob.message = coob.message;
                responseCreateCoob.TitulaireCompte = coob.titulaire;
                
                return responseCreateCoob;
                
            }
        }catch (Exception e) {
            
            VI_SM027_CoordonneesBancaires.Coordonnees rcc = new VI_SM027_CoordonneesBancaires.Coordonnees();
            rcc.message =e.getMessage();
            
            return rcc;
            
        }
        
    }
    
    //
/**
* @author André NGUEMA
* @date 01/02/2021
* @description Création du compte client
* @param parcours provenant du lwc et l'id du compte Contrat
* @return String qui contient l'id du compte contrat ou le message d'erreur en cas d'erreur
*/
    @AuraEnabled(cacheable=false)
    public static String createAccount(VI_parcours__c parcours, String idCompteContrat){
        //VI_SM030_CreerCompteClient.CreerCompteClient('+14B','01','01','PP','5.0','callout:VI_AuthOctopus');
        System.debug('idCompteContrat'+ idCompteContrat);
        system.debug('VI_Id_coordonnees_bancaires__c'+ parcours.VI_Id_coordonnees_bancaires__c);
        String idPersonne = parcours.VI_IDReferenceClient__c;
        String descriptionCompteClient = 'Compte créé automatiquement sur un parcours';  
        try{
            //if(idCompteContrat == null){ 
                String idCompteContratCree = VI_SM030_CreerCompteClient.CreerCompteClient('+14B', idPersonne,parcours.VI_Id_coordonnees_bancaires__c ,descriptionCompteClient, 'PP', '5.0', 'callout:VI_AuthOctopus');
                system.debug(idCompteContrat);
                return idCompteContratCree;
            //}
            //return idCompteContrat;
        }catch (Exception e) {
            return 'Erreur :'+ e.getmessage();
            
        }
    }
    
/**
* @author André NGUEMA
* @date 01/02/2021
* @description Création du compte dans Salesforce
* @param parcours provenant du lwc, l'id du compte Contrat et le contact
* @return String qui contient le message de success ou d'erreur
*/
    @AuraEnabled(cacheable=false)
    public static String createAccountSF(VI_parcours__c parcours, String idCompteContrat, Contact contact){
        string message;
        try{
            //Create account
            Account a = new Account (Name = contact.FirstName + ' '+ Contact.LastName, No_compte_contrat__c = idCompteContrat);
            
            insert a;
            //Create accountContactRelationship
            AccountContactRelation accountContactRelation = new AccountContactRelation (AccountId = a.Id ,
                                                                                        ContactId = parcours.VI_Contact__c);
            insert accountContactRelation;
            message = a.Id;
        }
        catch(exception e){
            message = e.getmessage();
        }
        return message;
    }
    
    
    public class IbanClientWrapper{
        
        @AuraEnabled
        public List<VI_SM027_CoordonneesBancaires.Coordonnees> coordonnees {get;set;}
        
        @AuraEnabled
        public String message{get; set;}
        
        public IbanClientWrapper( List<VI_SM027_CoordonneesBancaires.Coordonnees> coordonnees, String message){//
            this.coordonnees = coordonnees;
            this.message = message; 
        }
    }
    
    public class saisieIbanWrapper{ 
       
        @AuraEnabled
        public VI_parcours__C parcours {get;set;}
       
       /* @AuraEnabled
        public ResponseCreateCoob responseCoob{get; set;}*/
        
        @AuraEnabled
        public IbanClientWrapper ibanClientWrapper{get; set;}
        
        @AuraEnabled
        public String message{get; set;}
        
        public saisieIbanWrapper( VI_parcours__C parcours, String message, IbanClientWrapper ibanClientWrapper){//
            this.parcours = parcours;
            this.ibanClientWrapper = ibanClientWrapper;
            this.message = message;
        }
            
    }
    
    /*public class ResponseCreateCoob{ 
       
        @AuraEnabled
        public String idCoob {get;set;}
       
        @AuraEnabled
        public String nomDeLaBanque{get; set;}
        
        @AuraEnabled
        public String IbanNumber{get; set;}
        
        @AuraEnabled
        public Boolean coordAdded{get; set;}
        
        @AuraEnabled
        public String message{get; set;}
        
        
        public ResponseCreateCoob( String idCoob, String nomDeLaBanque, String IbanNumber, Boolean coordAdded, String message){//
            this.idCoob = idCoob;
            this.nomDeLaBanque = nomDeLaBanque;
            this.IbanNumber = IbanNumber;
            this.coordAdded = coordAdded;
            this.message = message;
        }
            
    }*/

}