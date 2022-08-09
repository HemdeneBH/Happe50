/**
 * @File Name          : HP_HttpUtils_TEST.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 24/04/2020 à 18:15:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTEST
public with sharing class HP_HttpUtils_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }

    @isTest 
    static void requestGetOutput(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<Integer, String> dataMapGet =new Map<Integer, String>{200 =>'GET'};
            Map<Integer, String> dataMapPost =new Map<Integer, String>{201 =>'POST'};
            Test.startTest();
            String outputGet = HP_HttpUtils.requestGetOutput(dataMapGet);
            String outputPost = HP_HttpUtils.requestGetOutput(dataMapPost);
            System.assertEquals(outputGet, 'GET');
            System.assertEquals(outputPost, 'POST');
            Test.stopTest();
        }
    }
}