/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: test Class:Insère un contact pour vérifier le remplissage  email,Mobile,telephone par les email,Mobile,telephone Principals
*/
@isTest(SeeAllData = true)
public class ConsentementsHandler_TEST {
    @isTest static void testConsentementsHandler(){
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockTestConsentements');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        ConsentementsHandler.getConsentementsQuestions();
    }
        @isTest static void fetchSmileQuestions(){
     ConsentementsHandler.fetchSmileQuestions();    
      
    }
}