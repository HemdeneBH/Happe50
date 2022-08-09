/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM033_ServiceDocument
*@CreatedDate: 15/03/2021
*/
@isTest
global class VI_SM033_ServiceDocument_Mock implements WebServiceMock{
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element response_x=new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element();
            VI_gdfsuezBefCalypsoDocumentV2.lireDocumentOutputDt lireDocumentOutput=new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentOutputDt();
            lireDocumentOutput.contenuDocument='aaaaa';
            lireDocumentOutput.nomDocument='test';
            lireDocumentOutput.documentXMLMetadonnees='test';
            VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt listeValeurs= new VI_gdfsuezComBefChpPivot_DocumentV2.listeValeursDt();
            listeValeurs.code='11';
            lireDocumentOutput.statutDocument=listeValeurs;
            response_x.lireDocumentOutput=lireDocumentOutput;
            
            VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessagesDt retoursMessages=new VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessagesDt();
            List<VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessageDt> messageRetours1 = new List<VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessageDt>();
            VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessageDt messageRetour=new VI_gdfsuezComBefChpPivot_DocumentV2.retourTraitementMessageDt();
            messageRetour.id = '77654d1a-ff8f-49a3-b896-14c658c9423c';
            messageRetour.code = 'OCTOPUS_DemanderSignature_01';
            messageRetour.libelle = 'Traitement effectué sans erreur';
            messageRetour.type_x = 'Information';
            messageRetour.source = 'Middleware Octopus';
            messageRetour.classe = 'Fonctionnelle';
            messageRetour.timestamp = Datetime.now();
            messageRetours1.add(messageRetour);
            retoursMessages.retourTraitementMessage = messageRetours1;
            response_x.messageRetours = retoursMessages;
            response.put('response_x', response_x);
        }
}