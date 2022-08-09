/*@author: MHA
*Descritpion: récupérationd des valeurs de l'API installation
*@createDate: 06/09/2018
*LastModified: MHA 20/12/2018
*/
@isTest
global class SM_AP08_InstallationApiService_TEST {
    /*@author: MHA
    *Descritpion: récupérationd des valeurs de l'API installation avec le PDL et le PCE
    *@createDate: 06/09/2018
    *LastModified: MHA 20/12/2018
    */
    @isTest
    global static void GetIdLocalWithPDLPCE() {
        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>insideInputMap = new Map<String, object>();
        Map<String, object>outputMap = new Map<String, object>() ;

        insideInputMap.put('selectedPDLValFormula', '07379884188779');
        insideInputMap.put('selectedPCEValFormula', '07380028906578');
        inputMap.put('ChoixElements1', insideInputMap);

        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        HttpRequest request = new HttpRequest();
        Http http= new http();
        HttpResponse response= http.send(request);
        system.debug(response.getBody());
        // WHEN
        service.invokeMethod('callInstallations', inputMap, outputMap, null) ;

        // THEN
        System.debug(outputMap);
        Map<String, object>data1 = (Map<String, Object>)outputMap.get('data1');
        List<Object>resultdata1 = (List<Object>)data1.get('resultdata1');
        SM_AP08_InstallationApiService.InstallationsModel installation= (SM_AP08_InstallationApiService.InstallationsModel)resultdata1[2];
        system.debug('@testClass'+installation.idLocal);
        System.assertEquals('25972',installation.idLocal);

    }

    /*@author: MHA
    *Descritpion: récupérationd des valeurs de l'API installation avec le PDL
    *@createDate: 06/09/2018
    *LastModified: MHA 20/12/2018
    */
    @isTest
    global static void GetIdLocalWithPDL() {
        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>insideInputMap = new Map<String, object>();
        Map<String, object>outputMap = new Map<String, object>() ;

        insideInputMap.put('selectedPDLValFormula', '07379884188779');
        /*insideInputMap.put('selectedPCEValFormula', '07380028906578');*/
        inputMap.put('ChoixElements1', insideInputMap);

        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        // WHEN
        service.invokeMethod('callInstallations', inputMap, outputMap, null) ;

        // THEN
        System.debug(outputMap);
        Map<String, object>data1 = (Map<String, Object>)outputMap.get('data1');
        List<Object>resultdata1 = (List<Object>)data1.get('resultdata1');
        SM_AP08_InstallationApiService.InstallationsModel installation= (SM_AP08_InstallationApiService.InstallationsModel)resultdata1[2];
        system.debug('@testClass'+installation.idLocal);
        System.assertEquals('25972',installation.idLocal);

    }

    /*@author: MHA
    *Descritpion: récupérationd des valeurs de l'API installation avec le PCE
    *@createDate: 06/09/2018
    *LastModified: MHA 20/12/2018
    */
    @isTest
    global static void GetIdLocalWithPCE() {
        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>insideInputMap = new Map<String, object>();
        Map<String, object>outputMap = new Map<String, object>() ;

        insideInputMap.put('selectedPCEValFormula', '07380028906578');
        inputMap.put('ChoixElements1', insideInputMap);



        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        // WHEN
        service.invokeMethod('callInstallations', inputMap, outputMap, null) ;

        // THEN
        System.debug(outputMap);
        Map<String, object>data1 = (Map<String, Object>)outputMap.get('data1');
        List<Object>resultdata1 = (List<Object>)data1.get('resultdata1');
        SM_AP08_InstallationApiService.InstallationsModel installation= (SM_AP08_InstallationApiService.InstallationsModel)resultdata1[1];
        system.debug('@testClass'+installation.idLocal);

        System.assertEquals('25972',installation.idLocal);

    }

    /*@author: MHA
    *Descritpion: récupérationd des valeurs de l'API installation avec l'Id Local
    *@createDate: 20/12/2018
    *LastModified: MHA 20/12/2018
    */
    @isTest
    global static void getInstallationWithIdLocal(){
        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>insideInputMap = new Map<String, object>();
        Map<String, object>outputMap = new Map<String, object>() ;

        inputMap.put('idLocal','25972');

        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);
        // WHEN
        service.invokeMethod('getInstallationData', inputMap, outputMap, null) ;
        Map<String,Object> resultData = (Map<String,Object>)outputMap.get('resultdata');
        List<Object> result = (List<Object>)resultData.get('_data');
        Map<String, Object> datas = (Map<String, Object>)result.get(1);
        System.debug('@MHA testMGH'+result.get(1));
        String idLocal = String.valueOf(datas.get('idLocal'));
        String idPointDeLivraison = String.valueOf(datas.get('idPointDeLivraison'));
        String idInstallation = String.valueOf(datas.get('id'));
        String secteurActivite = String.valueOf(datas.get('secteurActivite'));
        System.assertEquals('25972',idLocal);
        System.assertEquals('18156',idPointDeLivraison);
        System.assertEquals('11466',idInstallation);
        System.assertEquals('Gaz Naturel',secteurActivite);

    }

    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    public static void prepareApiCallResource(){
        MP_Generics_Endpoints__c endpoint = new MP_Generics_Endpoints__c();
        endpoint.EndPoint__c = 'https://auth.ext.rec.api.engie.fr';
        endpoint.Name = 'api_endpoint';
        insert endpoint;

        MP_Xdata_credentials__c sm_api_version = new MP_Xdata_credentials__c();
        sm_api_version.Value__c = '0.1';
        sm_api_version.Name = 'sm_api_version';
        insert sm_api_version;

        MP_Xdata_credentials__c sm_api_key_INT = new MP_Xdata_credentials__c();
        sm_api_key_INT.Value__c = 'l7xx914e96a9169640b2ab5afd09c6163829';
        sm_api_key_INT.Name = 'sm_api_key_INT';
        insert sm_api_key_INT;
    }

    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void should_be_able_to_find_pdl_installation() {


        //  Given
        //  Etant donne que le client ne possede pas de contrat ELEC
        //  Le Consultant clique sur le bouton Rejoignez-Nous de la card ELEC
        //  Etape Choix de l'offre dans l'OS MoveIN

        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>outputMap = new Map<String, object>() ;

        inputMap.put('typeEnergieDemandee', 'ELEC');
        inputMap.put('idLocal', '25972');

        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistencePDLOrPCE', inputMap, outputMap, null) ;


        // THEN
        System.assertEquals(true,outputMap.get('isPDLOrPCEExistInSAP'));


    }

    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void should_be_able_to_find_pce_installation() {

        //  Given
        //  Etant donne que le client ne possede pas de contrat ELEC
        //  Le Consultant clique sur le bouton Rejoignez-Nous de la card ELEC
        //  Etape Choix de l'offre dans l'OS MoveIN

        Map<String, object>inputMap = new Map<String, object>() ;
        Map<String, object>outputMap = new Map<String, object>() ;

        inputMap.put('typeEnergieDemandee', 'GAZ');
        inputMap.put('idLocal', '25972');

        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallations');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistencePDLOrPCE', inputMap, outputMap, null) ;


        // THEN
        System.assertEquals(true,outputMap.get('isPDLOrPCEExistInSAP'));

    }
    
    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void verifyExistentInstallations_ELEC() {


        //  Given
    

        Map<String, object>inputMap = new Map<String, object>() ;
        
        Map<String, object>etapeContexteMap = new Map<String, object>() ;
        etapeContexteMap.put('EnergyTypeOptions','Elec');
        
        Map<String, object>etapeLogementMap = new Map<String, object>() ;
        etapeLogementMap.put('selectedPDLValFormula','07379884188779');
        
        
        inputMap.put('ChoixElements',etapeContexteMap);
        inputMap.put('ChoixElements1',etapeLogementMap);
        Map<String, object>outputMap = new Map<String, object>() ;


        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallationsElec');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistentInstallations', inputMap, outputMap, null) ;


        // THEN
        System.debug('output map : '+ outputMap);
        //SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated =  infoPDLPCEToBeCreatedMap = (SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated) outputMap.get('InfoPDLPCEToBeCreated');
        String idLocal  = (String) outputMap.get('idLocal');
        System.assertEquals(idLocal,'25972');


    }
    
     /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void verifyExistentInstallations_GAZ() {


        //  Given
    

        Map<String, object>inputMap = new Map<String, object>() ;
        
        Map<String, object>etapeContexteMap = new Map<String, object>() ;
        etapeContexteMap.put('EnergyTypeOptions','Gaz');
        
        Map<String, object>etapeLogementMap = new Map<String, object>() ;
        etapeLogementMap.put('selectedPCEValFormula','07380028906578');
        
        
        inputMap.put('ChoixElements',etapeContexteMap);
        inputMap.put('ChoixElements1',etapeLogementMap);
        Map<String, object>outputMap = new Map<String, object>() ;


        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallationsGaz');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistentInstallations', inputMap, outputMap, null) ;


        // THEN
        System.debug('output map : '+ outputMap);
        //SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated =  infoPDLPCEToBeCreatedMap = (SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated) outputMap.get('InfoPDLPCEToBeCreated');
        String idLocal  = (String) outputMap.get('idLocal');
        System.assertEquals(idLocal,'25972');


    }
    
    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void verifyExistentInstallations_Elec_GAZ_Associated() {


        //  Given
    

        Map<String, object>inputMap = new Map<String, object>() ;
        
        Map<String, object>etapeContexteMap = new Map<String, object>() ;
        etapeContexteMap.put('EnergyTypeOptions','Elec');
        
        Map<String, object>etapeLogementMap = new Map<String, object>() ;
        etapeLogementMap.put('selectedPDLValFormula','07379884188779');
        etapeLogementMap.put('associatedPCEVal','07380028906578');
        
        
        inputMap.put('ChoixElements',etapeContexteMap);
        inputMap.put('ChoixElements1',etapeLogementMap);
        Map<String, object>outputMap = new Map<String, object>() ;


        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallationsGaz');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistentInstallations', inputMap, outputMap, null) ;


        // THEN
        System.debug('output map : '+ outputMap);
        //SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated =  infoPDLPCEToBeCreatedMap = (SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated) outputMap.get('InfoPDLPCEToBeCreated');
        String idLocal  = (String) outputMap.get('idLocal');
        System.assertEquals(idLocal,'25972');


    }
    
    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void verifyExistentInstallations_GAZ_ELEC_Associated() {


        //  Given
    

        Map<String, object>inputMap = new Map<String, object>() ;
        
        Map<String, object>etapeContexteMap = new Map<String, object>() ;
        etapeContexteMap.put('EnergyTypeOptions','Gaz');
        
        Map<String, object>etapeLogementMap = new Map<String, object>() ;
        etapeLogementMap.put('selectedPCEValFormula','07380028906578');
        etapeLogementMap.put('associatedPDLVal','07379884188779');
        
        
        inputMap.put('ChoixElements',etapeContexteMap);
        inputMap.put('ChoixElements1',etapeLogementMap);
        Map<String, object>outputMap = new Map<String, object>() ;


        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallationsGaz');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistentInstallations', inputMap, outputMap, null) ;


        // THEN
        System.debug('output map : '+ outputMap);
        //SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated =  infoPDLPCEToBeCreatedMap = (SM_AP08_InstallationAapiService.InfoPDLPCEToBeCreated) outputMap.get('InfoPDLPCEToBeCreated');
        String idLocal  = (String) outputMap.get('idLocal');
        System.assertEquals(idLocal,'25972');


    }
    
    /*@author: HEL
    *Descritpion:
    *@createDate:
    *LastModified: HEL
    */
    @isTest
    global static void verifyExistentInstallations_GAZ_ELEC_DUO() {


        //  Given
    

        Map<String, object>inputMap = new Map<String, object>() ;
        
        Map<String, object>etapeContexteMap = new Map<String, object>() ;
        etapeContexteMap.put('EnergyTypeOptions','Duo');
        
        Map<String, object>etapeLogementMap = new Map<String, object>() ;
        etapeLogementMap.put('selectedPCEValFormula','07380028906578');
        etapeLogementMap.put('selectedPDLValFormula','07379884188779');
        
        
        inputMap.put('ChoixElements',etapeContexteMap);
        inputMap.put('ChoixElements1',etapeLogementMap);
        Map<String, object>outputMap = new Map<String, object>() ;


        SM_AP08_InstallationApiService service = new SM_AP08_InstallationApiService();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiInstallationsGaz');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        // Set the mock callout mode
        Test.setMock(HttpCalloutMock.class, mock);

        // WHEN
        service.invokeMethod('verifyExistentInstallations', inputMap, outputMap, null) ;


        // THEN
        System.debug('output map : '+ outputMap);
        String idLocal  = (String) outputMap.get('idLocal');
        System.assertEquals(idLocal,'25972');


    }
    
    
    
}