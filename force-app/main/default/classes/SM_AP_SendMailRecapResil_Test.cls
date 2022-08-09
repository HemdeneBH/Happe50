@isTest
public  class SM_AP_SendMailRecapResil_Test {
    
    
    static testMethod void SM_AP_SendMailRecapResil_Test() {
        String inputString = '{"NOExistingJson":{},"isActiveElec":true,"isActiveGaz":true,"isNotRecollementElec":true,"isNotRecollement":true,"ContactMail":"mohamed.kchaou@talan.com","getNom":"FERREIRA VANRENTERGHEM","getCivilite":"MR et MME","getIdBP":"0306559627","ChercherAdresseFormula":"92 Rue Fieux 31100 Toulouse","ChoixProcedureAutoItv":"Intervention","typeCompteur":"Non Communicant","LINKYlv2":false,"LINKYlv1":false,"CreneauElecHeureFin":"173000","CreneauElecHeureDebut":"000000","DateInterventionElec":"Lundi 30 déc 2019","DateInterventionGaz":"Vendredi 09 nov 2018","CreneauGazHeureFin":"8:00","CreneauGazHeureDebut":"12:00","ResilElecActif":true,"ResilGazActif":true}';
        Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
        SM_AP_SendMailRecapResil objectRecapResil = new SM_AP_SendMailRecapResil() ;
        Map < String, Object >  outMap = new Map < String, Object >() ;
        objectRecapResil.invokeMethod('SendRecapMail',inputMap,outMap,null) ;
        
        
        inputString = '{"NOExistingJson":{},"isActiveElec":true,"isActiveGaz":true,"isNotRecollementElec":true,"isNotRecollement":true,"ContactMail":"mohamed.kchaou@talan.com","getNom":"FERREIRA VANRENTERGHEM","getCivilite":"MR et MME","getIdBP":"0306559627","ChercherAdresseFormula":"92 Rue Fieux 31100 Toulouse","ChoixProcedureAutoItv":"Autorelève","typeCompteur":"Non Communicant","LINKYlv2":false,"LINKYlv1":false,"CreneauElecHeureFin":"173000","CreneauElecHeureDebut":"000000","DateInterventionElec":"Lundi 30 déc 2019","DateInterventionGaz":"Vendredi 09 nov 2018","CreneauGazHeureFin":"8:00","CreneauGazHeureDebut":"12:00","ResilElecActif":true,"ResilGazActif":true}';
        inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
        objectRecapResil = new SM_AP_SendMailRecapResil() ;
        outMap = new Map < String, Object >() ;
        objectRecapResil.invokeMethod('SendRecapMail',inputMap,outMap,null) ;
        
    }
    
}