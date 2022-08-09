public with sharing class SM_AP89_GestionSouscriptionService {
   
   // @future(callout=true)
    public static void demanderSouscriptionService(String email,String idcompteclient,String idpersonne,String idPropositionCommerciale,Map <String, Object> outMap){



      /*  SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        //String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1"><soapenv:Header/><soapenv:Body><v1:demanderSouscriptionService><demanderSouscriptionServiceInput><idCompteClient>000507988474</idCompteClient><idPersonne>0305595557</idPersonne><adresseEmailCorrespondance>test@gmail.com</adresseEmailCorrespondance><idPropositionCommerciale>7013936282</idPropositionCommerciale><enseigne><code>CRC</code></enseigne><service><serviceGestion><libelleCourt>Compte en ligne</libelleCourt><code>CEL</code></serviceGestion><statutService><libelleCourt>Demandé</libelleCourt><code>3</code></statutService></service><service><serviceGestion><libelleCourt>ma facture</libelleCourt><code>ZFACT</code></serviceGestion><typeGestion><libelleCourt>ma facture en ligne</libelleCourt><code>ZFACTL</code></typeGestion><statutService><libelleCourt>Demandé</libelleCourt><code>3</code></statutService></service></demanderSouscriptionServiceInput><context><version>1.0</version><systemPath><system><systemId>0</systemId></system></systemPath><allowCache>false</allowCache></context></v1:demanderSouscriptionService></soapenv:Body></soapenv:Envelope>';
        //String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1"><soapenv:Header/><soapenv:Body><v1:demanderSouscriptionService><demanderSouscriptionServiceInput><idCompteClient>'+idcompteclient+'</idCompteClient><idPersonne>'+idpersonne+'</idPersonne><adresseEmailCorrespondance>'+email+'</adresseEmailCorrespondance><enseigne><code>CRC</code></enseigne><service><serviceGestion><libelleCourt>Compte en ligne</libelleCourt><code>CEL</code></serviceGestion><statutService><libelleCourt>Demandé</libelleCourt><code>3</code></statutService></service><service><serviceGestion><libelleCourt>ma facture</libelleCourt><code>ZFACT</code></serviceGestion><typeGestion><libelleCourt>ma facture en ligne</libelleCourt><code>ZFACTL</code></typeGestion><statutService><libelleCourt>Demandé</libelleCourt><code>3</code></statutService></service></demanderSouscriptionServiceInput><context><version>1.0</version><systemPath><system><systemId>0</systemId></system></systemPath><allowCache>false</allowCache></context></v1:demanderSouscriptionService></soapenv:Body></soapenv:Envelope>';
        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.gdfsuez.com/bef/chp/calypso/GestionSouscriptionService/v1"><soapenv:Header/><soapenv:Body><v1:demanderSouscriptionService><demanderSouscriptionServiceInput><idCompteClient>'+idcompteclient+'</idCompteClient><idPersonne>'+idpersonne+'</idPersonne><adresseEmailCorrespondance>'+email+'</adresseEmailCorrespondance><enseigne><code>CRC</code></enseigne><service><serviceGestion><libelleCourt>ma facture</libelleCourt><code>ZFACT</code></serviceGestion><typeGestion><libelleCourt>ma facture en ligne</libelleCourt><code>ZFACTL</code></typeGestion><statutService><libelleCourt>Demandé</libelleCourt><code>3</code></statutService></service></demanderSouscriptionServiceInput><context><version>1.0</version><systemPath><system><systemId>0</systemId></system></systemPath><allowCache>false</allowCache></context></v1:demanderSouscriptionService></soapenv:Body></soapenv:Envelope>';
        String mediateur ='ES-GestionSouscription_v1';
        String tns = 'GestionSouscriptionService';
        
        //String endpoint = 'https://octopus.ws-ines-rct.engie.com:50001/smile-noprod-gdc/ws/'+ mediateur;//Lien Recette octopus
        String endpoint = octopusCS.endpoint__c + mediateur;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(endpoint);
        
        request.setClientCertificateName(octopusCS.certName__c);// Certificat recette Octopus
        request.setMethod('POST');
        request.setHeader('Content-Type', 'text/xml; charset=UTF-8');
        request.setHeader('SOAPAction', 'tns:'+tns);
        request.setTimeout(60000);
        request.setBody(body);
        
        HttpResponse res = http.send(request);
        system.debug('### req demande souscription service '+body);
        system.debug('### resp demande souscription service '+res.getBody());        
        
        */
        
                //Context
        gdfsuezComBefChpPivot.contextDt octx = initContextt('Smile', '1.0');
        //gdfsuezComBefChpPivotCompteClient.contextDt octx = initContext('Smile', '1.0');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();

        gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort port = new gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort();
        port.clientCertName_x = octopusCS.certName__c;
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'GestionSouscription_v1' limit 1];
        port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };

        gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt input = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt();    
        input.idCompteClient =  idcompteclient;
        input.idPersonne = idpersonne;
        input.idPropositionCommerciale = idPropositionCommerciale;
        input.adresseEmailCorrespondance = email;
        input.enseigne = new gdfsuezComBefChpPivot.listeValeursDt();
        input.enseigne.code = 'CRC';
        input.service = new gdfsuezComBefChpCalypsoGestionso.serviceDt[1];
        input.service[0] = new gdfsuezComBefChpCalypsoGestionso.serviceDt();
        input.service[0].serviceGestion = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].serviceGestion.libelleCourt = 'ma facture';
        input.service[0].serviceGestion.code = 'ZFACT';
        input.service[0].typeGestion = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].typeGestion.libelleCourt = 'ma facture en ligne';
        input.service[0].typeGestion.code = 'ZFACTL';
        input.service[0].statutService = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].statutService.libelleCourt = 'Demandé';
        input.service[0].statutService.code = '3';

        gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element response = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element();
		
		if (!Test.isRunningTest()) {
			response = port.DemanderSouscriptionService_Http(input, octx);

        }
        else{

            Test.setMock(HttpCalloutMock.class, new SM_AP89_GestionSouscriptionService_mock());
			gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort porttest = new gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort();
			system.debug('@@ start of mock');
			response = porttest.DemanderSouscriptionService_Http(input, octx);
			system.debug('@@ end of mock');
           
        }

       Map<String, Object> ipOutput = new Map<String, Object> ();
       /*  if(response != null && response.messageRetours != null){
        
        ipOutput.put('code', response.messageRetours.messageRetour[0].code);
        } */
        
 
        if(response != null && response.messageRetours != null){
        
        
        outMap.put('code', response.messageRetours.messageRetour[0].code);
          
        }

      
        
    }
    

    @AuraEnabled(cacheable=false)

    public static Map<String, Object> demanderSouscriptionServiceRef(Map<String, Object> inputMap){
        
        //Context
        gdfsuezComBefChpPivot.contextDt octx = initContextt('Smile', '1.0');
        //gdfsuezComBefChpPivotCompteClient.contextDt octx = initContext('Smile', '1.0');
        SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
        
        gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort port = new gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort();
        port.clientCertName_x = octopusCS.certName__c;
        SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'GestionSouscription_v1' limit 1];
        port.endpoint_x = octopusCS.endpoint__c + suffixs.suffix__c;
        port.inputHttpHeaders_x = new Map < String, String > {
            'Content-Type' => 'text/xml;charset=utf-8'
                };
        
        gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt input = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceInputDt();    
        input.idCompteClient =  (String) inputMap.get('account');
        input.idPersonne = (String) inputMap.get('refClientIdBP');
        
        input.adresseEmailCorrespondance = (String) inputMap.get('mail');
        input.enseigne = new gdfsuezComBefChpPivot.listeValeursDt();
        input.enseigne.code = 'CRC';
        input.service = new gdfsuezComBefChpCalypsoGestionso.serviceDt[1];
        input.service[0] = new gdfsuezComBefChpCalypsoGestionso.serviceDt();
        input.service[0].serviceGestion = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].serviceGestion.libelleCourt = 'ma facture';
        input.service[0].serviceGestion.code = 'ZFACT';
        input.service[0].typeGestion = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].typeGestion.libelleCourt = 'ma facture en ligne';
        input.service[0].typeGestion.code = 'ZFACTL';
        input.service[0].statutService = new gdfsuezComBefChpPivot.listeValeursDt();
        input.service[0].statutService.libelleCourt = 'Demandé';
        input.service[0].statutService.code = '3';


        gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element response = new gdfsuezComBefChpCalypsoGestionso.demanderSouscriptionServiceResponse_element();
		
		if (!Test.isRunningTest()) {
			response = port.DemanderSouscriptionService_Http(input, octx);


        }
        else{

            Test.setMock(HttpCalloutMock.class, new SM_AP89_GestionSouscriptionService_mock());
			gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort porttest = new gdfsuezComBefChpCalypsoGestionso.DemandeSouscriptionServicePort();
			system.debug('@@ start of mock');
			response = porttest.DemanderSouscriptionService_Http(input, octx);
			system.debug('@@ end of mock');
           
        }

        Map<String, Object> ipOutput = new Map<String, Object> ();
        if(response != null && response.messageRetours != null){
        
        ipOutput.put('code', response.messageRetours.messageRetour[0].code);


        }
        
        return ipOutput;                 
    }
    
	//ADE DesactiverServiceGestion FT1-4112
	@AuraEnabled(cacheable=false)
    public static Map<String, Object>  desactiverServiceGestion(Map<String, Object> inputMap){
    //Context
    gdfsuezComBefChpPivotCompteClient.contextDt octx = initContext('Smile', '6.0');
    SM_OCTOPUS__c octopusCS = SM_OCTOPUS__c.getOrgDefaults();
    //Port
    gdfsuezBefCalypsoCompteclientV6.Dependency port = new gdfsuezBefCalypsoCompteclientV6.Dependency();
    port.clientCertName_x = octopusCS.certName__c;
    SM_WS_Suffix__mdt suffixs = [select id, suffix__c from SM_WS_Suffix__mdt where developername = 'CompteClient' limit 1];
    port.endpoint_x = octopusCS.endpoint__c +suffixs.suffix__c;
    port.inputHttpHeaders_x = new Map < String, String > {
      'Content-Type' => 'text/xml;charset=utf-8'
    };
        
         // input
        gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionInputDt desactiverServiceGestionInputDt=new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionInputDt();
        /*--------------ZFACTL----------------*/
        //serviceGestion
        gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element compteClient_serviceSouscrit_element=new gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element();
        gdfsuezComBefChpPivotCompteClient.listeValeursDt serviceGestion=new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
        serviceGestion.code='ZFACT';
        //typeGestion
        gdfsuezComBefChpPivotCompteClient.listeValeursDt typeGestion=new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
        typeGestion.code='ZFACTL';               
        compteClient_serviceSouscrit_element.serviceGestion=serviceGestion;
        compteClient_serviceSouscrit_element.typeGestion=typeGestion;
        gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element[] serviceSouscrits=new gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element[1];
        serviceSouscrits.add(compteClient_serviceSouscrit_element);
        /*------------ZFACTLSMS------------------*/
        //serviceGestion
        gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element compteClient_serviceSouscrit_elementSMS=new gdfsuezComBefCalypsoComptecltV6.CompteClient_serviceSouscrit_element();
        gdfsuezComBefChpPivotCompteClient.listeValeursDt serviceGestionSMS=new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
        serviceGestionSMS.code='ZFACT';
        //typeGestion
        gdfsuezComBefChpPivotCompteClient.listeValeursDt typeGestionSMS=new gdfsuezComBefChpPivotCompteClient.listeValeursDt();
        typeGestionSMS.code='ZFACTLSMS';               
        compteClient_serviceSouscrit_elementSMS.serviceGestion=serviceGestionSMS;
        compteClient_serviceSouscrit_elementSMS.typeGestion=typeGestionSMS;
        serviceSouscrits.add(compteClient_serviceSouscrit_elementSMS);        
        /*------------------------------*/     
        
        desactiverServiceGestionInputDt.compteClient = new gdfsuezComBefCalypsoComptecltV6.CompteClient();
        desactiverServiceGestionInputDt.compteClient.idCompteClient = (String)inputMap.get('account');//'000402627727';
        desactiverServiceGestionInputDt.compteClient.serviceSouscrit=serviceSouscrits;        
        System.debug('desactiverServiceGestionInputDt'+desactiverServiceGestionInputDt.compteClient.serviceSouscrit);


		gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionResponse_element response = new gdfsuezBefCalypsoCompteclientV6.desactiverServiceGestionResponse_element();
        Map<String, Object> ipOutput = new Map<String, Object> ();
        try{            
            response = port.DesactiverServiceGestion_Http(desactiverServiceGestionInputDt, octx);

            for(gdfsuezComBefChpPivotCompteClient.retourTraitementMessageDt rs:response.messageRetours.retourTraitementMessage){
                
                if(rs != null && rs.code.equals('OCTOPUS_DesactiverServiceGestion_01')){
                    ipOutput.put('code', 'OCTOPUS_DesactiverServiceGestion_01');
                }  
            }
            if(ipOutput.get('code')==null){
                ipOutput.put('code', 'OCTOPUS_DesactiverServiceGestion_02');
            }
            
        }catch (Exception e) {   
            ipOutput.put('code', 'OCTOPUS_DesactiverServiceGestion_02');

        }
     return ipOutput;                 
        

    }
 
    public static gdfsuezComBefChpPivotCompteClient.contextDt initContext(String application, String version) {

        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
    gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element osource = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element();
    osource.systemId = application;
    gdfsuezComBefChpPivotCompteClient.contextDt octx = new gdfsuezComBefChpPivotCompteClient.contextDt();
    octx.version = version;
    octx.allowCache = false;
    octx.systemPath = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_element();
    octx.systemPath.system_x = new gdfsuezComBefChpPivotCompteClient.contextDt_systemPath_system_element[] {
      osource
    };
    return octx;

}

     public static gdfsuezComBefChpPivot.contextDt initContextt(String application, String version) {
        
        // Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
        gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
        osource.systemId = application;
        gdfsuezComBefChpPivot.contextDt octx = new gdfsuezComBefChpPivot.contextDt();
        octx.version = version;
        octx.allowCache = false;
        octx.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
        octx.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {
            osource
                };
                    return octx;
        
    }

    

}