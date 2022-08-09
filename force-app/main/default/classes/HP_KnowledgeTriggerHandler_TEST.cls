/**
 * @File Name          : HP_KnowledgeTriggerHandler_TEST.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/05/2020 à 03:49:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/05/2020   Vincent Albiser     Initial Version
**/
@isTest
public class HP_KnowledgeTriggerHandler_TEST {

    @testSetup static void dataSetup(){
 
        System.runAs(HP_UTIL_SmartFactory.insertUserHP()){
            
            Knowledge__kav k = (Knowledge__kav) HP_UTIL_SmartFactory.createSObject('Knowledge__kav', null, new Map<String, Object>{
                'Title' => 'Test',
                'UrlName' => 'TestUrl'
            }, null, null, null);
            insert k;    
            
            Knowledge__DataCategorySelection categorySelection = (Knowledge__DataCategorySelection) HP_UTIL_SmartFactory.createSObject('Knowledge__DataCategorySelection', null, new Map<String, Object>{
                'DataCategoryGroupName' => 'happ_e',
                'DataCategoryName' => 'all',
                'ParentId' => k.Id
            }, null, null, null);
            insert categorySelection;             
        }
    }

    @isTest static void setDataCategories_TEST(){
		
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){           
            Test.startTest();
            Knowledge__kav k = [SELECT Id FROM Knowledge__kav WHERE Title ='Test'];
            update k;
            k = [SELECT Id, HP_TECH_DataCategories__c FROM Knowledge__kav WHERE Title ='Test'];
            Test.stopTest();
            System.assertEquals('All', k.HP_TECH_DataCategories__c);
        }         
    }
}