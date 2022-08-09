/**
 * @description       : Batch class that updates fields on case when the paiement is already requested and
 *                      can't be delayed, It also sends an email to inform the client
 * @author            : FT2-AE
 * @group             : SMILE FT2
 * @last modified on  : 03-08-2022
 * @last modified by  : FT2-AE
**/
public with sharing class SM_BAT06_CaseTraitementDLP implements Database.Batchable<sObject>,Database.AllowsCallOuts, Database.Stateful{
    Exception[] errors = new Exception[0];
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id,subject,SM_TECH_DLP_Formule__c,Contact.Name,Contact.Salutation,Contact.MobilePrincipalValue__c,Contact.EmailPrincipalValue__c From Case 
                                                where (Status =: System.Label.SM_CL20_CaseStatusToBeProcessed AND RecordType.DeveloperName like:System.Label.SM_CL41_RT_Service AND Sous_type__c = 'Délai de paiement / plan d\'apurement' AND
                                                Type='Paiement' AND SM_TECH_DLP_Formule__c!=NULL AND SM_TECH_DLP_Formule__c<5 AND (SM_StatusDuDelaiDePaiement__c!='REFUS du Délai de Paiement' OR TECH_DPSendRefusStatusCode__c!='EmailOuSMSEnvoye'))]);
     }
     
     public void execute( Database.BatchableContext BC, List<Case> listCases){
        if (listCases.size() > 0) {
              try {
                updateCase(listCases);
              } catch(Exception e) {
                  errors.add(e);
              }
          }
     }
      public void finish(Database.BatchableContext BC){
          if(!errors.isEmpty()) {
              System.debug('### Errors occured during batch process ###');
              for (Exception e : errors) {
                  System.debug(e.getStackTraceString()+'\n');
              }
          }
     }
     public void updateCase(List<Case> listCases) {
        for (Case caseToUpdate : listCases) {
            caseToUpdate.Status = System.Label.SM_CL21_Case_status_PreCloturee;
            caseToUpdate.Sous_statut__c = System.Label.SM_CL21_CaseSubStatusConforme;
            caseToUpdate.SM_StatusDuDelaiDePaiement__c = 'REFUS du Délai de Paiement';
            if(!String.isBlank(caseToUpdate.Contact.EmailPrincipalValue__c)){
                caseToUpdate.SM_TECH_DelaiPaiementRefuse__c = true;
                caseToUpdate.Vlocity_SendEmail__c = true;
                caseToUpdate.SM_TECH_Nom__c = caseToUpdate.Contact.Name.toUpperCase();
                caseToUpdate.SM_TECH_Civilite__c =  caseToUpdate.Contact.Salutation;
                caseToUpdate.Vlocity_ContactEmail__c = caseToUpdate.Contact.EmailPrincipalValue__c;
                caseToUpdate.TECH_DPSendRefusStatusCode__c = 'EmailOuSMSEnvoye';
            }else{
                if(!String.isBlank(caseToUpdate.Contact.MobilePrincipalValue__c)){
                    String mobileValue = caseToUpdate.Contact.MobilePrincipalValue__c.replaceAll( '\\s+', '');
                    String procedureName = 'IP_SM_NotificationSMS_SOAP';
                    Map<String, Object> ipOutput =new map<string, object>();
                    Map <String, Object> ipOptions = new Map <String, Object> ();
                    Map<String, Object> ipInput = new Map<String, Object> ();
                    ipOptions.put('ignoreCache',true);
                    ipInput.put('idFormulaireSMS','REFUSDELAIPAIEMENT');
                    ipInput.put('typologieMarche','DGP');
                    ipInput.put('telephone',mobileValue);
                    if(!Test.isRunningTest()){
                        ipOutput = ( Map<String, Object> )vlocity_cmt.IntegrationProcedureService.runIntegrationService(procedureName, ipInput, ipOptions); 
                    }else{
                        if(caseToUpdate.subject=='TESTSMSKO'){
                            ipOutput.put('codeRetour','OCTOPUS_EnvoyerSMS_05');
                        }else{
                            ipOutput.put('codeRetour','OCTOPUS_EnvoyerSMS_01');
                        }
                    }
                    system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT06_CaseTraitementDLP][execute][MESSAGE]: The IP: IP_SM_NotificationSMS_SOAP returns;'+ipOutput);
                    if(!ipOutput.isEmpty() && ipOutput!=null ){
                        String codeRetour=(String)ipOutput.get('codeRetour'); 
                        if(codeRetour=='OCTOPUS_EnvoyerSMS_01' || codeRetour=='OCTOPUS_EnvoyerSMS_08'){
                            caseToUpdate.TECH_DPSendRefusStatusCode__c = 'EmailOuSMSEnvoye';
                            system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT06_CaseTraitementDLP][execute][MESSAGE]: THE SMS was sent to the client '+caseToUpdate.Contact.Name);
                        }else{
                            caseToUpdate.TECH_DPSendRefusStatusCode__c = 'EmailOuSMSKO';
                            caseToUpdate.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
                            caseToUpdate.Sous_statut__c = '';
                            system.debug(LoggingLevel.INFO, '## >> INFO [SM_BAT06_CaseTraitementDLP][execute][MESSAGE]: THE SMS Failed to be sent to the client '+caseToUpdate.Contact.Name);
                        }
                    }
                }else{
                    caseToUpdate.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
                    caseToUpdate.Sous_statut__c = '';
                    caseToUpdate.TECH_DPSendRefusStatusCode__c = 'EmailOuSMSEmpty';
                }
            }
            if(Test.isRunningTest() && caseToUpdate.subject=='TESTDMLKO'){
                throw new DMLException('TEST DML exception'); 
            }
        }
        Database.SaveResult[] resultOfUpdate = Database.update(listCases, false);
    }
}