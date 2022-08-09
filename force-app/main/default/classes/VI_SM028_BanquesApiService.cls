/*
*@Auhtor: Paul Ghoussoub
*@Description: Appel de l'API SMILE banques
*@CreatedDate: 15/02/2021
*/
public class VI_SM028_BanquesApiService {
/*
*@Auhtor: Paul Ghoussoub
*@Description récupération du nom de la banque grâce à l'IBAN
*@CreatedDate: 15/02/2021
*/
    public static String getInstitutBanqueByIBAN(String IbanNumber,String contexte, String partitionName) {
        Map<String, String> listParameters = new Map<String, String>();
        if(IbanNumber == null){
            System.debug('pas de valeur pour l\'IBAN');
            return null;
        }else{
            String codeGuichet = IbanNumber.substring(4, 14);
            listParameters.put('codeBanqueGuichet', codeGuichet);
            System.debug('PG codeGuichet:'+codeGuichet);
        }
        String token;
        if(!Test.isRunningTest()){
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
        }
        else{
            token = 'test';
        }
        if (token == null) {
            system.debug('Token not found ...');  
            //    return null;
        }
        system.debug('token '+token);
        Map < String, Object > result;
        HttpResponse httpResponse = new HttpResponse();
        //httpResponse = getResponse(token, listParameters);
        httpResponse = VI_UTIL001_HttpUtilities.makeHttpCall(token,'GET',contexte+'_Banques',listParameters,null, contexte);
        if (httpResponse != null) {
            Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
            system.debug('httpResponse.getBody() '+httpResponse.getBody());
            system.debug('resultAsMap '+resultAsMap);
            List < Object > listResult = (List < Object > ) resultAsMap.get('_data');
            
            if (listResult==null || listResult.Size() == 0) {
                system.debug('No data to get the nomInstituBancaire ' + listResult);
                return null;
            }
            // methode qui transform les données retournées par l'api , qui extrait les champ qu'on a besoin au niveau de l'omniscript
            /*transformToOutPut(listResult, outMap);*/
            result = (Map < String, Object >)listResult.get(0);
            System.debug('*** nomInstitutBancaire : ' + result.get('nomInstitutBancaire'));
            return (String)result.get('nomInstitutBancaire');
            //outputMap.put('nomInstitutBancaire',result.get('nomInstitutBancaire'));
            //System.debug('*** output : ' + outputMap);
        }
        return null;
    }
    
}