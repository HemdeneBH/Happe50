/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM029_CoordonneesBancaires
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM029_CoordonneesBancaires_Mock implements WebServiceMock{
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
            gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element response_x= new  gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesResponse_element();
            gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesOutputDt creerCoordonneesBancairesOutput=new gdfsuezBefCalypsoCoordonneesbancaires.creerCoordonneesBancairesOutputDt();
            creerCoordonneesBancairesOutput.idCoordonneeBancaire='FR1930002005680000876440G50';
            creerCoordonneesBancairesOutput.idPersonne='4567';
            
            gdfsuezBefCalypsoCoordonneesbancaires.messageRetoursDt messageRetours =new  gdfsuezBefCalypsoCoordonneesbancaires.messageRetoursDt();
            List<gdfsuezBefCalypsoCoordonneesbancaires.messageRetour_element> messageRetours1 = new List<gdfsuezBefCalypsoCoordonneesbancaires.messageRetour_element>();
            gdfsuezBefCalypsoCoordonneesbancaires.messageRetour_element messageRetour=new  gdfsuezBefCalypsoCoordonneesbancaires.messageRetour_element();
            messageRetour.code = 'OCTOPUS_CreerCB_01';
            messageRetour.libelle = 'Success';
            messageRetour.type_x = 'Information';
            messageRetour.source = 'Middleware Octopus';
            messageRetours1.add(messageRetour);
            messageRetours.messageRetour = messageRetours1;
            
            response_x.creerCoordonneesBancairesOutput=creerCoordonneesBancairesOutput;
            response_x.messageRetours=messageRetours;
            response.put('response_x', response_x);
        }
}