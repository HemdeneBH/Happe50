/**
 * @author Sutharsan Pushparajah
 * @date 28/06/2022
 * @description Test class for SM_SM103_XdataImportHandler
 */
@isTest
private class SM_SM103_XdataImportHandler_TEST {
   
    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateAccountBeforeInsert(){

        Boolean isError = false;

        Test.startTest();

        try {
            SM_SM103_XdataImportHandler.validateAccountBeforeInsert(null);
        } catch (Exception exp){
            isError = true;
        }

        System.assertEquals(false, isError);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateAccountBeforeUpdate(){

        Boolean isError = false;

        Test.startTest();

        try {
            SM_SM103_XdataImportHandler.validateAccountBeforeUpdate(null, null);
        } catch (Exception exp){
            isError = true;
        }

        System.assertEquals(false, isError);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateContactBeforeInsert(){

        Boolean isError = false;

        Test.startTest();

        try {
            SM_SM103_XdataImportHandler.validateContactBeforeInsert(null);
        } catch (Exception exp){
            isError = true;
        }

        System.assertEquals(false, isError);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateContactBeforeUpdate(){

        Boolean isError = false;

        Test.startTest();

        try {
            SM_SM103_XdataImportHandler.validateContactBeforeUpdate(null, null);
        } catch (Exception exp){
            isError = true;
        }

        System.assertEquals(false, isError);

        Test.stopTest();
    }

    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateAccount(){

        Account newAcc = new Account();
        Account oldAcc = new Account();
        
        Test.startTest();

        SM_SM103_XdataImportHandler.validateAccount(null, newAcc);

        System.assertEquals('AC_TECHNIQUE', newAcc.Name);
        System.assertNotEquals(null, newAcc.RecordTypeId);
        System.assertEquals('No_Compte_contrat__c is mandatory', newAcc.getErrors().get(0).message);

        oldAcc.Name = 'AC_TECHNIQUE';
        oldAcc.recordTypeId = newAcc.RecordTypeId;
        newAcc.Name = null;
        newAcc.RecordTypeId = null;
        newAcc.No_Compte_contrat__c = '1234';
        newAcc.ID_Local__c = 0;

        SM_SM103_XdataImportHandler.validateAccount(oldAcc, newAcc);

        System.assertEquals('ID_Local__c must be different from 0', newAcc.getErrors().get(0).message);
        System.assertEquals('AC_TECHNIQUE', newAcc.Name);
        System.assertNotEquals(null, newAcc.RecordTypeId);

        Test.stopTest();

    }

    /**
     * @author Sutharsan Pushparajah
     * @date 28/06/2022
     * @description testing mandatory fields
     */
    @isTest
    private static void testValidateContact(){

        Contact newCt = new Contact();
        Contact oldCt = new Contact();
        
        Test.startTest();

        SM_SM103_XdataImportHandler.validateContact(null, newCt);

        System.assertEquals('CT_TECHNIQUE', newCt.LastName);
        System.assertNotEquals(null, newCt.RecordTypeId);
       
        oldCt.LastName = 'CT_TECHNIQUE';
        oldCt.recordTypeId = newCt.RecordTypeId;
        newCt.LastName = null;
        newCt.RecordTypeId = null;
        newCt.Email = 'test';

        SM_SM103_XdataImportHandler.validateContact(oldCt, newCt);

        System.assertEquals('Email address is not valid : test', newct.getErrors().get(0).message);
        System.assertEquals('CT_TECHNIQUE', newCt.LastName);
        System.assertNotEquals(null, newCt.RecordTypeId);

        newCt.Email = null;
        newCt.Adresse_Mail_2__c = 'test';

        SM_SM103_XdataImportHandler.validateContact(oldCt, newCt);

        System.assertEquals('Adresse_Mail_2__c address is not valid : test', newct.getErrors().get(0).message);

        newCt.Adresse_Mail_2__c = null;
        newCt.Adresse_Mail_3__c = 'test';

        SM_SM103_XdataImportHandler.validateContact(oldCt, newCt);

        System.assertEquals('Adresse_Mail_3__c address is not valid : test', newct.getErrors().get(0).message);

        newCt.Adresse_Mail_3__c = null;
        newCt.Adresse_Mail_de_l_espace_client__c = 'test';

        SM_SM103_XdataImportHandler.validateContact(oldCt, newCt);

        System.assertEquals('Adresse_Mail_de_l_espace_client__c address is not valid : test', newct.getErrors().get(0).message);

        Test.stopTest();

    }


}