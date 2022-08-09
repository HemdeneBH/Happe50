/**
*    @description : récupère les articles publiés dans la base de connaissance
*    @author : Mickael
*    @projet : SMILE  
*/
global class SM_AP56_KnowledgeArticle implements vlocity_cmt.VlocityOpenInterface {

    global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('getArticle')) {
            try {
                getArticle(inputMap, outMap, options);
              } catch (Exception e) {
                system.debug(e);
                return false;
            }
        }else if(methodName.equals('getArticleByCategorie')){
            try {
                getArticleByCategorie(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }  
        }else if(methodName.equals('getArticleByOffre')){
            try {
                getArticleByOffre(inputMap, outMap, options);
            } catch (Exception e) {
                system.debug(e);
                return false;
            }  
        }
        return true;
    }
    
    
    
    public static void  getArticleByCategorie(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        String CategorieKnowledge = (String) inputMap.get('CategorieKnowledge');
        List<Knowledge__kav> articles; 
        if(CategorieKnowledge == 'Acquisition'){
            String CategorieKnowledgeCHF = 'Acquisition - CHF';
            String CategorieKnowledgeEM = 'Acquisition - EM';
            articles =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE (RecordType.DeveloperName = 'Insert_Omniscript' AND (Categorie_Consigne__c includes (:CategorieKnowledgeCHF) OR Categorie_Consigne__c includes (:CategorieKnowledgeEM)))];
        }
        else{
            articles =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE (RecordType.DeveloperName = 'Insert_Omniscript' AND Categorie_Consigne__c includes (:CategorieKnowledge))];
        }
        //List<Knowledge__kav> articles =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE (RecordType.DeveloperName = 'Insert_Omniscript' AND Categorie_Consigne__c =:  CategorieKnowledge) OR  Cle_Migration__c=:'000001038' OR Cle_Migration__c=:'000001039'];
        Map<String,Object> mapArcticlesByNumber=new Map<String,Object>();
        
        for(Knowledge__kav article : articles){
            mapArcticlesByNumber.put('A_' + article.Cle_Migration__c, article.Consigne__c);
        }
        
        outMap.put('articles',mapArcticlesByNumber);
        system.debug('@@ outMap ' +outMap);
    }
    
    
    
    public static void  getArticle(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        List<Knowledge__kav> articles =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE RecordType.DeveloperName = 'Insert_Omniscript'];
        
        Map<String,Object> mapArcticlesByNumber=new Map<String,Object>();
        
        for(Knowledge__kav article : articles){
           mapArcticlesByNumber.put('A_' + article.Cle_Migration__c, article.Consigne__c);
        }

        outMap.put('articles',mapArcticlesByNumber);
        system.debug('@@ outMap ' +outMap);
    }
      
    
    public static void  getArticleByOffre(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
        //Get Custom metadatatype
        
        //get knowledge in CMDT
        List<Knowledge__kav> articles =[SELECT Cle_Migration__c,Id, Consigne__c FROM Knowledge__kav WHERE RecordType.DeveloperName = 'Insert_Omniscript' AND Cle_Migration__c= '000001103'];
        
        Map<String,Object> mapArcticlesByNumber=new Map<String,Object>();
        
        for(Knowledge__kav article : articles){
           mapArcticlesByNumber.put('A_' + article.Cle_Migration__c, article.Consigne__c);
        }

        outMap.put('articlesOffres',mapArcticlesByNumber);
        system.debug('@@ outMap ' +outMap);
    }   
      
}