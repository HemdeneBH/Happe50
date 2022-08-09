public class VI_SM040_RedirectionDocusign {

    public static PageReference redirectURL() {
        
        VI_DocuSignTokens__c DocuSignTokens;
        VI_Parcours__c Parcours;
        Blob decrypted = null;
        String DocuSignURL = '';
        String redirectionURL = 'retURL=RedirectDocusign?TimeStamp=';
        String envelopeId; 
        
        envelopeId = apexpages.currentpage().getparameters().get('e');
        system.debug('envelopeId '+envelopeId);
        
        if(envelopeId!= null){
            Parcours = [select Id, VI_EnveloppeCPV__c, VI_EnveloppeMandat__c, VI_Email_CPV__c, VI_PrenomClientExistant__c, VI_NomClientExistant__c 
                        from VI_Parcours__c 
                        where VI_EnveloppeCPV__c = :envelopeId OR VI_EnveloppeMandat__c= :envelopeId ];
            String customer_name = Parcours.VI_PrenomClientExistant__c + ' ' + Parcours.VI_NomClientExistant__c;
            system.debug('DocuSignURL '+DocuSignURL);
            DocuSignURL = VI_SM024_GetDocusignToken.createSignatureLink(envelopeId, Parcours.VI_Email_CPV__c, '1234', '1', customer_name,null);
            if (DocuSignURL == 'ENVELOPE_HAS_BEEN_VOIDED'|| DocuSignURL == 'UNKNOWN_ENVELOPE_RECIPIENT'){
                DocuSignURL = Label.VI_DocuSignRedirectionURL+'?event=envelopeExpired';
            }
        }
        else{
            // Récupération des param de l'URL
            String tokenName = apexpages.currentpage().getparameters().get('TimeStamp');
            system.debug('TimeStamp param :'+ tokenName); 
            tokenName = tokenName.replaceAll(' ', '+');
            system.debug('TimeStamp param après replace :'+ tokenName);
            redirectionURL = redirectionURL+tokenName+'&encrypted='; 
            
            // Récupération de la clé de décryptage contenu dans le VI_DocuSignTokens__c grace au TimeStamp
            DocuSignTokens = VI_DocuSignTokens__c.getvalues(tokenName);
            if (DocuSignTokens != null) {
                system.debug('DocuSignTokens Name : '+ DocuSignTokens.Name);
                system.debug('DocuSignTokens Value : '+ DocuSignTokens.VI_Value__c);
                String secretString = apexpages.currentpage().getparameters().get('encrypted');
                secretString = secretString.replaceAll(' ', '+');
                system.debug('encrypted param : '+ secretString);
                redirectionURL = redirectionURL+secretString+'&'; 
                // Décryptage de la partie encodé de l'URL
                Blob key = EncodingUtil.base64decode(DocuSignTokens.VI_Value__c);
                Blob encrypted = EncodingUtil.base64decode(secretString);
                system.debug('encrypted :'+ string.valueof(encrypted));
                try {
                    decrypted = Crypto.decryptWithManagedIV('AES128', key, encrypted);
                    system.debug('decrypted : '+ decrypted); 
                } catch(DmlException e) {
                    System.debug('The following exception has occurred: ' + e.getMessage());
                }
                String decryptedString = decrypted.toString();
                system.debug('decryptedString : '+ decryptedString);
                
                // Récupération de l'id du parcours 
                String parcours_id = decryptedString.substringBetween('=', '&');
                system.debug('parcours_id : '+ parcours_id);
                Parcours = [select Id, VI_EnveloppeCPV__c, VI_EnveloppeMandat__c, VI_Email_CPV__c, VI_PrenomClientExistant__c, VI_NomClientExistant__c from VI_Parcours__c where Id = :parcours_id];
                String customer_name = Parcours.VI_PrenomClientExistant__c + ' ' + Parcours.VI_NomClientExistant__c;
                
                // Redirection selon le type le type d'enveloppe
                if (decryptedString.contains('Type=CPV')) {
                    system.debug('De type CPV');
                    redirectionUrl=redirectionUrl+'&Type=CPV';
                    DocuSignURL = VI_SM024_GetDocusignToken.createSignatureLink(Parcours.VI_EnveloppeCPV__c, Parcours.VI_Email_CPV__c, '1234', '1', customer_name, redirectionURL);
                    system.debug('DocuSignURL2 '+DocuSignURL);
                    if (DocuSignURL == 'ENVELOPE_HAS_BEEN_VOIDED'|| DocuSignURL == 'UNKNOWN_ENVELOPE_RECIPIENT'){
                        system.Debug('ttl expired');
                        DocuSignURL = Label.VI_DocuSignRedirectionURL+'?event=envelopeExpired';
                    }
                } else if (decryptedString.contains('Type=Mandat')) {
                    system.debug('De type Mandat');
                    redirectionUrl=redirectionUrl+'&Type=Mandat';
                    DocuSignURL = VI_SM024_GetDocusignToken.createSignatureLink(Parcours.VI_EnveloppeMandat__c, Parcours.VI_Email_CPV__c, '1234', '1', customer_name, redirectionURL);
                    system.debug('DocuSignURL3 '+DocuSignURL);
                    if (DocuSignURL == 'ENVELOPE_HAS_BEEN_VOIDED'|| DocuSignURL == 'UNKNOWN_ENVELOPE_RECIPIENT'){
                        system.Debug('ttl expired');
                        DocuSignURL = Label.VI_DocuSignRedirectionURL+'?event=envelopeExpired';
                    }
                }
                else {
                    system.debug('WRONG URL: WRONG ENVELOPPE TYPE');
                }
            }
            else {
                system.debug('WRONG URL : NO DOCUSIGNTOKEN WITH THIS NAME');
            }
        }
    	system.debug('DocuSignURLDocuSignURL '+DocuSignURL);
        PageReference page;
        if(!Test.isRunningTest()){
            page = new PageReference(DocuSignURL);
            page.setRedirect(true);
        }
      	return page;
    }
}