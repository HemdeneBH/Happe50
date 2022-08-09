/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 01-27-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public without sharing class HP_UTIL_MetadataUpdate implements Metadata.DeployCallback {
   public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context){
       if(result.status == Metadata.DeployStatus.SUCCEEDED){
           System.debug('### Success : '+result);
       }else{
            System.debug('### Failure : '+result);
       }
   }

   public static void handleUpdate(String fullName, String label, Map<String, Object> fieldWithValuesMap){
       Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
       customMetadata.fullName = fullName;
       customMetadata.label = label;

       for(String key : fieldWithValuesMap.keySet()){
           Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
           customField.field = key;
           customField.value = fieldWithValuesMap.get(key);
           customMetadata.values.add(customField);
       }
       Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
       mdContainer.addMetadata(customMetadata);
       HP_UTIL_MetadataUpdate callback = new HP_UTIL_MetadataUpdate();
       if(!Test.isRunningTest()){
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
       }
       
   }
}