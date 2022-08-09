global with sharing class SM_AP86_FillInteractionDetails implements vlocity_cmt.VlocityOpenInterface{
    
    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('FillInteractionDetails')) {
            try {
                FillInteractionDetails(inputMap, outMap, options);
                } catch (Exception e) {
                system.debug(e.getStackTraceString());
                return false;
            }
        }

        return true;
    }
    
    public void FillInteractionDetails( Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
		
        String interactionDetail;
        String interactionDetailsTransform;
        String parcours = String.valueOf(inputMap.get('parcours'));
        Map<String,Object> parameters = (Map<String,Object>) inputMap.get('interactionDetailsParam');

        system.debug('parameters' + parameters);
        
        if(!Test.isRunningTest()){
         interactionDetail = [SELECT Id, parcours__c, detailInteraction__c, DeveloperName FROM SM_interactionDetail__mdt where parcours__c = :parcours limit 1].detailInteraction__c;
        }
        else{
            interactionDetail = 'Informations clients\n'
                +'\tMaj infos perso : OK / KO\n'+
                +'\tConsentement Engie et Partenaires : OK / KO\n';
        }
        
        for(String Key : parameters.keySet()){
            system.debug('key:' + key + ' value:' + parameters.get(key));
            interactionDetail = interactionDetail.replace('%'+key+'%',String.valueOf(parameters.get(key)));           
        }
		
        outMap.put('InteractionDetails',interactionDetail);

    }
   
}