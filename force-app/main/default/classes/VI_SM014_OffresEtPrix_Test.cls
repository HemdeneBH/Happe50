/*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM014_OffresEtPrix
*@CreatedDate: 06/11/2020
*@LastModified: 
*/
@isTest
public class VI_SM014_OffresEtPrix_Test {
    
    @isTest
    static void testCalloutDual() {
        String codeCommune = '59350';
        String codePostal = '59000';
        String enseigneSouscription = 'PPO';
        String contSouscriptionCode ='CHGT_FOURN';
        DateTime dateEffet = System.now() ;
        String plageconso = '6000';
        String vpuissance = '3';
        String typeDeComptage = 'Triple';
        String lastModifFTA = '2018-07-03 00:00:00';
        String codeFTA = '32';
        String pourcentageOffreVerte = '20';
        Integer CAE = 5500;
        String niveauOuvertureService = 'Niveau 0';
        String application = 'VI';
        String version = '2';
        
        Map<String, List<String>> mapPackOffres = new Map<String, List<String>>();
        List<String> offres = new List<String>();
        offres.add('offre1');
        offres.add('offre2');
        mapPackOffres.put('pack', offres);
        
        Map<String, Boolean> mapIsOffreVerte = new Map<String, Boolean>();
        mapIsOffreVerte.put('pack', true);
        
        Map<String,String> mapStrucmesfour = new Map<String, String>();
        mapStrucmesfour.put('pack', '11');
            
    	gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element reponse = 
            VI_SM014_OffresEtPrix.callPrixETRemise(codeCommune, codePostal, enseigneSouscription, contSouscriptionCode, dateEffet, mapPackOffres, plageconso, vpuissance, typeDeComptage,
                                                   lastModifFTA, codeFTA, pourcentageOffreVerte, CAE, niveauOuvertureService, mapIsOffreVerte, mapStrucmesfour, application, version, 'callout:VI_AuthOctopus');
        
        Integer i;
        for (i = 0; i < reponse.rechercherPrixEtRemisesOutput.size(); i++){
            String idOffre = 'DGBUEBUKF' + (i+2) +'VGO_P';
            String idPack = 'DGBUEBUKF' + (i+2) +'VGO_P';
       		System.assertEquals(idOffre, reponse.rechercherPrixEtRemisesOutput[i].donneesOffre[0].idOffre);
       		System.assertEquals(idPack, reponse.rechercherPrixEtRemisesOutput[i].donneesPack.idPack);
        }
    }
    
}