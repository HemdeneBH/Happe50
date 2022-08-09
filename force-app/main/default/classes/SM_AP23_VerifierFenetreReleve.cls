global class SM_AP23_VerifierFenetreReleve implements vlocity_cmt.VlocityOpenInterface {

 global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

  if (methodName.equals('verifierFenetreReleve')) {
   try {
    verifierFenetreReleve(inputMap, outMap, options);
   } catch (Exception e) {
    system.debug(e.getStackTraceString());
    return false;
   }
  }
  return true;
 }


 public static void verifierFenetreReleve(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

      Map<String,Object> initData = (Map<String,Object>) inputMap.get('InitData') ;
      String pdlPce = (String) initData.get('pdlpce') ;
       String pdlPce1 = (String) initData.get('pdlpce1') ;

     
     
  //Context
  gdfsuezComBefChpPivotReleve.contextDt octx = initContext('Smile', '3.0');
  SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();


  //   codes.add(canalCodeInput);


  //Port 
  gdfsuezComBefChpCalypsoReleveV3.RelevePort port = new gdfsuezComBefChpCalypsoReleveV3.RelevePort();
  port.clientCertName_x = octopusCS.certName__c;
  port.endpoint_x = octopusCS.endpoint__c + 'E-Releve_v3';
  port.inputHttpHeaders_x = new Map < String, String > {
   'Content-Type' => 'text/xml;charset=utf-8'
  };


  // input 
  // 
  gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt verifFenetreInput = new gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt();
          verifFenetreInput.PDL = new List<gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt_PDL_element>();
     
     if(!String.isBlank(pdlPce)){
     gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt_PDL_element elementInput  = new gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt_PDL_element();
     elementInput.idPDL =  pdlPce ; //'21100274761305' ;
     elementInput.dateReference = Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); 
         verifFenetreInput.PDL.add(elementInput) ; 
     }
      if(!String.isBlank(pdlPce1)){ // cas dual

     gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt_PDL_element elementInput1  = new gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveInputDt_PDL_element();
     elementInput1.idPDL =  pdlPce1 ; //'21100274761305' ;
     elementInput1.dateReference =  Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss'); 
         verifFenetreInput.PDL.add(elementInput1)    ; 
         }
     
     
     
  gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveResponse_element response = new gdfsuezComBefChpCalypsoReleveV3.verifierFenetreReleveResponse_element();

  String responseCode;
  String responseLibelle;

     try{

  if (!Test.isRunningTest()) {
    response = port.VerifierFenetreReleve_Http(verifFenetreInput, octx);
  } else {
 Test.setMock(HttpCalloutMock.class, new gdfsuezComBefChpCalypsoReleveV3HttpMock());
   gdfsuezComBefChpCalypsoReleveV3.RelevePort porttest = new gdfsuezComBefChpCalypsoReleveV3.RelevePort();
   system.debug('@@ start of mock');
   response = porttest.VerifierFenetreReleve_Http(verifFenetreInput, octx);
   system.debug('@@ end of mock');

  }
      
system.debug('response ****'+response);
      
   responseCode = response.messageRetours.messageRetour[0].code;
   responseLibelle = response.messageRetours.messageRetour[0].libelle;

   system.debug('reponse : ' + response);
   system.debug('responseCode: ' + responseCode);
   system.debug('responseLibelle : ' + responseLibelle);
   outMap.put('VerifFenetreError', responseCode.equals('OCTOPUS_VerifierFenetreReleve_01')?'OK' : responseCode.equals('OCTOPUS_VerifierFenetreReleve_08')?'La date du jour ne se situe pas dans la période de saisie d auto-relève conseillée' : (responseCode+' : '+responseLibelle)) ;
     }catch(Exception e){
         system.debug('## error ## '+e.getStackTraceString());
         outMap.put('VerifFenetreError','Probléme survenu lors d appel WS'+e.getStackTraceString());
     }


 }


 public static gdfsuezComBefChpPivotReleve.contextDt initContext(String application, String version) {
  // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
  gdfsuezComBefChpPivotReleve.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotReleve.contextDt_systemPath_system_element();
  osource.systemId = application;
  gdfsuezComBefChpPivotReleve.contextDt octx = new gdfsuezComBefChpPivotReleve.contextDt();
  octx.version = version;
  octx.allowCache = false;
  octx.systemPath = new gdfsuezComBefChpPivotReleve.contextDt_systemPath_element();
  octx.systemPath.system_x = new gdfsuezComBefChpPivotReleve.contextDt_systemPath_system_element[] {
   osource
  };
  return octx;
 }



}