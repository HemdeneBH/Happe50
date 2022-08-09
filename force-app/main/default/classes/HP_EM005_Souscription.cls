/**
 * @File Name          : HP_EM005_Souscription.cls
 * @Description        : EM de HP_EnrolmentDetails__c (va remplacer HP_DML_EnrolmentDetails et HP_SLCT_EnrolmentDetails)
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Hemdene Ben Hammouda





 * @Last Modified On   : 06-07-2022











 * @Modification Log   :
 * Ver       Date            Author                 Modification
 * 1.0    02/01/2020   Vincent Albiser     Initial Version
 **/
public without sharing class HP_EM005_Souscription {

    //private static final String ENDPOINT_CREATION_SOUSCRIPTION_ALGILAB =  '/propositions/souscription?';

    /**
     * @description récupération des souscriptions pour le portail admin
     * @author Vincent Albiser | 20/01/2020
     * @param HP_PortailUtilisateur__c utilisateur
     * @param String contexte
     * @param Date startDate
     * @param Date endDate
     * @return List<HP_Souscription__c>
     **/
    public static List<HP_Souscription__c> getSouscriptionsForPortailAdmin(HP_PortailUtilisateur__c utilisateur, String contexte, Datetime startDate, Datetime endDate){

        List<HP_Souscription__c> souscriptionList = new List<HP_Souscription__c>();

        if(utilisateur != null && contexte != null) {

            String soql = 'SELECT Id, ';
            soql +=   ' HP_Contact__r.Id_Tiers__c, ';
            soql +=   ' HP_DigitalDateSave2__c, ';
            soql +=   ' HP_DigitalElecDocumentId__c, ';
            soql +=   ' HP_DigitalGazDocumentId__c, ';
            soql +=   ' HP_DigitalExemplaires__c, ';
            soql +=   ' HP_DigitalLogin__r.Login__c, ';
            soql +=   ' HP_DigitalLogin__r.Prestataire__r.Name, ';
            soql +=   ' HP_Type_Energie__c, ';
            soql +=   ' HP_Contact__r.Email, ';
            soql +=   ' HP_Contact__r.FirstName, ';
            soql +=   ' HP_Contact__r.LastName, ';
            soql +=   ' HP_Porte_Feuille_Contrat__r.Xdata_Id__c, ';
            soql +=   ' HP_NumberPCE__c, ';
            soql +=   ' HP_NumPDL__c, ';
            soql +=   ' HP_Revision_Document__c, ';
            soql +=   ' HP_code_promotion__c, ';
            soql +=   ' HP_creation_mandat__c, ';
            soql +=   ' HP_creation_CPV_elec__c, ';
            soql +=   ' HP_creation_CPV_gaz__c, ';
            soql +=   ' HP_DigitalDocumentMandateId__c, ';  
            soql +=   ' HP_Souscription_Digital_Id__c, ';
            soql +=   ' HP_Statut__c, ';
            soql +=   ' HP_type_Souscription__c, ';
            soql +=   ' HP_DigitalUpdatePropositionStatus__c, ';
            soql +=   ' Name, ';
            soql +=   ' (select Id, HP_Type_de_Compteur__c, HP_Proposition_Commerciale_XdataId__c from HP_Contrats__r) ';
            soql += ' FROM HP_Souscription__c ';
            soql += ' WHERE ';

            //filtre contexte
            switch on contexte {

                when 'lead' {
                    soql += ' HP_Statut__c IN (\'' + 'SAVE_2' + '\',\'' + 'SAVE_2_CONFIRMED' + '\',\'' + 'SAVE_3' + '\') ';
                }   
                when 'contrat' {
                    soql += ' HP_Statut__c IN (\'' + 'SAVE_2_CONFIRMED' + '\',\'' + 'SAVE_3' + '\') ';
                }

            }

            //filtre utilisateur
            if(utilisateur.Prestataire__r.Canal__r.Name == 'CRC-HAPPE') {
                //pas de filtre
            }
            else if(utilisateur.Role__c == 'Superviseur') {
                soql += ' AND HP_DigitalLogin__r.Prestataire__c = \'' + utilisateur.Prestataire__c + '\' ';
            }
            else{
                soql += ' AND HP_DigitalLogin__c = \'' + utilisateur.Id + '\' ';
            }

            //filtre date
            if(startDate != null) {
                soql += ' AND HP_DigitalDateSave2__c >= :startDate ';
            }
            if(endDate != null) {
                soql += ' AND HP_DigitalDateSave2__c <= :endDate ';
            }

            //order, limit
            soql += ' Order By CreatedDate DESC ';
            soql += ' LIMIT 2000 ';

            System.debug(soql);
            souscriptionList = Database.query(soql);
        }

        return souscriptionList;
    }


    /**
     * @description permet de créer une souscription dans Agilab
     * @author Slimene Belhaj Ali | 16/01/2020
     * @param String contractId Xdata contact Id
     * @param String agilabStatus Statut de mode d'envoi { 1 => Electronique, 2 => Papier }
     * @return Map<Integer, String>
     **/
    public static Map<Integer, String> creationSouscriptionAgilab(String codeOffre, String codePromo, String idPropCommercial, String idPrestataire){
        System.debug('@@@ contractId ' + codeOffre + '  ' + codePromo + '  ' + idPropCommercial+  '  ' + idPrestataire);
        //String resources = ENDPOINT_CREATION_SOUSCRIPTION_ALGILAB + 'code_offre=' + codeOffre + '&id_proposition_commerciale=' + idPropCommercial
        //+(codePromo != null ? ('&code_promo=' + codePromo) : '');

        Map<String, String> parms = new Map<String, String> {
            'code_offre' => codeOffre,
            'id_proposition_commerciale' => idPropCommercial,
            'prestataire' => idPrestataire
        };

        if(codePromo != null) {
            parms.put('code_promo', codePromo);
        }
        Map<Integer, String> responseNoteMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_CREATION_SOUSCRIPTION, parms);
        System.debug('@@@ Response :' + responseNoteMap);
        return responseNoteMap;
    }

   

   

   

    public static String saveSouscription(final HP_EnrolmentRestResourceModel.FirstSave_v0_1 selfcare) {
        HP_Souscription__c souscription = new HP_Souscription__c();
        souscription.HP_Canal_de_vente__c = selfcare.salesChannel;
        souscription.HP_Classe_de_la_consommation_Gaz__c = selfcare.gasConsumptionClass;
        souscription.HP_Code_Gaz_Produit__c = selfcare.gasProductCode;
        souscription.HP_Code_Electrique_Produit__c = selfcare.electricityProductCode;
        souscription.HP_Code_postal__c = selfcare.zipCode;
        souscription.HP_code_Postal_Insee__c = selfcare.inseeCityCode;
        souscription.HP_code_promotion__c = selfcare.promotionalCode;
        souscription.HP_Complement_d_adresse__c = selfcare.additionalAddressInformation;

        if(selfcare.contractStartDate != null)
            souscription.HP_Date_de_Contractualisation__c = selfcare.contractStartDate; // optional in save1
        
        souscription.HP_Date_Origine__c = selfcare.originDateTime;
        souscription.HP_Energie_Verte__c = (selfcare.greenElectricity != null) ? selfcare.greenElectricity : false;
        souscription.HP_Estimation_Consommation_electrique__c = selfcare.electricityEstimatedConsumptionKiloWatt;
        souscription.HP_Estimation_Consommation_gaz__c = selfcare.gasEstimatedConsumptionKiloWatt;
        souscription.HP_Gaia_Id__c = selfcare.ownerGaiaId;
        souscription.HP_Jour_de_facturation__c = selfcare.billingDay;
        souscription.HP_Lien_enregistrement__c = selfcare.recordLink;
        souscription.HP_Methode_de_paiement__c = selfcare.billingMethod;
        souscription.HP_Montant_de_la_facturation_electrique__c = selfcare.electricityBillingAmount;
        souscription.HP_Montant_de_la_facturation_gaz__c = selfcare.gasBillingAmount;
        souscription.HP_Predecesseur__c = selfcare.formerContractHolderLastName;
        souscription.HP_Nom_de_rue__c = selfcare.streetName;
        souscription.HP_Nom_de_ville__c = selfcare.city;
        souscription.HP_Numero_de_voie__c = selfcare.streetNumber;
        souscription.HP_Periode_de_facturation__c = selfcare.billingPeriodicity;
        souscription.HP_Plan_de_Prix_electrique__c = selfcare.electricityPricingPlan;
        souscription.HP_Puissance_Compteur_electrique__c = selfcare.electricityPowerRatingKiloVoltAmpere;
        souscription.HP_Source__c = selfcare.source;
        souscription.HP_Souscription_Digital_Id__c = selfcare.selfcareId;
        souscription.HP_Type_Energie__c = selfcare.energyType;
        souscription.HP_type_Souscription__c = selfcare.enrolmentType;
        souscription.HP_NumberPCE__c =  selfcare.gasMeterId;
        souscription.HP_NumPDL__c = selfcare.electricityMeterId;
        souscription.HP_Statut__c = 'SAVE_1';
        souscription.HP_Consentement_GRD__c = selfcare.consentement_grd != null ? selfcare.consentement_grd : false;

        souscription.HP_OptionVert__c = selfcare.optionVert == true ? true : false;
        //Champ pour analyser les ventes et les taux de conversions des souscriptions.
        souscription.HP_TECH_wasSave1__c = 1;	
        if(selfcare.campagneInfos != null){
            souscription.HP_CampaignLabel__c = selfcare.campagneInfos.campaignLabel;            
            souscription.HP_CampaignSource__c = selfcare.campagneInfos.campaignSource;
            souscription.HP_CampaignMedium__c = selfcare.campagneInfos.campaignMedium;        
        }
       /*  pourcentage de remise elec & gaz */

       if(String.isNotBlank(selfcare.currentPercentReductionEleca1)) souscription.reduction_a1_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionEleca1);



       if(String.isNotBlank(selfcare.currentPercentReductionEleca2)) souscription.reduction_a2_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionEleca2);
       if(String.isNotBlank(selfcare.currentPercentReductionAboElec))  souscription.reduction_abo_elec__c =  Decimal.valueOf(selfcare.currentPercentReductionAboElec);

       if(String.isNotBlank(selfcare.currentPercentReductionAboGaz))  souscription.reduction_abo_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionAboGaz);
       if(String.isNotBlank(selfcare.currentPercentReductionGaza1))  souscription.reduction_a1_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionGaza1);
       if(String.isNotBlank(selfcare.currentPercentReductionGaza2))  souscription.reduction_a2_gaz__c =  Decimal.valueOf(selfcare.currentPercentReductionGaza2);

      if(String.isNotBlank(selfcare.email_devis)) souscription.HP_emailDevis__c = selfcare.email_devis;
     System.debug('@@@ first condition 1:');
        Database.upsert(souscription,HP_Souscription__c.Fields.HP_Souscription_Digital_Id__c);
        System.debug('@@@ first condition 2:');

        // Attachment depend on energy type
        List<Attachment> lstAttachment = new List<Attachment>();
        Boolean hasElec = selfcare.energyType == 'ELECTRICITY' || selfcare.energyType == 'COMBINED_GAS_AND_ELECTRICITY';
        Boolean hasGaz = selfcare.energyType == 'GAS' || selfcare.energyType == 'COMBINED_GAS_AND_ELECTRICITY';
        Boolean gasPhotoNotEmpty = selfcare.gasPhoto != null &&  selfcare.gasPhoto.body !=null && selfcare.gasPhoto.body.length() > 0 ;
        Boolean  electricityPhotoNotEmpty = selfcare.electricityPhoto != null &&  selfcare.electricityPhoto.body !=null && selfcare.electricityPhoto.body.length() > 0;
       
        if( electricityPhotoNotEmpty &&  hasElec){
            Blob elecDecodedBody = EncodingUtil.base64Decode(selfcare.electricityPhoto.body);
            String extensioneElec = selfcare.electricityPhoto.contentType !=null ?   selfcare.electricityPhoto.contentType.subString(6) : 'JPG';


            Attachment attachmentElec = new Attachment();
            attachmentElec.Name = 'compteur_' +  System.now().format('yyyy_MM_dd_hh_mm_ss') + '_elec'+'.'+extensioneElec;
            attachmentElec.Body = elecDecodedBody;
            attachmentElec.ContentType = selfcare.electricityPhoto.contentType; 
            attachmentElec.ParentId = souscription.Id;







            lstAttachment.add(attachmentElec);

        }

        if( gasPhotoNotEmpty && hasGaz) {
            Blob gazDecodedBody = EncodingUtil.base64Decode(selfcare.gasPhoto.body);
            String extensionGas = selfcare.gasPhoto.contentType !=null ?   selfcare.gasPhoto.contentType.subString(6) : 'JPG';
            Attachment attachmentGaz = new Attachment();
            attachmentGaz.Name = 'compteur_' +  System.now().format('yyyy_MM_dd_hh_mm_ss') + '_gaz'+'.'+extensionGas;
            attachmentGaz.Body = gazDecodedBody;
            attachmentGaz.ContentType = selfcare.gasPhoto.contentType; 
            attachmentGaz.ParentId = souscription.Id;






			

                        lstAttachment.add(attachmentGaz);
        }
       
        Database.insert(lstAttachment, true);
        return souscription.Id;
    }

    public static HP_Souscription__c loadSouscription(String selfcareId) {
        return [select Id,HP_OptionVert__c, HP_Statut__c, HP_RUM__c,HP_IBAN__c, HP_CoContractant__r.Id,HP_CoContractant__r.Salutation,HP_CoContractant__r.lastName,HP_CoContractant__r.firstName, HP_Methode_de_paiement__c,HP_Jour_de_facturation__c , HP_Periode_de_facturation__c,HP_Puissance_Compteur_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Montant_de_la_facturation_gaz__c,HP_Type_Energie__c,HP_code_promotion__c, HP_Date_Origine__c,HP_Souscription_Digital_Id__c,
            HP_Montant_de_la_facturation_electrique__c, HP_Date_de_Contractualisation__c,HP_type_Souscription__c, HP_Estimation_Consommation_electrique__c, HP_Plan_de_Prix_electrique__c,
            HP_Code_Electrique_Produit__c, HP_Code_Gaz_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Complement_d_adresse__c,HP_Nom_de_rue__c,HP_Numero_de_voie__c,HP_Nom_de_ville__c,
            HP_Code_postal_facturation__c, HP_code_Postal_Insee_facturation__c, HP_Complement_d_adresse_facturation__c, HP_Nom_de_rue_facturation__c,HP_Numero_de_voie_facturation__c, HP_Nom_de_ville_facturation__c,HP_Parrainage__c,HP_VoucherCode__c,
            HP_isLinky__c,HP_isCommunicantElec__c,HP_isGaspar__c,HP_isCommunicantGaz__c, HP_ActivationPrioritaire__c,Hp_consentementQ1_1__c,Hp_consentementQ1_2__c,Hp_consentementQ1_3__c, OK_Electricite__c, OK_Gaz__c,
            (select Id, HP_Id_Compteur__c,HP_Numero_reference_du_Compteur__c, HP_Proposition_Commerciale_XdataId__c, HP_Contrat_XdataId__c, HP_Souscription_Digital_Id__c,HP_Type_de_Compteur__c from HP_Contrats__r) from HP_Souscription__c
            where HP_Souscription_Digital_Id__c = : selfcareId];
	}
	
	public static List<HP_Souscription__c> loadSouscriptionList(String selfcareId) {
		return [select Id,HP_OptionVert__c, HP_Statut__c, HP_RUM__c,HP_IBAN__c, HP_CoContractant__r.Id,HP_CoContractant__r.Salutation,HP_CoContractant__r.lastName,HP_CoContractant__r.firstName, HP_Methode_de_paiement__c,HP_Jour_de_facturation__c , HP_Periode_de_facturation__c,HP_Puissance_Compteur_electrique__c,HP_Estimation_Consommation_gaz__c,HP_Montant_de_la_facturation_gaz__c,HP_Type_Energie__c,HP_code_promotion__c, HP_Date_Origine__c,HP_Souscription_Digital_Id__c,
			HP_Montant_de_la_facturation_electrique__c, HP_Date_de_Contractualisation__c,HP_type_Souscription__c, HP_Estimation_Consommation_electrique__c, HP_Plan_de_Prix_electrique__c,OK_Gaz__c,OK_Electricite__c,
			HP_Code_Electrique_Produit__c, HP_Code_Gaz_Produit__c,HP_Code_postal__c,HP_code_Postal_Insee__c,HP_Complement_d_adresse__c,HP_Nom_de_rue__c,HP_Numero_de_voie__c,HP_Nom_de_ville__c,
			HP_Code_postal_facturation__c, HP_code_Postal_Insee_facturation__c, HP_Complement_d_adresse_facturation__c, HP_Nom_de_rue_facturation__c,HP_Numero_de_voie_facturation__c, HP_Nom_de_ville_facturation__c,HP_Parrainage__c,HP_VoucherCode__c,
            HP_isLinky__c,HP_isCommunicantElec__c,HP_isGaspar__c,HP_isCommunicantGaz__c,HP_ActivationPrioritaire__c,Hp_consentementQ1_1__c,Hp_consentementQ1_2__c,Hp_consentementQ1_3__c,HP_Contact__r.HP_OptinMarketing__c,HP_Contact__r.ID_Tiers__c,
			(select Id, HP_Id_Compteur__c,HP_Numero_reference_du_Compteur__c, HP_Proposition_Commerciale_XdataId__c, HP_Contrat_XdataId__c, HP_Souscription_Digital_Id__c,HP_Type_de_Compteur__c from HP_Contrats__r) from HP_Souscription__c
			where HP_Souscription_Digital_Id__c = : selfcareId];
    }
    
    public static void changeStatus(Id souscriptionId, String status) {
        HP_Souscription__c souscription = new HP_Souscription__c (Id = souscriptionId, HP_Statut__c = status); 
        update souscription;





    }

    public static List<Map<String, Object>> loadDataCocontractant(String contactId) {
        List<HP_Souscription__c> souscriptionList = [select Id,toLabel(HP_Type_Energie__c),HP_Date_de_Contractualisation__c,HP_Statut__c,HP_Contact__c,HP_Nom_de_rue__c,HP_Complement_d_adresse__c, 
        HP_Numero_de_voie__c,HP_Code_postal__c,HP_Nom_de_ville__c,HP_CoContractant__c, HP_Contact__r.firstName, HP_Contact__r.lastName, 
        HP_Contact__r.Id_Tiers__c, HP_Porte_Feuille_Contrat__r.Xdata_Id__c,Hp_consentementQ1_1__c,Hp_consentementQ1_2__c,Hp_consentementQ1_3__c,
         (select HP_Contrat_XdataId__c,HP_Type_de_Compteur__c from HP_Contrats__r)
        from HP_Souscription__c
        where HP_CoContractant__c = :contactId and HP_Contact__r.Id_Tiers__c != null 
        and HP_Porte_Feuille_Contrat__r.Xdata_Id__c != null];
        List<Map<String, Object>> result = new List<Map<String, Object>>();

        for(HP_Souscription__c sous : souscriptionList) {
            String pfcXdata = String.valueOf(sous.HP_Porte_Feuille_Contrat__r.Xdata_Id__c);
            Object solde = null;
            try {
                Map<String, Object> resultAsMap = (Map <String, Object> ) JSON.deserializeUntyped(HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_SOLDE_EFFECTIF,'id_client_xdata='+sous.HP_Contact__r.Id_Tiers__c).getBody());
                Map<String, Object> output = (Map<String, Object>) resultAsMap.get('output');
                List<Object> soldes = (List<Object>) output.get('soldes');
                
                
                for(Object obj : soldes) {
                    Map<String, Object> currentItem = (Map<String, Object>)obj;
                    if(currentItem.get(pfcXdata) != null) {
                        solde = currentItem.get(pfcXdata);
                        break;
                    }
                }
            } catch(Exception e) {}
            

            String elecStatus = null;
            String gazStatus = null;
            String elecDateContractualisation = null;
            String gazDateContractualisation = null;
           
            for(Hp_Contrat__c cont : sous.HP_Contrats__r) {
                try {
                    Map<String, Object> resultContrat = (Map <String, Object> ) JSON.deserializeUntyped(HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONTRATS, '/' + cont.HP_Contrat_XdataId__c).getBody());
                    if(cont.HP_Type_de_Compteur__c == 'ELEC') {
                        elecStatus = (String)resultContrat.get('libelleStatutCrm');
                        elecDateContractualisation = (String) resultContrat.get('dateDebutValidite');
                    } else {
                        gazStatus = (String)resultContrat.get('libelleStatutCrm');
                        gazDateContractualisation = (String) resultContrat.get('dateDebutValidite');
                    }
                } catch(Exception e) {}
            }
            Map<String, Object> currentResult =  new Map<String, Object> {
                'id' => sous.Id,
                'firstName' => sous.HP_Contact__r.firstName,
                'lastName' => sous.HP_Contact__r.lastName,
                'status' => sous.HP_Statut__c,
                'address' => sous.HP_Numero_de_voie__c + ' ' + sous.HP_Nom_de_rue__c+ ' ' + sous.HP_Code_postal__c + ' ' + sous.HP_Nom_de_ville__c,
                'firstName' => sous.HP_Contact__r.firstName,
                'xdataId' =>  sous.HP_Contact__r.Id_Tiers__c,
                'idContractant' => sous.HP_Contact__c,
                'solde' => solde,
                'elecStatus' => elecStatus,
                'dateContractualisation' => sous.HP_Date_de_Contractualisation__c,
                'elecDateContractualisation' => elecDateContractualisation,
                'gazDateContractualisation' => gazDateContractualisation,
                'typeEnergie' => sous.HP_Type_Energie__c,
                'gazStatus' => gazStatus};
                System.debug('@@ currentResult ' + currentResult);
            result.add(currentResult);
        }
        return result;
    }

    public static List<HP_Souscription__c> getSouscriptionsInfos(List<String> souscriptionsIdList) {
        return [select Id,HP_Statut__c, HP_Souscription_Digital_Id__c, HP_Contact__c 
                from HP_Souscription__c
                where HP_Souscription_Digital_Id__c in :souscriptionsIdList];

    }
    
    @AuraEnabled(cacheable=true)
    public static List<HP_Souscription__c> soucriptionWithSamePdlPce(String idContractant, String value, String fieldName) {
        return DataBase.query('select Id from HP_Souscription__c where HP_Contact__c = :idContractant and ' + fieldName + ' =:value order by createdDate desc');
    }


    public static List<HP_Souscription__c> getSouscriptionsConcat(Set<String> concatenationSet, Date souscriptionDate) {
        return [select id , HP_NumPDL__c, HP_NumberPCE__c, HP_TECH_FormulaConcatField__c, HP_Statut__c  
                from hp_souscription__c
                where (HP_TECH_FormulaConcatField__c in :concatenationSet AND DAY_ONLY(HP_Date_Origine__c) >= :souscriptionDate )];

    }


















    public static List<HP_Souscription__c> getDevis(String digitalId) {
        string str = digitalId+'%';
        System.debug('@@ str ' + str);
        return [select id ,Name, HP_Souscription_Digital_Id__c, HP_Statut__c,HP_type_Souscription__c, HP_Type_Energie__c, HP_NumPDL__c, HP_NumberPCE__c from hp_souscription__c
                where HP_Souscription_Digital_Id__c  like :str];

    }

    public static List<HP_Souscription__c> getstatus(String digitalId) {
        string str = digitalId+'%';
        System.debug('@@ str ' + str);
        return [select id , Name,HP_Souscription_Digital_Id__c, HP_Statut__c from hp_souscription__c where HP_Statut__c   =: 'SAVE_1' and HP_Souscription_Digital_Id__c  like :str];

    }
   
    public static List<HP_Souscription__c> getSouscriptionsByFormula(Set<String> formulaSet, Date souscriptionDate) {
        return [select id , HP_NumPDL__c, HP_NumberPCE__c, HP_TECH_FormulaEnergyPDLPCEField__c, HP_Statut__c, HP_TECH_FormulaEnergyPDLPCEConcatField__c, HP_TECH_DedupOrder__c, HP_Contact__c  
                from hp_souscription__c
                where (HP_TECH_FormulaEnergyPDLPCEField__c in :formulaSet AND DAY_ONLY(HP_Date_Origine__c) >= :souscriptionDate ) order by HP_Date_Origine__c asc];

    }
   


















}