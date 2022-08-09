/**
 * @File Name          : InfoCouleurController.cls
 * @Description        : Controller de deux LWC (sM_LWC_POC_InfoCouleurVue ET sM_LWC_NbreInfoCouleur)
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Ticket             : FT2-277, FT2-289, FT2-291/ Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
public class InfoCouleurController {

    /**
    * @description: Renvoi un liste des InfoCouleur Actif
    * @return List<InfoCouleur__c> 
    **/
    @AuraEnabled (cacheable=true)
    public static List<InfoCouleur__c> getInfoCouleur(){
        return [Select Id,Name ,Description__c, Couleur__c, Info_Url__c, imgColorSource__c  from InfoCouleur__c where Active__c=true AND Archive__c=false];
    }

    /**
    * @description: Renvoi un liste des InfoCouleur Non Lues
    * @return List<InfoCouleur__c> 
    **/
    @AuraEnabled (cacheable=true)
    public static List<InfoCouleur__c> getNbreInfoCouleurNonLues(){
      	Integer nbreInfocouleur= 0;
        String userId = UserInfo.getUserId();
       List<InfoCouleur__c> infoCouleurNonVue = [select Id,Name ,Description__c, Couleur__c, Info_Url__c, imgColorSource__c, Active__c, Date_de_validit__c, CreatedDate, Nombre_de_vue__c  from InfoCouleur__c  where  Archive__c=false AND Id not in (SELECT Info_Couleur__c FROM Nombre_de_vue__c where User__c =: userId)];
       system.debug('***getNbreInfoCouleurNonLues:'+infoCouleurNonVue);
       
        return infoCouleurNonVue;

    }

    /**
    * @description: Test si la liste des infocrouleur est vide, pour ne pas afficher le carousel
    * @return boolean
    **/
    @AuraEnabled (cacheable=true)
    public static Boolean getCarousel(){
        Boolean ifCarousel=false;
        List<InfoCouleur__c> infoCouleurActives =  [Select Id,Name ,Description__c, Couleur__c, Info_Url__c, imgColorSource__c  from InfoCouleur__c where Active__c=true AND Archive__c=false];
        system.debug('infoCouleurActives :'+infoCouleurActives);
        if(infoCouleurActives!=null && !infoCouleurActives.isEmpty()) {
            ifCarousel = true;
            }else{
                ifCarousel= false;
            }
            system.debug('ifCarousel :'+ifCarousel);
        return ifCarousel;
    }

    /**
    * @description: 3 Methodes qui renvoient le nombre d'infoCouleur non vu par un utilisateur 
    *              suivant la couleur de l'info (Rouge/bleu/violet) 
    * @return Integer 
    **/
    @AuraEnabled (cacheable=true)
    public static Integer getNbreInfoCouleurBleu(){
      	Integer nbreInfocouleur= 0;
        String userId = UserInfo.getUserId();
       List<InfoCouleur__c> infoCouleurNonVue = [select Id, Name  from InfoCouleur__c where Couleur__c = 'Bleue' AND Archive__c=false AND Id not in (SELECT Info_Couleur__c FROM Nombre_de_vue__c where User__c =: userId)];
       system.debug('infoCouleurNonVue:'+infoCouleurNonVue);
       if (infoCouleurNonVue == null || infoCouleurNonVue.isEmpty())
            nbreInfocouleur = 0;
        else
            nbreInfocouleur = infoCouleurNonVue.size();
            system.debug('nbreInfocouleur:'+nbreInfocouleur);
        return nbreInfocouleur;

    }

    @AuraEnabled (cacheable=true)
    public static Integer getNbreInfoCouleurRouge(){
      	Integer nbreInfocouleur= 0;
        String userId = UserInfo.getUserId();
       List<InfoCouleur__c> infoCouleurNonVue = [select Id, Name  from InfoCouleur__c where Couleur__c = 'Rouge' AND Archive__c=false AND Id not in (SELECT Info_Couleur__c FROM Nombre_de_vue__c where User__c =: userId)];
       system.debug('infoCouleurNonVue:'+infoCouleurNonVue);
       if (infoCouleurNonVue == null)
            nbreInfocouleur = 0;
        else
            nbreInfocouleur = infoCouleurNonVue.size();
            system.debug('nbreInfocouleur:'+nbreInfocouleur);
        return nbreInfocouleur;

    }

    @AuraEnabled (cacheable=true)
    public static Integer getNbreInfoCouleurViolette(){
      	Integer nbreInfocouleur= 0;
        String userId = UserInfo.getUserId();
       List<InfoCouleur__c> infoCouleurNonVue = [select Id, Name  from InfoCouleur__c where Couleur__c = 'Violette' AND Archive__c=false AND Id not in (SELECT Info_Couleur__c FROM Nombre_de_vue__c where User__c =: userId)];
       system.debug('infoCouleurNonVue:'+infoCouleurNonVue);
       if (infoCouleurNonVue == null)
            nbreInfocouleur = 0;
        else
            nbreInfocouleur = infoCouleurNonVue.size();
            system.debug('nbreInfocouleur:'+nbreInfocouleur);
        return nbreInfocouleur;

    }

    /**
    * @description:  Au clic sur la carrousel la méthode "createViewBy" de la classe "InfoCouleurController" récupère l'id de l’objet InfoCouleur
                    -> Ajoute un enregistrement de l’objet "Nombre de vues" dans l'onglet associé
                    -> Sinon Implémenter le nombre de vue déjà existant 
    **/
    @AuraEnabled
    public static Nombre_de_vue__c createViewBy(String idInfoCouleur){    
       	String userId = UserInfo.getUserId();
        system.debug('userId:'+userId);
        system.debug('ParameterJs:'+idInfoCouleur);
        String InfoCouleurId=idInfoCouleur;
        system.debug('InfoCouleurId:'+InfoCouleurId);
        List<Nombre_de_vue__c> ExistingView = [Select Id,Name,Nombre_de_vue__c from Nombre_de_vue__c where User__c =: userId AND Info_Couleur__c =: InfoCouleurId ]; 
        system.debug('ExistingView:'+ExistingView);
        if (ExistingView != null && ExistingView.size()>0 )
        {    
        	ExistingView[0].Nombre_de_vue__c = ExistingView[0].Nombre_de_vue__c+1;
            ExistingView[0].Date_de_vue__c = system.today() ;
            update ExistingView[0];
            return ExistingView[0];
        }
        else
        {
            Nombre_de_vue__c ViewBy = new Nombre_de_vue__c(Nombre_de_vue__c =1, User__c=userId,Info_Couleur__c=InfoCouleurId, Date_de_vue__c = system.today()  );
            upsert ViewBy;
            return ViewBy;    
        }
   }       

}