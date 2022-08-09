/**
 * @File Name          : HP_KnowledgeTriggerHandler.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 19/05/2020 à 03:07:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/05/2020   Vincent Albiser     Initial Version
**/
public class HP_KnowledgeTriggerHandler {

    public static void execute(){
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            HP_EM030_Knowledge.setDataCategories((List<Knowledge__kav>) Trigger.new);
        }
    }
}