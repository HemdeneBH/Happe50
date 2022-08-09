/*
* @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
* @Date: 13/03/2019
* @Description: class test
*/
@isTest
global class SM_Adresses_Utilities_TEST {

  /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 13/03/2019
  * @Description Methode test to simulate the construction of output in method 
  */
  @isTest
  global static void globalSuccessTestFormatterAdresseCompteClient() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> insideObj = new Map<String, object>();

        inputMap.put('adresseAFormatter', '12 rue gabriel péri Rueil-Malmaison');

        
        SM_Adresses_Utilities service = new SM_Adresses_Utilities();
        service.invokeMethod('formatterAdresseCompteClient', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 1);
        String adresseFormatte = (String) outputMap.get('adresseFormatSAP');
        System.assertEquals(adresseFormatte, '12 RUE GABRIEL PERI RUEIL MALMAISON');
    }
    
    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 13/03/2019
  * @Description Methode test to formatt adress infomations for the creation of a contact in SAP
  */
  @isTest
  global static void globalSuccessTestFormatterAdresseCreerPersonne() {
        Map<String, object> inputMap = new Map<String, object>();
        Map<String, object> contactInfoMap = new Map<String, object>();
      
        Map<String, object> addressMap = new Map<String, object>();
        addressMap.put('City','Saint-Rémy-lès-Chevreuse');
        addressMap.put('Street','avenue gabriel péri');
      
        contactInfoMap.put('AddressIndication','bâtiment A Etage 1 porte 22');
        contactInfoMap.put('Address', addressMap);
        inputMap.put('ContactInfo', contactInfoMap);
      
        Map<String, object> outputMap = new Map<String, object>();
        Map<String, object> insideObj = new Map<String, object>();


        
        SM_Adresses_Utilities service = new SM_Adresses_Utilities();
        service.invokeMethod('formatterAdresseCreerPersonne', inputMap,  outputMap, null);
        System.assertEquals(outputMap.size(), 1);
        Map<String,Object> adresseFormatSAPMAP = (Map<String,Object>) outputMap.get('adresseFormatSAP');
        String addressIndication = (String) adresseFormatSAPMAP.get('AddressIndication');
        String city = (String) adresseFormatSAPMAP.get('City');
        String street = (String) adresseFormatSAPMAP.get('Street');
      
        System.assertEquals(addressIndication, 'BATIMENT A ETAGE 1 PORTE 22');
        System.assertEquals(city, 'SAINT REMY LES CHEVREUSE');
        System.assertEquals(street, 'AVENUE GABRIEL PERI');
    }

}