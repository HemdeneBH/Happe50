/**
 * @File Name          : HP_EM030_Knowledge.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/05/2020 à 04:15:50
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/05/2020   Vincent Albiser     Initial Version
**/
public class HP_EM030_Knowledge {
    
    public static void setDataCategories(List<Knowledge__kav> kList){
        
        List<Knowledge__DataCategorySelection> categoriesList = [SELECT ParentId, toLabel(DataCategoryName) FROM Knowledge__DataCategorySelection
            WHERE ParentId IN :kList];

        Map<Id, String> datacategoryNameMap = new Map<Id, String>();
        for(Knowledge__DataCategorySelection category : categoriesList){   
            if(datacategoryNameMap.containsKey(category.ParentId)){
                String str =  datacategoryNameMap.get(category.ParentId);
                datacategoryNameMap.put(category.ParentId, str + ',' + category.DataCategoryName);
            }
            else{
                datacategoryNameMap.put(category.ParentId, category.DataCategoryName);
            }
        }       
        
        for(Knowledge__kav article : kList){
            article.HP_TECH_DataCategories__c = '';
            if(datacategoryNameMap.containsKey(article.Id)){
                article.HP_TECH_DataCategories__c = datacategoryNameMap.get(article.Id);
            }
        }
    }    
}