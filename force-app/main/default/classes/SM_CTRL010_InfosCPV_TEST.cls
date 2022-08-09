/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 03-07-2022
 * @last modified by  : Mohamed Aamer
**/
@IsTest
public with sharing class SM_CTRL010_InfosCPV_TEST {

    @testSetup static void dataSetup(){

        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        insert user;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        
        Case testCase = new Case(Subject = 'test', AccountId = testAccount.Id);
        insert testCase;
        
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

        Order orderTest = new Order();
        orderTest.AccountId = testAccount.Id;
        orderTest.EffectiveDate = Date.today();
        orderTest.Status = 'Draft';
        orderTest.Case__c = testCase.Id;
        orderTest.Pricebook2Id = standardPrice.Pricebook2Id;
        insert orderTest;
        
        OrderItem newOrderItem = new OrderItem();
        newOrderItem.OrderId = orderTest.Id;
        newOrderItem.Product2Id = testProduct.Id;
        newOrderItem.Quantity = 1;
        newOrderItem.UnitPrice = 1;
        newOrderItem.PricebookEntryId = standardPrice.Id;
        insert newOrderItem;
    }

    @isTest static void getCaseOrdersTest(){
        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Case testCase = [Select Id From Case Where Subject='test'];
        Order orderTest = [Select Id From Order Where Case__c=:testCase.Id];
        Id orderId = orderTest.Id;
        
        System.runAs(user){
            Test.startTest();
            List<OrderItem> orderItems = SM_CTRL010_InfosCPV.getCaseOrders(testCase.Id);
            OrderItem orderItem = orderItems.get(0);
            System.assertEquals(orderId, orderItem.OrderId,'Order retreived');
            Test.stopTest();
        }
    }
    

}