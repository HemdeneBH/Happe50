/**
@Author Dallel Riadh
@name SM_AP90_AgentWorkInvocable
@CreatedDate 26/06/2020
@Description Méthode invocable afin de mettre à jour les champs Statut et Owner de l'intervention (Push Omni-channel)
@Version 1.0
@reference <Referenced program names>
@ModifiedBy Dallel Riadh
*/
global class SM_AP90_AgentWorkInvocable {

    /**
    * Une méthode invocable à partir du PB pour MAJ la dernière intervention au statut 'nouveau'
    associée au WorkItem(case) 
    * @name execute
    * @param requestList list qui contient une string "WorkItem\\UserId"
    * @return Void 
    * @throws exception
    */
    @InvocableMethod
    public static void execute (Request[] request) {

        // extraction de caseId et userId récuperé du Process Builder
        
        String caseId = request[0].caseId;
        String ownerId = request[0].ownerId;
        
        if(caseId!=null && ownerId!=null){

            // récupération des Interventions
            List<Intervention__c> listCaseInterventions = [Select Id,Statut__c,OwnerId 
                                            From Intervention__c 
                                            Where statut__c='Nouveau' And Case__c=:caseId 
                                            Order By CreatedDate Desc];

            if(listCaseInterventions.size()>0){

                //mettre à jour la statut et le Owner de l'intervention 
                listCaseInterventions[0].Statut__c = 'En cours';
                listCaseInterventions[0].OwnerId = ownerId;
                
                try {
                    update listCaseInterventions[0];
                } catch (Exception e) {
                    system.debug('Error:'+ e.getMessage());
                }  
            }
        }
    }

    global class Request{
        @InvocableVariable
        global id caseId;
        @InvocableVariable
        global id ownerId;
    }
    
}