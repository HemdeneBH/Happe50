@IsTEST
public with sharing class HP_CALL007_DQE_TEST {

    @testSetup static void dataSetup(){
        HP_UTIL_SmartFactory.insertUserHP();
    }
   

    @IsTest
    static void getSuggestions(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
		
                'gouv' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      'HP_APIGouv_MOCK',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            HP_WRP035_APIGouv result = HP_CALL007_DQE.getSuggestions('46+boulevard+de+la+libération+67500+Haguenau');
            System.debug(result.features[4].properties.postcode);
            System.assert(result.features[4].properties.postcode == '67500', 'Validé');
            Test.stopTest();
        } 
    }

    @IsTest
    static void getSuggestionsDQE(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
		
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      null,'{"24": {"Instance": "", "CodePostal": "75116", "Localite": "PARIS", "CodeVoie": "1456950", "NbNumero": 1, "Complement": "", "Voie": "BOULEVARD FLANDRIN", "Numero": "12", "label": "12 BOULEVARD FLANDRIN|75116 PARIS", "ListeNumero": "12", "Nbnumero": 1, "LieuDit": "", "TypeVoie": "", "SousLocalite": "*", "valid_num": 1, "IDLocalite": "75116", "Pays": "FRA", "IDVoie": "1456950", "Saisie": "12 boulevar", "Num": "12", "Entreprise": "", "NumSeul": "12"}}',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            List<Map<String, Object>> result = HP_CALL007_DQE.getSuggestionsDQE('46+boulevard+de+la+libération+67500+Haguenau');
           
            Test.stopTest();
        } 
    }

    @IsTest
    static void getcomplementDQE(){
        System.runAs(HP_UTIL_SmartFactory.runAsUserHP()){
            Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> bodyResponseMap = new Map<String, HP_UTIL_ResponseRestMock.ParameterMockWrapper> {
		
                'V2' => new HP_UTIL_ResponseRestMock.ParameterMockWrapper(200,
                                                      null,'{"1" : {"Batiment":"BATIMENTA"},"3" :{"Batiment":"BATIMENT C"},"iris":"5101"}',
                                                      new Map<String, String> { 'Content-Type' => 'application/json'})
            };
    
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HP_UTIL_ResponseRestMock(bodyResponseMap));
            List<Map<String, Object>> result = HP_CALL007_DQE.getComplementsDQE('8+rue+de+l+universite+26500+BOURG+LES+VALENCE');
           
            Test.stopTest();
        } 
    }
}