/*
*@author : MTR
*@Description:
*@CreatedDate :
*@LastModified: MHA 03/01/2019
*/
global class SM_AP42_CreationOrder implements vlocity_cmt.VlocityOpenInterface {
    /*
    *@author : MTR
    *@Description:
    *@CreatedDate :
    *@@LastModified: MHA 03/01/2019
    */
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        boolean returnValue = false;
        if (methodName.equals('createOrder')) {
            try {
                createOrder(inputMap, outMap, options);
                returnValue = true;
            } catch (Exception e) {
                system.debug(e.getStackTraceString());
            }
        }
        else if (methodName.equals('createOrderSA')){
            try {
                createOrderSA(inputMap, outMap, options);
                returnValue = true;
            } catch (Exception e) {
                system.debug(e.getStackTraceString());
            }
        }

        return returnValue;
    }

    /*
    *@author : MTR
    *@Description:
    *@CreatedDate :
    *@LastModified: MHA 03/01/2019
    */
    //à faire récupérer via la payload les variables
    public static void createOrder(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        system.debug(' SM_AP42 : inputMap : ' + inputMap);
        String consumerAccountID = String.valueof(inputMap.get('vIdConsumerAccount'));

        // String consumerAccountID = '0019E00000ai0UAQAY';
        String idPropositionCommerciale=String.valueof(inputMap.get('vIdPropositionCommerciale'));
        String newPCStatus=String.valueof(inputMap.get('vNewPCStatus'));      
        if('Accept'.equalsIgnoreCase(newPCStatus) && String.isBlank(idPropositionCommerciale)){
            system.debug(' SM_AP42 :  pas d \' idPropositionCommerciale alors que le client a accepté la CPV...');
            return;
        }
        String orderStatus;
        if('refuse'.equalsIgnoreCase(newPCStatus)){
            orderStatus = 'Refus';
        }
        if('Accept'.equalsIgnoreCase(newPCStatus) || 'Reflechis'.equalsIgnoreCase(newPCStatus)){
            orderStatus = 'Draft';
        }
        if (consumerAccountID == null || consumerAccountID.contains('$')) {
            system.debug(' SM_AP42 : Invalid consumerAccountID : ' + consumerAccountID);
            return;
        }
        String effectiveDate = String.valueof(inputMap.get('vEffectiveDate'));
        String energyType = String.valueof(inputMap.get('vEnergyTypeOptions'));
        String idPack=String.valueOf(inputMap.get('vIdPack'));

        // Standard  PriceBook2
        Id standarsPBId = findPriceBookId();

        // Creation Order
        Order newOrder = new Order();
        newOrder.AccountId = consumerAccountID;
        newOrder.EffectiveDate = Date.valueOf(effectiveDate);
        newOrder.Type__c = energyType;
        newOrder.Status = orderStatus;
        // RecordId setting
        Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId();
        newOrder.RecordTypeId = recordTypeId;
        if (idPropositionCommerciale != null) {
            newOrder.Numero_PC__c  = idPropositionCommerciale;
        }
        newOrder.Pricebook2Id = standarsPBId;
        insert newOrder;
        outMap.put('orderId', newOrder.Id);

        
        List<Product2> products = [Select id FROM Product2 WHERE Family = : idPack  and isActive=true];
        system.debug(' SM_AP42 : Products Found : ' + products);
        if (products == null || products.size() == 0) {
            system.debug(' SM_AP42 : No Products found !!!');
            return;
        }

        List<Id> productIds = new List<Id>();
        for (Product2 p : products) {
            productIds.add(String.valueOf(p.Id));
        }

        List<PricebookEntry> priceBookEntryList = [SELECT id, product2Id  FROM PricebookEntry WHERE product2Id IN : productIds ];
        Map<String, String>priceBookEntryMap = new Map<String, String>();
        if (priceBookEntryList.size() == productIds.size()) {
            if (priceBookEntryList.size() == 1) {
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(0).product2Id),String.valueOf(priceBookEntryList.get(0).id));
            } else if(priceBookEntryList.size() == 2){
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(0).product2Id),String.valueOf(priceBookEntryList.get(0).id));
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(1).product2Id),String.valueOf(priceBookEntryList.get(1).id));
            }
        }

        List<OrderItem> orderItemList = new List<OrderItem>();

        for(Id idValue : productIds){
            // Creation OrderItem
            OrderItem newOrderItem = new OrderItem();
            newOrderItem.OrderId = newOrder.Id;
            newOrderItem.Product2Id = idValue;
            if(String.isBlank(String.valueOf(priceBookEntryMap.get(idValue)))){
                //Create a new
                PricebookEntry newPrice = new PricebookEntry();
                newPrice.product2Id = idValue;
                newPrice.UnitPrice = 1;
                newPrice.Pricebook2Id  = standarsPBId;
                insert newPrice;
                newOrderItem.PricebookEntryId = newPrice.Id;
            }else{
                newOrderItem.PricebookEntryId = priceBookEntryMap.get(idValue);
            }
            newOrderItem.Quantity = 1;
            newOrderItem.UnitPrice = 1;

            orderItemList.add(newOrderItem);
        }

        system.debug(' SM_AP42 : OrderItemList size : ' + orderItemList.size());
        insert orderItemList;
        String caseId = String.valueof(inputMap.get('vCaseId'));
        String FEL = String.valueof(inputMap.get('vFEL'));
        String Mens = String.valueof(inputMap.get('vMens'));
        linkOrderToCaseFuture(newOrder.Id ,caseId,FEL,Mens,false);
    }
    
      /* public static void linkOrderToCase(Id OrderId, Map < String, Object > inputMap, boolean isSA){
        String caseId = String.valueof(inputMap.get('vCaseId'));
        System.debug('@@ id of case to update ' +caseId);
        if(!String.isBlank(caseId)){
            Order InsertedOrder = [Select id, OrderNumber, Status from Order Where id = : OrderId];
            system.debug('@@InsertedOrder ' +InsertedOrder.OrderNumber);
            Case caseToUpdate = [Select id,Order_Number_SA__c, Order_Number__c from Case where Id = : caseId];
            if(isSA){
                caseToUpdate.Order_Number_SA__c = InsertedOrder.OrderNumber;    
            }
            else{
                caseToUpdate.Order_Number__c = InsertedOrder.OrderNumber; 
            }
            
            update caseToUpdate;
        }

    }*/
	@future
     public static void linkOrderToCaseFuture(Id OrderId,String caseId,String FEL,String Mens, Boolean isSA){
        //String caseId = String.valueof(inputMap.get('vCaseId'));
        System.debug('@@ id of case to update ' +caseId);
        if(!String.isBlank(caseId)){
            Order InsertedOrder = [Select id, OrderNumber, Status from Order Where id = : OrderId];
            system.debug('@@InsertedOrder ' +InsertedOrder.OrderNumber);
            //get existing case
            Case caseToUpdate = new Case(Id=caseId);
            //[Select id,Order_Number_SA__c, Order_Number__c from Case where Id = : caseId];
            if(isSA){
                caseToUpdate.Order_Number_SA__c = InsertedOrder.OrderNumber;    
            }
            else{
                caseToUpdate.Order_Number__c = InsertedOrder.OrderNumber; 
                if('Oui'.equalsIgnoreCase(FEL)){
                    caseToUpdate.FEL__c=true;
                }
                else{
                    caseToUpdate.FEL__c=false;
                }
                if('Oui'.equalsIgnoreCase(Mens)){
                    caseToUpdate.MENS__c=true;
                }
                else{
                     caseToUpdate.MENS__c=false;
                }
            }
            
            update caseToUpdate;
        }

    }

    /*
    *@author : MHA
    *@Description: Maj du status de l'order après la transformation de la PC en 1ex
    *@CreatedDate : 26/03/2019
    *@LastModified: MHA 26/03/2019
    */
  /* public static void majOrder(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        //MAJ Status Order
        String orderId=String.valueOf(inputMap.get('vOrderId'));
        if(String.isNotBlank(orderId)){
            List<Order> orderList = [Select id, OrderNumber, Status from Order Where id = : orderId];
            if(!orderList.isEmpty()){
                Order orderToUpdate =orderList[0];
                String pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));
                if (pcStatus != null) {
                    if ('refuse'.equalsIgnoreCase(pcStatus)) {
                        orderToUpdate.Status = 'Refus';
                    } else if ('Accept'.equalsIgnoreCase(pcStatus)) {
                        orderToUpdate.Status = 'Activated';
                    }
                }
                update orderToUpdate;
            }
        }
       
    }*/
    @future
     public static void majOrderFuture(String orderId, string pcStatus) {
        //MAJ Status Order
        //String orderId=String.valueOf(inputMap.get('vOrderId'));
        if(String.isNotBlank(orderId)){
            List<Order> orderList = [Select id, OrderNumber, Status from Order Where id = : orderId];
            if(!orderList.isEmpty()){
                Order orderToUpdate =orderList[0];
                //String pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));
                if (pcStatus != null) {
                    if ('refuse'.equalsIgnoreCase(pcStatus)) {
                        orderToUpdate.Status = 'Refus';
                    } else if ('Accept'.equalsIgnoreCase(pcStatus)) {
                        orderToUpdate.Status = 'Activated';
                    }
                }
                update orderToUpdate;
            }
        }
       
    }
        
    
    
    /*
    *@Author : HEL
    *@Description: Creation d'une commande Service Affinitaire
	*@Project: Smile
    *@CreatedDate :HEL 01/04/2019
    */
    public static void createOrderSA(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String consumerAccountID = String.valueof(inputMap.get('idConsumerAccount'));

        String idPropositionCommercialeSA;
		String orderStatus;


        if (String.valueof(inputMap.get('idPCSA')) != null ) {
            idPropositionCommercialeSA = String.valueof(inputMap.get('idPCSA'));
        }
        if(String.valueOf(inputMap.get('newPCStatus')) == 'refuse'){
            orderStatus = 'Refus';
        }
        if(String.valueOf(inputMap.get('newPCStatus')) == 'Accept'){
            orderStatus = 'Draft';
        }


        if (consumerAccountID == null || consumerAccountID.contains('$')) {
            system.debug(' SM_AP42 : Invalid consumerAccountID : ' + consumerAccountID);
            return;
        }

        Map < String, Object > choixElements = (Map < String, Object > ) inputMap.get('ChoixElements');
        String effectiveDate = String.valueof(choixElements.get('EffectiveDate'));
        system.debug(' SM_AP42 : effectiveDate : ' + effectiveDate);
        



        String idPack;
		String serviceAffinitaireChoisi;
        
		String factureSimple = String.valueOf(inputMap.get('Asimple'));
		String factureCouple = String.valueOf(inputMap.get('Acouple'));
		
		if('Oui'.equals(factureSimple)){
			idPack = 'PREV_FACT_P';
			serviceAffinitaireChoisi='Service';
		}
		else if('Oui'.equals(factureCouple)){
			idPack = 'PREV_FACTC_P';
			serviceAffinitaireChoisi='Service Duo';
		}
        
        if(String.isBlank(idPack)){
            System.debug('SM_AP42 : Pas de service affinitaire souscrite');
            return;
        }   
        // Standard  PriceBook2
        Id standarsPBId =  findPriceBookId();
        // Creation Order
        Order newOrder = new Order();
        
        // RecordId setting
        Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId();
        newOrder.RecordTypeId = recordTypeId;
        
        
        newOrder.AccountId = consumerAccountID;
        newOrder.EffectiveDate = Date.valueOf(effectiveDate);
        newOrder.Type__c = serviceAffinitaireChoisi;     
        newOrder.Status = orderStatus;
		
        if (!String.isBlank(idPropositionCommercialeSA)) {
            newOrder.Numero_PC_SA__c  = idPropositionCommercialeSA;
        }
        newOrder.Pricebook2Id = standarsPBId;
        insert newOrder;
		
        outMap.put('orderSAId', newOrder.Id);

        List<Product2> products = [Select id FROM Product2 WHERE Family = : idPack ];
        system.debug(' SM_AP42 : Products Found : ' + products);
        if (products == null || products.size() == 0) {
            system.debug(' SM_AP42 : No Products found !!!');
            return;
        }

        List<Id> productIds = new List<Id>();
        for (Product2 p : products) {
            productIds.add(String.valueOf(p.Id));
        }

        List<PricebookEntry> priceBookEntryList = [SELECT id, product2Id  FROM PricebookEntry WHERE product2Id IN : productIds ];
        Map<String, String>priceBookEntryMap = new Map<String, String>();
        if (priceBookEntryList.size() == productIds.size()) {
            if (priceBookEntryList.size() == 1) {
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(0).product2Id),String.valueOf(priceBookEntryList.get(0).id));
            } else if(priceBookEntryList.size() == 2){
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(0).product2Id),String.valueOf(priceBookEntryList.get(0).id));
                priceBookEntryMap.put(String.valueOf(priceBookEntryList.get(1).product2Id),String.valueOf(priceBookEntryList.get(1).id));
            }
        }

        List<OrderItem> orderItemList = new List<OrderItem>();

        for(Id idValue : productIds){
            // Creation OrderItem
            OrderItem newOrderItem = new OrderItem();
            newOrderItem.OrderId = newOrder.Id;
            newOrderItem.Product2Id = idValue;
            if(String.isBlank(String.valueOf(priceBookEntryMap.get(idValue)))){
                //Create a new
                PricebookEntry newPrice = new PricebookEntry();
                newPrice.product2Id = idValue;
                newPrice.UnitPrice = 1;
                newPrice.Pricebook2Id  = standarsPBId;
                insert newPrice;
                newOrderItem.PricebookEntryId = newPrice.Id;
            }else{
                newOrderItem.PricebookEntryId = priceBookEntryMap.get(idValue);
            }
            newOrderItem.Quantity = 1;
            newOrderItem.UnitPrice = 1;

            orderItemList.add(newOrderItem);
        }

        system.debug(' SM_AP42 : OrderItemList size : ' + orderItemList.size());
        insert orderItemList;
        String caseId = String.valueof(inputMap.get('vCaseId'));
        linkOrderToCaseFuture(newOrder.Id ,caseId,null,null,true);
        
    }
   

	private static Id findPriceBookId(){
		
		// Standard  PriceBook2
        Id standarsPBId;
        if (Test.isRunningTest()) {
            standarsPBId = Test.getStandardPricebookId();
        } else {
            List<PriceBook2> standarsPB = [select id , name from PriceBook2 where IsActive = true and IsStandard = true];
            if (standarsPB == null || standarsPB.size() == 0) {
                system.debug(' SM_AP42 : No Standard  PriceBook2 found !!!');
                throw new OrderException('Unexcpected exception : No Standard  PriceBook2 found');
            } else {
                standarsPBId = standarsPB.get(0).Id;
            }
        }
		return standarsPBId;
	}
	
	private class OrderException extends Exception {}
	
	
}