/* 
 * @description:Handler trigger ServiceRessourceSkill
 * @projet:Smile
 *
 *
 * @Modified by : Mohamed Amine El Mandour
 * @Date : 29/10/2021
 * @Description:Routage des skills elligible.
 */
public class SM_ServiceRessourceSkillHandler extends TriggerHandler{
    private Map<Id, ServiceResourceSkill> oldMap;
    private Map<Id, ServiceResourceSkill> newMap;
    private List<ServiceResourceSkill> oldList;
    private List<ServiceResourceSkill> newList;
    
    // a modifier pour que ca ne soit plus en dure
    //final private Map<String,String> siteMatrix = new Map<String,String>{'Equipe 1 Fes DSPC DGP' => 'Sitel Fes','Equipe 1 TVE COMDATA Poitiers DGP'=>'COMDATA Poitiers','Equipe 1 Televente Euro CRM Lisieux DGP'=>'Euro CRM Lisieux'};
    //final private Map<String,String> skillMatrix = new Map<String,String>{'Sitel_Fes'=>'Sitel Fes','Comdata_Poitiers'=>'COMDATA Poitiers','EuroCRM_Lisieux'=>'Euro CRM Lisieux','WEB PARTICULIER' => 'Web particulier','PARTENAIRE CO'=>'Partenaire co','SERVICE PAYANT' => 'Service Payant', 'OFFRE REFERENCE'=>'Offre référence','Première MES' => 'Première MES'};
    
    public SM_ServiceRessourceSkillHandler() {
        this.oldMap = (Map<Id, ServiceResourceSkill>) Trigger.oldMap;
        this.newMap = (Map<Id, ServiceResourceSkill>) Trigger.newMap;
        this.oldList = (List<ServiceResourceSkill>) Trigger.Old;
        this.newList = (List<ServiceResourceSkill>) Trigger.New;
    }
    
    public override void beforeInsert(){
            SM_AP93_ServiceRessourceSklHandler.checkSkillValidForUserSite(newList);
    }
}