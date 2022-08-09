public class SM_AP77_CallIPApiService {
    @AuraEnabled(cacheable=false)
    public static Map < String, Object > callIP(Map<String,Object> inputMap, String NameIntergation) {
        Map < String, Object > options  = new Map<String, Object>();
        Map<String, Object> ipOutput;
        if(!Test.isRunningTest()){
            ipOutput = (Map<String,Object>)vlocity_cmt.IntegrationProcedureService.runIntegrationService(NameIntergation,  inputMap , options);
        }
        return ipOutput;
    }
}