/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-24-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_EC_PaymentRedirection_TEST {
    
    @isTest
    public static void testPaymentRedirection(){
        Test.startTest();
        Pagereference myPage = Page.HP_EC_PaymentConfirmation;
        Test.setCurrentPage(myPage);
        HP_EC_PaymentRedirection paymentRedirection = new HP_EC_PaymentRedirection();
        paymentRedirection.urlRedirection();
        Test.stopTest();
    }
}