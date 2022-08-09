/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM020_EstimerElecConsommation.
*@CreatedDate: 26/11/2020
*@LastModified: 26/11/2020
*/
@isTest
public class VI_SM020_EstimerElecConsommation_Test {
    
    @isTest
    public static void test_estimerElecConso(){
        
        Decimal estimerElecSuccess = VI_SM020_EstimerElecConsommation.estimerElec('1994', '23', '020', '010', 2, 34, '020', '010', '020', '010', '020', true,true,true,true, 'VI', '3', 'callout:AuthOctopus');
        
        System.assertEquals(4415, estimerElecSuccess);
        
                
        Decimal estimerElecErreur = VI_SM020_EstimerElecConsommation.estimerElec('', '', '', '', 2, 34, '', '', '', '', '', true,true,true,true,'VI', '3', 'callout:AuthOctopus');
        
        System.assertEquals(null, estimerElecErreur); 
        
    }
}