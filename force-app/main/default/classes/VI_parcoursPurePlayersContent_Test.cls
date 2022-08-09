/*
* @Author: Paul Ghoussoub
*@Description: Classe de test de VI_parcoursPurePlayersContent_Controller
*@CreatedDate: 28/1/2021
*@LastModified: 29/12/2020
*/
@isTest
public class VI_parcoursPurePlayersContent_Test {
    @testSetup
    static void testSetup(){
        
        
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        acc.RecordTypeId = Account.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('PartenaireAccountRT').getRecordTypeId();
        acc.VI_TypeParcours__c = 'PURE PLAYERS';
        acc.VI_Type_Enseigne__c = 'INDIRECTE';
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        u.IsActive = true;
        insert u;

    }
    
    @isTest
    static void testmethod1(){
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' AND isActive = true and Profile.Name ='VI_PurePlayer'
                 Limit 1];
        System.runAs(u){
            VI_Parcours__c parcours=VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
            parcours.VI_StatutParcours__c='Vente en cours';
            insert parcours;
            VI_DonneesParcours__c donnesParcours = new VI_DonneesParcours__c();
            insert donnesParcours;
            VI_Parcours__c y=VI_parcoursPurePlayersContent_Controller.getParcours(parcours.id);
            String parcoursId=VI_parcoursPurePlayersContent_Controller.createParcours('test');
            system.assert(parcoursId!=null);
            VI_parcoursPurePlayersContent_Controller.updateParcours(parcours.id,'test','Gaz','EM','Recherche du local par adresse','situation');
            VI_Parcours__c parcours2=[Select id,VI_ChoixParcours__c from VI_Parcours__c where id=:parcours.id limit 1];
            system.assertEquals(parcours2.VI_ChoixParcours__c, 'EM');
            String result=VI_parcoursPurePlayersContent_Controller.updateParcoursWrapper(parcours, false, false);
            system.assertEquals(result, 'Success');
            List<VI_DonneesParcours__c> listDP= VI_parcoursPurePlayersContent_Controller.getParcoursDonnee();
            system.assert(listDP.size()>0);
        }
    }
}