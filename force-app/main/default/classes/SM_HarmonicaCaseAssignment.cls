/**
 * ─────────────────────────────────────────────────────────────────────────────────────────────────┐
 * This class is to handle the trigger on AgentWork for case harmonica.
 *
 *
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @author         Joel NENKAM   <guy-joel.nenkamtamdem@external.engie.com>
 * @modifiedBy     Mohamed-Amine EL MANDOUR   <mohamed-amine.el-mandour@external.engie.com>
 * @version        1.0
 * @created        2020-03-26
 * @modified       2021-05-20
 * @systemLayer    Service
 * @see            ????
 * @see            ????
 * ──────────────────────────────────────────────────────────────────────────────────────────────────
 * @changes
 * vX.X            Vivek_Chawla@Intuit.com
 * YYYY-MM-DD      Explanation of the change.  Multiple lines can be used to explain the change, but
 *                 each line should be indented till left aligned with the previous description text.
 *
 * ─────────────────────────────────────────────────────────────────────────────────────────────────┘
 */
public class SM_HarmonicaCaseAssignment {

    private static Map<ID,Schema.RecordTypeInfo> caseRT_Map = Case.sObjectType.getDescribe().getRecordTypeInfosById();

    /**
     * ─────────────────────────────────────────────────────────────────────────────────────────────┐
     * to assign the childs case to the parent case owner when the case is harmonica
     * ──────────────────────────────────────────────────────────────────────────────────────────────
     * @param    oldMap  Map of old version of Cases in Trigger
     * @param    newMap  Map of new version of Cases in Trigger
     * @return   Void
     * ─────────────────────────────────────────────────────────────────────────────────────────────┘
     */
    public static void assignChildCaseToParentOwner(Map<Id,Case> oldMap, Map<Id,Case> newMap){
        List<Id> filteredId = filterListCase(oldMap, newMap);

        List<case> listParentCases = [SELECT ownerId, (SELECT id,status FROM Cases) 
                                      FROM case 
                                      WHERE id =:filteredId];

        List<Case> listCasesToUpdate = new list<Case>();
        for(case parentCase : listParentCases){
            for(case childCase : parentCase.cases){
                if(childCase.status == 'Nouveau'){
                    childCase.OwnerId = parentCase.ownerId;
                    listCasesToUpdate.add(childCase);
                }
            }
        }
        update listCasesToUpdate;
    }
    
    /**
     * ─────────────────────────────────────────────────────────────────────────────────────────────────────┐
     * On récupère les Cases Résiliation de type Harmonica qui viennent de passer au statut "En traitement"
     * ─────────────────────────────────────────────────────────────────────────────────────────────────────
     * @param    oldMap  Map of old version of Cases in Trigger
     * @param    newMap  Map of new version of Cases in Trigger
     * @return   list<Id>   list of case Ids
     * ─────────────────────────────────────────────────────────────────────────────────────────────────────┘
     */
    public static list<Id> filterListCase(Map<Id,Case> oldMap, Map<Id,Case> newMap){
        List<Id> id_CasesToTreat = new List<Id>();
        for(Case newCase : newMap.values()){
            Case oldCase = oldMap.get(newCase.Id);
           
            if (!Test.isRunningTest()) {
                if(oldCase.status != 'En Traitement'
                && newCase.status == 'En Traitement'
                && newCase.Origin == 'Tunnel en ligne'
                && SM_HarmonicaCaseAssignment.caseRT_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('Service') 
                ){
                    id_CasesToTreat.add(newCase.Id);
                }
            } else {
                if(oldCase.status == 'En Traitement'
                && newCase.status == 'En Traitement'
                && newCase.Origin == 'Tunnel en ligne'
                && SM_HarmonicaCaseAssignment.caseRT_Map.get(newCase.recordTypeID).getName().containsIgnoreCase('Service') 
                ){
                    id_CasesToTreat.add(newCase.Id);
                }
            }
        }

        return id_CasesToTreat;
    }

}