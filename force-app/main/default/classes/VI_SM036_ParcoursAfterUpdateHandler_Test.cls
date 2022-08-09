/*
*@Author: Georges Mardini
*@Description: Classe test de CaseHandler.
*@CreatedDate: 16/11/2020
*@LastModified: 29/12/2020
*/
@isTest 
public class VI_SM036_ParcoursAfterUpdateHandler_Test {
    @isTest
    public static void ParcoursAfterUpdateTest() {
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        acc.VI_TypeParcours__c ='PURE PLAYERS';
        Insert acc;
        
        // create Contact
        Contact Contact = SM_TestDataFactory.createContact('Test1',Acc.Id);
        Insert Contact;
        Contact Contact2 = SM_TestDataFactory.createContact('Test12',Acc.Id);
        Insert Contact2;
        
        // Create Case
        Case caseTest = SM_TestDataFactory.createCase('TEST', Acc.Id);
        caseTest.Sous_type__c = 'Changement de fournisseur';
        caseTest.Origin = 'Partner Community';
        insert caseTest;   
        
        Case caseTest2 = SM_TestDataFactory.createCase('TEST', Acc.Id);
        insert caseTest2;   
        
        // Create CaseComment
        CaseComment CaseCommentTest = new CaseComment();
        CaseCommentTest.parentId = caseTest.id;
        CaseCommentTest.CommentBody = 'Test Comment';
        insert CaseCommentTest;   
        
        // create Donne de vente
        String idCaseString = caseTest.id;
        Donnees_Vente__c donneVenteTest = SM_TestDataFactory.createDonneeVente(idCaseString,'Paris','1','12', 'rue','75015');
        donneVenteTest.RecordTypeID = Donnees_Vente__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName().get('Acquisition_Harmonica').getRecordTypeId();
        Insert donneVenteTest;
        
        // CASE 2 parcrousTest.VI_Case__c != null
        VI_Parcours__c parcrousTest2 = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcrousTest2.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE non connu';
        insert parcrousTest2;   
        parcrousTest2.VI_Contact__c = Contact.id;
        parcrousTest2.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE connu';
        parcrousTest2.VI_Case__c = caseTest2.id;
        update parcrousTest2; 
        
        //Vérification update Case
        List<CaseComment> caseTestVerif2 = new List<CaseComment>();
        caseTestVerif2 = [SELECT id, CommentBody FROM CaseComment WHERE parentId =: parcrousTest2.VI_Case__c];
        Boolean allGood2 = false;
        
        if(caseTestVerif2.size() > 0){
            allGood2 = true;
        }
        
        //System.assert(allGood2);
        
        // CASE 3 parcrousTest.VI_Case__c != null  parIter.VI_Contact__c != null && oldParcourMap.get(parIter.Id).VI_Contact__c != parIter.VI_Contact__c
        VI_Parcours__c parcrousTest3 = VI_TestDataFactory.createParcours('CHF', null, 'PURE PLAYERS');
        parcrousTest3.VI_Contact__c = Contact2.id;
        parcrousTest3.VI_ConsentProspectionEngieNonAnalogue__c = 'Non';
        parcrousTest3.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE non connu';
        parcrousTest3.VI_Case__c = caseTest.id;
        parcrousTest3.VI_CommentaireGeneral_Constitutionpanier__c = 'test Commentaire Constitution Panier';
        parcrousTest3.VI_CommentaireGeneral_EstimationConso__c = 'test Commentaire Estimation Conso';
        parcrousTest3.VI_CommentaireGeneral_idlocal__c = 'test Commentaire Identification Local';
        parcrousTest3.VI_CommentaireGeneral_idbesoin__c = 'test Commentaire Identification Besoin';
        parcrousTest3.VI_CommentaireGeneral_idclient__c = 'test Commentaire Identification Client';
        parcrousTest3.VI_CommentaireGeneral_InfosCompl__c = 'test Commentaire Information Complementaire';
        parcrousTest3.VI_CommentaireGeneral_MoyensPaiement__c = 'test Commentaire Moyen de Paiement';
        parcrousTest3.VI_CommentairesParcours__c = 'test Commentaire Commentaire Parcours';
        insert parcrousTest3;   
        
        
        CaseComment caseTest3 = new CaseComment();
        caseTest3.CommentBody = 'Constitution Panier : ';
        caseTest3.parentId = parcrousTest3.VI_Case__c;
        insert caseTest3;   
        
        parcrousTest3.VI_ConsentProspectionEngieNonAnalogue__c = 'Oui';
        parcrousTest3.VI_Contact__c = Contact.id;
        parcrousTest3.VI_StatutParcours__c = 'CPV Envoyées: PDL/PCE connu';
        parcrousTest3.VI_DonneesVente__c = donneVenteTest.id;
        parcrousTest3.VI_NomClient__c = 'test Donne Vente';
        
        parcrousTest3.VI_AF_Enregistre__c = true;
        parcrousTest3.VI_idDocumentCPV__c = '00MPA212351051360826xxxx';
        test.startTest();
        update parcrousTest3; 
        
        //Vérification update donnée de vente
        Donnees_Vente__c donneVenteTestVerif = new Donnees_Vente__c();
        donneVenteTestVerif = [SELECT id, Nom_client__c FROM Donnees_Vente__c WHERE id =: parcrousTest3.VI_DonneesVente__c];
        System.assertEquals('Test1', donneVenteTestVerif.Nom_client__c);
        
        //Vérification update Case
        List<CaseComment> caseTestVerif3 = new List<CaseComment>();
        caseTestVerif3 = [SELECT id, CommentBody FROM CaseComment WHERE parentId =: parcrousTest3.VI_Case__c];
        Boolean allGood3 = false;
        for(CaseComment cas : caseTestVerif3){
            if(cas.CommentBody.contains('Constitution Panier')){
                allGood3 = true;
            }
        }
        System.assert(allGood3);
        test.stoptest();
    }
    
    @isTest
    public static void getPhoneToFillTest() {
        // create Account
        Account acc = SM_TestDataFactory.createAccount('Harmonica_Account');
        acc.VI_TypeParcours__c ='PURE PLAYERS';
        Insert acc;
        
        // create Contact
        //CASE 1 : contactToCheck.MobilePhone==null, contactToCheck.Phone==null
        Contact Contact = SM_TestDataFactory.createContact('Test1',Acc.Id);
        Insert Contact;
        
        Map<Id,Contact> mapContact;
        mapContact = new Map<Id,Contact>{Contact.id => Contact};
            System.assertEquals(VI_ParcoursAfterUpdateHandler.getPhoneToFill(mapContact,Contact.id), ''); 
        
        //CASE 2 : contactToCheck.MobilePhone==null, contactToCheck.Phone!=null, contactToCheck.Tel_Fixe_Principal__c==null
        Contact Contact2 = SM_TestDataFactory.createContact('Test2',Acc.Id);
        Contact2.Phone = '+33111111111';
        Insert Contact2;
        
        Map<Id,Contact> mapContact2;
        mapContact2 = new Map<Id,Contact>{Contact2.id => Contact2};
            System.assertEquals(VI_ParcoursAfterUpdateHandler.getPhoneToFill(mapContact2,Contact2.id), '+33111111111'); 
        
        //CASE 3 : contactToCheck.MobilePhone==null, contactToCheck.Phone!=null, contactToCheck.Tel_Fixe_Principal__c!=null
        Contact Contact3 = SM_TestDataFactory.createContact('Test3',Acc.Id);
        Contact3.Phone = '+3311111111';
        Contact3.Tel_Fixe_Principal__c = 'Tel Fixe 2';
        Contact3.Tel_Fixe_2__c = '+33111111112';
        Insert Contact3;
        
        Map<Id,Contact> mapContact3;
        mapContact3 = new Map<Id,Contact>{Contact3.id => Contact3};
            System.assertEquals(VI_ParcoursAfterUpdateHandler.getPhoneToFill(mapContact3,Contact3.id), '+33111111112'); 
        
        //CASE 4: contactToCheck.MobilePhone!=null, contactToCheck.Mobile_Principal__c==null
        Contact Contact4 = SM_TestDataFactory.createContact('Test4',Acc.Id);
        Contact4.MobilePhone = '+3311111111';
        Insert Contact4;
        
        Map<Id,Contact> mapContact4;
        mapContact4 = new Map<Id,Contact>{Contact4.id => Contact4};
            System.assertEquals(VI_ParcoursAfterUpdateHandler.getPhoneToFill(mapContact4,Contact4.id), '+3311111111'); 
        
        //CASE 5: contactToCheck.MobilePhone!=null, contactToCheck.Mobile_Principal__c!=null
        Contact Contact5 = SM_TestDataFactory.createContact('Test5',Acc.Id);
        Contact5.MobilePhone = '+3311111111';
        Contact5.Mobile_Principal__c='Mobile 2';
        Contact5.Mobile_2__c = '+3311111112';
        Insert Contact5;
        
        
        Map<Id,Contact> mapContact5;
        mapContact5 = new Map<Id,Contact>{Contact5.id => Contact5};
            System.assertEquals(VI_ParcoursAfterUpdateHandler.getPhoneToFill(mapContact5,Contact5.id), '+3311111112');    
    }
    
    @isTest
    public static void getEnergieValueTest() {
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Je ne sais pas','eauChaude'), 'NSP');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Gaz naturel','eauChaude'), 'Gaz_naturel');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Electricité','eauChaude'), 'Électricité');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Réseau de chaleur','eauChaude'), 'Réseau_de_chaleur');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Propane GPL','eauChaude'), 'Propane_GPL');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Autre énergie renouv','eauChaude'), 'Autre_énergie_renouvelable');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Gaz naturel','chauffage'), 'Gaz');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Electricité','chauffage'), 'Elec');
        System.assertEquals(VI_ParcoursAfterUpdateHandler.getEnergieValue('Autre énergie renouv','chauffage'), 'Autre énergie renouvelable');
    }
}