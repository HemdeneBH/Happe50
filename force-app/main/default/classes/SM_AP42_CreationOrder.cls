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
                system.debug('### eror message create order ' + e.getStackTraceString());
                system.debug('### eror message create order ' + e.getMessage());
            }
        }
        else if (methodName.equals('createOrderSA')){
            try {
                createOrderSA(inputMap, outMap, options);
                returnValue = true;
            } catch (Exception e) {
                system.debug('### error createOrderSA ' + e.getMessage());
            }
        }
        else if (methodName.equals('createOrderOptions')){
            try {
                createOrderOptions(inputMap, outMap, options);
                returnValue = true;
            } catch (Exception e) {
                system.debug('### error createOrderOptions ' + e.getMessage());
            }
        }
        
        return returnValue;
    }

    /**
    * @description Création de l'order, l'objet porteur de la CPV avec le statut Brouillon
    * @author Mohamed Aamer | 02-09-2022 
    * @param inputMap 
    * @param outMap 
    * @param options 
    **/
    public static void createOrderOptions(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String caseId = String.valueof(inputMap.get('caseId'));
        String idConsumerAccount = String.valueof(inputMap.get('idConsumerAccount'));
        String idPropositionCommerciale = String.valueof(inputMap.get('idPropositionCommerciale'));
        String type = String.valueOf(inputMap.get('type'));
        String orderStatus = String.valueof(inputMap.get('status'));  
        String idPack = String.valueOf(inputMap.get('idPack'));
        Map<String, Object> option= (Map<String, Object>)inputMap.get('option');
        String productId = String.valueOf(option.get('id'));
        Set<String> packIds = new Set<String>{idPack};
        Set<String> productIds = new Set<String>{productId};
        List<OrderItem> orderItems = new List<OrderItem>();
        List<Order> orders = new List<Order>();
        Map<String, PricebookEntry> priceBookEntryMap = new Map<String, PricebookEntry>();

        Id standarsPBId = findPriceBookId();
        Id orderRT = Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId();

        List<PricebookEntry> priceBookEntries = SM_DM005_PriceBookEntry.retrieveByProductIds(productIds);
        PricebookEntry priceBookEntry = priceBookEntries[0];

        Order newOrder = new Order();
        newOrder.AccountId = idConsumerAccount;
        newOrder.EffectiveDate = Date.today();
        newOrder.Type__c = type;
        newOrder.Status = orderStatus;
        newOrder.Case__c = caseId;
        newOrder.RecordTypeId = orderRT;
        newOrder.Numero_PC__c  = idPropositionCommerciale;
        newOrder.Pricebook2Id = standarsPBId;
        insert newOrder;  

        createOrderItem(newOrder.Id,productId,pricebookEntry.Id);

        outMap.put('orderId', newOrder.Id);
    }
    
    /*
*@author : MTR
*@Description:
*@CreatedDate :
*@LastModified: MHA 03/01/2019
*/
    //à faire récupérer via la payload les variables
    public static void createOrder(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        // Get info from inputMap
        String consumerAccountID = String.valueof(inputMap.get('vIdConsumerAccount'));
        String typeComptage = String.valueOf(inputMap.get('vTypeComptage'));
        String idPropositionCommerciale = String.valueof(inputMap.get('vIdPropositionCommerciale'));
        String newPCStatus = String.valueof(inputMap.get('vNewPCStatus'));  
        System.debug('# aka a newPCStatus ' + newPCStatus );
       // String effectiveDate = String.valueof(inputMap.get('vEffectiveDate'));
        String energyType = String.valueof(inputMap.get('vEnergyTypeOptions'));
        String idPack = String.valueOf(inputMap.get('vIdPack'));
        String caseId = String.valueof(inputMap.get('vCaseId'));
        String FEL = String.valueof(inputMap.get('vFEL'));
        String Mens = String.valueof(inputMap.get('vMens'));
        
        List<OrderItem> orderItemList = new List<OrderItem>();
        List<Product2> listProducts = new List<Product2>();
        List<String> listStrucMesFour = new List<String>();
        Map<String, PricebookEntry> priceBookEntryMap = new Map<String, PricebookEntry>();
        String orderStatus = '';
        
        System.debug('### aka typeComptage ' + typeComptage);
        List<SM_TranscoTypeComptageStrucMesFour__mdt> listTrascoTypeCompt = [SELECT StructureMesureFournisseur__c 
                                                                             FROM SM_TranscoTypeComptageStrucMesFour__mdt 
                                                                             WHERE TypeComptage__c = :typeComptage];
        
        
        for(SM_TranscoTypeComptageStrucMesFour__mdt transco : listTrascoTypeCompt){
            listStrucMesFour.add(transco.StructureMesureFournisseur__c);
        }
        
        if('Accept'.equalsIgnoreCase(newPCStatus) && String.isBlank(idPropositionCommerciale)){
            system.debug(' SM_AP42 :  pas d \' idPropositionCommerciale alors que le client a accepté la CPV...');
            return;
        }
        
        if('refuse'.equalsIgnoreCase(newPCStatus)){
            orderStatus = 'Refus';
        }
        if('Accept'.equalsIgnoreCase(newPCStatus) || 'Reflechis'.equalsIgnoreCase(newPCStatus) || 'dejaAccept'.equalsIgnoreCase(newPCStatus)){
            orderStatus = 'Draft';
        }
        if (consumerAccountID == null || consumerAccountID.contains('$')) {
            system.debug(' SM_AP42 : Invalid consumerAccountID : ' + consumerAccountID);
            return;
        }
        
        // Standard  PriceBook2
        Id standarsPBId = findPriceBookId();
        
        // Creation Order
        Order newOrder = new Order();
        newOrder.AccountId = consumerAccountID;
        newOrder.EffectiveDate = Date.today();
        newOrder.Type__c = energyType;
        newOrder.Status = orderStatus;
        newOrder.Case__c = caseId;
        // RecordId setting
        Id recordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('SMILE').getRecordTypeId();
        newOrder.RecordTypeId = recordTypeId;
        if (idPropositionCommerciale != null) {
            newOrder.Numero_PC__c  = idPropositionCommerciale;
        }
        newOrder.Pricebook2Id = standarsPBId;
        insert newOrder;
        outMap.put('orderId', newOrder.Id);
        // if Dual or Elec
        if(listStrucMesFour.size() > 0){// Dual ou Elec
            listProducts = [SELECT id, TypeOffre__c,FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                            FROM Product2
                            WHERE  vlocity_cmt__Type__c = :energyType 
                            AND IsActive = true 
                            AND Family = :idPack
                            AND SM_structureMesureFournisseur__c = :listStrucMesFour];
            
            if(energyType == 'Duo' && listProducts.size()>0){
                listProducts = [SELECT id,TypeOffre__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                                FROM Product2
                                WHERE  vlocity_cmt__Type__c = : energyType
                                AND IsActive = true 
                                AND Family = :idPack
                                AND (SM_structureMesureFournisseur__c = :listStrucMesFour OR SM_structureMesureFournisseur__c = null)];
                
            }
        }
        else{// Gaz il n'y a pas de structure mesure fournisseur
            listProducts = [SELECT id,TypeOffre__c, FamilyLabel__c,SM_structureMesureFournisseur__c, Family, ProductCode, vlocity_cmt__SpecificationType__c, ArticleURL__c, ArticlePreview__c
                            FROM Product2
                            WHERE  vlocity_cmt__Type__c = : energyType 
                            AND IsActive = true
                            AND Family = : idPack];
        }
    
        // Ajout de produits options vertes
        Boolean koCreationPDLSOpvt = inputMap.get('koCreationPDLSOpvt') != null && inputMap.get('koCreationPDLSOpvt') != '' && inputMap.get('koCreationPDLSOpvt') != ' ' ? Boolean.valueOf(inputMap.get('koCreationPDLSOpvt')) : null;
        String elecOptionChoice = inputMap.get('elecOptionChoice') != null && inputMap.get('elecOptionChoice') != '' && inputMap.get('elecOptionChoice') != ' ' ? String.valueOf(inputMap.get('elecOptionChoice')) : null;
        String gasOptionChoice = inputMap.get('gasOptionChoice') != null && inputMap.get('gasOptionChoice') != '' && inputMap.get('gasOptionChoice') != ' ' ? String.valueOf(inputMap.get('gasOptionChoice')) : null;
        
        if(koCreationPDLSOpvt == false && (elecOptionChoice == 'Y' || gasOptionChoice == 'Y')){
            
            List<String> familiesOpv = new List<String>();
            
            if(elecOptionChoice == 'Y'){
                familiesOpv.add('EFOPT_VERT_P');
            }
            
            if(gasOptionChoice == 'Y'){
                familiesOpv.add('GOPT_VERT_P');
            }
            
            // field?
            List<Product2> productsOpv = [SELECT Id FROM Product2 WHERE Family IN :familiesOpv AND vlocity_cmt__Type__c = 'Service' AND IsActive = true];
            
            if(productsOpv.size() > 0){
                listProducts.addAll(productsOpv);
            }
            
        }
        
        system.debug(' SM_AP42 : Products Found : ' + listProducts);
        if (listProducts == null || listProducts.size() == 0) {
            system.debug(' SM_AP42 : No Products found !!!');
            return;
        }
        
        
        List<PricebookEntry> priceBookEntryList = [SELECT id, product2Id  
                                                   FROM PricebookEntry 
                                                   WHERE product2Id IN :listProducts];
        
        system.debug(' SM_AP42 : priceBookEntryList : ' + priceBookEntryList);
        
            for(PricebookEntry pricebookEntry : priceBookEntryList){
                priceBookEntryMap.put(pricebookEntry.Product2Id, pricebookEntry);
            }
        
        system.debug(' SM_AP42 : priceBookEntryMap : ' + priceBookEntryMap);
        
        
        for(Product2 product : listProducts){
            // Creation OrderItem
            if(!priceBookEntryMap.containsKey(product.Id)){
                PricebookEntry newPrice = new PricebookEntry();
                newPrice.product2Id = product.Id;
                newPrice.UnitPrice = 1;
                newPrice.Pricebook2Id  = standarsPBId;  
                priceBookEntryMap.put(product.Id, newPrice);
            }
        }
        upsert priceBookEntryMap.values();
        
        for(Product2 product : listProducts){
            OrderItem newOrderItem = new OrderItem();
                newOrderItem.OrderId = newOrder.Id;
                newOrderItem.Product2Id = product.Id;
                newOrderItem.Quantity = 1;
                newOrderItem.UnitPrice = 1;
                newOrderItem.PricebookEntryId = priceBookEntryMap.get(product.Id).Id;
                orderItemList.add(newOrderItem);
        }
        system.debug(' SM_AP42 : OrderItemList size : ' + orderItemList.size());
        insert orderItemList;
       
        // Future Action
        linkOrderToCaseFuture(newOrder.Id ,caseId,FEL,Mens,false);
    }

    @future
    public static void createOrderItem(Id orderId, Id productId, Id pricebookEntryId) {
        OrderItem newOrderItem = new OrderItem();
        newOrderItem.OrderId = orderId;
        newOrderItem.Product2Id = productId;
        newOrderItem.Quantity = 1;
        newOrderItem.UnitPrice = 1;
        newOrderItem.PricebookEntryId = pricebookEntryId;
        insert newOrderItem;
    }
    
    @future
    public static void linkOrderToCaseFuture(Id OrderId,String caseId,String FEL,String Mens, Boolean isSA){
       // String caseId = String.valueof(inputMap.get('vCaseId'));
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
        System.debug('orderId: '+orderId);
        System.debug('pcStatus: '+pcStatus);
        //MAJ Status Order
        //String orderId=String.valueOf(inputMap.get('vOrderId'));
        if(String.isNotBlank(orderId)){
            Order orderToUpdate = new Order();
           orderToUpdate = [Select id, OrderNumber, Status from Order Where id = : orderId];
            System.debug('orderToUpdate: '+orderToUpdate);
            if(orderToUpdate != null){
                //String pcStatus =String.valueOf(inputMap.get('vNewPCStatus'));
                if (pcStatus != null) {
                    System.debug('pcStatus: '+pcStatus);
                    if ('refuse'.equalsIgnoreCase(pcStatus)) {
                        orderToUpdate.Status = 'Refus';
                    } else if ('Accept'.equalsIgnoreCase(pcStatus) || 'dejaAccept'.equalsIgnoreCase(pcStatus)) {
                        System.debug('update Order');
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
        String choixAssuranceFacture = String.valueof(inputMap.get('ChoixAssuranceFacture'));
        String idPropositionCommercialeSA = String.valueof(inputMap.get('idPCSA'));
       // String effectiveDate = String.valueof(inputMap.get('EffectiveDate'));
        String factureSimple = String.valueOf(inputMap.get('Asimple'));
        String factureCouple = String.valueOf(inputMap.get('Acouple'));
        String caseId = String.valueof(inputMap.get('vCaseId'));
        String orderStatus;
        String idPack;
        String serviceAffinitaireChoisi;
        
        if(String.valueOf(choixAssuranceFacture) == 'N'){
            orderStatus = 'Refus';
        }
        else{
            orderStatus = 'Draft';
        }
          SYstem.debug('#### aka consumerAccountID ' + consumerAccountID);
        
        if (consumerAccountID == null || consumerAccountID.contains('$')) {
            system.debug(' SM_AP42 : Invalid consumerAccountID : ' + consumerAccountID);
            return;
        }
        
      
        
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
        newOrder.EffectiveDate = Date.today();
        newOrder.Type__c = serviceAffinitaireChoisi;     
        newOrder.Status = orderStatus;
        
        if (!String.isBlank(idPropositionCommercialeSA)) {
            newOrder.Numero_PC_SA__c  = idPropositionCommercialeSA;
        }
        newOrder.Pricebook2Id = standarsPBId;
        insert newOrder;
        
        outMap.put('orderSAId', newOrder.Id);
        
        List<Product2> listProducts = [Select id FROM Product2 WHERE Family = : idPack ];
        system.debug(' SM_AP42 : Products Found : ' + listProducts );
        if (listProducts == null || listProducts .size() == 0) {
            system.debug(' SM_AP42 : No Products found !!!');
            return;
        }
         
        List<PricebookEntry> priceBookEntryList = [SELECT id, product2Id  
                                                   FROM PricebookEntry 
                                                   WHERE product2Id IN :listProducts];
        
        system.debug(' SM_AP42 : priceBookEntryList : ' + priceBookEntryList);
          Map<String, PricebookEntry> priceBookEntryMap = new Map<String, PricebookEntry>();
          List<OrderItem> orderItemList = new List<OrderItem>();
            for(PricebookEntry pricebookEntry : priceBookEntryList){
                priceBookEntryMap.put(pricebookEntry.Product2Id, pricebookEntry);
            }
        
        system.debug(' SM_AP42 : priceBookEntryMap : ' + priceBookEntryMap);
        
        
        for(Product2 product : listProducts){
            // Creation OrderItem
            if(!priceBookEntryMap.containsKey(product.Id)){
                PricebookEntry newPrice = new PricebookEntry();
                newPrice.product2Id = product.Id;
                newPrice.UnitPrice = 1;
                newPrice.Pricebook2Id  = standarsPBId;  
                priceBookEntryMap.put(product.Id, newPrice);
            }
        }
        upsert priceBookEntryMap.values();
        
        for(Product2 product : listProducts){
            OrderItem newOrderItem = new OrderItem();
                newOrderItem.OrderId = newOrder.Id;
                newOrderItem.Product2Id = product.Id;
                newOrderItem.Quantity = 1;
                newOrderItem.UnitPrice = 1;
                newOrderItem.PricebookEntryId = priceBookEntryMap.get(product.Id).Id;
                orderItemList.add(newOrderItem);
        }
        system.debug(' SM_AP42 : OrderItemList size : ' + orderItemList.size());
        insert orderItemList;
        System.debug('### aka caseId ' + caseId);
        linkOrderToCaseFuture(newOrder.Id ,caseId,null,null,true);
        
    }
    
    
    private static Id findPriceBookId(){
        
        // Standard  PriceBook2
        Id standarsPBId;
        if (Test.isRunningTest()) {
            standarsPBId = Test.getStandardPricebookId();
        } else {List<PriceBook2> standarsPB = [select id , name from PriceBook2 where IsActive = true and IsStandard = true]; if (standarsPB == null || standarsPB.size() == 0) { system.debug(' SM_AP42 : No Standard  PriceBook2 found !!!');throw new OrderException('Unexcpected exception : No Standard  PriceBook2 found');} else {standarsPBId = standarsPB.get(0).Id;
            }
        }
        return standarsPBId;
    }
    
    private class OrderException extends Exception {}
    
    
}