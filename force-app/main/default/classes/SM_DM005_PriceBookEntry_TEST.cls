/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 03-04-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_DM005_PriceBookEntry_TEST {
    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        insert user;

        Product2 testProduct = new Product2(
            Name = 'Test',
            FamilyLabel__c = 'Elec Malin 2 ans',
            Family = 'GBUF1C_P',
            IsActive = true
        );
        insert testProduct;

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProduct.Id,
            UnitPrice = 100,
            IsActive = true,
            UseStandardPrice = false
        );

        insert standardPrice;
    }

    @isTest static void retrieveCasesByPcIdsTest(){
        
        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Product2 testProduct = [Select Id From Product2 Where Name='Test'];
        String productId = testProduct.Id;
        Set<String> productIds = new Set<String> {productId};
        System.runAs(user){
            Test.startTest();
            List<PricebookEntry> prices = SM_DM005_PriceBookEntry.retrieveByProductIds(productIds);
            PricebookEntry pricetest = prices.get(0);
            System.assertEquals(productId, pricetest.Product2Id,'PricebookEntry retreived');
            Test.stopTest();
        }
    }
}