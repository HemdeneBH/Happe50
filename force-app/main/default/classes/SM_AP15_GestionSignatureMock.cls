@isTest
public class SM_AP15_GestionSignatureMock implements WebServiceMock {
   public void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
    gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element response_x = new gdfsuezBefCalypsoMandatV1.demanderSignatureResponse_element();
    gdfsuezBefCalypsoMandatV1.demanderSignatureOutputDt demanderSignatureOutput = new gdfsuezBefCalypsoMandatV1.demanderSignatureOutputDt();
    demanderSignatureOutput.idPersonne = '0209008052';
    demanderSignatureOutput.idMandat = '00S000127313';
    demanderSignatureOutput.idDocument = '5F9AF13E-7487-432A-B633-284897E54079:CE9ACA82-10C9-4B4B-B3EB-7CBDD93A9D45';
    demanderSignatureOutput.versionDocument = '1';
    demanderSignatureOutput.idApplication = 'SMILE';
    response_x.demanderSignatureOutput = demanderSignatureOutput;
    gdfsuezComBefChpPivot_Mandat1.messageRetoursDt messageRetours = new gdfsuezComBefChpPivot_Mandat1.messageRetoursDt();

    List<gdfsuezComBefChpPivot_Mandat1.messageRetour_element> messageRetours1 = new List<gdfsuezComBefChpPivot_Mandat1.messageRetour_element>();
    gdfsuezComBefChpPivot_Mandat1.messageRetour_element messageRetour = new gdfsuezComBefChpPivot_Mandat1.messageRetour_element();
    messageRetour.id = '77654d1a-ff8f-49a3-b896-14c658c9423c';
    messageRetour.code = 'OCTOPUS_DemanderSignature_01';
    messageRetour.libelle = 'Traitement effectué sans erreur';
    messageRetour.type_x = 'Information';
    messageRetour.source = 'Middleware Octopus';
    messageRetour.classe = 'Fonctionnelle';
    messageRetour.timestamp = Datetime.now();
    messageRetours1.add(messageRetour);
    messageRetours.messageRetour = messageRetours1;
    response_x.messageRetours = messageRetours;
    response.put('response_x', response_x);
   }
}