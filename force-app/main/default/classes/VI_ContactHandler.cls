/* 
 * @description:Handler trigger contact
 * @projet:Pure player
 *
 *
 * @Modified by : Paul Ghoussoub
 * @Date : 14/9/2021
 * @Description:Optimisation trigger avec le pattern 0'hara.
 */
public with sharing class VI_ContactHandler extends TriggerHandler{
    private Map<Id, Contact> oldMap;
    private Map<Id, Contact> newMap;
    private List<Contact> oldList;
    private List<Contact> newList;
    Set<Id> emailsChanged = new Set<Id>();
    
    public VI_ContactHandler() {
        this.oldMap = (Map<Id, Contact>) Trigger.oldMap;
        this.newMap = (Map<Id, Contact>) Trigger.newMap;
        this.oldList = (List<Contact>) Trigger.Old;
        this.newList = (List<Contact>) Trigger.New;
    }
    public override void beforeInsert(){
         system.debug('in vi before insert');
         VI_SM045_CreerUtilisateurPartenaire.remplirUserNameContact(this.newList);
    }
    public override void afterInsert(){
         system.debug('in vi after insert');
         VI_SM045_CreerUtilisateurPartenaire.creerUtilisateur(this.newMap);
    }
     public override void afterUpdate(){
         system.debug('in vi after update');
         VI_SM045_CreerUtilisateurPartenaire.creerUtilisateur(this.newMap);
    }
}