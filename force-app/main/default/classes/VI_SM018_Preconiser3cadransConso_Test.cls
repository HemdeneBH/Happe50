/*
*@Author: Paul Ghoussoub
*@Description: Classe de test de VI_SM018_Preconiser3cadransConso du WS Consommation
*@CreatedDate: 26/11/2020
*/
@isTest
public class VI_SM018_Preconiser3cadransConso_Test { 
    @isTest
    public static void test_preconiser3cadrans(){
        VI_SM018_Preconiser3cadransConso.Estimation3Cadrans estimerElecSuccess=VI_SM018_Preconiser3cadransConso.preconiser3cadrans('020', '010', '010', '020', 'VI', '3', 'callout:AuthOctopus');
        system.debug('estimerElecSuccess '+estimerElecSuccess);
        system.AssertEquals(0.22,estimerElecSuccess.cleHC);
        
    }
}