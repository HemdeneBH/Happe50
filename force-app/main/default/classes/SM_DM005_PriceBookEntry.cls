/**
 * @description       : DM Class for Product2 Object
 * @author            : Mohamed Aamer
 * @last modified on  : 02-09-2022
 * @last modified by  : Mohamed Aamer
**/
public with sharing class SM_DM005_PriceBookEntry {

    public static List<PricebookEntry> retrieveByProductIds(final Set<String> productIds){
        List<PricebookEntry> priceBookEntries = [
            SELECT Id, product2Id
            FROM PricebookEntry
            WHERE product2Id IN :productIds
        ];
        return priceBookEntries;
    }
}