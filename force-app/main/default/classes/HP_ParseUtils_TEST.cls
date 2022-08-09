@isTest
public class HP_ParseUtils_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }
    
    @isTest
    static void serializeStringSetTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, String> sampleMap = new Map<String, String>{'fruit' => 'Apple'}; 
            String serialized = HP_ParseUtils.serializeStringSet(sampleMap, new Set<String> {'fruit'});
            System.debug(serialized);
        } 
    }
    
    @isTest
	private static void parseTest(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            String sampleJson = '[{"fruit": "Apple","size": "Large","color": "Red"}]';
            List<Map<String, Object>> jSonStaticResourceList = HP_ParseUtils.parse(sampleJson);
            System.debug(jSonStaticResourceList);
        }
    }
    
}