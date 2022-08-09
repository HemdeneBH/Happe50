@isTest
public class VI_gdfsuezBefCalypsoDocumentV2_Test {
@isTest
    static void callAllMethods(){
        
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuResponse_element creerDocumentPrevisuResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuResponse_element();
    	VI_gdfsuezBefCalypsoDocumentV2.validerDocumentOutputDt validerDocumentOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.validerDocumentOutputDt();
    	VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisu_element creerDocumentPrevisu_element= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisu_element();
    	VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentInputDt modifierDocumentInputDt= new VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuOutputDt creerDocumentPrevisuOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuOutputDt();
        VI_gdfsuezBefCalypsoDocumentV2.composerDocumentOutputDt composerDocumentOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.composerDocumentOutputDt();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentInputDt creerDocumentInputDt= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.composerDocumentInputDt composerDocumentInputDt= new VI_gdfsuezBefCalypsoDocumentV2.composerDocumentInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.composerDocumentResponse_element composerDocumentResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.composerDocumentResponse_element();
        VI_gdfsuezBefCalypsoDocumentV2.documentModifie_element documentModifie_element= new VI_gdfsuezBefCalypsoDocumentV2.documentModifie_element();
        VI_gdfsuezBefCalypsoDocumentV2.composerDocument_element composerDocument_element= new VI_gdfsuezBefCalypsoDocumentV2.composerDocument_element();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuInputDt creerDocumentPrevisuInputDt= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentPrevisuInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentOutputDt modifierDocumentOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentOutputDt();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentResponse_element creerDocumentResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentResponse_element();
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentOutputDt lireDocumentOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentOutputDt();
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element lireDocumentResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentResponse_element();
        VI_gdfsuezBefCalypsoDocumentV2.validerDocumentResponse_element validerDocumentResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.validerDocumentResponse_element();
        VI_gdfsuezBefCalypsoDocumentV2.lireDocument_element lireDocument_element= new VI_gdfsuezBefCalypsoDocumentV2.lireDocument_element();
        VI_gdfsuezBefCalypsoDocumentV2.documentCompose_element documentCompose_element= new VI_gdfsuezBefCalypsoDocumentV2.documentCompose_element();
        VI_gdfsuezBefCalypsoDocumentV2.documentValide_element documentValide_element= new VI_gdfsuezBefCalypsoDocumentV2.documentValide_element();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocumentOutputDt creerDocumentOutputDt= new VI_gdfsuezBefCalypsoDocumentV2.creerDocumentOutputDt();
        VI_gdfsuezBefCalypsoDocumentV2.modifierDocument_element modifierDocument_element= new VI_gdfsuezBefCalypsoDocumentV2.modifierDocument_element();
        VI_gdfsuezBefCalypsoDocumentV2.listeCodeValeurDt listeCodeValeurDt= new VI_gdfsuezBefCalypsoDocumentV2.listeCodeValeurDt();
        VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt lireDocumentInputDt= new VI_gdfsuezBefCalypsoDocumentV2.lireDocumentInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.FichierMetadata_element FichierMetadata_element= new VI_gdfsuezBefCalypsoDocumentV2.FichierMetadata_element();
        VI_gdfsuezBefCalypsoDocumentV2.creerDocument_element creerDocument_element= new VI_gdfsuezBefCalypsoDocumentV2.creerDocument_element();
        VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentResponse_element modifierDocumentResponse_element= new VI_gdfsuezBefCalypsoDocumentV2.modifierDocumentResponse_element();
        VI_gdfsuezBefCalypsoDocumentV2.documentCree_element documentCree_element= new VI_gdfsuezBefCalypsoDocumentV2.documentCree_element();
        VI_gdfsuezBefCalypsoDocumentV2.validerDocumentInputDt validerDocumentInputDt= new VI_gdfsuezBefCalypsoDocumentV2.validerDocumentInputDt();
        VI_gdfsuezBefCalypsoDocumentV2.document_element document_element= new VI_gdfsuezBefCalypsoDocumentV2.document_element();
        VI_gdfsuezBefCalypsoDocumentV2.validerDocument_element validerDocument_element= new VI_gdfsuezBefCalypsoDocumentV2.validerDocument_element();
        VI_gdfsuezBefCalypsoDocumentV2.coupleCodeValeur_element coupleCodeValeur_element= new VI_gdfsuezBefCalypsoDocumentV2.coupleCodeValeur_element();
        VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort DocumentPrevisuPort= new VI_gdfsuezBefCalypsoDocumentV2.DocumentPrevisuPort();
        VI_gdfsuezComBefChpPivot_DocumentV2.contextDt context = new VI_gdfsuezComBefChpPivot_DocumentV2.contextDt();
		test.startTest();
        Test.setMock(WebServiceMock.class, new VI_SM033_ServiceDocument_Mock());
        DocumentPrevisuPort.lireDocument(lireDocumentInputDt, context);
        test.stopTest();
    }

}