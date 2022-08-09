/*
*@Author: Paul Ghoussoub
*@Description: Batch qui est lancé chaque jour pour remplir l'idLocal de l'assurance facture associée au parcours qui n'en ont pas
*@CreatedDate: 04/04/2022
*/
global class VI_BAT006_MAJContrat implements Database.Batchable<sObject>, Database.AllowsCallouts{
    global final String query = 'SELECT Id,VI_PDLRechercheLocal__c,VI_PCERechercheLocal__c,VI_idCompteClient__c FROM VI_Parcours__c where VI_Id_Local__c=null AND VI_Case__r.Status=\'Fermé\' AND VI_AssuranceFactureCocheeAF__c=true';
    //global final String query = 'SELECT Id,VI_PDLRechercheLocal__c,VI_PCERechercheLocal__c,VI_idCompteClient__c FROM VI_Parcours__c where id=\'a4H0Q0000019vaDUAQ\'';

    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('VI_BAT006_MAJContrat starting...');
        return Database.getQueryLocator(query);
    }
    
    public static void execute(){
        VI_BAT006_MAJContrat majContratBatch = new VI_BAT006_MAJContrat();
        Database.executeBatch(majContratBatch,200);
    }
    
    global void execute(Database.BatchableContext bc, List<VI_Parcours__c> scope){
        String idLocal;
        for(VI_Parcours__c parcours:scope) {
            VI_SM050_Installation.InstallationsWrapper installations;
            if(!test.isRunningTest()){
                if(parcours.VI_PDLRechercheLocal__c!=null){
                    installations=VI_SM050_Installation.callInstallations(parcours.VI_PDLRechercheLocal__c,'VI', 'local.VIToken');
                }
                else if(parcours.VI_PCERechercheLocal__c!=null){
                    installations=VI_SM050_Installation.callInstallations(parcours.VI_PCERechercheLocal__c,'VI', 'local.VIToken');
                }
            }
            
            else{
                StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
                multimock.setStaticResource('VI_Installations_Mock');
                multimock.setStatusCode(200);
                multimock.setHeader('Content-Type', 'application/json');
                Test.setMock(HttpCalloutMock.class, multimock);
                installations=VI_SM050_Installation.callInstallations('1234', 'VI', 'local.VIToken');
            }
            system.debug('installations '+installations);
            
            if(installations!=null && installations.data!=null && installations.data.size()>0 && installations.data[0]!=null && installations.data[0].idLocal!=null){
                idLocal= String.valueof(installations.data[0].idLocal);
                parcours.VI_Id_Local__c=idLocal;
                
                system.debug('idLocal '+idLocal);
                VI_SM042_AssuranceFacture.getResponseEditContratTranquility(parcours.id,idLocal,parcours.VI_idCompteClient__c,'VI', 'local.VIToken');
                update parcours;
                
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('VI_BAT006_MAJContrat ending...');
    }
}