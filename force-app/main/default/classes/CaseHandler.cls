/**
@Author <Raouaa Jmour>
@name <CaseHandler>
@CreatedDate <19/03/2020>
@Description <Handler Trigger for CaseTrigger>
@Version <1.0>
@ModifiedBy <Raouaa Jmour>
*/


public with sharing class CaseHandler extends TriggerHandler {

    private List<Case> newList;
    String smileRecordTypeIds = System.Label.SM_Case_RecordTypeIds;
    String smileCaseDuplicateErrorMessage = System.Label.SM_CaseDuplicate_ErrorMessage;
    
    public CaseHandler() {
        this.newList = (List<Case>) Trigger.New;
    }

    public override void beforeInsert(){

        for(Case c : newList){

            
            //Pour les cases Smile : Empêcher la création des cases en double 
            //quand on fait un refresh de la page avec un parcours déjà ouvert
            if(smileRecordTypeIds.contains(c.recordTypeId)){
                Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.smileToken');
                //La variable createCase est settée à '1' au clic sur le lien qui va lancer le parcours
                //à partir de la vue 360.
                String varCache = (String)sessionPart.get('createCase');
                System.debug('varCache :'+ varCache);
    
                //Si la variable createCase est à '1' => c'est un cas normal (pas un refresh) donc on 
                //permet la création du case et on la met à jour à '0'.
                if(varCache == '1'){
                System.debug('Value to be set to 0');
                sessionPart.put('createCase', '0');
    
                }
                //Si la variable createCase est à '0' => c'est forcément un refresh  donc on 
                //bloque la création du case.
                else if (varCache == '0'){
                c.adderror(smileCaseDuplicateErrorMessage);
                }
    
            }
    
        
        }
    }
}