@isTest
public  class SM_AP41_PrestaServiceElecOnlineRes_Test {
    /*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: test method to invoke creerPrestationGaz
*/
    static testMethod void SM_AP41_PrestaServiceElecOnlineRes_Test() {
        
        String inputString = '{"NOEXISTINGJSON":{},"Complement":"","getVille":"PARIS","getStreet":"RUE POLIVEAUDVDVD","getNoVoie":"12","getCodePostal":"75018","getFix":"01 34 12 78 50","idPdl":"01199999844520","ChoixProcedureAutoItv":"Intervention","PrestationDistrib":{"TypeDeCompteur":"Historique","statutCompteurLibelle":"Autre DISCO non téléopérable N0","Statut":"A initier","SituationVente":"Resiliation","SIContractuel":"DISCO","SecteurActivite":"Elec","NumeroPDLPCE":"01199999844520","NiveauOuvertureAuxServices":"Niveau 0","NbCadrans":1,"Matricule":"875","Index":8937,"id":"a4O6E000000HYqlUAG","EtatPDL":"En service","EtatDuCompteur":"non coupe","StatutDuCompteur":"non coupe","ElecRepriseIndexMHS":false,"ElecInterventionObligatoire":false,"ElecInterventionOption":true,"ElecAutoreleve":true,"DatePrestation":"2019-11-22","Accessibilite":"Accessible","DateDernierIndex":"2019-03-06"},"autoreleveElec":{"IndexHPvalide":true,"IndexBasevalide":true,"IndexHCvalide":true,"Base":null,"TourCadranBase":false,"AlerteIndexBaseNonvalide":null,"HP":123,"TourCadranHP":null,"AlerteIndexHPNonvalide":null,"HC":123,"TourCadranHC":null,"AlerteIndexHCNonvalide":null},"LINKYlv2":false,"LINKYlv1":false,"CreaneauElec":"jou","getPrenom":"Anna","getNom":"GRAMME","getCivilite":"MR et MME","DateOpsElecForm":"2019-11-22T00:00:00","getIdBP":"0309022754","idContrat":"6011930586","InterventionElec":{"InterventionElecObligato":"Non Obligatoire","CiviliteOpsElec":"MR et MME","NomOpsElec":"GRAMME","PrenomOpsElec":"Anna","TelephoneOpsElec":"01 34 12 78 50","CommentairesOpsElec":"PNO"}}'; 
        Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputString);
        SM_AP41_PrestaServiceElecOnlineResil objectResil = new SM_AP41_PrestaServiceElecOnlineResil() ;
        Map < String, Object >  outMap = new Map < String, Object >() ;
        objectResil.invokeMethod('creerPrestationElecOnline',inputMap,outMap,null) ;
        
        Prestation_distributeur__c ops = new Prestation_distributeur__c() ;
        insert ops ;
        Map<String,Object>   ElementsToSerialize = new Map<String,Object>() ;
        ElementsToSerialize.put( 'id',ops.Id) ;		
        ElementsToSerialize.put( 'idPrestationServiceFournisseur', 'Test' ) ;		
        ElementsToSerialize.put( 'idPrestationServiceDistributeur', 'Test') ;		
        ElementsToSerialize.put( 'dateSouhaite', '2019-11-2') ;
        ElementsToSerialize.put( 'typeOPS', 'Online') ;
        ElementsToSerialize.put( 'creaneau', 'Midi') ;        
        ElementsToSerialize.put('Name', 'OPS Elec');       
        ElementsToSerialize.put('NomContactIntervention', 'Test') ;
        ElementsToSerialize.put('PrenomContactIntervention',  'Test');
        ElementsToSerialize.put('TelephoneContactIntervention', 'Test');
        ElementsToSerialize.put('CiviliteContactIntervention', 'Test');
        ElementsToSerialize.put('indexBase',1234) ;
        ElementsToSerialize.put('indexHP', 1234) ;     
        ElementsToSerialize.put('indexHC', 1234) ;
        
        Map<String,Object > autoreleveElec   =  ( Map<String,Object > )inputMap.get('autoreleveElec') ;
        objectResil.handleAutoreleve(autoreleveElec) ;
        
        string jsonString = JSON.serializePretty(ElementsToSerialize);		
        SM_AP41_PrestaServiceElecOnlineResil.updateOPS(jsonString) ;

        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element response = new  gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteResponse_element() ;
        response.creerPrestationServiceElectriciteOutput  = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt() ;
        response.creerPrestationServiceElectriciteOutput.tableauDeCharge = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_element() ;
        response.creerPrestationServiceElectriciteOutput.tableauDeCharge.creneau = new List<gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element>() ;                
        gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element creaneau = new gdfsuezBefCalypsoPrestationServiceElec.creerPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element() ;
        creaneau.date_x = '2019-05-19sT00:00:00' ;
        creaneau.creneauHoraire = new gdfsuezComBefChpPSEPivot.listeValeursDt() ;
        creaneau.creneauHoraire.code ='mjo' ;
        creaneau.creneauHoraire.libelleCourt  ='milieu de journée' ;           
        response.creerPrestationServiceElectriciteOutput.tableauDeCharge.creneau .add(creaneau) ;                
        SM_AP41_PrestaServiceElecOnlineResil.getTableauDeCharge(response.creerPrestationServiceElectriciteOutput.tableauDeCharge);

        
    }
    
    
    
}