/**
 * @File Name          : HP_EM001_DQE.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 25/03/2020 à 14:56:01
 * @Modification Log   : 
 * Ver       Date            Author                  Modification
 * 1.0    20/01/2020   Mouhamadoune Coulibaly     Initial Version
**/ 
public with sharing class HP_EM0017_DQE {

 

    /**
    * @description 
    * @author Mouhamadoune Coulibaly | 20/01/2020 
    * @param email 
    * @return HP_WRP001_DQEemail retourne des informations sur la validité de l'email
    **/
    public static HP_WRP0017_DQEemail getEmailValidation(String email){
        String body =  HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PROTECTED_DQE_MAIL, '/?Email='+email).getBody();
        Map<String,Object> resultAsMap =  (Map<String,Object>) JSON.deserializeUntyped(body);
        HP_WRP0017_DQEemail outputData = (HP_WRP0017_DQEemail)HP_ParseUtils.convert(resultAsMap.get('1'),HP_WRP0017_DQEemail.class );
        System.debug('HP_WRP001_DQEemail.response.outputData : ' + JSON.serialize(outputData));
        return outputData;

 

    }
     /**
     * @description 
     * @author Mouhamadoune Coulibaly | 22/01/2020 
     * @param telephone 
     * @return HP_WRP0018_DQEtelephone retourne des informations sur la validité du numero de telephone
     **/
     public static HP_WRP0018_DQEtelephone getTelephoneValidation(String telephone, String pays){
       
        String param = '/?Pays='+pays+'&Tel='+telephone+'&Format=3';
        String body =  HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_PROTECTED_DQE_TEL, param).getBody();
        Map<String,Object> resultAsMap =  (Map<String,Object>) JSON.deserializeUntyped(body);    
        HP_WRP0018_DQEtelephone outputData = (HP_WRP0018_DQEtelephone)HP_ParseUtils.convert(resultAsMap.get('1'),HP_WRP0018_DQEtelephone.class );
        System.debug('HP_WRP0018_DQEtelephone.response.outputData : ' + JSON.serialize(outputData));
        return outputData;
         
    }
    

 

}
 
    // HP_EM0017_DQE.getTelephoneValidation('0613035600','FRA');
    // HP_EM0017_DQE.getEmailValidation('momo@enib.fr');