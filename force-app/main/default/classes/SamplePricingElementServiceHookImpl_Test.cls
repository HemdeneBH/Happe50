@isTest//(seeAllData=true)
public class SamplePricingElementServiceHookImpl_Test {
    private static testMethod void testcallPromotionApprovalProcess() {
        //Order orderRecord = TestFactory.testCreateOrder();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = TestFactory.testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem'); 
		system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        Test.startTest();
        SamplePricingElementServiceHookImpl Objectclass = new SamplePricingElementServiceHookImpl();
        Boolean result6 = Objectclass.invokeMethod('priceLineItems.PreInvoke',
                                               new map<String, object>{'parent'=>ord,
                                               'itemList'=>itmelists
                                               },
                                               outPutMap ,
                                               optionsMap );
        
        
        Test.stopTest();
    }
    
    /*
    private static testMethod void testcallPreProcessorInvoke() {
        //Order orderRecord = TestFactory.testCreateOrder();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = TestFactory.testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem'); 
		system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        Test.startTest();
        Vlocity_PreProcessor_Multi Objectclass2 = new Vlocity_PreProcessor_Multi();
        Boolean result7 = Objectclass2.invokeMethod('calculate',
                                               new map<String, object>{'parent'=>ord,
                                               'itemList'=>itmelists
                                               },
                                               outPutMap ,
                                               optionsMap );
        
        
        Test.stopTest();
    }
*/
    
    /*
    private static testMethod void testcallgetAttribute() {
        //Order orderRecord = TestFactory.testCreateOrder();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = TestFactory.testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem'); 
		system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        Test.startTest();
        Vlocity_PreProcessor_Multi Objectclass3 = new Vlocity_PreProcessor_Multi();
        Boolean result5 = Objectclass3.invokeMethod('calculate',
                                               new map<String, object>{'parent'=>ord,
                                               'itemList'=>itmelists
                                               },
                                               outPutMap ,
                                               optionsMap );
        
        
        Test.stopTest();
    }*/
}