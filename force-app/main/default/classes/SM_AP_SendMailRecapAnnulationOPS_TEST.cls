@isTest
public  class SM_AP_SendMailRecapAnnulationOPS_TEST {

    @isTest
    static void SM_AP_SendMailRecapAnnulationOPSResil_TEST() {
    Test.startTest();
    String inputString = '{"TypeCard":"GAZ","num":"23","rue":"rue TEST","cplt":"chez Test","contactEmail":"test@test.com","cp":"75015","ville":"Paris","contactName":"Michu Michu","contactSalutation":"MR","OPSSituationDeVente":"Resiliation","dateRDV":"Lundi 30 déc 2019","fraisPrestation" : "20","presence" : "1","deltaFrais": 1}';
    Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
    SM_AP_SendMailRecapAnnulationOPS objectRecapAnnulation = new SM_AP_SendMailRecapAnnulationOPS() ;
    Map < String, Object >  outMap = new Map < String, Object >() ;
    objectRecapAnnulation.invokeMethod('SendRecapMail',inputMap,outMap,null) ;
    Test.stopTest();

}
    
    @isTest
    static void SM_AP_SendMailRecapAnnulationOPSEmm_TEST() {
    Test.startTest();
    String inputString = '{"TypeCard":"GAZ","num":"23","rue":"rue TEST","cplt":"chez Test","contactEmail":"test@test.com","cp":"75015","ville":"Paris","contactName":"Michu Michu","contactSalutation":"MR","OPSSituationDeVente":"Emménagement","dateRDV":"Lundi 30 déc 2019","fraisPrestation" : "20","presence" : "1","deltaFrais": 1}';
    Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
    SM_AP_SendMailRecapAnnulationOPS objectRecapAnnulation = new SM_AP_SendMailRecapAnnulationOPS() ;
    Map < String, Object >  outMap = new Map < String, Object >() ;
    objectRecapAnnulation.invokeMethod('SendRecapMail',inputMap,outMap,null) ;
    Test.stopTest();

}
    @isTest
    static void SM_AP_SendMailRecapAnnulationOPSCHF_TEST() {
    Test.startTest();
    String inputString = '{"TypeCard":"ELEC","num":"23","rue":"rue TEST","cplt":"chez Test","contactEmail":"test@test.com","cp":"75015","ville":"Paris","contactName":"Michu Michu","contactSalutation":"MR","OPSSituationDeVente":"Changement de fournisseur","dateRDV":"Lundi 30 déc 2019","fraisPrestation" : "20","presence" : "1","deltaFrais": 1}';
    Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
    SM_AP_SendMailRecapAnnulationOPS objectRecapAnnulation = new SM_AP_SendMailRecapAnnulationOPS() ;
    Map < String, Object >  outMap = new Map < String, Object >() ;
    objectRecapAnnulation.invokeMethod('SendRecapMail',inputMap,outMap,null) ;
     
    Test.stopTest();

}
   
}