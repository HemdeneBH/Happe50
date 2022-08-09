/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_DM002_OrderItem {
    
    public static List<OrderItem> retrieveOrdersByCaseId(final String caseId){
        
        System.debug('caseId: '+caseId);
        List<OrderItem> orderItems = [ 
            SELECT OrderId,PricebookEntry.Product2.Name
            FROM OrderItem 
            WHERE OrderId IN (
                SELECT Id
                FROM Order
                WHERE Case__c =:caseId
                AND Status != 'Refus'
            )];
        return orderItems;
    }
}