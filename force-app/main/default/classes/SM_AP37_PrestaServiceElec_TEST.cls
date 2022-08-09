/*
* @Author: 
* @Date: 11/02/2019
* @LastModified: 08/03/2019
* @Description: Vlocity class for prestation Service Elec
*/
@isTest(SeeAllData=true)
public class SM_AP37_PrestaServiceElec_TEST {
    public static String CREEROFF_RETOUROCTOPUS;
    public static String LIRELEC_ID_DISTRIB;
    public static String LIRELEC_ID_FOURN;
    public static String LIRELEC_PDL;
    public static String LIRELEC_DATEPREVUE;
    public static String LIRELEC_CRENEAU;
    public static String LIRELEC_CRENEAU_CODE;
    public static String LIRELEC_COM;
    public static String LIRELEC_TEL;
    public static String LIRELEC_CP;
    public static String LIRELEC_CPLT;
    public static String LIRELEC_VOIE;
    public static String LIRELEC_NUMVOIE;
    public static String LIRELEC_VILLE;
    public static String LIRELEC_NOM;
    public static String LIRELEC_PRENOM;
    public static String LIRELEC_CIVILITE;
    public static String LIRELEC_CODERETOUR;
    public static String LIRELEC_DATESOUHAIT;
    public static String LIRELEC_TDC;
     public static String LIRELEC_CODELIBL;
    public static Prestation_distributeur__c aPresta;
/*
    @testSetup static void setup() {
    SM_AP08_TestLib.insertCS_SMOCTOPUS();
    }
*/
  
    @isTest
    public static void lirePrestationElec(){
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> outMap = new Map<String, Object>();
        
        LIRELEC_ID_DISTRIB = 'D0001';
        LIRELEC_ID_FOURN = 'F0001';
        LIRELEC_PDL = '1234';
        LIRELEC_DATEPREVUE = '2018-09-06T00:00:00Z';
        LIRELEC_CRENEAU = 'Après-midi';
        LIRELEC_CRENEAU_CODE = 'APM';
        LIRELEC_COM = 'PO:Commentaires technicien';
        LIRELEC_TEL = '0101010101';
        LIRELEC_CP = '92220';
        LIRELEC_CPLT = 'Batiment';
        LIRELEC_VOIE = '102';
        LIRELEC_NUMVOIE = 'avenue aristide briand';
        LIRELEC_VILLE = 'Bagneux';
        LIRELEC_NOM = 'Nom';
        LIRELEC_PRENOM = 'Prenom';
        LIRELEC_CIVILITE = 'Mr';
        LIRELEC_CODERETOUR = '----';
        LIRELEC_DATESOUHAIT = '2018-09-06T00:00:00Z';

        inputMap.put('commentaires', LIRELEC_COM);
        inputMap.put('idPrestationDistributeur', 'A12345');

        try{
            SM_AP37_PrestaServiceElec recollementElec = new SM_AP37_PrestaServiceElec();
            recollementElec.invokeMethod('lirePrestationElec',inputMap,outMap,null);
        }
        catch(Exception e){
        }
    }
    
    
    
    static testMethod void lirePrestationElecOnlineTest() {
        Map < String, Object > inputMap = new Map < String, Object >();   
        Map < String, Object > outMap = new Map < String, Object >();  
        
        LIRELEC_ID_DISTRIB = 'D0001';
        LIRELEC_ID_FOURN = 'F0001';
        LIRELEC_PDL = '1234';
        LIRELEC_DATEPREVUE = '2018-09-06T00:00:00Z';
        LIRELEC_CRENEAU = 'Après-midi';
        LIRELEC_CRENEAU_CODE = 'APM';
        LIRELEC_COM = 'PO:Commentaires technicien';
        LIRELEC_TEL = '0101010101';
        LIRELEC_CP = '92220';
        LIRELEC_CPLT = 'Batiment';
        LIRELEC_VOIE = '102';
        LIRELEC_NUMVOIE = 'avenue aristide briand';
        LIRELEC_VILLE = 'Bagneux';
        LIRELEC_NOM = 'Nom';
        LIRELEC_PRENOM = 'Prenom';
        LIRELEC_CIVILITE = 'Mr';
        LIRELEC_CODERETOUR = '----';
        LIRELEC_DATESOUHAIT = '2018-09-06T00:00:00Z';
        LIRELEC_CODELIBL = 'F100B';
            
        inputMap.put('TypeCard','ELEC');
        inputMap.put('idPrestationDistributeur', '123456');  
        inputMap.put('commentaires', LIRELEC_COM); 
        
        SM_AP37_PrestaServiceElec lirePrestaElecOnline = new SM_AP37_PrestaServiceElec();
        
        // Test 1 : avec présence obligatoire
        lirePrestaElecOnline.invokeMethod('lirePrestationElecOnline',inputMap,outMap,null);
        
        // Test 2 : sans présence obligatoire
        LIRELEC_COM = 'PNO:Commentaires technicien';
        inputMap.put('commentaires', LIRELEC_COM);
        lirePrestaElecOnline.invokeMethod('lirePrestationElecOnline',inputMap,outMap,null);
        System.assertEquals('2', outMap.get('presence'));
        
         // Test 3 : selfcare
        inputMap.put('TypeUser', 'client');
         LIRELEC_CODELIBL = 'F100B';
        lirePrestaElecOnline.invokeMethod('lirePrestationElecOnline',inputMap,outMap,null);
        System.assertEquals('Mise en service dans votre nouveau logement', outMap.get('libelle'));
        
        inputMap.put('TypeUser', 'client');
         LIRELEC_CODELIBL = 'F140';
        lirePrestaElecOnline.invokeMethod('lirePrestationElecOnline',inputMap,outMap,null);
        System.assertEquals('Coupure dans votre ancien logement', outMap.get('libelle'));
        
        inputMap.put('TypeUser', 'client');
         LIRELEC_CODELIBL = '';
        lirePrestaElecOnline.invokeMethod('lirePrestationElecOnline',inputMap,outMap,null);
		 System.assertEquals('', outMap.get('libelle'));
    }
    
    static testMethod void lirePrestationElecListTest() {
        LIRELEC_ID_DISTRIB = 'D0001';
        LIRELEC_ID_FOURN = 'F0001';
        LIRELEC_PDL = '1234';
        LIRELEC_DATEPREVUE = '2018-09-06T00:00:00';
        LIRELEC_CRENEAU = 'Après-midi';
        LIRELEC_CRENEAU_CODE = 'APM';
        LIRELEC_COM = 'PO Commentaires technicien';
        LIRELEC_TEL = '0101010101';
        LIRELEC_CP = '92220';
        LIRELEC_CPLT = 'Batiment';
        LIRELEC_VOIE = '102';
        LIRELEC_NUMVOIE = 'avenue aristide briand';
        LIRELEC_VILLE = 'Bagneux';
        LIRELEC_NOM = 'Nom';
        LIRELEC_PRENOM = 'Prenom';
        LIRELEC_CIVILITE = 'Mr';
        LIRELEC_CODERETOUR = '----';
        LIRELEC_DATESOUHAIT = '2018-09-06T00:00:00Z';

        String inputAsString = '{"RechercherPrestaElec":{"ops":{"09701143164444":{"idPrestationServiceFournisseur":"0090644876","statutPrestationService":"Programmée chez EGD","codePrestationService":"E0005","idPrestationServiceDistrib":"A03QHIZA","libellePrestation":"MES sur raccordement existant"}},"errorCode":"INVOKE-200","error":"OK"}}';
        
        Map < String, Object > inputMap = (Map < String, Object > ) JSON.deserializeUntyped(inputAsString);
        Map < String, Object > outMap = new Map < String, Object >();  
        inputMap.put('TypeCard','ELEC');
        SM_AP37_PrestaServiceElec lireElecList = new SM_AP37_PrestaServiceElec();
        
        // Test 1 : avec présence obligatoire
        lireElecList.invokeMethod('lirePrestationElecList',inputMap,outMap,null);
    }

    static testMethod void updPrestationElecOnlineTest() {
        SM_AP37_PrestaServiceElec elec = new SM_AP37_PrestaServiceElec();
        
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map<String, Object> opsMap = new Map<String, Object>();
        
        LIRELEC_ID_DISTRIB = 'D0001';
        LIRELEC_ID_FOURN = 'F0001';
        LIRELEC_PDL = '1234';
        LIRELEC_DATEPREVUE = '2018-09-06T00:00:00Z';
        LIRELEC_CRENEAU = 'Après-midi';
        LIRELEC_CRENEAU_CODE = 'APM';
        LIRELEC_COM = 'PO:Commentaires technicien';
        inputMap.put('commentaires', LIRELEC_COM);
        LIRELEC_TEL = '0101010101';
        LIRELEC_CP = '92220';
        LIRELEC_CPLT = 'Batiment';
        LIRELEC_VOIE = '102';
        LIRELEC_NUMVOIE = 'avenue aristide briand';
        LIRELEC_VILLE = 'Bagneux';
        LIRELEC_NOM = 'Nom';
        LIRELEC_PRENOM = 'Prenom';
        LIRELEC_CIVILITE = 'Mr';
        LIRELEC_CODERETOUR = '----';
        LIRELEC_TDC = '<creneau><date>2019-06-14T00:00:00</date><creneauHoraire><libelleCourt>Fin de matinée</libelleCourt><code>FMA</code></creneauHoraire></creneau>';
        
        inputMap.put('OPSUpdate', opsMap);
        
        // Test 1 : on ne saisit pas de nom -> renvoi d'un code erreur
        elec.invokeMethod('modifierPrestationElec',inputMap,outMap,null);
        System.assertEquals('ERR_CIVNAME', outMap.get('updOpsElec_code'));
        
        // Test 2 : on saisit un nom -> pas de code erreur
       opsMap.put('LastName', 'Je saisis un nom');
        opsMap.put('FirstName', 'prenom');
        opsMap.put('Civility', 'Mr');
        opsMap.put('PhoneNumber', '04040404040');
        opsMap.put('DateEffetSouhaite', '2018-09-06T00:00:00Z');
        opsMap.put('Creneau','apm');
        inputMap.put('OPSUpdate', opsMap);
        elec.invokeMethod('modifierPrestationElec',inputMap,outMap,null);
        System.assertEquals('', outMap.get('updOpsElec_code'));      
        
         LIRELEC_DATEPREVUE = String.valueOf(Date.today().addDays(1));
        // Test 3 : -> type User Client
        opsMap.put('LastName', 'Je saisis un nom');
        opsMap.put('FirstName', 'prenom');
        opsMap.put('Civility', 'Mr');
        opsMap.put('PhoneNumber', '04040404040');
        opsMap.put('DateEffetSouhaite', '2018-09-06T00:00:00Z');
        opsMap.put('Creneau','apm');
        inputMap.put('TypeUser', 'Client');
        inputMap.put('OPSUpdate', opsMap);
        elec.invokeMethod('modifierPrestationElec',inputMap,outMap,null);
        System.assertEquals('', outMap.get('updOpsElec_code')); 
    }
    
    static testMethod void searchPrestationElecTest() {
        SM_AP37_PrestaServiceElec searchelec = new SM_AP37_PrestaServiceElec();
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
        Map < String, Object > rechercheResult = new Map < String, Object >();
        Map < String, Object > rechercheResultField = new Map < String, Object >();
        
        Map<String, Set<String>> contrat = new Map<String, Set<String>>();
        Set<String> elec = new Set<String>();
        elec.add('09702156185740');
        contrat.put('elec', elec);
        inputMap.put('WSContrat', contrat);
        
        rechercheResultField.put('idPrestationServiceFournisseur','0090645345');
        rechercheResultField.put('statutPrestationService','Programmée chez EGD');
        rechercheResultField.put('codePrestationService','E0005');
        rechercheResultField.put('idPrestationServiceDistrib','A03QJ1N0');
        rechercheResultField.put('libellePrestation','MES sur raccordement existant');
        
        rechercheResult.put('RecherchePrestationElecResult',rechercheResultField);
        
        inputMap.put('RecherchePrestationElec',rechercheResult);
        
        searchelec.invokeMethod('rechercherPrestationElec',inputMap,outMap,null);
    }
    
    static testMethod void lirePrestaElecOfflineTest() {
        SM_AP37_PrestaServiceElec lireOfflineElec = new SM_AP37_PrestaServiceElec();
        Map < String, Object > inputMap = new Map < String, Object >(); 
        Map < String, Object > outMap = new Map < String, Object >();
      
        lireOfflineElec.invokeMethod('lirePrestationElecOffline',inputMap,outMap,null);
    }
}