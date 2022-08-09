/*
* @Author: Ibrahim Merabti
* @Date: 20/04/2020
* @Description: Apex controller for visualforce email template 
*/
global inherited sharing class SM_HarmonicaEmailTemplates { 
    global String caseId {get;set;}
    global String dvFieldName {get;set;}
    global String complementText {get;set;}
    global String dvValue{
        get{
            String cleanCaseId = String.escapeSingleQuotes(CaseId);

            // Si le champ demandé est "Code_pack__c", requeter la base des produits pour récupérer le libélle du produit correspondant
            if(dvFieldName == 'Code_pack__c') {
                Donnees_Vente__c[] codePack = [select Code_pack__c from Donnees_Vente__c where CaseId__c  =:cleanCaseId WITH SECURITY_ENFORCED];
                //Donnees_Vente__c[] codePack = [select Code_pack__c from Donnees_Vente__c where CaseId__c  =:CaseId];
                if(codePack.size() > 0){
                    List<Product2> product = [select familyLabel__c from product2 where Family =: codePack[0].Code_pack__c WITH SECURITY_ENFORCED limit 1];   
                    //List<Product2> product = [select familyLabel__c from product2 where Family =: codePack[0].Code_pack__c limit 1];
                    if(product.size() > 0){
                        return product[0].familyLabel__c;
                    }   
                }
                
                
            }
            // Si le champ demandé est défferent de "Code_pack__c", récuperer le dynamiquement     
            else{
                String cleandvFieldName = String.escapeSingleQuotes(dvFieldName);

                String recordQuery = 'SELECT  '+cleandvFieldName+ ' FROM Donnees_Vente__c WHERE CaseId__c =:cleanCaseId WITH SECURITY_ENFORCED';
                List<Donnees_Vente__c> dvRecord  = Database.query(recordQuery);   
                
                Map<String, Schema.SObjectField> theSobjectMap = Schema.SObjectType.Donnees_Vente__c.fields.getMap();
                Schema.SObjectField field = theSobjectMap.get(dvFieldName);
                if(field.getDescribe().getType()==Schema.DisplayType.DATE){
                    return(String) DateTime.valueOf(string.valueOf(dvRecord[0].get('Date_resiliation__c'))).format('dd/MM/yyyy');                    
                }else{
                    return (String) dvRecord[0].get(dvFieldName); 
                }
                
            }
            return null;
            
        } set;}
    
}