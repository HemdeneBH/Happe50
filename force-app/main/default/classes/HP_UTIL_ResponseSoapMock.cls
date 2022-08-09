/**
 * @File Name          : HP_UTIL_ResponseSoapMock.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 17/04/2020 à 12:20:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
@isTest
global  class HP_UTIL_ResponseSoapMock  implements WebServiceMock {

   
    global void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		System.debug(LoggingLevel.INFO, 'gdfsuezBefCalypsoPdlelectriciteV3.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		
        if(request instanceOf gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectricite_element) {
            System.debug('coucou');
            gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element pdl=  new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteResponse_element();
            pdl.lirePDLElectriciteOutput= new gdfsuezBefCalypsoPdlelectriciteV3.lirePDLElectriciteOutputDt();
    
            pdl.lirePDLElectriciteOutput.donneesPDL =new  List<gdfsuezComBefCalypsoPdlelectricite.PDLElectricite>();
            gdfsuezComBefCalypsoPdlelectricite.PDLElectricite donneespdl = new gdfsuezComBefCalypsoPdlelectricite.PDLElectricite();
           
            List<gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element> donneesGenerales = new   List<gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element>();
            gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element donneesGenerale = new gdfsuezComBefCalypsoPdlelectricite.donneesGenerales_element();
            List<gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element> situationContractuelles= new  List<gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element>();
            gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element situationContractuelle= new  gdfsuezComBefCalypsoPdlelectricite.situationContractuelle_element();

            List<gdfsuezComBefCalypsoPdlelectricite.situationComptage_element> situationComptages = new  List<gdfsuezComBefCalypsoPdlelectricite.situationComptage_element>();
            List<gdfsuezComBefCalypsoPdlelectricite.compteur_element> compteurList = new  List<gdfsuezComBefCalypsoPdlelectricite.compteur_element>();
            gdfsuezComBefCalypsoPdlelectricite.compteur_element compteur = new gdfsuezComBefCalypsoPdlelectricite.compteur_element();
            gdfsuezComBefCalypsoPdlelectricite.compteurs_element compteurs =new gdfsuezComBefCalypsoPdlelectricite.compteurs_element();
            gdfsuezComBefCalypsoPdlelectricite.situationComptage_element situationComptage = new  gdfsuezComBefCalypsoPdlelectricite.situationComptage_element();
            List<gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element> situationAlimentations = new  List<gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element>();
            gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element situationAlimentation = new  gdfsuezComBefCalypsoPdlelectricite.situationAlimentation_element();
            gdfsuezComBefChpPivot.listeValeursDt etatContractuel = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefChpPivot.listeValeursDt niveauOuvertureServices = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefChpPivot.listeValeursDt etatAlimentation = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefChpPivot.listeValeursDt sIContractuel = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefChpPivot.listeValeursDt typeComptage = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefChpPivot.listeValeursDt formuleTarifaireAcheminement = new gdfsuezComBefChpPivot.listeValeursDt();
            gdfsuezComBefCalypsoPdlelectricite.structureTarifaire_element structureTarifaire = new gdfsuezComBefCalypsoPdlelectricite.structureTarifaire_element();
            gdfsuezComBefChpDistributeurelectric.puissanceSansDecimalDt puissanceSouscriteMax = new gdfsuezComBefChpDistributeurelectric.puissanceSansDecimalDt();
            gdfsuezComBefCalypsoPdlelectricite.modeleCompteur_element modeleCompteur =new  gdfsuezComBefCalypsoPdlelectricite.modeleCompteur_element();
            gdfsuezComBefCalypsoPdlelectricite.dispositifComptage_element dispositifComptage = new  gdfsuezComBefCalypsoPdlelectricite.dispositifComptage_element();
            donneesGenerale.etatContractuel = etatContractuel;
            etatContractuel.code ='SERVC';
            donneesGenerale.niveauOuvertureServices= niveauOuvertureServices;
            niveauOuvertureServices.code='0';
            situationContractuelle.contratId = 'GRD-F006';
            situationContractuelle.sIContractuel = sIContractuel;
            sIContractuel.code = 'GINKO';
            situationContractuelle.structureTarifaire =structureTarifaire;
            structureTarifaire.formuleTarifaireAcheminement = formuleTarifaireAcheminement;
            formuleTarifaireAcheminement.code= 'BTINFCUST' ;
            structureTarifaire.puissanceSouscriteMax =puissanceSouscriteMax;
            puissanceSouscriteMax.valeur= 12 ;
            puissanceSouscriteMax.unite= 'kVA';
            compteur.modeleCompteur =modeleCompteur;
            modeleCompteur.nbCadrans=6 ;
            situationComptage.dispositifComptage =dispositifComptage;
            dispositifComptage.typeComptage =typeComptage;
            typeComptage.libelleCourt= 'Compteur Bleu Electronique' ;
   
            situationAlimentation.etatAlimentation= etatAlimentation;
            etatAlimentation.code= 'ALIM';

            situationAlimentations.add(situationAlimentation);
            donneespdl.situationAlimentation = situationAlimentations;
            compteurList.add(compteur);
            dispositifComptage.compteurs =compteurs;
            compteurs.compteur = compteurList;
            situationComptages.add(situationComptage);
            donneespdl.situationComptage = situationComptages;
            situationContractuelles.add(situationContractuelle);
            donneespdl.situationContractuelle = situationContractuelles;
            donneesGenerales.add(donneesGenerale);
            donneespdl.donneesGenerales = donneesGenerales;
            pdl.lirePDLElectriciteOutput.donneesPDL.add(donneespdl);
        

            
            
			response.put( 'response_x', pdl);
		}
		
    }
}