/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-13-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-07-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@RestResource(urlMapping = '/updateOPS')
global with sharing class CMN_OPSUpdate {

    @HttpPost
    global static String handleOpsInfos() {
        
        String body = RestContext.request.requestBody.toString();
        Datetime startCall = Datetime.now();
        Map<String, list<CMN_OPSinfo>> resu = (Map<String, list<CMN_OPSinfo>>) JSON.deserialize(body, Map<String, list<CMN_OPSinfo>>.class);
        list<CMN_OPSinfo> OPSinfos = resu.get('OPSinfos');
        System.debug('body**** =============================' +  body );
        Map<String, String> confMap = loadConfig();
        Map<String, List<CMN_OPSinfo>> opsSplited = splitOPSByRTId(OPSinfos); // HP : record HP,   SM : records SM
        String result = 'OK';
        for(String rt : opsSplited.keySet()) {
            try{
                CMN_OPSProcessingInterface apexClass = (CMN_OPSProcessingInterface) Type.forName(confMap.get(rt)).newInstance();
                apexClass.processing(opsSplited.get(rt));

            } catch(Exception e) {
                result = 'NOK';
            }

        }
        RestContext.response.responseBody = Blob.valueOf(result);
        HP_UTIL_HTTPUtils.saveLogResponse(RestContext.request,  RestContext.response, (Datetime.now().getTime() - startCall.getTime()));
        return result;
    }

    private static Map<String, String> loadConfig() {
        Map<String, String> result = new Map<String, String>();
        List<CMN_OPSProcessing__mdt> configList = [select DeveloperName, Processing__c from CMN_OPSProcessing__mdt];
        for(CMN_OPSProcessing__mdt conf : configList) {
            result.put(conf.DeveloperName, conf.Processing__c);
        }

        return result;
    }

    private static Map<String, List<CMN_OPSinfo>> splitOPSByRTId(list<CMN_OPSinfo> opsList) {
        Map<String, CMN_OPSinfo> opsMap = new Map<String, CMN_OPSinfo>();
        for (CMN_OPSinfo opstemp: opsList) {
            opsMap.put(opstemp.idAffaire, opstemp);
        }
        List <Prestation_distributeur__c> accs = [SELECT Numero_affaire_distributeur__c, RecordType.DeveloperName 
        FROM Prestation_distributeur__c WHERE Numero_affaire_distributeur__c IN: opsMap.keySet()];

        Map<String, List<CMN_OPSinfo>> result = new Map<String, List<CMN_OPSinfo>>();

        for(Prestation_distributeur__c ac : accs) {
            List<CMN_OPSinfo> currentOPList;
            if(ac.RecordType == null) {
                currentOPList = result.get('NULL');

                if(currentOPList == null) {
                    currentOPList = new List<CMN_OPSinfo>();
                    result.put('NULL', currentOPList);
                }
                currentOPList.add(opsMap.get(ac.Numero_affaire_distributeur__c));
                continue;
            }
            currentOPList = result.get(ac.RecordType.DeveloperName);
            if(currentOPList == null) {
                currentOPList = new List<CMN_OPSinfo>();
                result.put(ac.RecordType.DeveloperName, currentOPList);
            }
            currentOPList.add(opsMap.get(ac.Numero_affaire_distributeur__c));
        }

        return result;
    }
}