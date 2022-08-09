@isTest
global class SM_AP72_EspaceClientService_Test {
    
    @isTest
    global static void testCreationEspaceClient(){
        //GIVEN
        
        Map<String,Object> espaceClientACreer =  SM_TestDataFactory.createAccountData('Marie','LEMOINE','MME','marie.lemoine@test.com','123456687');
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiEspacesPrives');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        //WHEN 
        String response  = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientACreer);
        
        
        //THEN
        System.assertEquals('OK', response);
        
    }
    
    @isTest
    global static void testEnvoieEmailActivation(){
        //GIVEN
        
        Map<String,Object> mailActivationRequest = new Map<String,Object>{
            'email' => 'marie.lemoine@test.com',
                'numeroBP' => '123456687'
                };
                    
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiEmailActivation');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        //WHEN 
        String response  = SM_AP72_EspaceClientService.renvoyerMailActivation(mailActivationRequest);
        
        
        //THEN
        System.assertEquals('OK', response);
        
    }
    @isTest
    global static void testGetMessagefromErrorCodeKO(){
        
        Test.startTest();
        Map<String,Object> espaceClientACreer =  SM_TestDataFactory.createAccountData('Marie','LEMOINE','MME','marie.lemoine@test.com','123456687');   
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiErrorMassagesKO');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        //WHEN 
        String response  = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientACreer);
        Test.stopTest();
        //THEN
        //System.assertEquals('Une erreur technique est survenue. L’Espace Client n’a pas été créé. Inviter le Client à contacter le Webmaster directement depuis le site de ENGIE particuliers.', response);
    }
    @isTest
    global static void testGetMessagefromErrorCodeOK(){
        Test.startTest();
        Map<String,Object> espaceClientACreer =  SM_TestDataFactory.createAccountData('Marie','LEMOINE','MME','marie.lemoine@test.com','123456687');   
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiErrorMassagesOK');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        //WHEN 
        String response  = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientACreer);
        Test.stopTest();
        //THEN
        System.assertEquals('OK', response);
    }
    @isTest
    global static void testGetMessagefromErrorCodeKOGenerique(){
        Test.startTest();
        Map<String,Object> espaceClientACreer =  SM_TestDataFactory.createAccountData('Marie','LEMOINE','MME','marie.lemoine@test.com','123456687');   
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('SM_MockResponseApiErrorMassagesKOGenerique');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        
        //WHEN 
        String response  = SM_AP72_EspaceClientService.creerEspaceClient(espaceClientACreer);
        Test.stopTest();
        //THEN
        System.assertEquals('Une erreur technique est survenue. L’Espace Client n’a pas été créé. Inviter le Client à contacter le Webmaster directement depuis le site de ENGIE particuliers.', response);
    }
}