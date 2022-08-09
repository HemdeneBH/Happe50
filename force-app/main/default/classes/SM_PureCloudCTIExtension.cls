/*
* @Auhtor: Riadh Dallel ~ riadh.dallel@external.engie.com
* @Date: 25/06/2021
* @Description: une extension de classe Purecloud « SaveLog »
*/
global Without Sharing class SM_PureCloudCTIExtension implements purecloud.CTIExtension.SaveLog {


    private static String caseStatus_escalade = 'Escaladé';
    private static String interventionStatus_Nouveau = 'Nouveau';
    private static String interventionNewStatus_EnCours = 'En cours';


    public String onSaveLog(String data) {
        Map<String, Object> saveLogData = (Map<String, Object>) JSON.deserializeUntyped(data);
        Map<String, Object> interaction = ( Map<String, Object>) saveLogData.get('interaction');
        Map<String, Object> attributes = ( Map<String, Object>) interaction.get('attributes');
        Map<String, Object> callLog = ( Map<String, Object>) saveLogData.get('callLog');
        Boolean isConnected = (Boolean) interaction.get('isConnected');
        
        if (isConnected && attributes !=null) {
            String caseId = (String) attributes.get('sf_urlpop');
            if (String.isNotBlank(caseId)){
                List<Case> caseListToUpdate = new List<Case>(); 
                caseListToUpdate = [select id,Status, ownerId, PureCloud_acceptedGenesys__c From Case Where id=: caseId Limit 1] ; 
                

                if(caseListToUpdate.size() > 0){
                    try{
                        caseListToUpdate[0].OwnerId = UserInfo.getUserId();
                        caseListToUpdate[0].PureCloud_acceptedGenesys__c = true;
                        caseListToUpdate[0].PureCloud_conversationId__c = '';
                        update caseListToUpdate;

                        if(caseListToUpdate[0].Status == caseStatus_escalade){
                            updateIntervention(caseListToUpdate[0]); 
                        } 
                    } catch (DMLException e){
                        System.debug('Erreur technique lors de la mise à jour du case: ' + e);

                    }
                }
            }
        }

        //send the task id as a response by default
        Task task = (Task) JSON.deserialize(JSON.serialize(callLog), Task.class);
        upsert task;

        return (task != null && !String.isBlank(task.id) ) ? task.id : '' ; 
    }

    private void updateIntervention(Case caseToUpdate ){
        if(caseToUpdate.ownerId != null){
            List<Intervention__c> listCaseInterventions = [SELECT Id,Statut__c,OwnerId 
                                                           FROM Intervention__c 
                                                           WHERE statut__c=:interventionStatus_Nouveau 
                                                             AND Case__c=:caseToUpdate.Id 
                                                           ORDER BY CreatedDate DESC];

            if(listCaseInterventions.size()>0){ 
                //mettre à jour la statut et le Owner de l'intervention 
                listCaseInterventions[0].Statut__c = interventionNewStatus_EnCours;
                listCaseInterventions[0].OwnerId = caseToUpdate.ownerId;
               
                try{
                   update listCaseInterventions[0];
                } catch (Exception e) {
                   system.debug('Error:'+ e.getMessage());
                }  
            }     
        } 

    }
}