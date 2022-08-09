/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM043_ChiffrerURL
*@CreatedDate: 7/9/2021
*/
@isTest
public class VI_SM043_ChiffrerURL_Mock implements WebServiceMock{
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
            VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element response_x=new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element();
            VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineOutputDt chiffrerChaineOutput=new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineOutputDt();
            chiffrerChaineOutput.chaineChiffree='test';
            response_x.chiffrerChaineOutput=chiffrerChaineOutput;
            VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessagesDt messageRetours=new VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessagesDt();
            List<VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt> messageRetours1 = new List<VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt>();
            VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt messageRetour=new VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessageDt();
            messageRetour.code = 'OCTOPUS_ChiffrerChaine_01';
            messageRetour.libelle = 'Traitement effectué sans erreur';
            messageRetour.type_x = 'Information';
            messageRetour.source = 'Middleware Octopus';
            messageRetours1.add(messageRetour);
            messageRetours.retourTraitementMessage = messageRetours1;
            response_x.messageRetours = messageRetours;
            response.put('response_x', response_x);
        }
}