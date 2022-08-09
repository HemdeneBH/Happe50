/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM034_ProcessusRelanceMandat
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM034_ProcessusRelanceMandat_Mock implements WebServiceMock {
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
            VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element response_x=new VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatResponse_element();
            VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatOutputDt demarrerRelanceMandatOutput=new VI_gdfsuezComBefChpRelanceMandat.demarrerRelanceMandatOutputDt();
            demarrerRelanceMandatOutput.idProcessus='1234';
            response_x.demarrerRelanceMandatOutput=demarrerRelanceMandatOutput;
            VI_gdfsuezComBefChpPivotRelanceMandat.messageRetoursDt messageRetours=new  VI_gdfsuezComBefChpPivotRelanceMandat.messageRetoursDt();
            List<VI_gdfsuezComBefChpPivotRelanceMandat.messageRetour_element> messageRetours1 = new List<VI_gdfsuezComBefChpPivotRelanceMandat.messageRetour_element>();
            VI_gdfsuezComBefChpPivotRelanceMandat.messageRetour_element messageRetour=new VI_gdfsuezComBefChpPivotRelanceMandat.messageRetour_element();
            messageRetour.code = 'OCTOPUS_DemanderSignature_01';
            messageRetour.libelle = 'Traitement effectué sans erreur';
            messageRetour.type_x = 'Information';
            messageRetour.source = 'Middleware Octopus';
            messageRetours1.add(messageRetour);
            messageRetours.messageRetour = messageRetours1;
            response_x.messageRetours = messageRetours;
            response.put('response_x', response_x);
            
        }
}