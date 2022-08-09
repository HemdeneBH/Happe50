/** 
* @author            : Ahlam BENABBOU
* @group             : SMILE FT4
* @description       : Batchable class that relaunches client space creation for contacts without EC
**/
public with sharing class SM_BAT05_RelaunchEspaceClient implements Database.Batchable<sObject>, Database.AllowsCallOuts,Database.Stateful  {
    List<Contact> listContactsToUpdate= new List<Contact>();
    public  Database.QueryLocator start(Database.BatchableContext BC) {
        // Collect the batches of contacts to be passed to execute which are the contacts having and id_tiers and that were created during the last 30 days
        DateTime nowDateTime = System.now();
        DateTime dateReLaunch = nowDateTime.addDays(-30);
        String dateTimeFormat=dateReLaunch.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        //DateTime Formatted_Date=dateReLaunch.parse(dateTimeFormat);
        return Database.getQueryLocator([SELECT ID_Tiers__c,LastName,FirstName,ChoixEmailEspaceClient__c,Phone,Identifiant_Buisness_Partener__c,RecordTypeId 
                                         FROM Contact 
                                         WHERE ID_Tiers__c != null 
                                         AND Tech_StatusCreationEspaceClient__c ='Scheduled' 
                                         AND LastModifiedDate >=: dateReLaunch]);
        
        
    }
    public void execute(Database.BatchableContext bc,List<Contact> listContacts){
        
        List<Object> referencesSI =new List<object>();
        Map<String, Object> referenceClient1 =new map<string, object>();
        Map<String, Object> referenceClient2 =new map<string, object>();
        map<string, object> inputContact = new map<string, object>();
        Map<String, Object> ipOutput =new map<string, object>();
        
        if(!listContacts.isEmpty()){
            for(Contact cont : listContacts){
                inputContact = getInputContactForIPCreateEC(cont);
                system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT05_RelaunchEspaceClient][execute][MESSAGE]: Method implemented and the contact map was created with success :'+ inputContact);
                if(!Test.isRunningTest()){
                    ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService('IP_SM_EspaceClientOKTA', inputContact, null); 
                }
                else{
                    if(cont.Identifiant_Buisness_Partener__c =='206359257'){
                        ipOutput.put('EspaceClientCree',true);
                        ipOutput.put('EspaceClientExistant',false);
                    }else{
                        ipOutput.put('EspaceClientCree',false);
                        ipOutput.put('EspaceClientExistant',false);
                    }
                }
                system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT05_RelaunchEspaceClient][execute][MESSAGE]: The IP: IP_SM_EspaceClientOKTA returns;'+ipOutput);
                //Create a list for the EC creation failure cases  
                List<Contact> listContactWithOutEC=new List<Contact>();
                //Check if the map is not null and if it contains content
                if(!ipOutput.isEmpty() && ipOutput!=null ){
                    Boolean created=(Boolean)ipOutput.get('EspaceClientCree'); 
                    Boolean existant=(Boolean)ipOutput.get('EspaceClientExistant');
                    If (created==false && existant==false){
                        listContactWithOutEC.add(cont);
                        system.debug(LoggingLevel.WARN, '## >> WARN [SM_BAT05_RelaunchEspaceClient][execute][MESSAGE]: the EC was not created nor existant, so the contact was added to listContactWithOutEC  : '+cont);
                    }else{
                        listContactsToUpdate.add(cont);
                        system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT05_RelaunchEspaceClient][execute][MESSAGE]: the EC was created, the contact was added to listContactsToUpdate  : '+cont);
                    }
                }
            }
        }
    }    
    public void finish(Database.BatchableContext bc){
        //invoke ContactsToUpdate method below
        if(listContactsToUpdate.size()>0 && listContactsToUpdate != null){
            ContactsToUpdate(listContactsToUpdate); 
        }
    }
    // Method to update contacts 
    public static void ContactsToUpdate(List<Contact> listContacts){
        
        // process each batch of the contact records
        if(listContacts != null && listContacts.size()>0){
            for(Contact Con: listContacts) {        
                // Update the new Contacts fields
                Con.Tech_StatusCreationEspaceClient__c='';
                Con.ChoixEmailEspaceClient__c='';
            }
            try {
                // Update the Contact Records
                update listContacts;            
                
            }catch(Exception excep) {
                system.debug(LoggingLevel.ERROR, '## >> ERROR [SM_BAT05_RelaunchEspaceClient][ContactsToUpdate][MESSAGE]:'+ excep.getMessage() + '\n' + excep.getStackTraceString()); 
            }
        }
    }
    //Method to build a MAP for inputContact
    public Map < String, Object > getInputContactForIPCreateEC(Contact cont){
        List<Object> referencesSI =new List<object>();
        Map<String, Object> referenceClient1 =new map<string, object>();
        Map<String, Object> referenceClient2 =new map<string, object>();
        map<string, object> inputContactMap = new map<string, object>();
        referenceClient1.put('referenceClient',cont.ID_Tiers__c);
        referenceClient1.put('application', 'XDATA_DGP');
        referenceClient2.put('referenceClient',cont.Identifiant_Buisness_Partener__c);
        referenceClient2.put('application', 'SYMPHONIE_DGP');
        referencesSI.add(referenceClient1);
        referencesSI.add(referenceClient2);
        inputContactMap.put('nom',cont.LastName);
        inputContactMap.put('prenom',cont.FirstName);
        inputContactMap.put('email',cont.ChoixEmailEspaceClient__c);
        inputContactMap.put('login',cont.ChoixEmailEspaceClient__c);
        inputContactMap.put('idTIER',cont.ID_Tiers__c);
        inputContactMap.put('idBP',cont.Identifiant_Buisness_Partener__c);
        inputContactMap.put('referencesSI',referencesSI);
        return inputContactMap;
    }
    
    
}