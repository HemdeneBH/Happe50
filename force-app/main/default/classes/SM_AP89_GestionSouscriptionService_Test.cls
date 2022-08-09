/*@Author: ADE
*@Description: class de test de FEL
*@CreatedDate: 28/10/2020
*/
@isTest(SeeAllData=true)
public with sharing class SM_AP89_GestionSouscriptionService_Test {
    
    static testMethod void   demanderSouscriptionService_Test(){
         Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SM_AP89_GestionSouscriptionService_mock());
        Map<String, Object> inputMap=new Map<String, Object>();
       Map<String, Object> outMap=new Map<String, Object>();
        outMap.put('code','OCTOPUS_DemanderSouscriptionService_01');
        
       SM_AP89_GestionSouscriptionService.demanderSouscriptionService('lahoucine.ikerchalene@external.engie.com','312376423','312376423','312376423',outMap);        

      //  System.assertEquals(rdemanderSouscriptionServiceRef,'OCTOPUS_DemanderSouscriptionService_01');    

        Test.stopTest();
        
    }
    
    
    
     /*@Author: ADE
    *@Description: methode de test pour souscription FEL
    *@CreatedDate: 28/10/2020
    */
    static testMethod void demanderSouscriptionServiceRef_Test() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SM_AP89_GestionSouscriptionService_mock());
        Map<String, Object> inputMap=new Map<String, Object>();
        inputMap.put('mail','lahoucine.ikerchalene@external.engie.com');
        inputMap.put('refClientIdBP','312376423');
        inputMap.put('account','000516686693');
        String rdemanderSouscriptionServiceRef=String.valueOf(SM_AP89_GestionSouscriptionService.demanderSouscriptionServiceRef(inputMap).get('code'));        

        System.assertEquals(rdemanderSouscriptionServiceRef,'OCTOPUS_DemanderSouscriptionService_01');    

        Test.stopTest();
    }
     /*@Author: ADE
    *@Description: methode de test pour desactivation FEL
    *@CreatedDate: 28/10/2020
    */
    static testMethod void desactiverServiceGestion_Test() {  
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new SM_AP92_DesactiverServiceGestion_Mock());
        Map<String, Object> inputMap=new Map<String, Object>();
        inputMap.put('account','000516686693');
        String rdemanderSouscriptionServiceRef=String.valueOf(SM_AP89_GestionSouscriptionService.desactiverServiceGestion(inputMap).get('code'));        

        System.assertEquals(rdemanderSouscriptionServiceRef,'OCTOPUS_DesactiverServiceGestion_01');   

        Test.stopTest();
        
    }
}