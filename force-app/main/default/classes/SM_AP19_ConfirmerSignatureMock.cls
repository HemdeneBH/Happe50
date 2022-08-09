@isTest
public class SM_AP19_ConfirmerSignatureMock implements WebServiceMock {
    public static String CODE_RETOUR_WS = '';
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

    gdfsuezBefCalypsoMandatV1.confirmerSignatureResponse_element response_x = new gdfsuezBefCalypsoMandatV1.confirmerSignatureResponse_element();

    gdfsuezBefCalypsoMandatV1.confirmerSignatureOuputDt confirmerSignatureOutput = new gdfsuezBefCalypsoMandatV1.confirmerSignatureOuputDt();
    confirmerSignatureOutput.idPersonne = '0309034399';
    confirmerSignatureOutput.URL = '';
    confirmerSignatureOutput.idApplication = 'SMILE';
    gdfsuezBefCalypsoMandatV1.compteClientConfirmerDt listeCompteClient = new gdfsuezBefCalypsoMandatV1.compteClientConfirmerDt();
    List<String> idCompteClient = new List<String>{'000512478584'};
    listeCompteClient.idCompteClient = idCompteClient;
    confirmerSignatureOutput.listeCompteClient = listeCompteClient;
    response_x.confirmerSignatureOutput = confirmerSignatureOutput;

    gdfsuezComBefChpPivot_Mandat1.messageRetoursDt messageRetours = new gdfsuezComBefChpPivot_Mandat1.messageRetoursDt();
    List<gdfsuezComBefChpPivot_Mandat1.messageRetour_element> messageRetour = new List<gdfsuezComBefChpPivot_Mandat1.messageRetour_element>();
    gdfsuezComBefChpPivot_Mandat1.messageRetour_element messageRetourValue = new gdfsuezComBefChpPivot_Mandat1.messageRetour_element();
    messageRetourValue.id = '793e6525-abec-4381-8f2b-f0c96502454b';
    messageRetourValue.code = CODE_RETOUR_WS;
    messageRetourValue.libelle = 'Traitement effectué sans erreur';
    messageRetourValue.type_x = 'Information';
    messageRetourValue.source = 'Middleware Octopus';
    messageRetourValue.classe = 'Fonctionnelle';
    messageRetourValue.timestamp = Datetime.now();
    messageRetour.add(messageRetourValue);
    messageRetours.messageRetour = messageRetour;
    response_x.messageRetours = messageRetours;
    response.put('response_x', response_x);
  }
}