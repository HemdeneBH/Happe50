@isTest
global class SM_AP14_GestionPrelevementMock implements WebServiceMock {
    global void doInvoke(Object stub,
    Object request,
    Map < String, Object > response,
    String endpoint,
    String soapAction,
    String requestName,
    String responseNS,
    String responseName,
    String responseType) {
        gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element response_x = new gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementResponse_element();

        gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementOutputDt demanderPrelevementOutput = new gdfsuezComBefChpCalypsoGestionprele.demanderPrelevementOutputDt();
        gdfsuezComBefChpCalypsoGestionprele.mandatDPDt mandat = new gdfsuezComBefChpCalypsoGestionprele.mandatDPDt();
        mandat.idMandat = '00S012453607';
        gdfsuezComBefChpPivot_Prelevement1.listeValeursDt statutMandat = new gdfsuezComBefChpPivot_Prelevement1.listeValeursDt();
        statutMandat.libelleCourt = 'A confirmer';
        statutMandat.code = '2';
        mandat.statutMandat = statutMandat;
        mandat.idPersonne = '0309034268';
        mandat.idCoordonneeBancaire = '0309034268-0001';
        demanderPrelevementOutput.mandat = mandat;

        gdfsuezComBefChpCalypsoGestionprele.compteClientDt compteClient = new gdfsuezComBefChpCalypsoGestionprele.compteClientDt();
        compteClient.idCompteClient = '000512478480';
        gdfsuezComBefChpCalypsoGestionprele.listeServicesGestionDt listeServicesGestion = new gdfsuezComBefChpCalypsoGestionprele.listeServicesGestionDt();
        List<gdfsuezComBefChpPivot_Prelevement1.listeValeursDt> serviceGestions = new  List<gdfsuezComBefChpPivot_Prelevement1.listeValeursDt>();

        gdfsuezComBefChpPivot_Prelevement1.listeValeursDt serviceGestion = new gdfsuezComBefChpPivot_Prelevement1.listeValeursDt();
        serviceGestion.libelleCourt = 'Demande prélèvement';
        serviceGestion.code = 'DP';
        serviceGestions.add(serviceGestion);

        listeServicesGestion.serviceGestion = serviceGestions;
        compteClient.listeServicesGestion = listeServicesGestion;
        demanderPrelevementOutput.compteClient = compteClient;

        gdfsuezComBefChpPivot_Prelevement1.messageRetoursDt messageRetours = new gdfsuezComBefChpPivot_Prelevement1.messageRetoursDt();
        List<gdfsuezComBefChpPivot_Prelevement1.messageRetour_element>messageRetours_element = new List<gdfsuezComBefChpPivot_Prelevement1.messageRetour_element>();
        gdfsuezComBefChpPivot_Prelevement1.messageRetour_element messageRetour_element1 = new gdfsuezComBefChpPivot_Prelevement1.messageRetour_element();
        messageRetour_element1.id = 'a3082dfa-6a51-4baa-a636-df25ce372141';
        messageRetour_element1.code = 'OCTOPUS_DemanderPrelevement_02';
        messageRetour_element1.libelle = 'Information remontée par le service CreerMandat : Traitement effectué sans erreur.';
        messageRetour_element1.type_x = 'Information';
        messageRetour_element1.source = 'Middleware OCTOPUS';
        messageRetour_element1.classe = 'Fonctionnelle';
        messageRetour_element1.timestamp = Datetime.now() ;
        messageRetours_element.add(messageRetour_element1);

        gdfsuezComBefChpPivot_Prelevement1.messageRetour_element messageRetour_element2 = new gdfsuezComBefChpPivot_Prelevement1.messageRetour_element();
        messageRetour_element2.id = 'a3082dfa-6a51-4baa-a636-df25ce372141';
        messageRetour_element2.code = 'OCTOPUS_DemanderPrelevement_06';
        messageRetour_element2.libelle = 'Information remontée par le service MajCompteClient : Compte client 000512478480 mis à jour avec succès : idCoordonneeBancaire=0309034268-0001.';
        messageRetour_element2.type_x = 'Information';
        messageRetour_element2.source = 'Middleware OCTOPUS';
        messageRetour_element2.classe = 'Fonctionnelle';
        messageRetour_element2.timestamp = Datetime.now();
        messageRetours_element.add(messageRetour_element2);

        gdfsuezComBefChpPivot_Prelevement1.messageRetour_element messageRetour_element3 = new gdfsuezComBefChpPivot_Prelevement1.messageRetour_element();
        messageRetour_element3.id = 'a3082dfa-6a51-4baa-a636-df25ce372141';
        messageRetour_element3.code = 'OCTOPUS_DemanderPrelevement_05';
        messageRetour_element3.libelle = 'Information remontée par le service ActiverServiceGestion : DP activée avec succès.';
        messageRetour_element3.type_x = 'Information';
        messageRetour_element3.source = 'Middleware OCTOPUS';
        messageRetour_element3.classe = 'Fonctionnelle';
        messageRetour_element3.timestamp = Datetime.now();
        messageRetours_element.add(messageRetour_element3);

        gdfsuezComBefChpPivot_Prelevement1.messageRetour_element messageRetour_element4 = new gdfsuezComBefChpPivot_Prelevement1.messageRetour_element();
        messageRetour_element4.id = 'a3082dfa-6a51-4baa-a636-df25ce372141';
        messageRetour_element4.code = 'OCTOPUS_DemanderPrelevement_01';
        messageRetour_element4.libelle = 'Traitement effectué sans erreur';
        messageRetour_element4.type_x = 'Information';
        messageRetour_element4.source = 'Middleware OCTOPUS';
        messageRetour_element4.classe = 'Fonctionnelle';
        messageRetour_element4.timestamp = Datetime.now();
        messageRetours_element.add(messageRetour_element4);

        messageRetours.messageRetour = messageRetours_element;

        response_x.demanderPrelevementOutput = demanderPrelevementOutput;
        response_x.messageRetours = messageRetours;
        response.put('response_x', response_x);
    }

}