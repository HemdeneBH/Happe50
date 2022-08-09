/*
*@author : MTR
*@Description:
*@CreatedDate :
*@LastModified: MHA 13/12/2018
*/
@isTest
public class SM_AP42_CreationOrder_Test {
    
    @testSetup static void dataSetup(){
        User user = SM_TestDataFactory.createUser('ter', 'email@email.com', 'lastName', 'username_Test@username-engie.com', 'System administrator');
        insert user;

        Account testAccount = new Account(Name = 'Test Customer Account');
        insert testAccount;
        
        Case testCase = new Case(AccountId = testAccount.Id);
        insert testCase;
        
        Product2 testProduct = new Product2(
            Name = 'Test',
            FamilyLabel__c = 'Elec Malin 2 ans',
            Family = 'GBUF1C_P',
            IsActive = true
        );
        
        Product2 testProduct1 = new Product2(
            Name = 'Test2',
            FamilyLabel__c = 'Elec Malin 2 ans',
            Family = 'GOPT_VERT_P',
            vlocity_cmt__Type__c = 'Service',
            IsActive = true
        );
        
        List<Product2> testProductList = new List<Product2>();
        testProductList.add(testProduct);
        testProductList.add(testProduct1);
        insert testProductList;

        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProductList.get(0).Id,
            UnitPrice = 100,
            IsActive = true,
            UseStandardPrice = false
        );
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = testProductList.get(1).Id,
            UnitPrice = 100,
            IsActive = true,
            UseStandardPrice = false
        );
        List<PricebookEntry> standardPriceList = new List<PricebookEntry>();
        standardPriceList.add(standardPrice1);
        standardPriceList.add(standardPrice);
        insert standardPriceList;
    }

    @IsTest
    static void createOrderOptionsTest(){
        Id orderId;
        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];
        Product2 testProduct = [Select Id From Product2 Where Name='Test2'];
        Map<String,Object> option = new Map<String,Object>();
        option.put('id', testProduct.id);
        System.runAs(user){
            
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > options = new Map < String, Object >();

            inputMap.put('idConsumerAccount', testAccount.Id);
            inputMap.put('idPropositionCommerciale', '1234567890');
            inputMap.put('status', 'Draft');
            inputMap.put('caseId', testCase.Id);
            inputMap.put('idPack', 'GBUF1C_P');
            inputMap.put('type', 'Gaz');
            inputMap.put('option', option);
            
            Test.startTest();

            SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
            service.invokeMethod('createOrderOptions', inputMap, outMap, null);
            Order newOrder;
            if (outMap.get('orderId') != null) {
                orderId = (Id)outMap.get('orderId');
                newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
            }
            System.assertEquals(orderId, newOrder.Id,'order created');
            Test.stopTest();
        }
        
    }

    /*
    *@author : MTR
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void createOrderTest() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];
        Product2 testProduct = [Select Id From Product2 Where Name='Test2'];
        System.runAs(user){
        Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > offreChoisis = new Map < String, Object >();
            Id orderId;
            
            inputMap.put('vIdConsumerAccount', testAccount.Id);
            inputMap.put('vIdPropositionCommerciale', '1234567890');
            inputMap.put('vNewPCStatus', 'Accept');
            inputMap.put('vCaseId', testCase.Id);
            inputMap.put('vEffectiveDate', '2018-12-03T23:00:00.000Z');
            inputMap.put('vIdPack', 'GBUF1C_P');
            inputMap.put('vEnergyTypeOptions', 'Gaz');
            inputMap.put('vFEL', true);
            inputMap.put('vMens', false);
            inputMap.put('gasOptionChoice', 'Y');
            inputMap.put('koCreationPDLSOpvt', false);
            inputMap.put('vTypeComptage', 'Triple');

            SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
            service.invokeMethod('createOrder', inputMap, outMap, null);
            Test.stopTest();
            System.assertNotEquals(String.valueOf(outMap.get('orderId')), null,'orderId created');
        }
    }
    
    /*
    *@author : MHA
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void createRefusedOrderTest() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];
        System.runAs(user){
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > Recap = new Map < String, Object >();
            Map < String, Object > offreChoisis = new Map < String, Object >();
            Id orderId;
            
            inputMap.put('vIdConsumerAccount', testAccount.Id);
            inputMap.put('vIdPropositionCommerciale', '1234567890');
            inputMap.put('vNewPCStatus', 'Refuse');
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
            System.assertEquals('Refus', newOrder.Status);
            Test.stopTest();
        }
    }
    
    /*
*@author : MHA
*@Description:Test de la création de l'order sans pricebookEntry
*@CreatedDate :
*@LastModified: MHA 07/03/2019
*/
    static testMethod void createOrderTestWithOutPriceBookEntry() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];

        System.runAs(user){
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > offreChoisis = new Map < String, Object >();
            
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
            Test.stopTest();
            System.assertEquals('Draft', newOrder.Status);
        }
    }
    
    /*
    *@author : MHA
    *@Description:Test de la création de l'order sans produit
    *@CreatedDate :
    *@LastModified: MHA 07/03/2019
    */
    static testMethod void createOrderTestWithOutProduct() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];

        System.runAs(user){
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > offreChoisis = new Map < String, Object >();
            Id orderId;
                        
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
            Test.stopTest();
            System.assertEquals('Draft', newOrder.Status);
        }
    }
    
    /*
*@author : MHA
*@Description:
*@CreatedDate :
*@LastModified: MHA 03/01/2019
*/
    static testMethod void errorOnAccountIdFromOmniscript() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];
        
        System.runAs(user){
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > offreChoisis = new Map < String, Object >();
            Id orderId;
            
            choixElements.put('EffectiveDate', '2018-12-03T23:00:00.000Z');
            offreChoisis.put('idPack', 'GBUF1C_P');
            
            
            inputMap.put('DRId_Case', testCase.Id);
            inputMap.put('choixElements', choixElements);
            inputMap.put('idPropositionCommerciale', '1234567890');
            inputMap.put('OffreChoisis', offreChoisis);
            inputMap.put('newPCStatus', 'refuse');
            
            SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
            service.invokeMethod('createOrder', inputMap, outMap, null);
            Order newOrder;
            if (outMap.get('orderId') != null) {
                orderId = (Id)outMap.get('orderId');
                newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
            }
            Test.stopTest();
            System.assertEquals(null, newOrder);
        }
    }
    
    /*
    *@author : MHA
    *@Description: test le cas d'erreur où l'idProposition commerciale n'existe pas et que le statut d'entrée est accepté
    *@CreatedDate : 03/01/2019
    *@LastModified: MHA 03/01/2019
    */
    static testMethod void ErrorAcceptedMethod() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];
        
        System.runAs(user){
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Map < String, Object > recap = new Map < String, Object >();
            Id orderId;
            
            choixElements.put('EffectiveDate', '2018-12-03T23:00:00.000Z');
            recap.put('OffreSouscrite', 'Elec Malin 2 ans');
            
            inputMap.put('DRId_Case', testCase.Id);
            inputMap.put('idConsumerAccount', testAccount.Id);
            inputMap.put('choixElements', choixElements);
            inputMap.put('Recap', recap);
            inputMap.put('newPCStatus', 'Accept');
            
            SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
            service.invokeMethod('createOrder', inputMap, outMap, null);
            Order newOrder;
            if (outMap.get('orderId') != null) {
                orderId = (Id)outMap.get('orderId');
                newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
            }
            Test.stopTest();
            System.assertEquals(null, newOrder);
        }
    }
    
    /*
    *@author : HEL
    *@Description: test de creation d'un order SA
    *@CreatedDate : 09/04/2019
    
    */
    static testMethod void createOrderSATest() {

        User user = [Select Id From User Where UserName='username_Test@username-engie.com'];
        Account testAccount = [Select Id From Account Where Name = 'Test Customer Account'];
        Case testCase = [Select Id From Case Where AccountId=:testAccount.Id];

        System.runAs(user){
            String idConsumerAccount = testAccount.Id;
            Test.startTest();
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
            Map < String, Object > choixElements = new Map < String, Object >();
            Id orderId;
            
            inputMap.put('EffectiveDate', '2019-04-09T23:00:00.000Z');
            inputMap.put('vCaseId', testCase.Id);
            inputMap.put('idConsumerAccount', idConsumerAccount);
            inputMap.put('idPCSA', '1234567890');
            inputMap.put('newPCStatus', 'Accept');
            inputMap.put('Asimple','Oui');
            inputMap.put('Acouple','Non');
            inputMap.put('ChoixAssuranceFacture','Y');
            
            SM_AP42_CreationOrder service = new SM_AP42_CreationOrder();
            service.invokeMethod('createOrderSA', inputMap, outMap, null);
            Order newOrder;

            if (outMap.get('orderSAId') != null) {
                orderId = (Id)outMap.get('orderSAId');
                newOrder = [Select id, OrderNumber, Status from Order Where id = : orderId ];
            }
            Test.stopTest();
            System.assertEquals('Draft', newOrder.Status);
        }
    }
}