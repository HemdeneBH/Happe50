/*
*@Author: MKC
*@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires
*@CreatedDate: 01/02/2019
*@LastModified: MHA 04/04/2019
*/
global class SM_AP24_CoordonneesBancaires implements vlocity_cmt.VlocityOpenInterface {

  /*
  *@Author: MKC
  *@Description: Méthode à appeler dans cette API
  *@CreatedDate: 01/02/2019
  *@LastModified: MHA 04/04/2019
  */
  global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        if (methodName.equals('getCoordonneesBancaires')) {
      try {
        getCoordonneesBancaires(inputMap, outMap, options);
      } catch (Exception e) {
        system.debug(e);
        return false;
      }
    }
    return true;

}

  /*
   *@Author: MKC
   *@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires avec l'idBP
   *@CreatedDate: 01/02/2019
   *@LastModified: MHA 04/04/2019
   */
  public static void getCoordonneesBancaires(Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {

        String vIdBP = (String) inputMap.get('refClientIdBP');
    vIdBP = bpVerification(vIdBP);
    //='0309980004';
    String reqParams = '?';
    /* Rechercher les coodonnees bancaires a partir de la ref client  */
    if (!String.isBlank(vIdBP)) {
      reqParams = reqParams + 'idBusinessPartner=' + vIdBP;
    } else {
      system.debug('Pas d idBP en entrée l API ne peut etre invoqué...');
      // pas de Idbp , on ne peut recupérer les coordonnées bancaires
      return ;
    }
    String token;
    if (Test.isRunningTest()) {
      token = 'wadfkoa1234';
    } else {
      token = SM_MP_AP04_GetTokenService.getTokenFromSmile();
    }
    if (token == null) {
      system.debug('@@ Token not found ...');
      return;
    }
    HttpResponse httpResponse = new HttpResponse();
    if (test.isRunningTest()) {
      StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
      mock.setStaticResource('SM_MockResponseGetCoordonneesBancaires');
      mock.setStatusCode(200);
      mock.setHeader('Content-Type', 'application/json');
      // Set the mock callout mode
      Test.setMock(HttpCalloutMock.class, mock);
    }
    httpResponse = getResponse(token, reqParams);


    system.debug('@@ httpResponse ' + httpResponse);
    if (httpResponse != null) {
      Map < String, Object > resultAsMap = (Map < String, Object > ) JSON.deserializeUntyped(httpResponse.getBody());
      List < Object > listCoordonneesB = (List < Object > ) resultAsMap.get('_data');
      if (listCoordonneesB != null && !listCoordonneesB.isEmpty()) {
        Map < String, Object > coordonnes = (Map < String, Object > ) listCoordonneesB[0];
        Map < String, String > mapChamps = new Map < String, String > ();
        String iBAN = (String) coordonnes.get('iBAN');
        String bic = (String) coordonnes.get('bIC');
        String Nombanque = (String) coordonnes.get('nomInstitutBancaire');
        String TitulaireCompte = (String) coordonnes.get('titulaire');
        String idBusinessPartner = (String) coordonnes.get('idBusinessPartner');
        String idCoordonneesBancaire = (String) coordonnes.get('id');
        mapChamps.put('IbanNumber', iBAN);
        mapChamps.put('bic', bic);
        mapChamps.put('Nombanque', Nombanque);
        mapChamps.put('TitulaireCompte', TitulaireCompte);
        mapChamps.put('idPersonne', idBusinessPartner);
        mapChamps.put('idCoordonneeBancaire', idCoordonneesBancaire);
        Map < String, Object > mapPrelBloc = new Map < String, Object > ();
        Map < String, Object > mapPrelInfoBloc = new Map < String, Object > ();
        mapPrelInfoBloc.put('PrelevementInfosBlock', mapChamps);
        mapPrelBloc.put('PrelevementBlock', mapPrelInfoBloc);
        mapPrelBloc.put('EditBlock1', getAllList(listCoordonneesB));
        outMap.put('ServicesGestion', mapPrelBloc);
      }

    }

}

  /*
   *@Author: MKC
   *@Description: Appel de l'API APIHOUR apiset/coordonnées bancaires avec l'idBP
   *@CreatedDate: 01/02/2019
   *@LastModified: MHA 04/04/2019
   */
  public static List < Object > getAllList(List < Object > listCoordonneesB) {

    List < Object > listtemp = new List < Object > ();
    try {
      for (Object coordonnesObj : listCoordonneesB) {
        Map < String, object > coordonnes = (Map < String, Object > ) coordonnesObj;
        system.debug('coordonesss####' + coordonnes);
        Map < String, String > mapChamps = new Map < String, String > ();

        String iBAN = (String) coordonnes.get('iBAN');
        String bic = (String) coordonnes.get('bIC');
        String Nombanque = (String) coordonnes.get('nomInstitutBancaire');
        String TitulaireCompte = (String) coordonnes.get('titulaire');
        //idCompteClient coté Octopus mappé avec IdPortefeuillContrat coté Xdata
        integer idCompteClient = (integer) coordonnes.get('idPortefeuilleContrat');
        //Idpersonne coté Octopus mappé avec IdBP coté Xdata
        String idPersonne = (String) coordonnes.get('idBusinessPartner');
        String idCoordonneesBancaire = (String) coordonnes.get('id');
        mapChamps.put('IbanNumber', iBAN);
        mapChamps.put('bic', bic);
        mapChamps.put('Nombanque', Nombanque);
        mapChamps.put('TitulaireCompte', TitulaireCompte);
        mapChamps.put('idPersonne', String.valueOf(idPersonne));
        mapChamps.put('idCompteClientCoordB', String.valueOf(idCompteClient));
        mapChamps.put('idCoordonneeBancaire', idCoordonneesBancaire);
        mapChamps.put('libelle1', 'N° IBAN: ' + iBAN + ' ,BIC: ' + bic);
        mapChamps.put('libelle2', 'Nom de la banque: ' + Nombanque + ' ,Titulaire du compte: ' + TitulaireCompte);
        listtemp.add(mapChamps);
        System.debug('*** Added to json : ' + mapChamps);
      }
    } catch (Exception e) {
      system.debug('## error occured ##' + e.getStackTraceString());
    }
    return listtemp;


  }


  /*
   *@Author: MKC
   *@Description: Gestion de la response
   *@CreatedDate: 01/02/2019
   *@LastModified: MHA 04/04/2019
   */
  public static HttpResponse getResponse(String token, String reqParams) {

        HttpRequest httpReq = buildHttpRequestHeaders(token, reqParams);
    HttpResponse httpResp = sendData(httpReq);
    if (httpResponseFailureDetected(httpResp)) {
      // should abort next step's
      system.debug('## [getAdresse] error occured when sending data ##');
      system.debug(httpResp != null ? httpResp.getBody() : 'http response is null');
      return null;
    }
    system.debug('http response is ' + httpResp.getBody());
    return httpResp;

}


  public static HttpRequest buildHttpRequestHeaders(String token, String reqParams) {

        HttpRequest req = new HttpRequest();
    req.setMethod('GET');
    String endpointURL = '';
    if (!Test.isRunningTest()) {
      SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'Coordonnees_Bancaires' limit 1];
      endpointURL = 'callout:AuthAPIHour' + suffixs.suffix__c;
    }
    req.setEndpoint(endpointURL + reqParams);
    req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
    req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('sm_api_key_INT').Value__c);
    req.setHeader('Authorization', 'Bearer ' + token);
    req.setHeader('Content-Type', 'application/json');
    return req;

}

  public static HttpResponse sendData(HttpRequest request) {

        Http http = new Http();
    HttpResponse res;
    try {
      res = http.send(request);

    } catch (Exception e) {
      system.debug('## sendData failed ' + e.getMessage());
      return null;
    }
    return res;

}


  private static Boolean httpResponseFailureDetected(HttpResponse response) {

        system.debug('@@ response.getStatusCode() ' + response.getStatusCode());
    system.debug('@@ response.getBody() ' + response.getBody());
    return (response == null || (response.getStatusCode() != 201 && response.getStatusCode() != 200 && response.getStatusCode() != 206));

}

  public static String bpVerification(String idBP) {

        String result = '';
    if (idBP.length() < 10) {

      Integer missingNumber = 10 - idBP.length();
      for (Integer i = 0; i < missingNumber; i++) {
        result += '0';
      }
    }
    result += idBP;
    system.debug('result:'+result);
    return result;

}

}