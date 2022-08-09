/*
* @Author: Amine Deghais ~ amine.deghais@external.engie.com
* @Date: 03/09/2019
* @Description: test Class:Insère un contact pour vérifier le remplissage  email,Mobile,telephone par les email,Mobile,telephone Principals
*/
@isTest(SeeAllData = true)
public class ConsentementsHandler_TEST {
    @isTest static void testConsentementsHandler(){
        ConsentementsHandler.getConsentementsQuestions();
    }
}