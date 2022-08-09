/**
@Author Dallel Riadh
@name SM_Purecloud_RoutingDeleteInvocable
@CreatedDate 25/06/2021
@Description Méthode invocable afin de supprimer une demande de routage Genesys (PureCloud)
@Version 1.0
@reference <Referenced program names>
@ModifiedBy Dallel Riadh
*/

global class SM_Purecloud_RoutingDeleteInvocable {


    /**
    * Une méthode invocable à partir du Flow Case
    * @name execute
    * @param request list qui contient le conversationId du case
    * @return Void 
    * @throws exception
    */
    @InvocableMethod

    public static void execute (Request[] request) {
        // récuperer le conversationId envoyé par le flow SM_Flow08_CaseRoutingGenesys_AfterSave
        if(System.IsBatch() == false && System.isFuture() == false){ 
            String conversationId='';
            if(request.size() > 0 ) 
                conversationId = request[0].conversationId;

            if(conversationId!=''){
                sendDeleteRequest(conversationId);
            }
        }
    }

    //une méthode qui fait appel à l'SDK Purecloud pour supprimer une demande de routage
    @future(callout = true)
    public static void sendDeleteRequest(String conversationId){
        HttpResponse response;
        if(!Test.IsRunningTest())
            response = purecloud.SDK.Rest.post('/api/v2/conversations/'+conversationId+'/disconnect','', new Map<String, String>());
        else {
            SM_Purecloud_RoutingDeleteInvocable_Mock mock = new SM_Purecloud_RoutingDeleteInvocable_Mock();
            HTTPRequest request = new HTTPRequest();
            response = mock.respond(request);
        }
        if(response.getStatusCode()!=200){
		    try{
                // tracer les erreurs Genesys sur l'objet SyncEventLog__c
                insert new SyncEventLog__c (flux__c = 'Genesys_DeleteRouting', name='Delete routing failed', inputdat__c = response.getBody());
            } catch (DMLException e){
                System.debug('Erreur technique lors de la création du SyncEventLog');
            }
            
        }

    }

    global class Request{
        @InvocableVariable
        global String conversationId;
    }
    

}