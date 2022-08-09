public class VI_SM039_SignatureMandatListCase {
    
    public static void signedCase(Case[] newList,Map<Id, Case> oldMap){
        System.debug('### START sendCase ');
        System.debug('### newList : ' + newList);
        System.debug('### oldMap : ' + oldMap);
        List<Case> listcase=new List<Case>();
        Set<id> setCaseIds=new Set<Id>();
        List<VI_Parcours__c> listParcours;
        List<case> listCaseToUpdate=new List<Case>();
        Id CaseRTId = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        for(case cas:newList){
            if(cas.Origin != null){
                if(cas.Origin.equals('Partner Community')
                   && cas.VI_StatutMandat__c == 'Signed'
                   && oldMap.containsKey(cas.Id)  
                   && cas.VI_StatutMandat__c != oldMap.get(cas.Id).VI_StatutMandat__c
                   && cas.RecordTypeId == CaseRTId){
                       listcase.add(cas);
                   }   
            }
        }
        System.debug('listcase '+listcase);
        
        //Filling caseIds in set to query parcours for required fields
        if(listcase!= null & listcase.size()>0){
            for(case cas:listcase){
                setCaseIds.add(cas.id);
            }
        }
        listParcours=[Select id,VI_IDReferenceClient__c, VI_Id_coordonnees_bancaires__c, VI_ID_Mandat__c,VI_Case__c  from VI_Parcours__c where VI_Case__c in :setCaseIds];
        
        if(listParcours!= null & listParcours.size()>0){
            for(VI_Parcours__c parcoursWithMandatToUpdate:listParcours){
                VI_SM038_MAJMandat.majMandat(parcoursWithMandatToUpdate.VI_Case__c,parcoursWithMandatToUpdate.VI_ID_Mandat__c,
                                             '1',
                                             parcoursWithMandatToUpdate.VI_IDReferenceClient__c,
                                             parcoursWithMandatToUpdate.VI_Id_coordonnees_bancaires__c,
                                             'VI',
                                             '1.0',
                                             'callout:VI_AuthOctopus');
                
            }
        }
    }
}