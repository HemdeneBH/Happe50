/**
 * @Author: Amar KAILLO
 * @CreatedDate: 29/04/2021
 * @ClassName: SM_VFC_ET12Body_CTRL
**/
public class SM_VFC_ET12Body_CTRL {
    public String caseId {get; set;}
    public Map<String, String> result {set;} 
    public SM_VFC_ET12Body_CTRL() {
    }
    /**
     * @Author: Amar KAILLO
	 * @CreatedDate: 29/04/2021
     * @Return: Map of Key - Value
     * @Description: Getter to parse Omniscript Json in order to be sent as email details by process builder _ Utilisé dans le cas de EMDM Harmonica pour la partie Résiliation du mail
    **/
    public Map<String, Object> getResult() {
        /* We can not pass a long String in VF Component. that's why we are using a DML */
        system.debug('caseId' + caseId);
        List<Case> cases = [SELECT status, id, Sous_type__c,Vlocity_SendMailJson_Resil__c  FROM Case WHERE Id =: caseId];        
       
        Map<String, Object> result = new Map<String, Object>();
        system.debug('cases '+cases); 
        system.debug('sendMailJson '+cases[0].Vlocity_SendMailJson_Resil__c );
        
        if(!cases.isEmpty() && !String.isBlank(cases[0].Vlocity_SendMailJson_Resil__c  )) {
            
           result = (Map<String, Object>)JSON.deserializeUntyped(cases[0].Vlocity_SendMailJson_Resil__c );
           
        }
        system.debug('### result '+result);
        return result;
    }
}