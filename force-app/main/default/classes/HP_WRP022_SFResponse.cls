/**
 * @File Name          : HP_WRP022_SFResponse.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 27/02/2020 à 15:06:45
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    07/02/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class HP_WRP022_SFResponse {

    public Integer code;
    public String message;
    
    public List<Information> errors;
    public List<Information> warnings;
    public List<Information> infos;

    public Object output;
    
    public HP_WRP022_SFResponse(Integer code) {
        this.code = code;
        errors = new List<Information>();
        warnings = new List<Information>();
        infos = new List<Information>();
    }

    public void addInfo(String code, String message) {
        System.System.debug( '@@ResponseInfo : '+ code + '  ' + message);
        this.infos.add(new Information(code, message));
    }

    public void addError(String code, String message) {
        System.System.debug( '@@ResponseError : '+ code + '  ' + message);
        this.errors.add(new Information(code, message));
        this.infos.clear();
    }

    public void addWarning(String code, String message) {
        System.System.debug( '@@ResponseWarning : '+ code + '  ' + message);
        this.warnings.add(new Information(code, message));
    }
    
    public class Information {
         public Information(String code, String message) {
             this.code = code;
             this.message = message;
         }
        public String code;
        public String message;

    }

    public class APIException extends Exception {}

}