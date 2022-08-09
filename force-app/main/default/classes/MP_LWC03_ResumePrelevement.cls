public with sharing class MP_LWC03_ResumePrelevement {

    @AuraEnabled(cacheable=true)
    public static String getIDTiers(Id contactId) {
        List<Contact> c = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId];
        if (c.size() > 0) {
            Contact cont = c[0];
            List<Opportunity> opp = [SELECT Id, MP_ID_Tiers__c FROM Opportunity WHERE AccountId = :cont.AccountId];
            if (opp.size() > 0 && String.valueOf(opp[0].MP_ID_Tiers__c) != '')
                return String.valueOf(opp[0].MP_ID_Tiers__c);
            else
                return 'Pas d\'IDTiers';
        } else
            return 'Erreur sur l\'Objet Contact';
    }

    @AuraEnabled(cacheable=true)
    public static List<Object> getMandat(Id contactId) {
        List<Contact> c = [SELECT Id, AccountId FROM Contact WHERE Id = :contactId];
        List<Object> resList = new List<Object>();
        if (c.size() > 0) {
            Contact cont = c[0];
            List<Opportunity> opp = [SELECT Id, MP_ID_Tiers__c FROM Opportunity WHERE AccountId = :cont.AccountId];
            Map<String,Object> rdata = new Map<String, Object>();
            rdata.put('idPersonne', String.valueOf(opp[0].MP_ID_Tiers__c));
            if (opp.size() > 0 ) {
                HttpResponse httpResponse = new httpResponse();
                httpResponse = getResponse('get_mandat', JSON.serialize(rdata));
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody());
                resList = (List<Object>)results.get('_data');
                return resList;
            } else {
                resList.add('Pas de mandat rattachée à cette coordonnée');
                return resList;
            }
        } else {
            resList.add('Erreur sur l\'Objet Contact');
            return resList;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAllPrelevements(String fil) {
        Map<String,String> data = new Map<String,String>();
        data.put('filtre', fil);
        List<Object> sendToJS = new List<Object>();
        HttpResponse httpResPrev = new httpResponse();
        httpResPrev = getResponse('get_allprelevement', JSON.serialize(data));
        System.debug('allprelev=>'+httpResPrev.getBody());
        Map<String, Object> prevLine = new Map<String, Object>();
        if (httpResPrev != null && httpResPrev.getStatusCode() == 200) {
            prevLine.put('code', String.valueOf(httpResPrev.getStatusCode()));
            prevLine.put('message', (Map<String, Object>)JSON.deserializeUntyped(httpResPrev.getBody()));
        } else if (httpResPrev == null) {
            prevLine.put('code', '000');
            prevLine.put('message', 'ERREUR GET PRELEVEMENTS API');
        } else {
            prevLine.put('code', String.valueOf(httpResPrev.getStatusCode()));
            prevLine.put('message', (Map<String, Object>)JSON.deserializeUntyped(httpResPrev.getBody()));
        }
        return prevLine;
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getRefusPrelevements(String idtiers) {
        Map<String,String> data = new Map<String,String>();
        data.put('type', 'AP');
        data.put('idPersonne', idtiers);
        List<Object> sendToJS = new List<Object>();
        HttpResponse httpResPrev = new httpResponse();
        httpResPrev = getResponse('get_refusPrelevements', JSON.serialize(data));
        Map<String, Object> prevLine = new Map<String, Object>();
        if (httpResPrev != null && httpResPrev.getStatusCode() == 200) {
            prevLine.put('code', String.valueOf(httpResPrev.getStatusCode()));
            prevLine.put('message', (Map<String, Object>)JSON.deserializeUntyped(httpResPrev.getBody()));
        } else if (httpResPrev == null) {
            prevLine.put('code', '000');
            prevLine.put('message', 'ERREUR GET PRELEVEMENTS API');
        } else {
            prevLine.put('code', String.valueOf(httpResPrev.getStatusCode()));
            prevLine.put('message', (Map<String, Object>)JSON.deserializeUntyped(httpResPrev.getBody()));
        }
        return prevLine;
    }

    public static HttpResponse getResponse(String apiName, String dataParam) {
        HttpRequest httpReq = buildHttpRequestHeaders(apiName, dataParam);
        HttpResponse httpResp = sendData(httpReq);
        return httpResp;
    }  

    public static HttpRequest buildHttpRequestHeaders(String apiName, String dataParam) {
        HttpRequest req = new HttpRequest();
        String baseUrl = 'callout:MPMyPowerApihour/api/apiset';
        Map<String, Object> rdata = new Map<String, Object>();
        String IdTiersIndex;
        String IdPersonne;
        String codeBanqueGuichet;
        String newIBAN;
        String rum;
        String echeance;
        String fil;
        String type;
        String idTiers;
        if (dataParam != '') {
            rdata = (Map<String, Object>)JSON.deserializeUntyped(dataParam);
            IdPersonne = (String)rdata.get('idPersonne');
            IdTiersIndex = (String)rdata.get('tiersId');
            codeBanqueGuichet = (String)rdata.get('codeBanqueGuichet');
            newIBAN = (String)rdata.get('iBAN');
            rum = (String)rdata.get('rum');
            echeance = (String)rdata.get('nbrSchedule');
            fil = (String)rdata.get('filtre');
            type = (String)rdata.get('type');
        }
        if ('get_mandat'.equals(apiName)) {
            req.setMethod('GET');
            req.setEndpoint(baseUrl + '/0.2/mandats?idPersonne=' + IdPersonne);   
        } else if('get_allprelevement'.equals(apiName)) {
            Map<String,Object> filters = new Map<String,Object>();
            Map<String,Object> filter = new Map<String,Object>();
            filter.put('inList code', fil);
            filters.put('filters', filter);
            req.setMethod('GET');
            req.setEndpoint('callout:MPMyPowerApihour/api/mypower/' + MP_Xdata_credentials__c.getInstance('mpoc_api_version').Value__c + '/protected/payment/paymentScheduleInstance/list');
            req.setBody(JSON.serialize(filters));
        } else if('get_refusPrelevements'.equals(apiName)) {    
            req.setMethod('POST');
            req.setEndpoint('callout:MPMyPowerApihour/api/mypower/' + MP_Xdata_credentials__c.getInstance('mpoc_api_version').Value__c + '/protected/inbound/ENGIE/directDebitPayment/list');
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('type', 'AP');
            gen.writeStringField('idPersonne', IdPersonne);
            gen.writeEndObject();
            req.setBody(gen.getAsString());
           
        }

        req.setHeader('X-Correlation-Id', MP_AP13_GuidUtil.NewGuid());
        req.setHeader('api_key', MP_Xdata_credentials__c.getInstance('mpoc_api_key').Value__c);
        req.setHeader('Authorization', 'Bearer ' + MP_AP24_Authentication.getToken());
        req.setHeader('Accept', 'application/json');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('X-Authorization', 'Basic ' + MP_Xdata_credentials__c.getInstance('mpoc_x_authorization').Value__c);
        return req;
    }

    public static HttpResponse SendData(HttpRequest request) {
        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(request);
        } catch (Exception e) {
            return null;
        }
        return res;
    }
}