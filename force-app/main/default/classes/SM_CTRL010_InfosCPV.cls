/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 02-08-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_CTRL010_InfosCPV {

    @AuraEnabled(cacheable=true)
    public static List<OrderItem> getCaseOrders (Id caseId){
        List<OrderItem> orderItems = SM_DM002_OrderItem.retrieveOrdersByCaseId(caseId);
        System.debug('orderItems: '+orderItems);
        return orderItems;
    }
}