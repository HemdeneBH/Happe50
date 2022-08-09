/**
 * @Author: Maha Ghayouba
 * @CreatedDate: 04/02/2019
 * @ClassName: SM_AP55_ParseCaseJson
**/
public class SM_AP55_ParseCaseJson {
    public String caseId {get; set;}
    public Map<String, String> result {set;}
    /* SM_AP55_ParseCaseJson Conctructor */
    public SM_AP55_ParseCaseJson() {
    }
    
    
    /**
     * @Author: Maha Ghayouba
     * @CreatedDate: 04/02/2019
     * @Return: Map of Key - Value
     * @Description: Getter to parse Omniscript Json in order to be sent as email details by process builder
    **/
    public Map<String, Object> getResult() {
        /* We can not pass a long String in VF Component. that's why we are using a DML */
        
        List<Case> cases = [SELECT status, id, Sous_type__c,Vlocity_SendMailJson__c FROM Case WHERE Id =: caseId];        
       
        Map<String, Object> result = new Map<String, Object>();
        
        if(!cases.isEmpty() && !String.isBlank(cases[0].Vlocity_SendMailJson__c )) {
            
           result = (Map<String, Object>)JSON.deserializeUntyped(cases[0].Vlocity_SendMailJson__c);
           
            //Ces clés sont évaluées dans les components VFC, si elle n'existe pas alors ca plante au runtime.
            if (!result.containsKey('isEMM_Harmonica')){
                result.put('isEMM_Harmonica', false);
        }
      
            if (!result.containsKey('chooseSellingOption')){
                result.put('chooseSellingOption', '');
            }

            if (!result.containsKey('containOptionVertes')){
                result.put('containOptionVertes', false);
            }

            if (!result.containsKey('containAssuranceFacture')){
                result.put('containAssuranceFacture', false);
            }

            if (!result.containsKey('containServicesPayants')){
                result.put('containServicesPayants', false);
            }

            if (!result.containsKey('EnergyIsElec')){
                result.put('EnergyIsElec', false);
            }

        }
      
        system.debug('### result '+result);
        return result;
    }
}