global class SM_AP77_EmailPhoneVerificationService implements vlocity_cmt.VlocityOpenInterface {
    private static Map<String,Object> outMapEmailLWC = new Map<String,Object>();
    private static Map<String,Object> outMapPhoneNumberLWC = new Map<String,Object>();

    public static Map<String, String> additionalHeaders = new Map<String, String>{
        'X-Api-Key' => MP_Xdata_credentials__c.getInstance('sm_api_key_digital_INT').Value__c,
        'DIG_ID_CLIENT' => MP_Xdata_credentials__c.getInstance('sm_digital_id_client').Value__c,
        'DIG_SECRET_CLIENT' => MP_Xdata_credentials__c.getInstance('sm_digital_secret_client').Value__c
    };

    /* @Author: LIK
     * @Description: Permet de réaliser le traitement dans le cas d'un appel depuis un composant lightning sans changer la structure des autres méthodes
     * @CreatedDate: 19/11/2019
     */
    @AuraEnabled(cacheable=true)
    global static Map<String,Object> invokeMethodLWC(String methodName, Map<String,Object> inputMap, Map<String,Object> options) {

        system.debug('Entre dans invokeMethodLWC.');
        if (methodName.equals('verifyEmails')) {
            try {
                verifyEmails(inputMap, SM_AP77_EmailPhoneVerificationService.outMapEmailLWC, options);
            } catch (Exception e) {
                system.debug('[ :verifyEmails]:Exception: ' + e);
                return SM_AP77_EmailPhoneVerificationService.outMapEmailLWC;
            }
            return SM_AP77_EmailPhoneVerificationService.outMapEmailLWC;
        }
        if (methodName.equals('verifyPhoneNumbers')) {
            try {
                system.debug('Input' + inputMap);
                system.debug('OutMap' + SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC);
                system.debug('Input' + options);
                verifyPhoneNumbers(inputMap, SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC, options);
            } catch (Exception e) {
                system.debug('[SM_AP77_EmailPhoneVerificationService:verifyPhoneNumbers]:Exception: ' + e);
                SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC = new Map<String,Object>();
                SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC.put('Error', e);
                return SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC;
            }
            return SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC;
        }
        system.debug('OutMap Fin' + SM_AP77_EmailPhoneVerificationService.outMapPhoneNumberLWC);
        return null;
    }

    /**
     * Permet de réaliser le traitement dans le cas d'un appel depuis un omniscript
     */
    global Boolean invokeMethod(String methodName, Map<String,Object> inputMap, Map<String,Object> outMap, Map<String,Object> options) {
        if (methodName.equals('verifyEmails')) {
            try {
                verifyEmails(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('[ :verifyEmails]:Exception: ' + e);
                return false;
            }
        }
        if (methodName.equals('verifyPhoneNumbers')) {
            try {
                verifyPhoneNumbers(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug('[SM_AP77_EmailPhoneVerificationService:verifyPhoneNumbers]:Exception: ' + e);
                return false;
            }
        }
        return true;
    }

    /* @Author: HEL
    * @Description : Service appelé depuis un OS pour vérifier la validité des emails du contact
    * @CreatedDate : 03/10/2019
    */
    public static void verifyEmails(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {

        String email1 = (String) inputMap.get('email1');
        String email2 = (String) inputMap.get('email2');
        String email3 = (String) inputMap.get('email3');
        String service = (String) inputMap.get('service');

        if('updateContact'.equals(service)){
            String contactId = (String) inputMap.get('contactId');
            Contact contactToUpdate = [SELECT Email, Adresse_Mail_2__c,Adresse_Mail_3__c FROM Contact WHERE ID = :contactId];
            if(!String.isBlank(contactToUpdate.Email)){
                email1 = contactToUpdate.Email.equals(email1) ? '' : email1;
            }
            if(!String.isBlank(contactToUpdate.Adresse_Mail_2__c)){
                email2 = contactToUpdate.Adresse_Mail_2__c.equals(email2) ? '' : email2;
            }
            if(!String.isBlank(contactToUpdate.Adresse_Mail_3__c)){
                email3 = contactToUpdate.Adresse_Mail_3__c.equals(email3) ? '' : email3;
            }
        }

        
        String codeRetour;
        if(!String.isBlank(email1)){
            codeRetour = verifyEmail(email1);
            outMap.put('code1',codeRetour);
            if('00'.equals(codeRetour) || '01'.equals(codeRetour) || '03'.equals(codeRetour) || '99'.equals(codeRetour)){
                outMap.put('email1','OK');
            }
            else{
                outMap.put('email1','KO');
            }
        }
        if(!String.isBlank(email2)){
            codeRetour = verifyEmail(email2);
            outMap.put('code2',codeRetour);
            if('00'.equals(codeRetour) || '01'.equals(codeRetour) || '03'.equals(codeRetour) || '99'.equals(codeRetour)){
                outMap.put('email2','OK');
            }
            else{
                outMap.put('email2','KO');
            }
        }
        if(!String.isBlank(email3)){
            codeRetour = verifyEmail(email3);
            outMap.put('code3',codeRetour);
            if('00'.equals(codeRetour) || '01'.equals(codeRetour) || '03'.equals(codeRetour) || '99'.equals(codeRetour)){
                outMap.put('email3','OK');
            }
            else{
                outMap.put('email3','KO');
            }
        }
    }


    /* @Author: HEL
    * @Description : Service appelé depuis un OS pour vérifier la validité des emails du contact
    * @CreatedDate : 03/10/2019
    */
    public static void verifyPhoneNumbers(Map<String,Object> inputMap, Map<String,Object> outMap, Map <String,Object> options) {
        String mobile1 = (String) inputMap.get('mobile1');
        String mobile2 = (String) inputMap.get('mobile2');
        String mobile3 = (String) inputMap.get('mobile3');
        String phone1 = (String) inputMap.get('phone1');
        String phone2 = (String) inputMap.get('phone2');
        String phone3 = (String) inputMap.get('phone3');
        String service = (String) inputMap.get('service');

        if('updateContact'.equals(service)){
            String contactId = (String) inputMap.get('contactId');
            Contact contactToUpdate = [SELECT MobilePhone,Mobile_2__c,Mobile_3__c,Phone,Tel_Fixe_2__c,Tel_Fixe_3__c FROM Contact WHERE ID = :contactId];
            if(!String.isBlank(contactToUpdate.MobilePhone)){
                mobile1 = contactToUpdate.MobilePhone.equals(mobile1) ? '' : mobile1;
            }
            if(!String.isBlank(contactToUpdate.Mobile_2__c)){
                mobile2 = contactToUpdate.Mobile_2__c.equals(mobile2) ? '' : mobile2;
            }
            if(!String.isBlank(contactToUpdate.Mobile_3__c)){
                mobile3 = contactToUpdate.Mobile_3__c.equals(mobile3) ? '' : mobile3;
            }
            if(!String.isBlank(contactToUpdate.Phone)){
                phone1 = contactToUpdate.Phone.equals(phone1) ? '' : phone1;
            }
            if(!String.isBlank(contactToUpdate.Tel_Fixe_2__c)){
                phone2 = contactToUpdate.Tel_Fixe_2__c.equals(phone2) ? '' : phone2;
            }
            if(!String.isBlank(contactToUpdate.Tel_Fixe_3__c)){
                phone3 = contactToUpdate.Tel_Fixe_3__c.equals(phone3) ? '' : phone3;
            }
        }


        if(!String.isBlank(mobile1)){
            if('OK'.equals(verifyPhoneNumber(mobile1))){
                outMap.put('mobile1','OK');
            }
            else{
                outMap.put('mobile1','KO');
            }
        }
        if(!String.isBlank(mobile2)){
            if('OK'.equals(verifyPhoneNumber(mobile2))){
                outMap.put('mobile2','OK');
            }
            else{
                outMap.put('mobile2','KO');
            }
        }
        if(!String.isBlank(mobile3)){
            if('OK'.equals(verifyPhoneNumber(mobile3))){
                outMap.put('mobile3','OK');
            }
            else{
                outMap.put('mobile3','KO');
            }
        }
        if(!String.isBlank(phone1)){
            if('OK'.equals(verifyPhoneNumber(phone1))){
                outMap.put('phone1','OK');
            }
            else{
                outMap.put('phone1','KO');
            }
        }
        if(!String.isBlank(phone2)){
            if('OK'.equals(verifyPhoneNumber(phone2))){
                outMap.put('phone2','OK');
            }
            else{
                outMap.put('phone2','KO');
            }
        }
        if(!String.isBlank(phone3)){
            if('OK'.equals(verifyPhoneNumber(phone3))){
                outMap.put('phone3','OK');
            }
            else{
                outMap.put('phone3','KO');
            }
        }
    }

    /* @Author: HEL
    * @Description : Appel api digital pour valider un email du contact
    * @CreatedDate : 03/10/2019
    */
    public static String verifyEmail(String email){

        Map<String,String> listParamsRequest = new Map<String,String> {
            'Email' =>email,
            'Module'  =>'TEL',
            'Rectify' => '1'
        };

        HttpResponse httpResponse =  getResponse('VerifyEmail', listParamsRequest);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());


        Map<String,Object> reponse = (Map<String,Object>) resultAsMap.get('reponse');
        Map<String,Object> retourFonctionnel = (Map<String,Object>) reponse.get('1');
        String codeRetour = (String) retourFonctionnel.get('IdError');
        return codeRetour;
    }


    public static String coverageCode(String email){

        Map<String,String> listParamsRequest = new Map<String,String> {
            'Email' =>email,
            'Module'  =>'TEL',
            'Rectify' => '1'
        };

        HttpResponse httpResponse =  new HttpResponse();
        Map<String,Object> resultAsMap = new Map<String,Object>();
        Map<String,Object> reponse = new Map<String,Object>();
        Map<String,Object> retourFonctionnel = new Map<String,Object>();
        
        
        Map<String,String> listParamsRequest2 = new Map<String,String> {
            'Email' =>email,
            'Module'  =>'TEL',
            'Rectify' => '1'
        };

        HttpResponse httpResponse2 =  new HttpResponse();
        Map<String,Object> resultAsMap2 = new Map<String,Object>();


        Map<String,Object> reponse3 = (Map<String,Object>) resultAsMap.get('reponse');
        Map<String,Object> retourFonctionnel3 = new Map<String,Object>();
        
         Map<String,String> listParamsRequest3 = new Map<String,String> {
            'Email' =>email,
            'Module'  =>'TEL',
            'Rectify' => '1'
        };

        HttpResponse httpResponse3 =  new HttpResponse();
        Map<String,Object> resultAsMap3 = new Map<String,Object>();


        Map<String,Object> reponse4 = (Map<String,Object>) resultAsMap.get('reponse');
        Map<String,Object> retourFonctionnel4 = new Map<String,Object>();
        
        return 'OK';
        

    }


    /* @Author: HEL
    * @Description : Appel api digital pour valider un numéro de téléphone du contact
    * @CreatedDate : 16/10/2019
    */
    public static String verifyPhoneNumber(String phoneNumber){

        Map<String,String> listParamsRequest = new Map<String,String> {
            'tel' =>phoneNumber,
            'module'  =>'TEL',
            'format' => '0',
            'pays'  => 'FRA'
        };

        HttpResponse httpResponse =  getResponse('VerifyPhoneNumber', listParamsRequest);
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(httpResponse.getBody());


        Map<String,Object> reponse = (Map<String,Object>) resultAsMap.get('reponse');
        Map<String,Object> retourFonctionnel = (Map<String,Object>) reponse.get('1');
        if('1'.equals(String.valueOf(retourFonctionnel.get('IdError')))){
            return 'OK';
        }
        else{
            return 'KO';
        }
    }

    /* @Author: HEL
    * @Description : Build the HttpRequest for post method
    * @CreatedDate : 09/07/2018
    */
    public static String buildRequestParams(Map<String,String> listParameters){
        
        String endPoint = '';
        if(listParameters.size()>0){
            endPoint = endPoint +'?';
            Set<String> queryParamsKeys = listParameters.keySet();
            for(String key : queryParamsKeys){
                endPoint=endPoint+key+'='+listParameters.get(key)+'&';
            }
            endPoint = endPoint.substring(0, endPoint.length()-1);

        }
        return endPoint;
    }

    /* @Author: HEL
    * @Description : Envoie de la requete POST
    * @CreatedDate : 03/10/2019
    */
    public static HttpResponse getResponse(String apiSuffix, Map<String, String> listParams) {
        String endpointParams = buildRequestParams(listParams);
        HttpResponse httpResp = CalloutManager.sendRequest(apiSuffix, endpointParams, 'GET', CalloutManager.Scope.READ, null,additionalHeaders);
        if (CalloutManager.httpResponseFailureDetected(httpResp)) {
            // should abort next step's
            system.debug('[SM_AP77_EmailPhoneVerificationService:getResponse] error when sending http request');
            system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
            throw new IOException('[SM_AP77_EmailPhoneVerificationService] : ERROR APPEL API');
        }

        return httpResp;

    }

    public class IOException extends Exception {
    }

}