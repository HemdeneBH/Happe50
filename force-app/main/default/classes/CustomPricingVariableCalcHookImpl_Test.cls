@isTest//(seeAllData = true)
public class CustomPricingVariableCalcHookImpl_Test {
    
    public static Map<String, Object> testCreateOrderWithProducts() {
        Id pricebookId = Test.getStandardPricebookId();        
        Account acc = new Account(name='EngieTest');
        insert acc;
        
		Order ord = new Order(AccountId = acc.id,vlocity_cmt__Phone__c='0523400003',Status = 'Draft',EffectiveDate = Date.today(),Pricebook2Id = pricebookId);
        insert ord;
        
        vlocity_cmt__ObjectClass__c objType = new vlocity_cmt__ObjectClass__c(Name = 'OT - Panneau',vlocity_cmt__IsActive__c = true,vlocity_cmt__ObjectApiName__c = 'Product2');
        insert objType;
        
        Product2 prod = new Product2(Name = 'Panneau',ProductCode = 'MyPower_011',isActive = true,vlocity_cmt__ObjectTypeId__c = objType.Id);
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);
        insert pbEntry;
        
        OrderItem oli = new OrderItem(OrderId = ord.Id,Quantity = 5,Product2Id = prod.Id,PricebookEntryId = pbEntry.Id,UnitPrice = 100.00,vlocity_cmt__OneTimeCalculatedPrice__c = 100.00,vlocity_cmt__OneTimeCharge__c = 100.00);
        insert oli;
        
        Map<String, Object> dynMap = new Map<String, Object>();
        dynMap.put('Order',ord);
        dynMap.put('OrderItem',oli);
        dynMap.put('ProceBookEntry',pbEntry);
        
        return dynMap;
    }
    private static testMethod void testcallcalculatePreInvoke() {
        //Order orderRecord = TestFactory.testCreateOrder();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem');
		system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        
             
        Test.startTest();
        CustomPricingVariableCalcHookImpl objclass1 = new CustomPricingVariableCalcHookImpl();
          
        Boolean result = objclass1.invokeMethod('calculate.PreInvoke',new map<String, object>{'parent'=>ord,
                                               'itemList'=>itmelists
                                               },new map<String, object>{'parent'=>ord,
                                                   'itemList'=>itmelists},optionsMap);
        
		Test.stopTest();
    }
    
    private static testMethod void testcallcalculatePostInvoke() {

        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<string, object> innerMap = new Map<string, object>();
        	innerMap.put('OT_TAX1_CALC',120.20);
        	innerMap.put('OT_STD_PRC_TOTAL',200.20);
            innerMap.put('ROLLUP_OT_TAX2_AMT',320.20);
        	innerMap.put('OT_TAX2',320.20);
        	outPutMap.put('pricingVariableMap',innerMap);
        
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem'); 
		system.debug('ordItem::'+ordItem); 
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        Test.startTest();
        
        CustomPricingVariableCalcHookImpl objclass2 = new CustomPricingVariableCalcHookImpl();
        
        Boolean result = objclass2.invokeMethod('calculate.PostInvoke',new map<String, object>{'parent'=>ord,
                                               'itemList'=>itmelists,'isRoot'=>true},outPutMap,optionsMap);
        Test.stopTest();
    }
}