/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-22-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_WRP048_OktaUser {

    public class Request{
        @AuraEnabled
        public OktaProfile profile;
    
        @AuraEnabled
        public OktaCredentials credentials;
    
        @AuraEnabled
        public List<String> groupIds;

        public Request(HP_PortailUtilisateur__c user){
            this.profile = new OktaProfile();
            this.credentials = new OktaCredentials();
            this.groupIds = new List<String>();
            this.profile.login                  = user.Login__c;
            this.credentials.password.value     = user.Password__c;
            this.profile.lastName               = user.Nom__c;
            this.profile.firstName              = user.Prenom__c;
            this.profile.email                  = user.Login__c;
            for(String groupId : HP_UTIL_MetadataManager.getConfigByKey(HP_Constantes.HP_OKTA_GROUP_ID).split(';')){
                this.groupIds.add(groupId);
            }
        }   
    }

    public class ResponseSuccess{
        @AuraEnabled
        public final String id;
        @AuraEnabled
        public final String status;
        @AuraEnabled
        public final String created;
        @AuraEnabled
        public final String activated;
        @AuraEnabled
        public final String statusChanged;
        @AuraEnabled
        public final String lastLogin;
        @AuraEnabled
        public final String lastUpdated;
        @AuraEnabled
        public final String passwordChanged;

        @AuraEnabled
        public OktaType type;

        @AuraEnabled
        public OktaProfile profile;

        @AuraEnabled
        public OktaCredentials credentials;

        @AuraEnabled
        public OktaLinks links;

    }

    public class ResponseFailure{
        @AuraEnabled
        public final String errorCode;
        @AuraEnabled
        public final String errorSummary;
        @AuraEnabled
        public final String errorLink;
        @AuraEnabled
        public final String errorId;

        @AuraEnabled
        public List<OktaErrorCause> errorCauses;

    }
    
    public class OktaProfile{
        @AuraEnabled
        public final String firstName;

        @AuraEnabled
        public final String lastName;

        @AuraEnabled
        public final String email;

        @AuraEnabled
        public final String login;

        @AuraEnabled
        public final String mobilePhone;

        @AuraEnabled
        public final String secondEmail;

    }

    public class OktaCredentials{
        @AuraEnabled
        public OktaPassword password;

        @AuraEnabled
        public List<OktaEmail> emails;

        @AuraEnabled
        public OktaProvider provider;

        public OktaCredentials(){
            this.password = new OktaPassword();
        }
    }

    public class OktaPassword{
        @AuraEnabled
        public String value;
    }

    public class OktaEmail{
        @AuraEnabled
        public String value;
        @AuraEnabled
        public String status;
        @AuraEnabled
        public String type;
    }

    public class OktaProvider{
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String name;
    }

    public class OktaType{
        @AuraEnabled
        public String id;
    }

    public class OktaLinks{
        @AuraEnabled
        public OktaLinkPrototypeMethod suspend;

        @AuraEnabled
        public OktaLinkPrototype schema;

        @AuraEnabled
        public OktaLinkPrototypeMethod resetPassword;

        @AuraEnabled
        public OktaLinkPrototypeMethod forgotPassword;

        @AuraEnabled
        public OktaLinkPrototypeMethod expirePassword;

        @AuraEnabled
        public OktaLinkPrototypeMethod changeRecoveryQuestion;

        @AuraEnabled
        public OktaLinkPrototype self;

        @AuraEnabled
        public OktaLinkPrototype type;

        @AuraEnabled
        public OktaLinkPrototypeMethod changePassword;

        @AuraEnabled
        public OktaLinkPrototypeMethod deactivate;
    }

    public class OktaLinkPrototype{
        @AuraEnabled
        public String href;
    }

    public class OktaLinkPrototypeMethod{
        @AuraEnabled
        public String href;
        @AuraEnabled
        public String method;
    }
    
    public class OktaErrorCause{
        @AuraEnabled
        public String errorSummary;
    }
}