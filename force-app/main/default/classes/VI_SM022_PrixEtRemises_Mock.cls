/*
*@Auhtor: Paul Ghoussoub
*@Description: Classe Mock de VI_SM033_ServiceDocument
*@CreatedDate: 15/03/2021
*/
@isTest
public class VI_SM022_PrixEtRemises_Mock implements WebServiceMock{
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
            if(request instanceof VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServices_element){
                VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element response_x=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesResponse_element();
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt> listOutput=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt output=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixServicesOutputDt();
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt> prixOutputList=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt prixOutput=new VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt();
                
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt> donneesPrixList=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt donneesPrix=new VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDt();
                donneesPrixList.add(donneesPrix);
                
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt> donneesPrixCritereList=new List< VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt donnePrixCritere=new  VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixCriteresDt();
                                
                donnePrixCritere.donneesPrixParametre='ZZCAE';
                donnePrixCritere.donneesPrixValeur='2';
                
                donneesPrixCritereList.add(donnePrixCritere);
                donneesPrix.donneesPrixCriteres=donneesPrixCritereList;
                
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDetailsDt donnePrixDetail=new  VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixDetailsDt();
                
                donnePrixDetail.prixMensuelHT=1;
                donnePrixDetail.prixMensuelTTC=2;
                donnePrixDetail.prixAnnuelHT=3;
                donnePrixDetail.prixAnnuelTTC=4;
                
                donneesPrix.donneesPrixDetails=donnePrixDetail;
                
                donnePrixCritere.donneesPrixParametre='ZZCAE';
                donnePrixCritere.donneesPrixValeur='2';
                
                donneesPrixCritereList.add(donnePrixCritere);
                donneesPrix.donneesPrixCriteres=donneesPrixCritereList;
                
                prixOutput.idOffre='1';
                prixOutput.datePropositionCommerciale=date.today();
                prixOutput.dateEffetContrat=date.today();
                prixOutput.typePrix='type';
                prixOutput.donneesPrix =donneesPrixList;
                prixOutputList.add(prixOutput);
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt> donneesPrixAnnexeList=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt donneesPrixAnnexe=new VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPrixOutDt();
                donneesPrixAnnexe.idOffre='1';
                donneesPrixAnnexe.datePropositionCommerciale=date.today();
                donneesPrixAnnexe.dateEffetContrat=date.today();
                donneesPrixAnnexe.typePrix='type';
                
                                
                donnePrixCritere.donneesPrixParametre='ZZCAE';
                donnePrixCritere.donneesPrixValeur='2';
                
                donneesPrixCritereList.add(donnePrixCritere);
                donneesPrix.donneesPrixCriteres=donneesPrixCritereList;
                
                
                donnePrixDetail.prixMensuelHT=1;
                donnePrixDetail.prixMensuelTTC=2;
                donnePrixDetail.prixAnnuelHT=3;
                donnePrixDetail.prixAnnuelTTC=4;
                
                donneesPrix.donneesPrixDetails=donnePrixDetail;
                
                donneesPrixList.add(donneesPrix);
                donneesPrixAnnexe.donneesPrix=donneesPrixList;
                donneesPrixAnnexeList.add(donneesPrixAnnexe);
                
                output.donneesPrix=prixOutputList;
                output.donneesPrixAnnexe=donneesPrixAnnexeList;
                
                VI_gdfsuezComBefChpCommunV3.messageRetoursDt retoursMessages=new VI_gdfsuezComBefChpCommunV3.messageRetoursDt();
                List<VI_gdfsuezComBefChpCommunV3.messageRetour_element> messageRetours1 = new List<VI_gdfsuezComBefChpCommunV3.messageRetour_element>();
                VI_gdfsuezComBefChpCommunV3.messageRetour_element messageRetour=new VI_gdfsuezComBefChpCommunV3.messageRetour_element();
                messageRetour.code = 'OCTOPUS_DemanderSignature_01';
                messageRetour.libelle = 'Traitement effectué sans erreur';
                messageRetour.type_x = 'Information';
                messageRetour.source = 'Middleware Octopus';
                
                messageRetours1.add(messageRetour);
                retoursMessages.messageRetour=messageRetours1;
                
                listOutput.add(output);
                response_x.rechercherPrixServicesOutput=listOutput;
                response_x.messageRetours=retoursMessages;
                
                response.put('response_x', response_x);
            }
            else if(request instanceof VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element)
            {
                VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element requestElement=(VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemises_element) request;
                VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element response_x=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesResponse_element();
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt> listOutput=new List< VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt output=new VI_gdfsuezBefCalypsoPrixetremisesV2.rechercherPrixEtRemisesOutputDt();
                
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt donneesPack=new VI_gdfsuezBefCalypsoPrixetremisesV2.donneesPackDt();
                donneesPack.idPack='';
                donneesPack.libellePack='';
                VI_gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt listeRemises=new VI_gdfsuezBefCalypsoPrixetremisesV2.listeRemisesDt();
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.remiseDt> listeRemiseDT=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.remiseDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.remiseDt remise=new VI_gdfsuezBefCalypsoPrixetremisesV2.remiseDt();
                remise.montantHT=1;
                remise.montantTTC=1;
                remise.tauxTVA=1;
                remise.duree='1';
                remise.pourcentageRemise='1';
                remise.natureRemise='1';
                remise.dateFinEffet=Date.today();
                VI_gdfsuezComBefChpCommunV3.listeValeursDt valeurs=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                valeurs.idValeur='1';
                remise.typeRemise=valeurs;
                remise.applicationRemise=valeurs;
                
                listeRemiseDT.add(remise);
                listeRemises.remise=listeRemiseDT;
                donneesPack.listeRemises=listeRemises;
                
                output.donneesPack=donneesPack;
                
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt> donneesOffreList=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt donneesOffre=new VI_gdfsuezBefCalypsoPrixetremisesV2.donneesOffreDt();
                system.debug('requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal '+requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal);
                if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75020' || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75022'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75023'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75024'
                    ){
                    donneesOffre.idOffre='1';
                    donneesOffre.libelleOffre='1';
                }
                if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75012' || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75013'
                   || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75014'
                   || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75015'
                   || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75016'
                   || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75017'
                   || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75018'){
                    donneesOffre.idOffre='2';
                    donneesOffre.libelleOffre='2';
                }
                
                
                VI_gdfsuezBefCalypsoPrixetremisesV2.listePrixDt listePrix=new VI_gdfsuezBefCalypsoPrixetremisesV2.listePrixDt();
                List<VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt> listPrixDt=new List<VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt>();
                VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt prix=new VI_gdfsuezBefCalypsoPrixetremisesV2.prixDt();
                prix.dateDebutValiditePrix=date.today();
                prix.montantHT=1;
                prix.montantTTC=1;
                prix.tauxTVA=1;
                
                VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt caracteristiquesGaz=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreGazDt();
                VI_gdfsuezComBefChpCommunV3.listeValeursDt typePrix=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75010' || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75012'){
                    typePrix.code='AB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75011'){
                    typePrix.code='CO';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75013'){
                    typePrix.code='TOTAB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75014'){
                    typePrix.code='TOTCO';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75015'){
                    typePrix.code='ACHAB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75016'){
                    typePrix.code='ACHCO';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75017'){
                    typePrix.code='OB';
                }
                VI_gdfsuezComBefChpCommunV3.listeValeursDt plageConsommation=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                plageConsommation.code='6000';
                caracteristiquesGaz.typePrix=typePrix;
                caracteristiquesGaz.plageConsommation=plageConsommation;
                prix.caracteristiquesGaz=caracteristiquesGaz;
                
                VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt caracteristiquesElec=new VI_gdfsuezBefCalypsoPrixetremisesV2.caracteristiquesOffreElecDt();
                VI_gdfsuezComBefChpCommunV3.listeValeursDt typePrixElec=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75010'){
                    typePrixElec.code='AB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75024'){
                    typePrixElec.code='CO';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75020'){
                    typePrixElec.code='AB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75021' || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75025'){
                    typePrixElec.code='ACHAB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75022'){
                    typePrixElec.code='OB';
                }
                else if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75023'){
                    typePrixElec.code='ACHCO';
                }
                VI_gdfsuezComBefChpCommunV3.listeValeursDt puissance=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                puissance.code='6';
                VI_gdfsuezComBefChpCommunV3.listeValeursDt typecomptage=new VI_gdfsuezComBefChpCommunV3.listeValeursDt();
                if (requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75020' || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75021'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75022'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75023'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75024'
                    || requestElement.rechercherPrixEtRemisesInput[0].identifiantsLieu.codepostal=='75010'){
                        typecomptage.code='S';
                    }
                caracteristiquesElec.typePrix=typePrixElec;
                caracteristiquesElec.puissance=puissance;
                caracteristiquesElec.typecomptage=typecomptage;
                prix.caracteristiquesElec=caracteristiquesElec;
                
                listPrixDt.add(prix);
                
                listePrix.prix=listPrixDt;
                donneesOffre.listePrix=listePrix;
                donneesOffreList.add(donneesOffre);
                
                output.donneesOffre=donneesOffreList;
                listOutput.add(output);
                response_x.rechercherPrixEtRemisesOutput=listOutput;
                response.put('response_x', response_x);
                
            }
        }
}