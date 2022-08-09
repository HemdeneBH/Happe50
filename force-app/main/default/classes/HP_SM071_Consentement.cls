/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class HP_SM071_Consentement {
    
    public static HP_MajConsentements__c createConsentement(Contact c, Boolean consentement, Decimal xDataId, Integer questionId, Integer questionnaireID, String source, String canal) {
        HP_MajConsentements__c cons = new HP_MajConsentements__c();
        cons.HP_Contact__c = c.Id;
        cons.HP_Consentement__c = consentement;
        cons.HP_IdXDATA__c = xDataId;
        cons.HP_IdQuestionConsentement__c = questionId;
        cons.HP_IdQuestionnaireConsentement__c = questionnaireID;
        cons.HP_Source__c = source;
        cons.HP_Canal__c = canal;
        return cons;
    }
}