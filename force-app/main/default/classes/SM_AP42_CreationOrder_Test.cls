/*@isTest(SeeAllData=true)*/
/*
*@author : MTR
*@Description:
*@CreatedDate :
*@LastModified: MHA 13/12/2018
*/
@isTest
public class SM_AP42_CreationOrder_Test {
    /*
    *@author : MTR
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void createOrderTest() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        /*Map < String, Object > Recap = new Map < String, Object >();*/
        Map < String, Object > offreChoisis = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        insert testProduct;

        inputMap.put('vIdConsumerAccount', testAccount.Id);
        inputMap.put('vIdPropositionCommerciale', '1234567890');
        inputMap.put('vNewPCStatus', 'Accept');
        inputMap.put('vCaseId', testCase.Id);
        inputMap.put('vEffectiveDate', '2018-12-03T23:00:00.000Z');
        inputMap.put('vIdPack', 'GBUF1C_P');
        inputMap.put('vEnergyTypeOptions', 'Gaz');
        inputMap.put('vFEL', true);
        inputMap.put('vMens', false);

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        insert standardPrice;

        System.debug('MHA Test priceBookId:' + standardPrice);

        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        //inputMap.put('vOrderId',String.valueOf(outMap.get('orderId')));
        System.assertNotEquals(String.valueOf(outMap.get('orderId')), null);
        /*service.invokeMethod('majOrderFuture', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderId') != null) {
            orderId = (Id)outMap.get('orderId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals('Activated', newOrder.Status);*/
        Test.stopTest();
    }

    /*
    *@author : MHA
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void createRefusedOrderTest() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        Map < String, Object > Recap = new Map < String, Object >();
        Map < String, Object > offreChoisis = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        Product2 testProduct1 = new Product2(Name = 'Test2', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        List<Product2> testProductList = new List<Product2>();
        testProductList.add(testProduct);
        testProductList.add(testProduct1);
        insert testProductList;

        inputMap.put('vIdConsumerAccount', testAccount.Id);
        inputMap.put('vIdPropositionCommerciale', '1234567890');
        inputMap.put('vNewPCStatus', 'Refuse');
        inputMap.put('vCaseId', testCase.Id);
        inputMap.put('vEffectiveDate', '2018-12-03T23:00:00.000Z');
        inputMap.put('vIdPack', 'GBUF1C_P');
        inputMap.put('vEnergyTypeOptions', 'Gaz');
        inputMap.put('vFEL', true);
        inputMap.put('vMens', false);

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct1.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        List<PricebookEntry> standardPriceList = new List<PricebookEntry>();
        standardPriceList.add(standardPrice1);
        standardPriceList.add(standardPrice);
        insert standardPriceList;

        System.debug('MHA Test priceBookId:' + standardPrice);

        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderId') != null) {
            orderId = (Id)outMap.get('orderId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals('Refus', newOrder.Status);
        Test.stopTest();
        
    }

    /*
    *@author : MHA
    *@Description:Test de la création de l'order sans pricebookEntry
    *@CreatedDate :
    *@LastModified: MHA 07/03/2019
    */
    static testMethod void createOrderTestWithOutPriceBookEntry() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        /*Map < String, Object > Recap = new Map < String, Object >();*/
        Map < String, Object > offreChoisis = new Map < String, Object >();
      

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        insert testProduct;

        
        inputMap.put('vIdConsumerAccount', testAccount.Id);
        inputMap.put('vIdPropositionCommerciale', '1234567890');
        inputMap.put('vNewPCStatus', 'Accept');
        inputMap.put('vCaseId', testCase.Id);
        inputMap.put('vEffectiveDate', '2018-12-03T23:00:00.000Z');
        inputMap.put('vIdPack', 'GBUF1C_P');
        inputMap.put('vEnergyTypeOptions', 'Gaz');
        inputMap.put('vFEL', true);
        inputMap.put('vMens', false);


        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        inputMap.put('orderId',String.valueOf(outMap.get('orderId')));
        Id orderId = (Id)outMap.get('orderId');
        Order newOrder= [Select id, OrderNumber, Status from Order Where id = : orderId ];
        System.assertEquals('Draft', newOrder.Status);
    }

    /*
    *@author : MHA
    *@Description:Test de la création de l'order sans produit
    *@CreatedDate :
    *@LastModified: MHA 07/03/2019
    */
    static testMethod void createOrderTestWithOutProduct() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        /*Map < String, Object > Recap = new Map < String, Object >();*/
        Map < String, Object > offreChoisis = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;
     
        inputMap.put('vIdConsumerAccount', testAccount.Id);
        inputMap.put('vIdPropositionCommerciale', '1234567890');
        inputMap.put('vNewPCStatus', 'Accept');
        inputMap.put('vCaseId', testCase.Id);
        inputMap.put('vEffectiveDate', '2018-12-03T23:00:00.000Z');
        inputMap.put('vIdPack', 'GBUF1C_P');
        inputMap.put('vEnergyTypeOptions', 'Gaz');
        inputMap.put('vFEL', true);
        inputMap.put('vMens', false);

        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderId') != null) {
            orderId = (Id)outMap.get('orderId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals('Draft', newOrder.Status);
        Test.stopTest();
    }

    /*
    *@author : MHA
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void errorOnAccountIdFromOmniscript() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        Map < String, Object > Recap = new Map < String, Object >();
        Map < String, Object > offreChoisis = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        Product2 testProduct1 = new Product2(Name = 'Test2', FamilyLabel__c = 'Elec Malin 2 ans', Family = 'GBUF1C_P', IsActive = true);
        List<Product2> testProductList = new List<Product2>();
        testProductList.add(testProduct);
        testProductList.add(testProduct1);
        insert testProductList;

        ChoixElements.put('EffectiveDate', '2018-12-03T23:00:00.000Z');
        /*Recap.put('OffreSouscrite', 'Elec Malin 2 ans');*/
        offreChoisis.put('idPack', 'GBUF1C_P');


        inputMap.put('DRId_Case', testCase.Id);
        inputMap.put('ChoixElements', ChoixElements);
        inputMap.put('idPropositionCommerciale', '1234567890');
        /*inputMap.put('Recap', Recap);*/
        inputMap.put('OffreChoisis', offreChoisis);
        inputMap.put('newPCStatus', 'refuse');

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct1.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        List<PricebookEntry> standardPriceList = new List<PricebookEntry>();
        standardPriceList.add(standardPrice1);
        standardPriceList.add(standardPrice);
        insert standardPriceList;

        System.debug('MHA Test priceBookId:' + standardPrice);

        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderId') != null) {
            orderId = (Id)outMap.get('orderId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals(null, newOrder);
        Test.stopTest();
    }

    /*
    *@author : MHA
    *@Description: test le cas d'erreur où l'idProposition commerciale n'existe pas et que le statut d'entrée est accepté
    *@CreatedDate : 03/01/2019
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void ErrorAcceptedMethod() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        Map < String, Object > Recap = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Elec Malin 2 ans', IsActive = true);
        insert testProduct;

        ChoixElements.put('EffectiveDate', '2018-12-03T23:00:00.000Z');
        Recap.put('OffreSouscrite', 'Elec Malin 2 ans');


        inputMap.put('DRId_Case', testCase.Id);
        inputMap.put('idConsumerAccount', testAccount.Id);
        inputMap.put('ChoixElements', ChoixElements);
        inputMap.put('Recap', Recap);
        inputMap.put('newPCStatus', 'Accept');

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        insert standardPrice;

        System.debug('MHA Test priceBookId:' + standardPrice);

        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrder', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderId') != null) {
            orderId = (Id)outMap.get('orderId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals(null, newOrder);
        Test.stopTest();
    }
    
    /*
    *@author : HEL
    *@Description: test de creation d'un order SA
    *@CreatedDate : 09/04/2019

    */
    static testMethod void createOrderSATest() {
        Test.startTest();
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > ChoixElements = new Map < String, Object >();
        Id orderId;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        String IdConsumerAccount = testAccount.Id;

        Case testCase = new Case();
        insert testCase;

        Product2 testProduct = new Product2(Name = 'Test', FamilyLabel__c = 'Service Facture Simple', Family = 'PREV_FACT_P', IsActive = true);
        insert testProduct;

        ChoixElements.put('EffectiveDate', '2019-04-09T23:00:00.000Z');


        inputMap.put('DRId_Case', testCase.Id);
        inputMap.put('idConsumerAccount', testAccount.Id);
        inputMap.put('ChoixElements', ChoixElements);
        inputMap.put('idPCSA', '1234567890');
        inputMap.put('newPCStatus', 'Accept');
        inputMap.put('Asimple','Oui');
        inputMap.put('Acouple','Non');

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(), Product2Id = testProduct.Id,
            UnitPrice = 100, IsActive = true, UseStandardPrice = false);
        insert standardPrice;


        SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
        service.invokeMethod('createOrderSA', inputMap, outMap, null);
        Order newOrder;
        if (outMap.get('orderSAId') != null) {
            orderId = (Id)outMap.get('orderSAId');
            newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
        }
        System.assertEquals('Draft', newOrder.Status);
        Test.stopTest();
    }
}