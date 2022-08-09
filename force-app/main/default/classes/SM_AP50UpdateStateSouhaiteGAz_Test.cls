@isTest
    public class SM_AP50UpdateStateSouhaiteGAz_Test {



     @isTest
     public static void test() {
      // cas 1 : DateEffetsouhaité doit etre à la date date effective de l'omniscript 
      String inputAsString = '{"PrestationGaz":{"formatMhs":null,"formatLastIndexGax":null,"isDGI":"","NavigationModeGaz":"Online","InfoRecollementGaz":null,"InformationsdeprestationGaz":{"DateEffetSouhaiteGaz":"2018-12-03","CreaneauGaz":"Journée","AntidateeGaz":false,"AlerteAntidatageGaz": true,"DemandeUrgenteGaz": false,"Messaging2": null,"OrigineDemande2": null }}, "pdlinfo": {"typeCompteur":"Historique","statutContractuel": "non libre","pdlType": "Gaz", "miseHorsServiceEnCours": false,  "matricule": "511",  "idPdl": "01100144562464", "fta": null,  "fraude": null, "etatTechnique": "non_coupe", "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": "2017-01-04T00:00:00.000Z", "dateDerniereTelereleve": "2017-01-04T00:00:00.000Z", "dateDerniereReleve": "2017-01-04T00:00:00.000Z", "consommationSansFournisseur": true, "accessReleve": "Accessible"},"ChoixElements": {  "EffectiveDate": "2018-11-23T23:00:00.000Z"}}';
      Map < String, Object > input = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);
      Map < String, Object > output = new Map < String, Object > ();
      SM_AP50_UpdateSateSouhaiteGAz instance = new SM_AP50_UpdateSateSouhaiteGAz();
      instance.invokeMethod('updateDateSOuhaite', input, output, null);
      Map < String, Object > prestationGaz = (Map < String, Object > ) output.get('PrestationGaz');
      Map < String, Object > infor = (Map < String, Object > ) prestationGaz.get('InformationsdeprestationGaz');
      System.assertEquals(infor.get('DateEffetSouhaiteGaz'), '2018-11-24');


      // cas 2 : DateEffetsouhaité pour le Gaz doit etre à la date  MHS de l'omniscript dans le cas dans une MHS en cours 
      String inputAsString1 = '{"PrestationGaz":{"formatMhs":null,"formatLastIndexGax":null,"isDGI":"","NavigationModeGaz":"Online","InfoRecollementGaz":null,"InformationsdeprestationGaz":{"DateEffetSouhaiteGaz":"2018-12-03","CreaneauGaz":"Journée","AntidateeGaz":false,"AlerteAntidatageGaz": true,"DemandeUrgenteGaz": false,"Messaging2": null,"OrigineDemande2": null }}, "pdlinfo": {"typeCompteur":"Historique","statutContractuel": "non libre","pdlType": "Gaz", "miseHorsServiceEnCours": true,  "matricule": "511",  "idPdl": "01100144562464", "fta": null,  "fraude": null, "etatTechnique": "non_coupe", "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": "2017-01-04T00:00:00.000Z", "dateDerniereTelereleve": "2017-01-04T00:00:00.000Z", "dateDerniereReleve": "2017-01-04T00:00:00.000Z", "consommationSansFournisseur": true, "accessReleve": "Accessible"},"ChoixElements": {  "EffectiveDate": "2018-11-23T23:00:00.000Z"}}';
      input = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString1);
      instance.invokeMethod('updateDateSOuhaite', input, output, null);
      prestationGaz = (Map < String, Object > ) output.get('PrestationGaz');
      infor = (Map < String, Object > ) prestationGaz.get('InformationsdeprestationGaz');
      System.assertEquals(infor.get('DateEffetSouhaiteGaz'), '2017-01-04');
         
         
         
       // cas 2 : DateEffetsouhaité pour le Gaz doit etre à la date  MHS de l'omniscript dans le cas dans une MHS en cours sans date
      String inputAsString2 = '{"PrestationGaz":{"formatMhs":null,"formatLastIndexGax":null,"isDGI":"","NavigationModeGaz":"Online","InfoRecollementGaz":null,"InformationsdeprestationGaz":{"DateEffetSouhaiteGaz":"2018-12-03","CreaneauGaz":"Journée","AntidateeGaz":false,"AlerteAntidatageGaz": true,"DemandeUrgenteGaz": false,"Messaging2": null,"OrigineDemande2": null }}, "pdlinfo": {"typeCompteur":"Historique","statutContractuel": "non libre","pdlType": "Gaz", "miseHorsServiceEnCours": true,  "matricule": "511",  "idPdl": "01100144562464", "fta": null,  "fraude": null, "etatTechnique": "non_coupe", "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": null, "dateDerniereTelereleve": "2017-01-04T00:00:00.000Z", "dateDerniereReleve": "2017-01-04T00:00:00.000Z", "consommationSansFournisseur": true, "accessReleve": "Accessible"},"ChoixElements": {  "EffectiveDate": "2018-11-23T23:00:00.000Z"}}';
      input = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString2);
      instance.invokeMethod('updateDateSOuhaite', input, output, null);
      prestationGaz = (Map < String, Object > ) output.get('PrestationGaz');
      infor = (Map < String, Object > ) prestationGaz.get('InformationsdeprestationGaz');
      System.assertEquals(infor.get('DateEffetSouhaiteGaz'), '2018-11-24');
         
     }




    }