/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM017_PreconiserRepartitionHPHCConso.
*@CreatedDate: 26/11/2020
*@LastModified: 26/11/2020 
*/
@isTest
public class VI_SM017_PrecoRepartitionHPHCConso_Test {
    
    @isTest
    public static void test_PrecoRepartitionHPHCConso(){
        
        VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC PrecoRepartitionHPHCConso_success = VI_SM017_PreconiserRepartitionHPHCConso.getRepartitionHPHC('020', '010', '010', '020', 'VI', '3', 'callout:AuthOctopus');
        
        System.assertEquals(0.32, PrecoRepartitionHPHCConso_success.cleRepartitionHC);
        System.assertEquals(0.68, PrecoRepartitionHPHCConso_success.cleRepartitionHP);
        VI_SM017_PreconiserRepartitionHPHCConso.EstimationHPHC PrecoRepartitionHPHCConso_erreur = VI_SM017_PreconiserRepartitionHPHCConso.getRepartitionHPHC('', '', '', '', 'VI', '3', 'callout:AuthOctopus');
        System.assertEquals(0.0, PrecoRepartitionHPHCConso_erreur.cleRepartitionHC);
        System.assertEquals(0.0, PrecoRepartitionHPHCConso_erreur.cleRepartitionHP);
    }

}