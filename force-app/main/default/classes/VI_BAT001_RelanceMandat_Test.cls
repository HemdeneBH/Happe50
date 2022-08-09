/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe de test de VI_BAT001_RelanceMandat
*@CreatedDate: 16/03/2021
*/
@isTest
public class VI_BAT001_RelanceMandat_Test {
    @testSetup
    static void testSetup1(){
        VI_Parcours__c parcours=new VI_Parcours__c(VI_URL_Mandat__c='www.urlmandat.com',VI_IDReferenceClient__c='1',VI_ID_Mandat__c='1',VI_EmailEnvoye__c=true,VI_idCompteClient__c='1',VI_Tech_relance__c=false);
        insert parcours;
    }
    @isTest
    static void testBatch(){
		Test.startTest();
        VI_BAT001_RelanceMandat.execute();
        Test.stopTest();        
        List<VI_Parcours__c> listParcours =[SELECT id,VI_Tech_relance__c from VI_Parcours__c];
        system.debug('listParcours '+listParcours);
        for(VI_Parcours__c parcours:listParcours){
            System.assert(parcours.VI_Tech_relance__c);
        }
    }

}