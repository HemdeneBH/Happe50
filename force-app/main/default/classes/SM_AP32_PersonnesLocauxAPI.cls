/*@author:Omar MOHAMAD
 *@description: Get all locals for contact
 *@createdDate: 26/11/2018
 *@LastModified:26/12/2018
 */
global class SM_AP32_PersonnesLocauxAPI implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        if (methodName.equals('callPersonnesLocaux')) {
            try {
                
                callPersonnesLocaux(inputMap,outMap,options);
                // your implementation, use outMap to send response back to OmniScript
            } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }
        
        return true;
    }
    
    
    public class LocalModel {
        
        public String IdLocal3;
        public String IdLocal;
        public String IdLocal2;
        public String IdPortefeuilleContrat;
        public String idLogement;
        public String ContactIdBP;
        public String BuildingNumber;
        public String StreetAddress;
        public String AdditionalAddress;
        public String PostalCode;
        public String City;
        
        public LocalModel(String IdLocal3,String IdLocal2 ,String IdPortefeuilleContrat,String ContactIdBP,String idLogement,
                          String IdLocal,String BuildingNumber, String StreetAddress, String AdditionalAddress, String PostalCode, String City) {
                              this.IdLocal3 = IdLocal3;
                              this.IdLocal2 = IdLocal2;
                              this.IdPortefeuilleContrat = IdPortefeuilleContrat;
                              this.idLogement = idLogement;
                              this.ContactIdBP = ContactIdBP;
                              this.IdLocal = IdLocal;
                              this.BuildingNumber = BuildingNumber;
                              this.StreetAddress = StreetAddress;
                              this.AdditionalAddress = AdditionalAddress;
                              this.PostalCode = PostalCode;
                              this.City = City;
                          }
    }
    
    
    public static List<Object> transformDataToCard(List<Object> apiData) {
        
        List<String> listIdContacts = new List<String>();
        String idBP ='';
        //FT2-1678 OPERATION IN LOOPS: Usages de SOQL ou DML dans des boucles 
        List<Object> listTemp = new List <Object>();

        Schema.RecordTypeInfo rtInfo = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Smile');

        for (Object obj : apiData) {
            Map <String,Object> objectX = (Map <String, Object>) obj;
            listIdContacts.add((String) objectX.get('idContact'));
        }
            
        List<Contact> contact= [SELECT Id,Identifiant_Buisness_Partener__c,ID_Tiers_Unifie__c,ID_Tiers__c
                                FROM Contact 
                                where Id IN :listIdContacts and RecordTypeId=:rtInfo.getRecordTypeId()];
         
                                
        if(contact != null && contact.size() == 1 ){
            Contact contactdetail = contact.get(0);
            idBP = contactDetail.Identifiant_Buisness_Partener__c;
            Decimal idPersonne =contactDetail.Id_Tiers__c ;
        }
        for (Object obj : apiData) {
        Map <String,Object> objectX = (Map <String, Object>) obj;   
            
            
            String idAddress = String.valueOf(objectX.get('idAdresse'));
            
            //get IdBan
            Map <String,Object> inputAddress = new Map< String, Object >();
            Map <String,Object> outputAddress = new Map< String, Object >();
            Map <String,Object> options = new Map< String, Object >();
            inputAddress.put('idAddress',idAddress);
            SM_AP07_AdressesApiService.getAddressById(inputAddress,outputAddress,options);
            
            Map <String,Object> logement = (Map <String,Object>) outputAddress.get('results');
            
            String getIBAN = '';
            if(logement != null){
                getIBAN = (String) logement.get('idBan');
            }
            System.debug('objectX' +objectX);
            System.debug('idBP' +idBP);
            
            listTemp.add(new LocalModel(
                String.valueOf(objectX.get('AccountId') ),String.valueOf(objectX.get('No_Compte_contrat')),String.valueOf(objectX.get('ID_Porte_feuille_contrat')),idBP,getIBAN,
                String.valueOf(objectX.get('id') ),String.valueOf(objectX.get('numeroVoie')),String.valueOf(objectX.get('libelleVoie')), String.valueOf(objectX.get('complementAdresse')), 
                String.valueOf(objectX.get('codePostal')), String.valueOf(objectX.get('ville'))));
            
            system.debug('@@ listTemp ' +listTemp);
        }
        
        return listTemp;
    }
    
    public static void callPersonnesLocaux(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        
        
        if (inputMap.get('Id') == null || String.valueOf(inputMap.get('Id')).length() == 0) {
            system.debug('Id is not found ...');
            return;
        }
        
        String idContact  = (String) inputMap.get('Id');
        system.debug(idContact);
        
        List<Object> locaux = new List <Object>();
        List<AccountContactRelation > AccountRelations= [SELECT AccountId, account.ID_Local__c, account.ID_Porte_feuille_contrat__c, account.No_Compte_contrat__c, ContactId,Id
                                                         FROM AccountContactRelation 
                                                         where ContactId = :idContact];
     
        List<String> ContactAccount = new List<String>();
        if(AccountRelations != null && AccountRelations.size() > 0 ){
            System.debug('AccountRelations.size() ' + AccountRelations.size());

            //FT2-1678 OPERATION IN LOOPS: Usages de SOQL ou DML dans des boucles 

            for(AccountContactRelation AccountRelation : AccountRelations){
                ContactAccount.add((String) AccountRelation.get('AccountId'));

            }

            List<Account> accounts = [SELECT Id,ID_Local__c,ID_Porte_feuille_contrat__c,No_Compte_contrat__c FROM Account WHERE Id IN :ContactAccount];  
                            
                if(accounts != null && accounts.size() > 0 ){
                    
                    for(Account account : accounts){
                        Decimal AccountLocal  = account.ID_Local__c;
                        System.debug('AccountLocal ' + AccountLocal);
                        Map < String, Object > inputMapLocal = new Map< String, Object >();
                        
                        
                        if(AccountLocal != null){
                            inputMapLocal.put('numeroLocal',Integer.valueOf(AccountLocal));
               
                            If(!Test.isRunningTest()){
                                SM_AP31_LocauxApiService.callLocaux(inputMapLocal,outMap,options);
                                //SM_AP08_InstallationApiService.getInstallationData(inputMapLocal,outMap,options);
                            }
                            
                            Map <String,Object> inputLocal = new Map< String, Object >();
                            
                            Map<String,Object> result = (Map<String,Object>)outMap.get('resultdata');                           
                            for(String key:result.keySet()){
                                inputLocal.put(key,result.get(key));
                            }
                            inputLocal.put('AccountId',account.Id);
                            inputLocal.put('ID_Porte_feuille_contrat',account.ID_Porte_feuille_contrat__c);
                            inputLocal.put('No_Compte_contrat',account.No_Compte_contrat__c);
                            inputLocal.put('idContact',idContact);
                            locaux.add(inputLocal);
                        }
                        
                        
                    }
                }
                
            
            
            system.debug('output locaux' + locaux.size());
            List<Object> transformedData =  (List<Object>) transformDataToCard(locaux) ;
            
            String JSONString = JSON.serialize(transformedData);
            outMap.put('resultdata',JSON.deserializeUntyped(JSONString));      
            // outMap.put('nombreLocaux',transformedData.size() == 1 ? 'OK' :'NOK' ) ;
            system.debug('outMap' + outMap);
            
        }
        else
        {
            system.debug('Error on Contact properties');
        }
    }
}