/*
* @Author: Ibrahim Merabti
* @Date: 27/05/2020
* @LastmodifiedDate  : 08-07-2022
* @Lastmodifiedby    : Olivier MADRE
* @Description: Test Class 
*/

@isTest
public class SM_HarmonicaDisplayContactInfos_TEST {
    /**
     * @author Unknow
     * @date 11/10/2021
     * @description create data for test class
     * @return Data
     */
    @testSetup 
    static void setup() {        
        // create Account
        Account Acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        Insert acc;
        // Create Case
        Case harmonicaCase = SM_TestDataFactory.createCase('TEST', Acc.Id);
        insert harmonicaCase;        
        // Create donneé vente
        Donnees_Vente__c dv = SM_TestDataFactory.createDonneeVente(harmonicaCase.Id,'Cergy','ABCD','52','Avenue des loups', '95800');
        insert dv;

    }

    /**
     * @author Unknow
     * @date 11/10/2021
     * @description test method getDataClient
     * @lastmodifiedDate  : 08-07-2022
     * @lastmodifiedby    : Olivier MADRE 
     * @return void
     */
    @isTest 
    public static void testSM_HarmonicaDisplayContactInfos(){
        // retrieve the case 
        Case harmonicaCase = [select Id from Case where Subject = 'TEST'];
        TEST.startTest();
        String dataClient = SM_HarmonicaDisplayContactInfos.getDataClient(harmonicaCase.Id);
        TEST.stopTest();
        System.assertNotEquals(null, dataClient);
    }       
}