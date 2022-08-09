public without sharing class SM_BAT04_KnowledgeSyncDataCategory implements Database.Batchable<SObject>{

    // Pour capter l'exception s'il y en a
    private Exception[] errors = new Exception[0];
    private String procedureName = 'Smile_IP_KnowledgeSync';
    

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Récupérer les article qui ont ete modifie dans la journée precedente  
        System.debug('start methode');
        DateTime dt = System.Now().addHours(-23);  
        return Database.getQueryLocator([SELECT id,Etape_de_l_omniscript__c , Categorie_Consigne__c ,PublishStatus, Title ,KnowledgeArticleId
                                         FROM Knowledge__kav
                                         WHERE LastModifiedDate >=:dt
                                           AND PublishStatus ='Online' ]);
    }

    public void execute(Database.BatchableContext bc, List<Knowledge__kav> kavToTreat){
        List<Knowledge__kav> kavToUpdate  = new List<Knowledge__kav>();
 
        // On reccupere les datacategory pour chaque article
        Set<Id> kavId = (new Map<Id,SObject>(kavToTreat)).keySet();
        Map<Id,List<String>> kavWithCategory = new Map<Id,List<String>>();  
        for(Knowledge__DataCategorySelection categorySelect : [SELECT id,ParentId, DataCategoryName  
                                                               FROM Knowledge__DataCategorySelection 
                                                               WHERE ParentId IN: kavId 
                                                            ] ) {
            if(kavWithCategory.get(categorySelect.ParentId)  == null){
                kavWithCategory.put(categorySelect.ParentId, new List<String>{(String)categorySelect.DataCategoryName});
            }  else {
                List<String> categorylist = (List<String>)kavWithCategory.remove(categorySelect.ParentId);
                categorylist.add((String)categorySelect.DataCategoryName) ;
                kavWithCategory.put(categorySelect.ParentId, categorylist); 
            }
            for(Id key : kavWithCategory.keySet()){
                if(kavWithCategory.get(key).contains('All')){
                    kavWithCategory.remove(key);
                }
            }
           

        }
        System.Debug('map of data category');
        System.debug(kavWithCategory);

        Set<String> newArticleVersionIds = new Set<String>();
        for(Knowledge__kav  articleKnowledge : kavToTreat){
            if(kavWithCategory.containsKey(articleKnowledge.Id)){
                System.debug('unpublish');
                System.debug('old Id' +articleKnowledge.id );
                // On dépublie chaque article pour créer une nouvelle version et pouvoir les traiter
                String newArticleVersionId = unPublishArticle(articleKnowledge.KnowledgeArticleId);
                if(newArticleVersionId == ''){
                    continue;
                }

                newArticleVersionIds.add(newArticleVersionId);
                // Appel a l'integration procedure pour faire le mapping DataCat vs CatConsigne
                Map <String, Object> ipInput = new Map <String, Object> ();
                List <Object> ipOutput = new List <Object> ();
                Map <String, Object> ipOptions = new Map <String, Object> ();
    
                List <Object> DataCategoryName = kavWithCategory.get(articleKnowledge.Id); 
                System.debug('IP the data: ' + DataCategoryName);
                ipInput.put('DataCategoryName', DataCategoryName);
                System.debug('IP Input: ' + ipInput);
                if(!Test.isRunningTest()){
                    ipOutput = (List <Object>) vlocity_cmt.IntegrationProcedureService.runIntegrationService(this.procedureName, ipInput, ipOptions);
                } else {
                    ipOutput.add( new Map<String,Object>{'Etape' => 'NULL', 'categoryConsigne'=>'Historique factures'});
                    ipOutput.add( new Map<String,Object>{'Etape' => 'CHOIX DE L\'OFFRE', 'categoryConsigne'=>'Changement d\'offre'});
                }

                // traitement du retour de l'IP permettant de récupérer le Mapping DataCat vs CatConsigne
                System.debug('IP Output: ' + ipOutput);
                List<String> listPickListValuesCateConsigne = getPickListValuesCategorieIntoList();
                List<String> listPickListValuesEtape = getPickListValuesEtapeIntoList();
                Set<String> categoriesArticle = new Set<String>();
                String etape = '';
                for(Object obj : ipOutput){
                    System.debug('filtring output');
                    if(obj != null){
                        Map<String,Object> resultMap = (Map<String,Object>) obj;
                        
                        // vérifier si l'étape récupérée depuis l'IP possede un equivalent dans la picklist Etape
                        if((String)resultMap.get('Etape') != 'NULL' && listPickListValuesEtape.contains((String)resultMap.get('Etape'))){
                            etape =  (String)resultMap.get('Etape');
                        } 
                        System.debug('Consigne  ' + resultMap.get('categoryConsigne') );
                        // vérifier si la data category récupérée depuis l'IP possede un equivalent dans la multiPicklist Category Consigne
                        if(listPickListValuesCateConsigne.contains((String)resultMap.get('categoryConsigne'))) {
                            categoriesArticle.add((String)resultMap.get('categoryConsigne'));
                        }
                    } 
                }
                // Mise à jour de la version draft de l'article
                System.debug('new article id: ' + newArticleVersionId);
                if(categoriesArticle.size() > 0 || etape != ''){
                    updateDraftArticleWithoutPublish(concat(categoriesArticle), etape, newArticleVersionId,kavToUpdate);
                    System.debug('All draft articles updated'); 
                }
            } 
        }

        //mass update of articles
        try{
            update kavToUpdate;
            publishArticle(newArticleVersionIds);
        } catch (exception e){
            errors.add(e);
        
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Logger les erreurs d'exception
        if(!errors.isEmpty()) {
            System.debug('### Errors occured during batch process SM_BAT04_KnowledgeSyncDataCategory ###');
            for (Exception e : errors) {
                System.debug(e.getStackTraceString()+'\n');
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                list<ApexEmailNotification> listRecipients = [SELECT UserId, User.Email, Email FROM ApexEmailNotification];
                List<String> recipients = new List<String>();
                for (ApexEmailNotification element : listRecipients ){
                    if(element.Email != null){
                        recipients.add(element.Email);
                    } else if (element.UserId != null) {
                        recipients.add(element.User.Email);
                    }
                }
                mail.setToAddresses(recipients);
                mail.setSubject('Error on SM_BAT04_KnowledgeSyncDataCategory');
                mail.setPlainTextBody(e.getStackTraceString()+'\n');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //envoi de mail vers liste de Apex Exception Email
            }
        }
    }

    public static String concat(Set<String> values) {
        if (values == null) {
            return null;
        } else {
            List<String> l = new List<String>(values);
            l.sort();
            return concat(l);
        }
    }
    
    public static String concat(List<String> values) {
        if (values == null) {
            return null;
        } else {
            return String.join(values, ';');
        }
    }
    
    public static String unPublishArticle(String recordId){ 
        try{
            String newArticleId = KbManagement.PublishingService.editOnlineArticle(recordId, true);
            return [SELECT KnowledgeArticleId 
                    FROM Knowledge__kav 
                    WHERE Id =: newArticleId].KnowledgeArticleId;
        } catch(exception e){
            System.debug('Cannot unpublish Article:' + recordId);
            System.debug(e);
            return   '';
        }  
    }
    
    /**
     * Permet de publier les articles
     */
    public static void publishArticle(Set<String> articleVersionIds) {  
        // la publication ne peut se faire que sur un article a la fois
        for(String avId :articleVersionIds){
            KbManagement.PublishingService.publishArticle(avId, true);
        }
    }

    /**
     * Permet de mettre à jour une version draft de l'article traité
     */
    public static void updateDraftArticleWithoutPublish(String categoriesConsigne, String etape, Id recordId ,List<Knowledge__kav> articles) {
        System.debug('KnowledgeArticleId : ' + recordId);
        try{
            Knowledge__kav newArticle = [SELECT Id,Etape_de_l_omniscript__c,Categorie_Consigne__c, KnowledgeArticleId, Title, UrlName 
                                         FROM Knowledge__kav 
                                         WHERE KnowledgeArticleId =: recordId ];   
            if(etape == '') {
                System.debug('Etape vide pour \'article : ' + newArticle.Id);
            }
            newArticle.Etape_de_l_omniscript__c = etape;

            if(categoriesConsigne == '') {
                System.debug('Category Consigne vide pour l\'article : ' + newArticle.Id);
            }
            newArticle.Categorie_Consigne__c = categoriesConsigne;
            
            System.debug('categorieconsign'+categoriesConsigne);
            System.debug('Id: ' + newArticle.Id);  
            articles.add(newArticle);
        } catch(exception e) {
            System.debug( 'Problem in update SM_BAT04_KnowledgeSyncDataCategory.updateDraftArticleWithoutPublish: '+ e);
        }   
    }    
    
    /**
     * Récupération des valeurs de la picklist Etape de l'objet Base de Connaissance
     */
    public static List<String> getPickListValuesEtapeIntoList(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Knowledge__kav.Etape_de_l_omniscript__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
    
    /**
     * Récupération des valeurs de la picklist Category Consigne de l'objet Base de Connaissance
     */
    public static List<String> getPickListValuesCategorieIntoList(){
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult CatResult = Knowledge__kav.Categorie_Consigne__c.getDescribe();
		List<Schema.PicklistEntry> plc = CatResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : plc){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }

}