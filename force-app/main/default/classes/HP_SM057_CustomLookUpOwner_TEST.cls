/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-19-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-19-2021   Slimene Belhaj Ali   Initial Version
**/
@IsTest
public with sharing class HP_SM057_CustomLookUpOwner_TEST {
    @IsTest
    public static void fetchLookUpValues_TEST() {
        Test.startTest();
        HP_SM057_CustomLookUpOwner.fetchLookUpValues('a', 'User');
        HP_SM057_CustomLookUpOwner.fetchLookUpValues('c', 'Group');
        Test.stopTest();
    }
}