public with sharing class VI_CaseHandler {
    public static void run(List<Case> newList,Map<id,Case> oldMap,Map<id,Case> newMap){
        VI_NotifyListCase.sendCase(newList, oldMap,newMap);
        VI_SM041_NotifyPartner.NotifyPartner(newList, oldMap);
        VI_SM039_SignatureMandatListCase.signedCase(newList, oldMap);
        VI_SM044_EmailDeConfirmation.sendEmailConfirmation(newList, oldMap);
    }
}