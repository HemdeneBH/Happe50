/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-05-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
@isTest
public with sharing class HP_VF_MaintenancePageController_TEST {
    @isTest
    public static void maintenanceControllerTest(){
        Test.StartTest(); 
        PageReference maintenancePage = Page.HP_EC_maintenancePage; 
        Test.setCurrentPage(maintenancePage);
        HP_VF_MaintenancePageController maintenancePageController = new HP_VF_MaintenancePageController();
        Test.StopTest();  
    }
}