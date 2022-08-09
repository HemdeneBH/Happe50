/**
 * @description       : Controller of the VF Page :=> HP_LiveAgent_feedback.page
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class HP_VF_LiveAgentFeedBack_Controller {

    public String score {get; set;}
    public Boolean oed {get; set;}
    public String verbatim {get; set;}
    public String chatDetails {get; set;}
    public String attachedRecords {get; set;}

    public Boolean getShow(){

        try{
            String cId = getCase(attachedRecords);
            String ctype = getcaseType(attachedRecords,cId);
            if(cId == null){
                return false;
            }else{
                if(ctype == 'HP_ChatIndispo'){
                    return false;
                }else{
                    return true;
                }
            }   
        }catch(Exception e){
            System.debug('The following exception has occurred get the parameter showEnqete" : ' + e.getMessage());
            return false;
        } 
    }

    public HP_VF_LiveAgentFeedBack_Controller(){
        attachedRecords = ApexPages.currentPage().getParameters().get('attachedRecords');
        chatDetails = ApexPages.currentPage().getParameters().get('chatDetails');

    }

    public PageReference saveNoteSat(){
        System.debug('save');
        
        try{
        HP_NoteDeSatisfaction__c note = new HP_NoteDeSatisfaction__c();
        note.HP_satisfaction_date__c= System.Today();
        note.HP_satisfaction_status__c = 'complété';
        note.HP_satisfaction_score__c = Decimal.valueOf(score);
        note.HP_satisfaction_OeD__c = oed==true?'Oui' :'Non';
        note.HP_satisfaction_verbatim__c = verbatim ;
        note.HP_satisfaction_canal__c = 'Chat';
        note.HP_Agent__c = getUserId(chatDetails); 
        note.HP_client_id__c = GetClientId(chatDetails);
        note.HP_Case__c= getCase(attachedRecords);
        insert note;
        System.debug('test note de sat creatrion '+ note);
        return Page.HP_LiveAgent_ThankYouMessage;


        }catch(Exception e){
            System.debug('The following exception has occurred while creating "note de satisfaction" : ' + e.getMessage());
        return Page.HP_LiveAgent_ThankYouMessage;
        }
        
    }

    public String getUserId(String chatd){
        
        try{
            Map<String ,Object> m = (Map<String, Object>) JSON.deserializeUntyped(chatd);
            Map<String, Object> agent = (Map<String, Object>) m.get('agent');
            String userId = (string)agent.get('userId');
            return userId;
        }catch(Exception e){
            System.debug('The following exception has occurred while getting the agent (user) ID : ' + e.getMessage());
            return null;
        }
    }

    public Decimal GetClientId(String attRec){

        try{
            Map<String ,Object> m = (Map<String, Object>) JSON.deserializeUntyped(attRec);
            String cId = (String) m.get('ContactId');
            Contact c = [SELECT Id, ID_Tiers__c FROM Contact WHERE Id =:cId Limit 1][0];
            Decimal IdTier = c.ID_Tiers__c;

            
            return Idtier;
        }catch(Exception e){
            System.debug('The following exception has occurred while getting the Contact ID : ' + e.getMessage());
            return null;
        }
    }
    public String getCase(String attRec){
        
        try{
            Map<String ,Object> m = (Map<String, Object>) JSON.deserializeUntyped(attRec);
            String caseId = (String) m.get('CaseId');
            return caseId;
        }catch(Exception e){
            System.debug('The following exception has occurred while getting the agent (user) ID : ' + e.getMessage());
            return null;
        }
    }

    public String getCaseType(String attRec, String cId){
        try{
            if (cId == null){
                return null;
            }
            else{
                case c = [SELECT Id,HP_Type__c FROM Case WHERE Id =:cId Limit 1][0];
                String ctype = c.HP_Type__c;
                return ctype;
            }
        }catch(Exception e){
            System.debug('The following exception has occurred while getting the case type : ' + e.getMessage());
            return null;
        }
    }
}