/**
 * @File Name          : POC_InfoCouleurVue.cls
 * @Description        : Controlleur de la page VisualForce "DejaLuVFP" qui se declanche avec le bouton "J'ai Lu"
 * @Author             : Jihad AZAMI HASSANI
 * @Ticket             : FT2-277, FT2-289, FT2-291/ Sprint 10
 * Ver       Date            Author      		    Modification
 * 1.0    05/03/2020   Jihad AZAMI HASSANI     Initial Version
**/
public class POC_InfoCouleurVue {
    //Apex properties or variables
    public Id InfoCouleurId { get; set; }
    public InfoCouleur__c info { get; set; }

    //constructor to get the Case record
    public POC_InfoCouleurVue(ApexPages.StandardController controller) {
    info =  (InfoCouleur__c) controller.getRecord();
    InfoCouleurId = info.Id;
    }

    //Method that can is called from the Visual Force page action attribute
    public PageReference InfoCouleurVue() {
       String IdInfoCouleur = createViewBy(InfoCouleurId);
       PageReference pageRef = new PageReference('/'+IdInfoCouleur);
        pageRef.setRedirect(true);
       return pageRef; //Returns to the infocouleur page
    }
    
    /**
    * @description:  Au clic sur le bouton "J'ai Lu"
                    -> Ajoute un enregistrement de l’objet "Nombre de vues" dans l'onglet associé
                    -> Sinon Implémenter le nombre de vue déjà existant 
    **/
    public static String createViewBy(String InfoCouleurId){    
       	String userId = UserInfo.getUserId();
        system.debug('userId:'+userId);
        //String InfoCouleurId = InfoCouleur.substringAfter('lightning.force.com/');
        system.debug('InfoCouleurId:'+InfoCouleurId);
        //Info_Couleur__c 
        List<Nombre_de_vue__c> ExistingView = [Select Id,Name,Nombre_de_vue__c from Nombre_de_vue__c where User__c =: userId AND Info_Couleur__c =: InfoCouleurId ]; 
        if (ExistingView != null && ExistingView.size()>0 )
        {    
        	ExistingView[0].Nombre_de_vue__c = ExistingView[0].Nombre_de_vue__c+1;
            ExistingView[0].Date_de_vue__c = system.today() ;
            update ExistingView[0];
            return InfoCouleurId;
        }
        else
        {
            Nombre_de_vue__c ViewBy = new Nombre_de_vue__c(Nombre_de_vue__c =1, User__c=userId,Info_Couleur__c=InfoCouleurId, Date_de_vue__c = system.today()  );
            upsert ViewBy;
            return InfoCouleurId;    
        }
       	
   }       

}