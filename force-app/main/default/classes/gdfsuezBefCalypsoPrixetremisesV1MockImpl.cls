//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
public class gdfsuezBefCalypsoPrixetremisesV1MockImpl implements WebServiceMock {
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
       
        System.debug(LoggingLevel.INFO, 'gdfsuezBefCalypsoPrixetremisesV1MockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemises_element) {
            gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesResponse_element req=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesResponse_element();
            List<gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt> rechercherPrixEtRemisesOutput=new List<gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt>();
            
            gdfsuezBefCalypsoPrixetremisesV1.prixDt prix=new gdfsuezBefCalypsoPrixetremisesV1.prixDt();
            prix.montantHT=23;
            prix.montantTTC=24;
            gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreElecDt caracteristiquesElec=new gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreElecDt();
            gdfsuezComBefChpCommunV3.listeValeursDt puissance = new gdfsuezComBefChpCommunV3.listeValeursDt();
            puissance.code='6';
            gdfsuezComBefChpCommunV3.listeValeursDt typeComptage = new gdfsuezComBefChpCommunV3.listeValeursDt();
            typeComptage.code='HPHC';
            gdfsuezComBefChpCommunV3.listeValeursDt typePrixElec = new gdfsuezComBefChpCommunV3.listeValeursDt();
            typePrixElec.code='CO';
            caracteristiquesElec.puissance=puissance;
            caracteristiquesElec.typeComptage=typeComptage;
            caracteristiquesElec.typePrix=typePrixElec;
            
            prix.caracteristiquesElec=caracteristiquesElec;
            gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreGazDt caracteristiquesGaz =new gdfsuezBefCalypsoPrixetremisesV1.caracteristiquesOffreGazDt();
            
            
            gdfsuezComBefChpCommunV3.listeValeursDt plageconsommation = new gdfsuezComBefChpCommunV3.listeValeursDt();
            plageconsommation.code='6000';
            
            gdfsuezComBefChpCommunV3.listeValeursDt typePrix = new gdfsuezComBefChpCommunV3.listeValeursDt();
            typePrix.code='AB';
            caracteristiquesGaz.plageconsommation=plageconsommation;
            caracteristiquesGaz.typePrix=typePrix;
            prix.caracteristiquesGaz=caracteristiquesGaz;   
            List<gdfsuezBefCalypsoPrixetremisesV1.prixDt> listPrix =new List<gdfsuezBefCalypsoPrixetremisesV1.prixDt>();
            listPrix.add(prix);               
            gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt data1=new gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt();
            data1.idOffre='GBUKF2';
            data1.libelleOffre='Duo Energie Garantie 2 ans';
            gdfsuezBefCalypsoPrixetremisesV1.listePrixDt listePrixV=  new gdfsuezBefCalypsoPrixetremisesV1.listePrixDt();
              listePrixV.prix=listPrix;
            data1.listePrix=listePrixV;
            
            List<gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt> data=new List<gdfsuezBefCalypsoPrixetremisesV1.donneesOffreDt>();
            data.add(data1);
            
            
            gdfsuezBefCalypsoPrixetremisesV1.donneesPackDt donneesPack=new gdfsuezBefCalypsoPrixetremisesV1.donneesPackDt();
            donneesPack.idPack ='DGBUEBUF3AK_P';  
                
            gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt donneesOffre1 = new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
            donneesOffre1.donneesOffre=data;
            donneesOffre1.donneesPack=donneesPack;
            rechercherPrixEtRemisesOutput.add(donneesOffre1);
            req.rechercherPrixEtRemisesOutput=rechercherPrixEtRemisesOutput;
           // gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt outputDT=new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesOutputDt();
            response.put( 'response_x', req);
        }
        else if(request instanceOf gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesServices_element) {
            response.put( 'response_x', new gdfsuezBefCalypsoPrixetremisesV1.rechercherPrixEtRemisesServicesResponse_element());
        }
    }
}