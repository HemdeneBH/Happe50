/**
 * @File Name          : HP_UTIL_ByPassTrigger.cls
 * @Description        : Classe utility 
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 22/04/2020 à 04:22:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    27/01/2020   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_UTIL_ByPassTrigger {
   
    /**
    * @description Permet de gérer les BypPass au niveau des triggers 
    * @author Sara El-Hannaoui | 27/01/2020 
    * @param String strFieldName 
    * @return Boolean 
    **/
    public static Boolean isByPassTrigger(String strFieldName) {
         Boolean isByPassTrigger = false;
         ByPassSettings__c oTriggerByPass = ByPassSettings__c.getInstance();
         if(oTriggerByPass !=  null && strFieldName !=  null &&  oTriggerByPass.get(strFieldName) !=  null && (Boolean)oTriggerByPass.get(strFieldName) ){
             isByPassTrigger=true;
         }
         return isByPassTrigger;
     }
 
 }