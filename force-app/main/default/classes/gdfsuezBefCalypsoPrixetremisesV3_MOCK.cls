/**
* @description       : Mock for WSDL generated class gdfsuezBefCalypsoPrixetremisesV3 (FT1-4381)
* @author            : David Attali
* @group             : 
* @last modified on  : 01-25-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   01-25-2021   David ATTALI    Initial Version
**/
@isTest
global class gdfsuezBefCalypsoPrixetremisesV3_MOCK implements WebServiceMock {
    
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {

        response.put('response_x', null); 
   }
}