/*
*@Author: Eloi Dereeper
*@Description: Gestion des appels à VI_VerifyEmail et VI_VerifyPhoneNumber
*@CreatedDate: 27/10/2020
*@LastModified: 27/10/2020
*/
global class VI_SM001_EmailPhoneVerificationService {
/**
* @author Eloi Dereeper
* @date 27/10/2020
* @description Appel webservice pour vérfier l'email
* @param email, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return Si l'email est vérfié ou pas
*/
    public static String verifyEmail(String email, String contexte, String partitionName){
        //To test: VI_SM001_EmailPhoneVerificationService.verifyEmail('amal.chreiteh@eit-mena.com', 'VI', 'local.VIToken' );
        Map<String, String> listParamsRequest = new Map<String, String>();
        listParamsRequest.put('Email', email);
        listParamsRequest.put('Module', 'PARTNERCOMMUNITY');
        listParamsRequest.put('Rectify', '1');
        String token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        system.debug('token '+token);
        if (token == null) {
            return null;
        }
        system.debug('mail paul debug 29');
        try{
            HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET', contexte+ '_VerifyEmail', listParamsRequest, null, contexte);
            EmailPhoneVerificationResponseWrapper emailVerifyWrapper = parse(httpResponse.getBody());
            system.debug('emailVerifyWrapper '+emailVerifyWrapper);
            system.debug('emailVerifyWrapper.code '+emailVerifyWrapper.code);
            if(emailVerifyWrapper.code != null){
                return emailVerifyWrapper.message;
            }
            if(emailVerifyWrapper!=null &&emailVerifyWrapper.reponse!=null &&emailVerifyWrapper.reponse.data!=null &&emailVerifyWrapper.reponse.data.idError!=null ){
                String codeRetour =  emailVerifyWrapper.reponse.data.idError;
                String acceptedCodeRetour = '00;01;03;99';
                System.debug('codeRetour'+ codeRetour);
                if(acceptedCodeRetour.contains(codeRetour)){
                    return 'OK';
                }
                else{
                    return 'KO';
                }
            }
            else{
                return 'Erreur lors de l\'appel';
            }
        }catch (Exception e) {
            return 'Erreur :' + e.getmessage();
        }
    }
/**
* @author Eloi Dereeper
* @date 27/10/2020
* @description Appel webservice pour vérfier le numéro
* @param email, contexte (HP,SM,VI), partitionName (local.VIToken,local.smileToken)
* @return Si le numéro est vérfié ou pas
*/
    public static String verifyPhoneNumber(String phoneNumber, String contexte, String partitionName){
        //to Test: VI_SM001_EmailPhoneVerificationService.verifyPhoneNumber('0528723682', 'VI', 'local.VIToken' );
        Map<String, String> listParamsRequest = new Map<String, String>();
        system.debug('phoneNumber '+phoneNumber);
        listParamsRequest.put('tel', phoneNumber);
        listParamsRequest.put('module', 'TEL');
        listParamsRequest.put('format', '0');
        listParamsRequest.put('pays', 'FRA');
        String token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        system.debug('token '+token);
        if (token == null) {
            return null;
        }
        try{
            HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET', contexte+'_VerifyPhoneNumber', listParamsRequest, null, contexte);
            system.debug(VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody()));
            if(httpResponse.getStatusCode() == 503){
                return 'Erreur : Service Temporarily Unavailable';
            }
            EmailPhoneVerificationResponseWrapper phoneVerifyWrapper = parse(httpResponse.getBody());
            system.debug('phoneVerifyWrapper '+phoneVerifyWrapper);
            if(phoneVerifyWrapper.code != null){
                return phoneVerifyWrapper.message;
            }
            String codeRetour =  phoneVerifyWrapper.reponse.data.idError;
            String acceptedCodeRetour = '00;01;03;99';
            System.debug('codeRetour'+ codeRetour);
            if(acceptedCodeRetour.contains(codeRetour)){
                return 'OK';
            }
            else{
                return 'KO ' + phoneVerifyWrapper.message;
            }
        }catch (Exception e) {
                return 'Erreur :'+ e.getmessage();
        }
    }
    /**
* @author Eloi Dereeper
* @date 27/10/2020
* @description Wrapper du retour de l'appel
*/ 
    public class EmailPhoneVerificationResponseWrapper{
        public String statut;   //OK
        public cls_reponse reponse;
        public String code; //null si 200, 201 ou 206
        public String name;
        public String message;
    }
    class cls_reponse {
        public cls_1 data;
    }
    class cls_1 {
        public Integer Redressement;    //0
        public String eMailOrigine; //amal.chreiteh@eit-mena.com
        public String IdError;  //00
        public String eMail;    //amal.chreiteh@eit-mena.com
        public String TelOrigine;   //0649351535
        public String Geolocation;  //METROPOLE
        public String Tel;  //0649351535
        public String Ported;   //
        public String Operator; //
        public String OldOperator;  //ORANGE
        public String Type; //MOBILE
    }
    public static EmailPhoneVerificationResponseWrapper parse(String response){ 
        response = VI_UTIL001_HttpUtilities.handleResponse(response);
        system.debug('response '+response);
        return (EmailPhoneVerificationResponseWrapper) System.JSON.deserialize(response, EmailPhoneVerificationResponseWrapper.class);
    }
    
}