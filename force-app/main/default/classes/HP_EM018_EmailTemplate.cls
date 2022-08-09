/**
 * @File Name          : HP_EM_018_EmailTemplate.cls
 * @Description        : 
 * @Author             : Mohamed Aamer
 * @Group              : 
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 27/01/2020 à 15:58:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/01/2020   Mohamed Aamer     Initial Version
**/
public with sharing class HP_EM018_EmailTemplate {

  public static EmailTemplate getEmailTemplateByName(String templateName) {
    try {
      List<EmailTemplate> templateList = [
          SELECT id, Subject, HtmlValue, Body
          FROM emailTemplate
          WHERE developerName = : templateName
          LIMIT 1
        ];
      return templateList[0] ;
    } catch (Exception e) {
      return null ;
    }

  }
}