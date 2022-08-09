/*@isTest*/
/*
*@author : MTR
*@Description:
*@CreatedDate :03/05/2019
*/
@isTest
public class SM_ProcessContrat_Test {   
    static testMethod void Test() {
        
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        
        String dataInput = '{"data": [{"typeContrat": "GN", "codeStatutContratCRM": "E0001","dateDebutContrat" : "2019-03-30"},'
        +'{"typeContrat": "GN", "codeStatutContratCRM": "E0005","dateDebutContrat" : "2019-03-30","uniteReleve":"uniteReleve"},'
             +'{"typeContrat": "GN", "codeStatutContratCRM": "E0009","dateFinContrat" : "2019-03-30","uniteReleve":""},'
            +'{"typeContrat": "GN", "codeStatutContratCRM": "E0009","dateFinContrat" : "2019-03-30","uniteReleve":"uniteReleve"},'
        +'{"typeContrat": "E", "codeStatutContratCRM": "E0001","dateDebutContrat" : "2019-03-30","uniteReleve":"uniteReleve"},'
            +'{"typeContrat": "E", "codeStatutContratCRM": "E0009","dateDebutContrat" : "2019-03-30","dateFinContrat" : "2019-03-30","uniteReleve":"uniteReleve"},'
             +'{"typeContrat": "E", "codeStatutContratCRM": "E0009","dateDebutContrat" : "2019-03-30","dateFinContrat" : "2019-03-29","uniteReleve":"uniteReleve"},'
           +' {"typeContrat": "E", "codeStatutContratCRM": "E0005","dateDebutContrat" : "2019-03-30","dateFinContrat" : "2019-03-29","uniteReleve":"uniteReleve"}]}';
        Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(dataInput);
        List<Map<String, Object>> data = new List<Map<String, Object>>();
        for (Object instance : (List<Object>)deserialized.get('data')){
            data.add((Map<String, Object>)instance);
        }
        
        inputMap.put('_data',data);        
        SM_ProcessContrat service = new SM_ProcessContrat();
        service.invokeMethod('Process', inputMap, outMap, null); 
    }
}