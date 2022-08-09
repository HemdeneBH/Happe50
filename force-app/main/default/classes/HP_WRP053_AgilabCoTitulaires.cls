/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 07-27-2022
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_WRP053_AgilabCoTitulaires {
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public Output output;


    public class Output {
        @AuraEnabled
        public List<CoTitulaire> co_titulaires;
    }

    public class CoTitulaire {
        @AuraEnabled
        public String civilite;
        @AuraEnabled
        public String nom;
        @AuraEnabled
        public String prenom;
    }
    
    public static HP_WRP053_AgilabCoTitulaires parse(String json) {
        return (HP_WRP053_AgilabCoTitulaires) System.JSON.deserialize(json, HP_WRP053_AgilabCoTitulaires.class); 
	}
}