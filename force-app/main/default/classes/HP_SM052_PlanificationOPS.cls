/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 03-03-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-16-2021   Slimene Belhaj Ali   Initial Version
**/
public inherited sharing class HP_SM052_PlanificationOPS {
    private static final String END_POINT_PRESTAELEC = 'ES-PrestationServiceElec_v3';
    public static final String END_POINT_PRESTAGAS = 'ES-PrestationServiceGaz_v2';


    public static Map<String, Object> lireOPSElec(String idAffaire) {
        gdfsuezComBefChpPSEPivot.contextDt context = (gdfsuezComBefChpPSEPivot.contextDt)HP_OctopusUtils.buildContext(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1, gdfsuezComBefChpPSEPivot.contextDt.class);
        gdfsuezBefCalypsoPrestationServiceElec.Dependency port =
        (gdfsuezBefCalypsoPrestationServiceElec.Dependency)HP_OctopusUtils.buildPort(END_POINT_PRESTAELEC, gdfsuezBefCalypsoPrestationServiceElec.Dependency.class);


        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt();
        input.online = true;
        input.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(input.loginUtilisateur == null || input.loginUtilisateur == '') {
			input.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_ELEC');
        }
        
        input.prestationServiceElectricite = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element[1];
        input.prestationServiceElectricite[0] = new gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteInputDt_prestationServiceElectricite_element();
        input.prestationServiceElectricite[0].idPrestationServiceDistributeur = idAffaire;

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteResponse_element response  = port.LirePrestationServiceElectricite_Http(input, context);
        
        Map<String, Object> result = new Map<String, Object>();
        result.put('code', response.messageRetours.retourTraitementMessage[0].code);

        gdfsuezBefCalypsoPrestationServiceElec.lirePrestationServiceElectriciteOutputDt_prestationServiceLire_element elem = response.lirePrestationServiceElectriciteOutput.prestationServiceLire[0];

        result.put('opsType',  elem.demande.donneesGeneralesDemande.natureDemande.libelleCourt);
        result.put('opsStatus', elem?.donneesGenerales?.statutPrestationService?.libelleCourt);
        result.put('code', elem?.donneesGenerales?.statutPrestationService?.code);
        result.put('commentaireDist', elem?.demande?.commentaireIntervention);
        result.put('personneContacterPrenom',  elem?.demande?.interlocuteurIntervention?.personnePhysique?.prenom);
        result.put('personneContacterNom',  elem?.demande?.interlocuteurIntervention?.personnePhysique?.nom);
        result.put('personneContacterCivilite',  elem?.demande?.interlocuteurIntervention?.personnePhysique?.civilite?.code);
        boolean disabledModify = (elem?.donneesGenerales?.statutPrestationService?.code == 'COURS' 
        && elem?.interventions?.intervention.donneesGenerales?.etatIntervention?.code == 'PLAN' && (
            elem?.interventions?.intervention?.operations?.teleoperables != null && elem?.interventions?.intervention?.operations?.teleoperables == false  
        ));
       
        if(disabledModify == false && elem?.interventions?.intervention?.operations?.teleoperables == true &&
        elem?.donneesGenerales?.statutPrestationService?.code == 'COURS' &&
        elem?.interventions?.intervention.donneesGenerales?.etatIntervention?.code == 'PLAN') {
            result.put('errorMessage', 'L’intervention sera réalisée à distance car il s’agit d’un compteur télé-opérable (Linky). Aucune action ou présence du client requise lors de l’intervention.');
        } else if(disabledModify == false) {
            result.put('errorMessage', 'Le statut de l’intervention ne permet pas de la replanifier.');
        }
        result.put('disabledModify', !disabledModify);
        if(elem.interventions != null && elem.interventions != null && elem.interventions.intervention != null  && elem.interventions.intervention.planifications != null && elem.interventions.intervention.planifications.planification != null){
        gdfsuezBefCalypsoPrestationServiceElec.planificationDt node = elem.interventions.intervention.planifications.planification[elem.interventions.intervention.planifications.nbPlanif - 1];
            result.put('datePrevue',  node.datePrevue.format('dd/MM/yyyy'));
            if(node.surSite != null && node.surSite.creneauHorairePrevu != null){
                if(elem?.demande?.disponibilite?.creneauHoraire?.libelleCourt != null && 
                node.surSite?.heureDebutPrevue != null && node?.surSite?.heureFinPrevue != null) {
                    result.put('creneau', node.surSite?.creneauHorairePrevu.libelleCourt + ' entre ' + node.surSite?.heureDebutPrevue + ' et ' + node?.surSite?.heureFinPrevue);
                }
            }
        }
        if(result.get('creneau') == null && elem.demande?.disponibilite?.creneauHoraire?.libelleCourt != null) {
            result.put('creneau', elem.demande.disponibilite.creneauHoraire.libelleCourt);
        }
        if(result.get('datePrevue') == null && elem?.demande?.disponibilite?.dateInterventionSouhaitee != null) {
            result.put('datePrevue', elem?.demande?.disponibilite?.dateInterventionSouhaitee.format('dd/MM/yyyy'));
        }

        if(result.get('datePrevue') == null && elem?.recevabilite?.recevabilitePositive?.dateEffetPrevue != null) {
            result.put('datePrevue', elem?.recevabilite?.recevabilitePositive?.dateEffetPrevue.format('dd/MM/yyyy'));
        }
        return result;
    }

    public static Map<String, Object> lireOPSGaz(String idAffaire) {
        gdfsuezComBefChpPivotPrestaGaz.contextDt context = HP_SM026_DistCreatePrestationGaz.initContext2(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1);
        gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
        port.endpoint_x = HP_OctopusUtils.END_POINT + END_POINT_PRESTAGAS;
        port.inputHttpHeaders_x = new Map<String, String> {HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET};
        
        gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt();
    
        input.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(input.loginUtilisateur == null || input.loginUtilisateur == '') {
			input.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_GAZ');
        }

        input.online = true;
		
		
		// Donnees générales
		input.prestationServiceGaz = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element[1];
		input.prestationServiceGaz[0] = new gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazInputDt_prestationServiceGaz_element();
        input.prestationServiceGaz[0].idPrestationServiceDistributeur = idAffaire;

        gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazResponse_element response = port.LirePrestationServiceGaz_Http(input, context);

        gdfsuezBefCalypsoPrestaGaz.lirePrestationServiceGazOutputDt_prestationServiceLire_element elem = response.lirePrestationServiceGazOutput.prestationServiceLire[0];

        
        Map<String, Object> result = new Map<String, Object>();
        result.put('opsType',  elem?.donneesGenerales?.typePrestationService?.code);
        try {
            if(elem?.donneesGenerales?.statutPrestationService?.code == '63') {
                result.put('datePrevue', elem?.interventions?.intervention[0]?.planification.datePrevue.format('dd/MM/yyyy'));
            } else {
                result.put('datePrevue', elem?.donneesGenerales?.dateEffetDemandee?.date_x.format('dd/MM/yyyy'));
            }
        } catch(Exception e){}

        try {
            if(elem?.donneesGenerales?.statutPrestationService?.code == '63' &&
             elem?.interventions?.intervention[0]?.planification?.creneauHoraire?.libelleCourt != null 
            && elem?.interventions?.intervention[0]?.planification?.heureDebut != null &&
             elem?.interventions?.intervention[0]?.planification?.heureFin != null){
                result.put('creneau', elem?.interventions?.intervention[0]?.planification?.creneauHoraire?.libelleCourt
                + ' entre ' + elem?.interventions?.intervention[0]?.planification.heureDebut + ' et '
                + elem?.interventions?.intervention[0]?.planification?.heureFin);
                
            } else {
                result.put('creneau', elem?.donneesGenerales?.dateEffetDemandee?.creneauHoraire?.libelleCourt);
            }
        } catch(Exception e){}
        
        result.put('personneContacterPrenom',  elem?.donneesGenerales?.utilisateurFinal?.prenom);
        result.put('personneContacterNom',  elem?.donneesGenerales?.utilisateurFinal?.nom);
        result.put('personneContacterCivilite',  elem?.donneesGenerales?.utilisateurFinal?.civilite?.code);

        result.put('opsStatus', elem?.donneesGenerales?.statutPrestationService?.libelleCourt);
        result.put('commentaireDist', elem?.interventions?.intervention[0]?.commentaireIntervention);

        boolean disabledModify = (elem?.donneesGenerales?.statutPrestationService?.code == '63' ||
        elem?.donneesGenerales?.statutPrestationService?.code == '45');
        System.debug('@@  elem?.donneesGenerales?.donneesPDL?.etatPDL?.code ' +  elem?.donneesGenerales?.donneesPDL?.etatPDL?.code);
        result.put('disabledModify', !disabledModify);
        if(disabledModify == false) {
            if(elem?.donneesGenerales?.statutPrestationService?.code == '50' && elem?.donneesGenerales?.donneesPDL?.etatPDL?.code == '3') {
                result.put('errorMessage', 'L’intervention sera réalisée à distance car il s’agit d’un compteur télé-opérable (Gazpar). Aucune action ou présence du client requise lors de l’intervention.');
            } else {
                result.put('errorMessage', 'Le statut de l’intervention ne permet pas de la replanifier.');

            }
        }
        return result;
    }

    @AuraEnabled
    public static Map<String, Object> lireOPS(String idAffaire, String type){
        if(type == 'elec') {
            return lireOPSElec(idAffaire);
        } else {
            return lireOPSGaz(idAffaire);
        }
    }

    @AuraEnabled
    public static Map<String, Object> modifierOPS(String idAffaire, String civilite, String nom, String prenom,
    String tel, String dateSou, String creneau, String commentaire, String type, String action){
        Datetime dt = Date.valueOf(dateSou);
        if(type == 'elec') {
            return modifyOPSElec(idAffaire, civilite, nom, prenom, tel, dt, creneau, commentaire);
        } else {
            return modifyOPSGaz(idAffaire, civilite, nom, prenom, tel, dt, creneau, commentaire, action);
        }
    }

    public static Map<String, Object> modifyOPSElec(String idAffaire, String civilite, String nom, String prenom,
     String tel, DateTime dateSou, String creneau, String commentaire) {
        
        gdfsuezComBefChpPSEPivot.contextDt context = (gdfsuezComBefChpPSEPivot.contextDt)HP_OctopusUtils.buildContext(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1, gdfsuezComBefChpPSEPivot.contextDt.class);
        gdfsuezBefCalypsoPrestationServiceElec.Dependency port =
        (gdfsuezBefCalypsoPrestationServiceElec.Dependency)HP_OctopusUtils.buildPort(END_POINT_PRESTAELEC, gdfsuezBefCalypsoPrestationServiceElec.Dependency.class);


        port.inputHttpHeaders_x = new Map<String, String>{'Content-Type' => 'text/xml;charset=utf-8'}; 

        gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteInputDt input = new gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteInputDt ();
        input.online = true;
        input.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(input.loginUtilisateur == null || input.loginUtilisateur == '') {
			input.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_ELEC');
        }

        input.commentaireIntervention = commentaire;
        input.idPrestationServiceDistributeur = idAffaire;
        
    
        
        input.disponibilite = new gdfsuezBefCalypsoPrestationServiceElec.disponibiliteDt();
        input.disponibilite.creneauHoraire = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.disponibilite.creneauHoraire.code = !String.isBlank(creneau) ? creneau.toLowerCase() : '';
        
        input.dateEffetSouhaitee = dateSou;    
        input.disponibilite.dateInterventionSouhaitee = dateSou;
        
        input.interlocuteurIntervention = new gdfsuezBefCalypsoPrestationServiceElec.interlocuteurInterventionDt();
        input.interlocuteurIntervention.personnePhysique= new gdfsuezBefCalypsoPrestationServiceElec.identiteDt();
        input.interlocuteurIntervention.personnePhysique.nom = nom;

        input.interlocuteurIntervention.personnePhysique.prenom = prenom;
        input.interlocuteurIntervention.personnePhysique.civilite = new gdfsuezComBefChpPSEPivot.listeValeursDt();
        input.interlocuteurIntervention.personnePhysique.civilite.code = civilite;               
        input.interlocuteurIntervention.coordonneesContact = new gdfsuezBefCalypsoPrestationServiceElec.coordonneesContactDt();
        input.interlocuteurIntervention.coordonneesContact.telephone = new String[]{tel.replace(' ','')}; 
        
        Map<String, Object> result = new Map<String, Object>();
                   
        gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteResponse_element response; 
        response  = port.ReplanifierRDVPrestationServiceElectricite_Http(input, context);
        String code = response.messageRetours.retourTraitementMessage[0].code;
        if(code == 'OCTOPUS_ReplanifierRDVPrestationServiceElectricite_01' && 
        response.replanifierRDVPrestationServiceElectriciteOutput.priseEnCompteDistributeur == true &&
        response.messageRetours?.retourTraitementMessage[0]?.causedBy?.code == 'SGT200') {
            result.put('code', 200);
            result.put('successMessage', response.messageRetours.retourTraitementMessage[0].causedBy.libelle);
        } else if(code == 'OCTOPUS_ReplanifierRDVPrestationServiceElectricite_01' && 
        response.replanifierRDVPrestationServiceElectriciteOutput.priseEnCompteDistributeur == false) {
            result.put('code', 210);

            List<Map<String, Object>> disps = new List<Map<String, Object>>();
            for(gdfsuezBefCalypsoPrestationServiceElec.replanifierRDVPrestationServiceElectriciteOutputDt_tableauDeCharge_creneau_element item :
                response.replanifierRDVPrestationServiceElectriciteOutput.tableauDeCharge.creneau) {
                disps.add(new Map<String, Object> {'date' => item.date_x, 'creneauLibelle' => item.creneauHoraire.libelleCourt,
                'creneauCode' => item.creneauHoraire.code});
            }
            result.put('disponibilites', disps);
        } else {
            result.put('code', 400);
            result.put('error', response.messageRetours?.retourTraitementMessage[0]?.causedBy?.libelle);
        }
        
        return result;
    }

    public static gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element modifyOPSGazGetResponse(String idAffaire, String civilite, String nom, String prenom,
     String tel, DateTime dateSou, String creneau, String commentaire, String action, String hd, String hf) {


        gdfsuezComBefChpPivotPrestaGaz.contextDt context = HP_SM026_DistCreatePrestationGaz.initContext2(HP_OctopusUtils.CONTEXT, HP_OctopusUtils.VERSION1);
        gdfsuezBefCalypsoPrestaGaz.Dependency port = new gdfsuezBefCalypsoPrestaGaz.Dependency();
        port.endpoint_x = HP_OctopusUtils.END_POINT + END_POINT_PRESTAGAS;
        port.inputHttpHeaders_x = new Map<String, String> {HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET};
        
		gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt input = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt();
    
        input.loginUtilisateur = HP_SLCT_User.retriveUser(System.UserInfo.getUserId()).Distributor_Login__c;
		if(input.loginUtilisateur == null || input.loginUtilisateur == '') {
			input.loginUtilisateur = HP_UTIL_MetadataManager.getConfigByKey('HP_LOGIN_GAZ');
        }

        input.online = true;
        input.idPrestationServiceDistributeur = idAffaire;
        input.dateRdv = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_dateRdv_element();
        input.dateRdv.date_x = dateSou;
        //input.dateEffetSouhaitee = dateSou;
        input.dateRdv.creneauHoraire = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
        input.dateRdv.creneauHoraire.code = creneau;
        input.contactIntervention = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_contactIntervention_element();
		input.contactIntervention.identiteContact = new gdfsuezBefCalypsoPrestaGaz.identiteContactDt();
		input.contactIntervention.identiteContact.nom = nom;
		input.contactIntervention.identiteContact.prenom = prenom;
		input.contactIntervention.identiteContact.civilite = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
        input.contactIntervention.identiteContact.civilite.code = civilite;
        input.contactIntervention.coordonneesContact = new gdfsuezBefCalypsoPrestaGaz.coordonneesContactDt();

        input.contactIntervention.coordonneesContact.telephone = tel != null ? tel.replace(' ','') : '';
        input.contactIntervention.accesLocal = new gdfsuezBefCalypsoPrestaGaz.contactInterventionDt_accesLocal_element();
        input.contactIntervention.accesLocal.complement = commentaire;
        input.action = new gdfsuezComBefChpPivotPrestaGaz.listeValeursDt();
		input.action.code = action;
        
        if(action == 'ACCEPTER') {
            input.accepterRdv = new gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazInputDt_accepterRdv_element();
            input.accepterRdv.optionExpress = false;
            input.dateRdv.heureDebut = hd;
            input.dateRdv.heureFin = hf;
        }
        
        gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response;
        response = port.ModifierPrestationServiceGaz_Http(input, context);

        return response;
     }

     public static Map<String, Object> modifyOPSGaz(String idAffaire, String civilite, String nom, String prenom,
     String tel, DateTime dateSou, String creneau, String commentaire, String action) {
        Map<String, Object> result = new Map<String, Object>();
        gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response = modifyOPSGazGetResponse(idAffaire, civilite, nom, prenom,
                tel, dateSou, creneau, commentaire, action, null, null);
        String code = response.messageRetours.retourTraitementMessage[0].code;
        
        if(code == 'OCTOPUS_ModifierPrestationServiceGaz_07') {
            String hd = response.modifierPrestationServiceGazOutput.planificationIntervention.heureDebut;
            String hf = response.modifierPrestationServiceGazOutput.planificationIntervention.heureFin;
            response = modifyOPSGazGetResponse(idAffaire, civilite, nom, prenom,
            tel, dateSou, creneau, commentaire, 'ACCEPTER', hd, hf);
            code = response.messageRetours.retourTraitementMessage[0].code;
        }
        
        if(code == 'OCTOPUS_ModifierPrestationServiceGaz_01') {
            result.put('code', 200);
        } else if(code == 'OCTOPUS_ModifierPrestationServiceGaz_05') {
            result.put('code', 210); 
            List<Map<String, Object>> disps = new List<Map<String, Object>>();
            for(gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazOutputDt_tableauDeCharges_creneauDisponible_element item :
                response.modifierPrestationServiceGazOutput.tableauDeCharges.creneauDisponible) {
                disps.add(new Map<String, Object> {'date' => item.date_x, 'creneauLibelle' => item.creneauHoraire.libelleCourt,
                'creneauCode' => item.creneauHoraire.code});
            }
            result.put('disponibilites', disps);
        } else {
            result.put('code', 400);
            //try{}
            String lebelError = response?.messageRetours?.retourTraitementMessage[0]?.causedBy?.libelle;
            if(lebelError != null) {
                String key =  lebelError.substringAfter('/').trim();
                try {
                    result.put('error', [select HP_Value__c from HP_MessageErrorOmega__c where Name = :key].HP_Value__c);
                } catch(Exception e) {
                    result.put('error', key);
                }
                
            }
            
        }
       
        return result;
     }

     @AuraEnabled
     public static Map<String, Object> cancelOPSGaz(String idAffaire, String civilite, String nom, String prenom,
     String tel, DateTime dateSou, String creneau, String commentaire) {
        Map<String, Object> result = new Map<String, Object>();
        gdfsuezBefCalypsoPrestaGaz.modifierPrestationServiceGazResponse_element response = modifyOPSGazGetResponse(idAffaire, civilite, nom, prenom,
                tel, dateSou, creneau, commentaire, 'ABANDONNER_RDV', null, null);
        return result;
     }

     @AuraEnabled
     public static void sendNotification(String contactId, String distName, String dateRDV, String creneau, String address, boolean sms, boolean email){
        Contact cont = [select toLabel(Salutation), FirstName, LastName, email, mobilePhone, Id_Tiers__c from contact where Id = :contactId];
        if(sms == true && cont.mobilePhone != null) {
            Map<String, String> input = new Map<String, String>();
            input.put('idFormulaireCode', 'SMS1');
            input.put('idClient', String.valueOf(cont.Id_Tiers__c));
            input.put('contenu', 'Votre rendez-vous avec '+ distName +' a été modifié et est planifié le '+ dateRDV + ', '+ creneau +'. Le service Client happ-e.');
            input.put('numMobile', cont.mobilePhone.replace('+33', '0'));
            input.put('canalCommunicationCode', 'SMS');
            HP_UTIL_MailSmsEnvoi.envoiAsync(input);
        } else if(sms == true && cont.mobilePhone != null) {
            System.debug('Le contact n\'a pas un tel mobile');
        }

        if(email == true) {
            Map<String, String> input = new Map<String, String>();
            input.put('idFormulaireCode', 'SF52');
            input.put('email', cont.Email);
            input.put('idClient', String.valueOf(cont.Id_Tiers__c));
            input.put('canalCommunicationCode', 'EMAIL');
            input.put('canalCommunicationLibCourt', 'Email');
            input.put('idFormulaireLibCourt', 'Mail happe');
            input.put('objet', 'Modification de la date de votre rendez-vous ' + distName);
            input.put('contenu', cont.Salutation + ' ' +cont.FirstName + ' ' +cont.LastName + ',<br/>' + 'Votre rendez-vous avec le distributeur '+
            distName +' a bien été modifié suite à votre contact avec notre service Client pour votre logement situé ' + address
            +'.<br/>Votre nouvelle date de rendez-vous est le ' + dateRDV + ', ' + creneau
            + '.<br/><br/>Le service Client happ-e');
            HP_UTIL_MailSmsEnvoi.envoiAsync(input);
        }
     }
}