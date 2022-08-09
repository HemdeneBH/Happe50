/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-09-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
public with sharing class HP_SM074_CheckWithinBusinessHours_TEST {
    
    @isTest     
    public static void CheckWithinBusinessHours_TEST() {
        List<String> listNames =new List<String>() ;
        listNames.add('HP');
        HP_SM074_CheckWithinBusinessHours.CheckWithinBusinessHours(listNames);
    }
}