/*
* @Author: Mohamed Kchaou
* @Date: 13/02/2019
* @Description: Test Class for SM_AP30_PrestationGaz
*/
@isTest
public class SM_AP30_PrestationGaz_Test {

    public static String LIREONLINE_CRENEAU_RETENU;
    public static String LIREONLINE_CRENEAU_RETENU_CODE;
    public static String LIREONLINE_PDL;
    public static String LIREONLINE_DATE_PREVUE;
    public static String LIREONLINE_REF_EXT;
    public static String LIREONLINE_COM;

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke creerPrestationGaz
    */
    static testMethod void creerPrestationGazTest() {
        
        Map < String, Object > recolGaz = new Map < String, Object >();
        Map < String, Object > infosGaz = new Map < String, Object >();
        Map < String, Object > elements1 = new Map < String, Object >();
        
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        
        
        
        
        Map < String, Object > elements = new Map < String, Object >();
        
        Map < String, Object > adress = new Map < String, Object >();  
        Map < String, Object > adressContact = new Map < String, Object >(); 
        
        adressContact.put('BillingAddress','adress') ;
        elements.put('AdresseContact',adressContact) ;      
        adress.put('isBillingAddressSameAsLiving','Oui') ;
        elements1.put('Address',adress);
        elements1.put('selectedAdrConsFormula','adress1');
        inputMap.put('ChoixElements',elements);      
        recolGaz.put('numAffaireDistrib','123456789');
        recolGaz.put('Prestation','987654321');
        elements1.put('selectedPCEVal','1234567890');
        infosGaz.put('InfoRecollementGaz',recolGaz);   
        infosGaz.put('NavigationModeGaz', 'Recollement');
        inputMap.put('idContrat','elements1');
        Map<String,String> pdlInfo = new  Map<String,String>() ;
        pdlInfo.put('idPdl', 'idPdl') ;
        inputMap.put('pdlinfo',pdlInfo) ;
        inputMap.put('ChoixElements1',elements1);
        inputMap.put('PrestationGaz', infosGaz);
        inputMap.put('refClientIdBP','IDBP');
        SM_AP30_PrestationGaz.switchToRecollement(inputMap,outMap) ;
        SM_AP30_PrestationGaz recollementGaz = new SM_AP30_PrestationGaz();
        
        recollementGaz.invokeMethod('creerPrestationGaz',inputMap,outMap,null);
        SM_AP30_PrestationGaz.setChoixProcedureSelectable(outMap) ;
        Prestation_distributeur__c prestation = new Prestation_distributeur__c() ;
        prestation.Name  ='12345678';
        insert prestation ;
        Map<String,Object> ElementsToSerialize = new Map<String,Object>() ;
        ElementsToSerialize.put( 'id', prestation.ID) ;		
        ElementsToSerialize.put( 'idPrestationServiceFournisseur', '1234') ;		
        ElementsToSerialize.put( 'idPrestationServiceDistributeur', '1234') ;		
        ElementsToSerialize.put( 'dateSouhaite', null) ;		
        string jsonString = JSON.serializePretty(ElementsToSerialize);		
        SM_AP30_PrestationGaz.updateOPS(jsonString) ;
        
        
        gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element responseElement = new gdfsuezBefCalypsoPrestaGaz.creerPrestationServiceGazResponse_element();
        
        responseElement.messageRetours = new gdfsuezComBefChpPivot.retourTraitementMessagesDt();
        responseElement.messageRetours.retourTraitementMessage =  new List<gdfsuezComBefChpPivot.retourTraitementMessageDt>() ;
        responseElement.messageRetours.retourTraitementMessage.add(new gdfsuezComBefChpPivot.retourTraitementMessageDt()) ;
        responseElement.messageRetours.retourTraitementMessage[0].code =  'OCTOPUS_CreerPrestationServiceGaz_02' ;
       // SM_AP30_PrestationGaz.updateMessage(true,'Autorelève',responseElement,  outMap);
       // SM_AP30_PrestationGaz.updateMessage(false,'Autorelève'responseElement,  outMap);
        responseElement.messageRetours.retourTraitementMessage[0].code = 'OCTOPUS_CreerPrestationServiceGaz_01' ; 
      //  SM_AP30_PrestationGaz.updateMessage(false,'Autorelève',responseElement,  outMap);
        
        
        
        //System.assertEquals('OCTOPUS_CreerPrestationServiceGazOffline_01', outMap.get('recol_gaz_ret'));
    }
    
    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke lirePrestationGazOnline
    */
    static testMethod void lirePrestationGazOnlineTest() {
            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();
        
            inputMap.put('TypeCard','GAZ');
            inputMap.put('idPrestationDistributeur', '123456');
            

            SM_AP30_PrestationGaz recollementGaz = new SM_AP30_PrestationGaz();

            // Test 1 : sans présence obligatoire
            LIREONLINE_CRENEAU_RETENU = 'Après-midi';
            LIREONLINE_CRENEAU_RETENU_CODE = 'APM';
            LIREONLINE_PDL = '1234';
            LIREONLINE_DATE_PREVUE = '2018-09-10T00:00:00Z';
            LIREONLINE_REF_EXT = 'D123';
            LIREONLINE_COM = 'NPO : présence non obligatoire';
            recollementGaz.invokeMethod('lirePrestationGazOnline',inputMap,outMap,null);

            /*System.assertEquals(SM_AP30_PrestationGaz_Test.LIREONLINE_CRENEAU_RETENU_CODE, outMap.get('creneauRetenuCode'));
            System.assertEquals(SM_AP30_PrestationGaz_Test.LIREONLINE_PDL, outMap.get('pdl'));
            System.assertEquals('10/09/2018', outMap.get('datePrevue'));
            System.assertEquals(SM_AP30_PrestationGaz_Test.LIREONLINE_REF_EXT, outMap.get('refExterne'));
            System.assertEquals(SM_AP30_PrestationGaz_Test.LIREONLINE_COM, outMap.get('commentaires'));
            System.assertEquals('2', outMap.get('presence'));*/

            // Test 2 : avec présence obligatoire
            SM_AP30_PrestationGaz_Test.LIREONLINE_COM = 'PO : présence obligatoire';
            //recollementGaz.invokeMethod('lirePrestationGazOnline',inputMap,outMap,null);
            //System.assertEquals('1', outMap.get('presence'));
           
            //Test 3 : avec présence obligatoire
            SM_AP30_PrestationGaz_Test.LIREONLINE_COM = 'PO : présence obligatoire';
            inputMap.put('TypeUser','Client');
            recollementGaz.invokeMethod('lirePrestationGazOnline',inputMap,outMap,null);
                
            gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element responseElement = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element();
            responseElement.lirePrestationServiceGazOutput = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt();
            responseElement.lirePrestationServiceGazOutput.prestationServiceLire = new List < gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element > ();
            responseElement.lirePrestationServiceGazOutput.prestationServiceLire.add(new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element());
            gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element response = responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0];
            response.donneesGenerales = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_donneesGenerales_element();
            response.interventions = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_interventions_element();

            SM_AP30_PrestationGaz.transformDataFromReadOnline(inputMap,responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0] );

    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke updatePrestationGaz
    */
    static testMethod void updatePrestationGazTest() {
            SM_AP30_PrestationGaz recollementGaz = new SM_AP30_PrestationGaz();

            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();

            Map<String, Object> opsMap = new Map<String, Object>();

            inputMap.put('OPSUpdate', opsMap);

            // Test 1 : on ne saisit pas de nom -> renvoi d'un code erreur
            recollementGaz.invokeMethod('updatePrestationGaz',inputMap,outMap,null);
            System.assertEquals('ERR_NAME', outMap.get('updOps_code'));

            // Test 2 : on saisit un nom -> pas de code erreur
            opsMap.put('LastName', 'Je saisis un nom');
            inputMap.put('OPSUpdate', opsMap);
            recollementGaz.invokeMethod('updatePrestationGaz',inputMap,outMap,null);
            System.assertEquals('', outMap.get('updOps_code'));
        
        
    }
    
    static testMethod void updatePrestationGazTest_full() {
        SM_AP30_PrestationGaz updateGaz = new SM_AP30_PrestationGaz();
        
        Map < String, Object > inputMap = new Map < String, Object >();
        Map < String, Object > outMap = new Map < String, Object >();
        
        Map<String, Object> opsMap = new Map<String, Object>();
        
        inputMap.put('OPSUpdate', opsMap);
        
        // Test 3 : 
        inputMap.put('TypeUser', 'Client');
        opsMap.put('LastName', 'Je saisis un nom');
        system.debug('test');
        opsMap.put('DateEffetSouhaite', '2018-09-10T00:00:00Z');
        inputMap.put('OPSUpdate', opsMap);
        outMap.put('code_retour_ops','OCTOPUS_ModifierPrestationServiceGaz_07');
        inputMap.put('actionName','NAVIGUER_PREC');
        updateGaz.updatePrestationGaz(inputMap,outMap,outMap,'REPLANIFIER_OPS');
        System.assertEquals('', outMap.get('updOps_code'));
        
        updateGaz.updatePrestationGaz(inputMap,outMap,outMap,'ACCEPTER');
    }
    
    /*
    * @Author: Omar MOHAMAD
    * @Date: 19/07/2019
    * @Description: test method to invoke annulerPrestationGaz
    */
 static testMethod void annulerPrestationGazTest() {
            SM_AP30_PrestationGaz annulerGaz = new SM_AP30_PrestationGaz();

            Map < String, Object > inputMap = new Map < String, Object >();
            Map < String, Object > outMap = new Map < String, Object >();

           

            // Test 1 : on ne saisit pas de idF et idD
            inputMap.put('idF', '');
            inputMap.put('idD', '');
            annulerGaz.invokeMethod('annulerPrestationGaz',inputMap,outMap,null);
            System.assertEquals('ERR_IDFD', outMap.get('updOps_code'));

           
            // Test 2 : on saisit un idF et idD
            inputMap.put('idF', '123456789');
            inputMap.put('idD', '987654321');
            annulerGaz.invokeMethod('annulerPrestationGaz',inputMap,outMap,null);
            System.assertEquals('', outMap.get('updOps_code'));
        
        
    }
    
    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke lirePrestationGazOnlinerecap
    */
    static testMethod void lirePrestationGazOnlinerecapTest() {

            SM_AP30_PrestationGaz lirePrestation = new SM_AP30_PrestationGaz();
            String idOps = '0039E00000XX41GQAT';
            String inputAsString = '{ "ContextId": "0039E00000XX41GQAT","InterventionGazObligatoire": true,"refClientIdBP": "01100144562464","TypeUser":"Client",  "PrestationGaz": {"InterventionGazObligato": "Présence Non Obligatoire","formatLastIndexGax": null,"isDGI": "","NavigationModeGaz": "Online","InfoRecollementGaz": null, "ChoixProcedureGaz": null, "ChoixProcedureGAZMHS": null, "repriseMHSGazMessage": null, "InformationsdeprestationGaz": {  "DateEtatDesLieuxFormula": true,   "mesure": null,   "consommationsansfournisseurMSG": false, "MESGAZurgente": true,  "DateEffetSouhaiteGaz": "2018-12-21",  "CreaneauGaz": "Journée",   "AntidateeGaz": false,  "AlerteAntidatageGaz": true,  "DemandeUrgenteGaz": false,  "Messaging2": null,   "OrigineDemande2": null,  "DemandeUrgente": "Engie" }, "BlockInterventionGaz": {   "Civilite": "MME",  "Nom": "Castafiore",  "Prenom": "Bianca",   "telephoneGaz": "06 93 82 21 23",  "CommentairePrestationGaz": "Présence Non Obligatoire" },  "BlockAutoreleveGaz": { "MaxToleratedIndex": 1284, "IndexGaz": 1244,  "IndexGazIncorrectMessage": true,   "DifferentielTropimportantMessage": true },"CreationPrestationGazMsg": false,  "formatMhs": null},"ChoixElements": { "AdresseContact": { "Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12", "NoVoie": null, "ComplementAdresse": null, "CodePostal": "75011", "Ville": "Paris",   "BillingAddress": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris"  }, "FormulaNumCompteClientFrom360": null, "chooseSellingOption": "Emménagement", "EnergyTypeOptions": "Duo", "EffectiveDate": "2018-11-16T23:00:00.000Z", "DateSupp1": true, "DateSupp42": true, "DateSupp4": true, "DateSupp1Message": true,  "DateSupp42Message": true, "DateSupp4Message": true, "yearOfBuild": "plus1an", "ChoixCanal": {   "Stop": {    "StopPhoning": true,   "StopMailing": false   } }, "ContactInfo": {  "Civilite": "MR et MME",  "Prenom": "Anna",    "Nom": "GRAMME"  }, "TelMobile": {  "principalMobileValue": "05 67 89 09 54",  "principalMobile": "Mobile 2",    "NewMobile2": "+33567890954",    "NewMobile1": "+33612345678" },  "TelFixe": {    "principalFixe": "Tel Fixe 3",   "NewTelFixe3": "+33134127850",  "NewTelFixe2": "+335467890709", "NewTelFixe1": "+33134127856" }, "AdresseEmail": {"principalEmail": "Adresse Mail 1",    "NouvelleAdresseMail3": "remi.pugel@external.engie.com",    "NouvelleAdresseMail2": "anna.gramme2@gmail.com",  "NouvelleAdresseMail1": "anna.gramme@gmail.com"  } }, "ChoixElements1": { "selectedPCEVal" : "01100144562464", "Address": { "Formula3": "Adresse concernée :  3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris",  "isBillingAddressSameAsLiving": "Non"   }, "SearchByAddress-Block": {   "SearchByAddress": "215 Rue des Piats 59200 Tourcoing",    "id": "ADRNIVX_0000000331881839",   "name": "215 Rue des Piats",   "label": null,  "city": "Tourcoing",  "citycode": "59599",   "postcode": "59200", "housenumber": "215",  "street": "Rue des Piats"  }},"PrestationElec": { "OPSLabel": "Emménagement", "isIndexBase": 6535, "LINKYlv1": false, "LINKYlv2": false, "FormatMhs": "2017-01-04T00:00:00.000Z", "FormatLastIndex": "2017-07-06T00:00:00.000Z",  "NavigationMode": "Online","InfoRecollementElec": null,"Informations de prestation": {"IsItvObligatoire": false, "IsSelectedIntervention": false,"DateEffetSouhaite": "2018-11-16T23:00:00.000Z","Creneau": null,"AntidateeElec": false, "AlerteAntidatageElec": true, "Demande Urgente?": false, "OrigineDemande1": null },"IsChoixAutorelItv": true, "IsChoixRepriseIndexAutorelItv": false, "ChoixProcedureAutoItv": "Intervention","ChoixProcedureRepriseIndexAutoItv": null,"BlocIntervention": { "MessagingIntervention": true,"FormulaCivitlite": "MR et MME", "FormulaNom": "GRAMME", "FormulaPrenom": "Anna","Telephone": "0699000000","Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris","commentaire": "0644444444" }, "AutoreleveElec": {  "Base": null,   "TourCadranBase": false,  "HP": 1001, "TourCadranHP": null,  "HC": 1001,  "TourCadranHC": null,  "CalculAvecNbCadran": 1,  "IndexBasevalide": true,  "IndexBasevalideBasculeItv": true, "DifferentielHP": null, "DifferentielHC": null,   "IndexHPHCValide": true, "IndexHPHCValideBasculeItv": true,  "AlerteIndexBaseNonvalide": null,  "AlerteIndexBaseNonvalideItv": null,   "AlerteIndexHPHCNonvalide": null,   "AlerteIndexHPHCNonvalideItv": null  } }, "error": "OK", "Radio2": "", "OffreChoisis": { "mensTotal": "109.69 €/mois","mensGaz": "30.38 €/mois","mens": "79.31 €/mois","mapConsoGazByTypeComptage": {"consoGaz": "0.09 €/kWh TTC (0.06576 HT)"},"mapConsoByTypeComptage": {  "HP": "HP:0.17 €/kWh TTC (0.10547 HT)",  "HC": "HC:0.13 €/kWh TTC (0.07452 HT)"  } }, "CAR": 677,"PDLChoisi": "01199999844520", "Montant": "76.86 €/mois", "pdlinfo": { "typeCompteur": "Historique","statutContractuel": "non libre","pdlType": "Gaz","miseHorsServiceEnCours": null, "matricule": "511", "idPdl": "01100144562464", "fta": "BTINFCUST","fraude": null, "etatTechnique": "non_coupe",  "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": null, "dateDerniereTelereleve": null,"dateDerniereReleve": null,  "consommationSansFournisseur": false, "accessReleve": "Accessible" ,"frequenceReleve":"BTINFCUST"}, "DRId_Prestation_distributeur__c": "a4c9E000001DfWiQAK","pdlElecInfo": {"typeCompteur": "Historique", "statut": "A initier","situationContractuelle": "DISCO", "secteurActivite": "Elec","puissanceSouscriteValeur": 6, "puissanceSouscriteUnite": "kVA", "puissancelimitee": null,"numRoues": null, "numbreCadrans": 1, "niveauOuvertureServices": "Niveau 0","matricule": "875", "indexHp": null, "indexHC": null,"index": "6535","idPDLElectricite": "01199999844520","ftaLibelle": null, "ftaCode": null,"etatPdl": "En service", "etatCompteur": "non coupe","dateMHS": "2017-01-04T00:00:00.000Z","dateDernierIndex": "2017-07-06T00:00:00.000Z","calendrierFournisseurLibelleCourt": null,"calendrierFournisseurCode": null,"autoreleve": false,"acessibilite": null },"PrestationDistrib": { "id":"' + idOPS + '", "DatePrestation": "2018-11-17","SituationVente": "Emménagement",  "ElecInterventionObligatoire": false, "ElecRepriseIndexMHS": false, "ElecInterventionOption": true,"StatutDuCompteur": "non coupe","Statut": "A initier","SecteurActivite": "Elec","NumeroPDLPCE": "01199999844520","NbCadrans": 1,"MHSEnCoursAu": "2017-01-04","Matricule": "875","Index": 6535,"EtatPDL": "En service","EtatDuCompteur": "non coupe","ElecAutoreleve": true,"DateDernierIndex": "2017-07-06","Accessibilite": "Accessible"},"ContactId": "0039E00000XX41GQAT","PrestationDistriGaz": {"matricule": "511","Accessibilite": "Accessible", "etatTechnique": "non_coupe","libelleCompteur": "Non Communicant","numeroPce": "01100144562464","statutContractuel": "non libre"},"ServicesGestion": {"PrelevementBlock": {"getMobilePrincipale": "+33567890954", "getEmailPrincipale": "anna.gramme@gmail.com",  "EnvoiCodeBlock": { "idPersonneMandat": "0302719249","idMandat": "00S012452626",  "codeInput": null,      "valeurInput": null}}}}';
            Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);
            Map < String, Object > outMap = new Map < String, Object > ();
            lirePrestation.invokeMethod('lirePrestationGaz', inputMap, outMap, null);

            gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element responseElement = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element();
            responseElement.lirePrestationServiceGazOutput = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt();
            responseElement.lirePrestationServiceGazOutput.prestationServiceLire = new List < gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element > ();
            responseElement.lirePrestationServiceGazOutput.prestationServiceLire.add(new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element());
            responseElement.lirePrestationServiceGazOutput.prestationServiceLire[0].donneesGenerales = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_donneesGenerales_element();

            SM_AP30_PrestationGaz.getDetailsFromResponseAndExposeItToOS(responseElement, outMap, inputMap);

    }


   static testMethod void creerPrestationGazOnlineTest1() {
        try{
            SM_AP30_PrestationGaz creerPrestation = new SM_AP30_PrestationGaz();
            String idOps = '0039E00000XX41GQAT';
            String inputAsString = '{"DateEffetSouhaiteGaz":"2018-11-24","pdlinfo":{"index":"6657","frequenceReleve":"BTINFC","accessReleve":"Accessible","natureIndex":null,"consommationSansFournisseur":true,"dateDerniereReleve":"2017-01-04T00:00:00.000Z","dateDerniereTelereleve":"2017-01-04T00:00:00.000Z","dateMiseHorsService":"2017-01-04T00:00:00.000Z","dateRefusTelereleve":null,"dgi":"DGI","etatTechnique":"non_coupe","fraude":null,"fta":"T2","idPdl":"01100144562464","matricule":"511","miseHorsServiceEnCours":false,"pdlType":"Gaz","statutContractuel":"non libre","typeCompteur":"Historique"},"refClientIdBP":"0309980004","choixProcedure":"Intervention","CreaneauGaz":"dma","PrestationDistriGaz":{"Accessibilite":"Accessible","Index":1234,"absenceindexdepuis5Jours":false,"autoreleveFacultative":true,"autoreleveObligatoire":false,"consommationSansFournisseur":false,"dateDerniereReleve":"2017-01-04","etatTechnique":"non_coupe","indexCalcule":false,"interventionFacultative":true,"interventionObligatoireCHF":false,"libelleCompteur":"Statut inconnu. A vérifier dans OMEGA","matricule":"511","numeroPce":"01100144562464","repriseMHS":false,"situationVente":"Emménagement","statutContractuel":"non libre","interventionObligatoireEM":false,"reprisedernierIndex":false,"id":"'+idOps+'","telereleve":false,"telereleveObligatoire":false},"idContrat":"6011930586","contactInfos":{"Nom":"Castafiore","Prenom":"Bianca","Civilite":"MME"},"contexte":"Emménagement","BlockInterventionGaz":{"CommentairePrestationGaz":"PNO","telephoneGaz":"06 93 82 21 23","PrenomGaz":"Bianca","NomGaz":"Castafiore","CiviliteGaz":"MME","PresenceNecessaireHeadLine":false},"coordonneContact":{"NewMobile1":"+33693822123","principalMobile":"Mobile 1","principalMobileValue":"06 93 82 21 23"},"repriseMHS":"","adressContact":{"Pays":"FRANCE","BillingAddress":"215 rue des Piats Moncomplément 59200 Tourcoing","Ville":"Tourcoing","CodePostal":"59200","ComplementAdresse":"Moncomplément","NoVoie":null,"Adresse":"215 rue des Piats"},"postcodeValue":"","libelleVoieValue":"","nVoieValue":"","cityValue":"","selectedAdrConsFormula":"215 RUE DES PIATS 59200 TOURCOING","origineDemande":"","CAR":677,"IndexGaz":"","InterventionGazObligatoire":false,"autoreleveObligatoire":false,"GazAbsenceindexdepuis5jours":false,"isBillingAddressSameAsLiving":"Non","NOEXISTINGJSON":{}}';
            Map < String, Object > inputMap = (Map < String, Object >) JSON.deserializeUntyped(inputAsString);

            Map < String, Object > outMap = new Map < String, Object > ();

            creerPrestation.invokeMethod('creerPrestationGazOnline', inputMap, outMap, null);
            System.assertEquals(null, outMap.get('code_retour_creer_ops_gaz'));
        }catch(exception e){}

    } 

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke creerPrestationGazOnline
    */
    static testMethod void creerPrestationGazOnlineTest2() {
        try{
            SM_AP30_PrestationGaz creerPrestation = new SM_AP30_PrestationGaz();
            String idOps = '0039E00000XX41GQAT';
            String inputAsString = '{"DateEffetSouhaiteGaz":"2018-11-24","pdlinfo":{"index":"6657","frequenceReleve":"BTINFC","accessReleve":"Accessible","natureIndex":null,"consommationSansFournisseur":true,"dateDerniereReleve":"2017-01-04T00:00:00.000Z","dateDerniereTelereleve":"2017-01-04T00:00:00.000Z","dateMiseHorsService":"2017-01-04T00:00:00.000Z","dateRefusTelereleve":null,"dgi":"DGI","etatTechnique":"non_coupe","fraude":null,"fta":"T2","idPdl":"01100144562464","matricule":"511","miseHorsServiceEnCours":false,"pdlType":"Gaz","statutContractuel":"non libre","typeCompteur":"Historique"},"refClientIdBP":"0309980004","choixProcedure":"Intervention","CreaneauGaz":"dma","PrestationDistriGaz":{"Accessibilite":"Accessible","Index":1234,"absenceindexdepuis5Jours":false,"autoreleveFacultative":true,"autoreleveObligatoire":false,"consommationSansFournisseur":false,"dateDerniereReleve":"2017-01-04","etatTechnique":"non_coupe","indexCalcule":false,"interventionFacultative":true,"interventionObligatoireCHF":false,"libelleCompteur":"Statut inconnu. A vérifier dans OMEGA","matricule":"511","numeroPce":"01100144562464","repriseMHS":false,"situationVente":"Emménagement","statutContractuel":"non libre","interventionObligatoireEM":false,"reprisedernierIndex":false,"id":"'+idOps+'","telereleve":false,"telereleveObligatoire":false},"idContrat":"6011930586","contactInfos":{"Nom":"Castafiore","Prenom":"Bianca","Civilite":"MME"},"contexte":"Changement de fournisseur","BlockInterventionGaz":{"CommentairePrestationGaz":"PNO","telephoneGaz":"06 93 82 21 23","PrenomGaz":"Bianca","NomGaz":"Castafiore","CiviliteGaz":"MME","PresenceNecessaireHeadLine":false},"coordonneContact":{"NewMobile1":"+33693822123","principalMobile":"Mobile 1","principalMobileValue":"06 93 82 21 23"},"repriseMHS":"","adressContact":{"Pays":"FRANCE","BillingAddress":"215 rue des Piats Moncomplément 59200 Tourcoing","Ville":"Tourcoing","CodePostal":"59200","ComplementAdresse":"Moncomplément","NoVoie":null,"Adresse":"215 rue des Piats"},"postcodeValue":"","libelleVoieValue":"","nVoieValue":"","cityValue":"","selectedAdrConsFormula":"215 RUE DES PIATS 59200 TOURCOING","origineDemande":"","CAR":677,"IndexGaz":"","InterventionGazObligatoire":false,"autoreleveObligatoire":false,"GazAbsenceindexdepuis5jours":false,"isBillingAddressSameAsLiving":"Non","NOEXISTINGJSON":{}}';
      
            Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);

            Map < String, Object > outMap = new Map < String, Object > ();

            creerPrestation.invokeMethod('creerPrestationGazOnline', inputMap, outMap, null);
            
            
            
            
            
        }catch(exception e){
            system.debug('error'+e.getStackTraceString());
        }
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke rechercherPrestationGaz
    */
  /*  static testMethod void rechercherPrestationGazTest() {
        try{
            SM_AP30_PrestationGaz creerPrestation = new SM_AP30_PrestationGaz();
            String idOps = '0039E00000XX41GQAT';
            String inputAsString = '{ "ContextId": "0039E00000XX41GQAT","InterventionGazObligatoire": true,"refClientIdBP": "01100144562464",  "PrestationGaz": {"InterventionGazObligato": "Présence Non Obligatoire","formatLastIndexGax": null,"isDGI": "","NavigationModeGaz": "Online","InfoRecollementGaz": null, "ChoixProcedureGaz": null, "ChoixProcedureGAZMHS": null, "repriseMHSGazMessage": null, "InformationsdeprestationGaz": {  "DateEtatDesLieuxFormula": true,   "mesure": null,   "consommationsansfournisseurMSG": false, "MESGAZurgente": true,  "DateEffetSouhaiteGaz": "2018-12-21",  "CreaneauGaz": "Journée",   "AntidateeGaz": false,  "AlerteAntidatageGaz": true,  "DemandeUrgenteGaz": false,  "Messaging2": null,   "OrigineDemande2": null,  "DemandeUrgente": "Engie" }, "BlockInterventionGaz": {   "Civilite": "MME",  "Nom": "Castafiore",  "Prenom": "Bianca",   "telephoneGaz": "06 93 82 21 23",  "CommentairePrestationGaz": "Présence Non Obligatoire" },  "BlockAutoreleveGaz": { "MaxToleratedIndex": 1284, "IndexGaz": 1244,  "IndexGazIncorrectMessage": true,   "DifferentielTropimportantMessage": true },"CreationPrestationGazMsg": false,  "formatMhs": null},"ChoixElements": { "AdresseContact": { "Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12", "NoVoie": null, "ComplementAdresse": null, "CodePostal": "75011", "Ville": "Paris",   "BillingAddress": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris"  }, "FormulaNumCompteClientFrom360": null, "chooseSellingOption": "Emménagement", "EnergyTypeOptions": "Duo", "EffectiveDate": "2018-11-16T23:00:00.000Z", "DateSupp1": true, "DateSupp42": true, "DateSupp4": true, "DateSupp1Message": true,  "DateSupp42Message": true, "DateSupp4Message": true, "yearOfBuild": "plus1an", "ChoixCanal": {   "Stop": {    "StopPhoning": true,   "StopMailing": false   } }, "ContactInfo": {  "Civilite": "MR et MME",  "Prenom": "Anna",    "Nom": "GRAMME"  }, "TelMobile": {  "principalMobileValue": "05 67 89 09 54",  "principalMobile": "Mobile 2",    "NewMobile2": "+33567890954",    "NewMobile1": "+33612345678" },  "TelFixe": {    "principalFixe": "Tel Fixe 3",   "NewTelFixe3": "+33134127850",  "NewTelFixe2": "+335467890709", "NewTelFixe1": "+33134127856" }, "AdresseEmail": {"principalEmail": "Adresse Mail 1",    "NouvelleAdresseMail3": "remi.pugel@external.engie.com",    "NouvelleAdresseMail2": "anna.gramme2@gmail.com",  "NouvelleAdresseMail1": "anna.gramme@gmail.com"  } }, "ChoixElements1": { "selectedPCEVal" : "01100144562464", "Address": { "Formula3": "Adresse concernée :  3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris",  "isBillingAddressSameAsLiving": "Non"   }, "SearchByAddress-Block": {   "SearchByAddress": "215 Rue des Piats 59200 Tourcoing",    "id": "ADRNIVX_0000000331881839",   "name": "215 Rue des Piats",   "label": null,  "city": "Tourcoing",  "citycode": "59599",   "postcode": "59200", "housenumber": "215",  "street": "Rue des Piats"  }},"PrestationElec": { "OPSLabel": "Emménagement", "isIndexBase": 6535, "LINKYlv1": false, "LINKYlv2": false, "FormatMhs": "2017-01-04T00:00:00.000Z", "FormatLastIndex": "2017-07-06T00:00:00.000Z",  "NavigationMode": "Online","InfoRecollementElec": null,"Informations de prestation": {"IsItvObligatoire": false, "IsSelectedIntervention": false,"DateEffetSouhaite": "2018-11-16T23:00:00.000Z","Creneau": null,"AntidateeElec": false, "AlerteAntidatageElec": true, "Demande Urgente?": false, "OrigineDemande1": null },"IsChoixAutorelItv": true, "IsChoixRepriseIndexAutorelItv": false, "ChoixProcedureAutoItv": "Intervention","ChoixProcedureRepriseIndexAutoItv": null,"BlocIntervention": { "MessagingIntervention": true,"FormulaCivitlite": "MR et MME", "FormulaNom": "GRAMME", "FormulaPrenom": "Anna","Telephone": "0699000000","Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris","commentaire": "0644444444" }, "AutoreleveElec": {  "Base": null,   "TourCadranBase": false,  "HP": 1001, "TourCadranHP": null,  "HC": 1001,  "TourCadranHC": null,  "CalculAvecNbCadran": 1,  "IndexBasevalide": true,  "IndexBasevalideBasculeItv": true, "DifferentielHP": null, "DifferentielHC": null,   "IndexHPHCValide": true, "IndexHPHCValideBasculeItv": true,  "AlerteIndexBaseNonvalide": null,  "AlerteIndexBaseNonvalideItv": null,   "AlerteIndexHPHCNonvalide": null,   "AlerteIndexHPHCNonvalideItv": null  } }, "error": "OK", "Radio2": "", "OffreChoisis": { "mensTotal": "109.69 €/mois","mensGaz": "30.38 €/mois","mens": "79.31 €/mois","mapConsoGazByTypeComptage": {"consoGaz": "0.09 €/kWh TTC (0.06576 HT)"},"mapConsoByTypeComptage": {  "HP": "HP:0.17 €/kWh TTC (0.10547 HT)",  "HC": "HC:0.13 €/kWh TTC (0.07452 HT)"  } }, "CAR": 677,"PDLChoisi": "01199999844520", "Montant": "76.86 €/mois", "pdlinfo": { "typeCompteur": "Historique","statutContractuel": "non libre","pdlType": "Gaz","miseHorsServiceEnCours": null, "matricule": "511", "idPdl": "01100144562464", "fta": "BTINFCUST","fraude": null, "etatTechnique": "non_coupe",  "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": null, "dateDerniereTelereleve": null,"dateDerniereReleve": null,  "consommationSansFournisseur": false, "accessReleve": "Accessible" ,"frequenceReleve":"BTINFCUST"}, "DRId_Prestation_distributeur__c": "a4c9E000001DfWiQAK","pdlElecInfo": {"typeCompteur": "Historique", "statut": "A initier","situationContractuelle": "DISCO", "secteurActivite": "Elec","puissanceSouscriteValeur": 6, "puissanceSouscriteUnite": "kVA", "puissancelimitee": null,"numRoues": null, "numbreCadrans": 1, "niveauOuvertureServices": "Niveau 0","matricule": "875", "indexHp": null, "indexHC": null,"index": "6535","idPDLElectricite": "01199999844520","ftaLibelle": null, "ftaCode": null,"etatPdl": "En service", "etatCompteur": "non coupe","dateMHS": "2017-01-04T00:00:00.000Z","dateDernierIndex": "2017-07-06T00:00:00.000Z","calendrierFournisseurLibelleCourt": null,"calendrierFournisseurCode": null,"autoreleve": false,"acessibilite": null },"PrestationDistrib": { "id":"' + idOPS + '", "DatePrestation": "2018-11-17","SituationVente": "Emménagement",  "ElecInterventionObligatoire": false, "ElecRepriseIndexMHS": false, "ElecInterventionOption": true,"StatutDuCompteur": "non coupe","Statut": "A initier","SecteurActivite": "Elec","NumeroPDLPCE": "01199999844520","NbCadrans": 1,"MHSEnCoursAu": "2017-01-04","Matricule": "875","Index": 6535,"EtatPDL": "En service","EtatDuCompteur": "non coupe","ElecAutoreleve": true,"DateDernierIndex": "2017-07-06","Accessibilite": "Accessible"},"ContactId": "0039E00000XX41GQAT","PrestationDistriGaz": {"matricule": "511","Accessibilite": "Accessible", "etatTechnique": "non_coupe","libelleCompteur": "Non Communicant","numeroPce": "01100144562464","statutContractuel": "non libre"},"ServicesGestion": {"PrelevementBlock": {"getMobilePrincipale": "+33567890954", "getEmailPrincipale": "anna.gramme@gmail.com",  "EnvoiCodeBlock": { "idPersonneMandat": "0302719249","idMandat": "00S012452626",  "codeInput": null,      "valeurInput": null}}}}';

            Map < String,
                  Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);

            Map < String, Object > outMap = new Map < String, Object > ();

            creerPrestation.invokeMethod('rechercherPrestationGaz', inputMap, outMap, null);
        }catch(exception e){}

    }*/
    
       static testMethod void searchPrestationGazTest() {
        SM_AP30_PrestationGaz searchgaz = new SM_AP30_PrestationGaz();
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > rechercheResult = new Map < String, Object >();
        Map < String, Object > rechercheResultField = new Map < String, Object >();
        
        Map<String, Set<String>> contrat = new Map<String, Set<String>>();
        Set<String> gaz = new Set<String>();
        gaz.add('09702156185740');
        contrat.put('gaz', gaz);
        inputMap.put('WSContrat', contrat);
        
        rechercheResultField.put('idPrestationServiceFournisseur','0090645345');
        rechercheResultField.put('statutPrestationService','Programmée chez EGD');
        rechercheResultField.put('codePrestationService','E0005');
        rechercheResultField.put('idPrestationServiceDistrib','A03QJ1N0');
        rechercheResultField.put('libellePrestation','MES sur raccordement existant');
        
        rechercheResult.put('RecherchePrestationGazResult',rechercheResultField);
        
        inputMap.put('RecherchePrestationGaz',rechercheResult);
        
        searchgaz.invokeMethod('rechercherPrestationGaz',inputMap,outMap,null);
    }

    /*
    * @Author: Mohamed Kchaou
    * @Date: 13/02/2019
    * @Description: test method to invoke lirePrestationGazList
    */
    static testMethod void lirePrestationGazListTest() {
            SM_AP30_PrestationGaz creerPrestation = new SM_AP30_PrestationGaz();
            String idOps = '0039E00000XX41GQAT';
            //String inputAsString = '{ "ContextId": "0039E00000XX41GQAT","InterventionGazObligatoire": true,"refClientIdBP": "01100144562464",  "PrestationGaz": {"InterventionGazObligato": "Présence Non Obligatoire","formatLastIndexGax": null,"isDGI": "","NavigationModeGaz": "Online","InfoRecollementGaz": null, "ChoixProcedureGaz": null, "ChoixProcedureGAZMHS": null, "repriseMHSGazMessage": null, "InformationsdeprestationGaz": {  "DateEtatDesLieuxFormula": true,   "mesure": null,   "consommationsansfournisseurMSG": false, "MESGAZurgente": true,  "DateEffetSouhaiteGaz": "2018-12-21",  "CreaneauGaz": "Journée",   "AntidateeGaz": false,  "AlerteAntidatageGaz": true,  "DemandeUrgenteGaz": false,  "Messaging2": null,   "OrigineDemande2": null,  "DemandeUrgente": "Engie" }, "BlockInterventionGaz": {   "Civilite": "MME",  "Nom": "Castafiore",  "Prenom": "Bianca",   "telephoneGaz": "06 93 82 21 23",  "CommentairePrestationGaz": "Présence Non Obligatoire" },  "BlockAutoreleveGaz": { "MaxToleratedIndex": 1284, "IndexGaz": 1244,  "IndexGazIncorrectMessage": true,   "DifferentielTropimportantMessage": true },"CreationPrestationGazMsg": false,  "formatMhs": null},"ChoixElements": { "AdresseContact": { "Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12", "NoVoie": null, "ComplementAdresse": null, "CodePostal": "75011", "Ville": "Paris",   "BillingAddress": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris"  }, "FormulaNumCompteClientFrom360": null, "chooseSellingOption": "Emménagement", "EnergyTypeOptions": "Duo", "EffectiveDate": "2018-11-16T23:00:00.000Z", "DateSupp1": true, "DateSupp42": true, "DateSupp4": true, "DateSupp1Message": true,  "DateSupp42Message": true, "DateSupp4Message": true, "yearOfBuild": "plus1an", "ChoixCanal": {   "Stop": {    "StopPhoning": true,   "StopMailing": false   } }, "ContactInfo": {  "Civilite": "MR et MME",  "Prenom": "Anna",    "Nom": "GRAMME"  }, "TelMobile": {  "principalMobileValue": "05 67 89 09 54",  "principalMobile": "Mobile 2",    "NewMobile2": "+33567890954",    "NewMobile1": "+33612345678" },  "TelFixe": {    "principalFixe": "Tel Fixe 3",   "NewTelFixe3": "+33134127850",  "NewTelFixe2": "+335467890709", "NewTelFixe1": "+33134127856" }, "AdresseEmail": {"principalEmail": "Adresse Mail 1",    "NouvelleAdresseMail3": "remi.pugel@external.engie.com",    "NouvelleAdresseMail2": "anna.gramme2@gmail.com",  "NouvelleAdresseMail1": "anna.gramme@gmail.com"  } }, "ChoixElements1": { "selectedPCEVal" : "01100144562464", "Address": { "Formula3": "Adresse concernée :  3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris",  "isBillingAddressSameAsLiving": "Non"   }, "SearchByAddress-Block": {   "SearchByAddress": "215 Rue des Piats 59200 Tourcoing",    "id": "ADRNIVX_0000000331881839",   "name": "215 Rue des Piats",   "label": null,  "city": "Tourcoing",  "citycode": "59599",   "postcode": "59200", "housenumber": "215",  "street": "Rue des Piats"  }},"PrestationElec": { "OPSLabel": "Emménagement", "isIndexBase": 6535, "LINKYlv1": false, "LINKYlv2": false, "FormatMhs": "2017-01-04T00:00:00.000Z", "FormatLastIndex": "2017-07-06T00:00:00.000Z",  "NavigationMode": "Online","InfoRecollementElec": null,"Informations de prestation": {"IsItvObligatoire": false, "IsSelectedIntervention": false,"DateEffetSouhaite": "2018-11-16T23:00:00.000Z","Creneau": null,"AntidateeElec": false, "AlerteAntidatageElec": true, "Demande Urgente?": false, "OrigineDemande1": null },"IsChoixAutorelItv": true, "IsChoixRepriseIndexAutorelItv": false, "ChoixProcedureAutoItv": "Intervention","ChoixProcedureRepriseIndexAutoItv": null,"BlocIntervention": { "MessagingIntervention": true,"FormulaCivitlite": "MR et MME", "FormulaNom": "GRAMME", "FormulaPrenom": "Anna","Telephone": "0699000000","Adresse": "3 Avenue de la République, Rés.Les Océanes Bât. A Appt 12  75011 Paris","commentaire": "0644444444" }, "AutoreleveElec": {  "Base": null,   "TourCadranBase": false,  "HP": 1001, "TourCadranHP": null,  "HC": 1001,  "TourCadranHC": null,  "CalculAvecNbCadran": 1,  "IndexBasevalide": true,  "IndexBasevalideBasculeItv": true, "DifferentielHP": null, "DifferentielHC": null,   "IndexHPHCValide": true, "IndexHPHCValideBasculeItv": true,  "AlerteIndexBaseNonvalide": null,  "AlerteIndexBaseNonvalideItv": null,   "AlerteIndexHPHCNonvalide": null,   "AlerteIndexHPHCNonvalideItv": null  } }, "error": "OK", "Radio2": "", "OffreChoisis": { "mensTotal": "109.69 €/mois","mensGaz": "30.38 €/mois","mens": "79.31 €/mois","mapConsoGazByTypeComptage": {"consoGaz": "0.09 €/kWh TTC (0.06576 HT)"},"mapConsoByTypeComptage": {  "HP": "HP:0.17 €/kWh TTC (0.10547 HT)",  "HC": "HC:0.13 €/kWh TTC (0.07452 HT)"  } }, "CAR": 677,"PDLChoisi": "01199999844520", "Montant": "76.86 €/mois", "pdlinfo": { "typeCompteur": "Historique","statutContractuel": "non libre","pdlType": "Gaz","miseHorsServiceEnCours": null, "matricule": "511", "idPdl": "01100144562464", "fta": "BTINFCUST","fraude": null, "etatTechnique": "non_coupe",  "dgi": "Non DGI", "dateRefusTelereleve": null, "dateMiseHorsService": null, "dateDerniereTelereleve": null,"dateDerniereReleve": null,  "consommationSansFournisseur": false, "accessReleve": "Accessible" ,"frequenceReleve":"BTINFCUST"}, "DRId_Prestation_distributeur__c": "a4c9E000001DfWiQAK","pdlElecInfo": {"typeCompteur": "Historique", "statut": "A initier","situationContractuelle": "DISCO", "secteurActivite": "Elec","puissanceSouscriteValeur": 6, "puissanceSouscriteUnite": "kVA", "puissancelimitee": null,"numRoues": null, "numbreCadrans": 1, "niveauOuvertureServices": "Niveau 0","matricule": "875", "indexHp": null, "indexHC": null,"index": "6535","idPDLElectricite": "01199999844520","ftaLibelle": null, "ftaCode": null,"etatPdl": "En service", "etatCompteur": "non coupe","dateMHS": "2017-01-04T00:00:00.000Z","dateDernierIndex": "2017-07-06T00:00:00.000Z","calendrierFournisseurLibelleCourt": null,"calendrierFournisseurCode": null,"autoreleve": false,"acessibilite": null },"PrestationDistrib": { "id":"' + idOPS + '", "DatePrestation": "2018-11-17","SituationVente": "Emménagement",  "ElecInterventionObligatoire": false, "ElecRepriseIndexMHS": false, "ElecInterventionOption": true,"StatutDuCompteur": "non coupe","Statut": "A initier","SecteurActivite": "Elec","NumeroPDLPCE": "01199999844520","NbCadrans": 1,"MHSEnCoursAu": "2017-01-04","Matricule": "875","Index": 6535,"EtatPDL": "En service","EtatDuCompteur": "non coupe","ElecAutoreleve": true,"DateDernierIndex": "2017-07-06","Accessibilite": "Accessible"},"ContactId": "0039E00000XX41GQAT","PrestationDistriGaz": {"matricule": "511","Accessibilite": "Accessible", "etatTechnique": "non_coupe","libelleCompteur": "Non Communicant","numeroPce": "01100144562464","statutContractuel": "non libre"},"ServicesGestion": {"PrelevementBlock": {"getMobilePrincipale": "+33567890954", "getEmailPrincipale": "anna.gramme@gmail.com",  "EnvoiCodeBlock": { "idPersonneMandat": "0302719249","idMandat": "00S012452626",  "codeInput": null,      "valeurInput": null}}}}';
            String inputAsString = '{"RechercherPrestaGaz":{"ops":{"09701143164444":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}},"errorCode":"INVOKE-200","error":"OK"}}';
            Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);
            Map < String, Object > outMap = new Map < String, Object > ();
        
            inputMap.put('TypeUser','Client');
            
            creerPrestation.invokeMethod('lirePrestationGazList', inputMap, outMap, null);
            SM_AP30_PrestationGaz.fillBLockIntervention(inputMap,false,inputMap,outMap) ;
    }

}