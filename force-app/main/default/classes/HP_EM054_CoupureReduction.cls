/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 02-28-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public with sharing class HP_EM054_CoupureReduction {
    
    private static final String TREVE_HIVERNALE = 'HP_DateDebutFin_Treve_Hivernale';
    private static final String DIFFERE_STATUT = 'DELAYED_PROCESS';
    private static final String GAS = 'Gas';
    private static final String ELECTRICITY = 'Electricity';
    private static final String PDL_PARAM = '?numeroPointDeLivraison=';
    private static final String ID_PDL_PARAM = '?idPointDeLivraison=';
    private static final String SIZE_PARAM = '&size=50';
    private static final String ACTIF_STATUT = 'Actif';
    private static final String A_TRAITER_STATUT = 'TO_DO';
    private static final String SUBTYPE_HAPPE = 'Suspicion Inversion de PDL';
    private static final String TYPE_HAPPE = 'HP_Coupure_ReductionPuissance';
    private static final String APUREMENT_PARAM = 'id_portefeuille_contrat_xdata=';
    private static final String ANNULER_STATUT = 'CANCELED';
    private static final String AIDE_PARAM = 'id_client_xdata=';
    
    @future(callout=true)
    public static void processCoupureReduction(List<Id> caseIds){
        System.debug('HP_EM054_CoupureReduction.processCoupureReduction | Method Start');
        String commentaire;
        Boolean needProcess = false;
        List<Case> caseList = retriveCases(caseIds);
        try {
            for(Case aCase : caseList){
                if(withinTreveHivernale()){
                    if(aCase.HP_Energy__c == GAS || aCase.HP_Client_Aide__c){
                        needProcess = false;
                        differCase(aCase, 'gaz_aide', getPeriodeHivernaleEndDate().addDays(1));
                    }else{
                            needProcess = true;
                        }
                }else{
                    needProcess = true;
                }
                if(needProcess){
                    if(hasDGPContracts(getXdataPDL(aCase))){
                        aCase.Status = A_TRAITER_STATUT;
                        aCase.HP_Type__c = TYPE_HAPPE;
                        aCase.HP_Sous_type__c = SUBTYPE_HAPPE;
                    }else if(!hasApurement(aCase).isEmpty()){
                        cancelCase(aCase, 'apurement');
                    }else if(hasBlocage(aCase) != null){
                        differCase(aCase, 'blocage', hasBlocage(aCase).addDays(1));
                    }else if(hasSoldeInferieur(aCase)){
                        cancelCase(aCase, 'soldeInferieur');
                    }else{
                        aCase.Status = A_TRAITER_STATUT;
                        aCase.HP_Type__c = TYPE_HAPPE;
                    }
                }
            }
            update caseList;
            System.debug('HP_EM054_CoupureReduction.processCoupureReduction | Method Exit');
        } catch (Exception ex) {
            System.debug('HP_EM054_CoupureReduction.processCoupureReduction | Exception : ' + ex.getMessage());
        }
        
    }


    /* Récupérer la date de fin de la trève hivernalle depuis le custom metadata HP_Parameter */
    public static Date getPeriodeHivernaleEndDate(){
        System.debug('HP_EM054_CoupureReduction.getPeriodeHivernaleEndDate | Method Start');
        String treveHivernaleParam = HP_UTIL_MetadataManager.getConfigByKey(TREVE_HIVERNALE);
        List<String> treveHivernaleDates = treveHivernaleParam.split('-');
        Integer month = Integer.valueOf(treveHivernaleDates[1].split('/')[1]);
        Date resultDate;
        if(Date.today().month()> Integer.valueOf(treveHivernaleDates[1].split('/')[1])){
            resultDate = Date.newInstance(Date.today().year()+1, Integer.valueOf(treveHivernaleDates[1].split('/')[1]), Integer.valueOf(treveHivernaleDates[1].split('/')[0]));
        }else{
            resultDate = Date.newInstance(Date.today().year(), Integer.valueOf(treveHivernaleDates[1].split('/')[1]), Integer.valueOf(treveHivernaleDates[1].split('/')[0]));
        }
        System.debug('HP_EM054_CoupureReduction.getPeriodeHivernaleEndDate | Method Exit');
        return resultDate;
    }

    /* Déterminer si on est en période de trève hivernale ou pas selon les dates récupérées */
    public static Boolean withinTreveHivernale(){
        String treveHivernaleParam = HP_UTIL_MetadataManager.getConfigByKey(TREVE_HIVERNALE);
        List<String> treveHivernaleDates = treveHivernaleParam.split('-');
        Integer endMonth = Integer.valueOf(treveHivernaleDates[1].split('/')[1]);
        Integer endDay = Integer.valueOf(treveHivernaleDates[1].split('/')[0]);
        Integer startMonth = Integer.valueOf(treveHivernaleDates[0].split('/')[1]);
        Integer startDay = Integer.valueOf(treveHivernaleDates[0].split('/')[0]);
        Integer currentMonth = Date.today().month();
        Integer currentDay = Date.today().day();

        if(currentMonth == endMonth){
            return currentDay <= endDay;
        }else if(currentMonth == startMonth){
            return currentDay >= startDay;
        } 

        if(startMonth > endMonth){
            return (currentMonth >= startMonth || currentMonth <= endMonth);
        }else{
            return (currentMonth >= startMonth && currentMonth <= endMonth );
        }
    }

    /* Récupérer l'Id xData du PDL à partir du Case (HP_Energy__c && HP_PDL_PCE__c) */
    public static String getXdataPDL(Case aCase){
        System.debug('HP_EM054_CoupureReduction.getXdataPDL | Method Start');
        Map <String, Object> resultMap = new Map <String, Object>();
        Map<String,Object> data = new Map <String, Object>();
        List<Object> listResultats = new List<Object>();
        try {
            if(aCase.HP_Energy__c == ELECTRICITY) {
                resultMap = (Map <String, Object> ) JSON.deserializeUntyped(HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_ELEC_PDL, PDL_PARAM + aCase.HP_PDL_PCE__c).getBody());
            }
            else {
                resultMap = (Map <String, Object> ) JSON.deserializeUntyped(HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_GAZ_PDL, PDL_PARAM + aCase.HP_PDL_PCE__c).getBody());
            }
            System.debug('@@ Result  : '+resultMap);
            listResultats = (List<Object>) resultMap.get('_data');
            data = (Map<String,Object>)listResultats[0];
            System.debug('@@ Id : '+data.get('id'));
        } catch (Exception ex) {
            System.debug('HP_EM054_CoupureReduction.getXdataPDL | Exception : '+ex.getMessage());   
        }
        System.debug('HP_EM054_CoupureReduction.getXdataPDL | Method Exit');
        return String.valueOf(data.get('id'));
    }

    /* Déterminer si le client a un contrat DGP Actif ou pas en se basant sur le retour de l'api get Contrat et sur les codes offre retourné */
    public static Boolean hasDGPContracts(String idXdataPDL){
        System.debug('HP_EM054_CoupureReduction.hasDGPContracts | Method Start');
        Boolean result = false;
        Map <String, Object> resultMap = new Map <String, Object>();
        Set<Integer> offresSet = getIdOffres();
        HttpResponse response;
        try {
            response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONTRATS, ID_PDL_PARAM+idXdataPDL+SIZE_PARAM);
            if(response.getStatusCode() == 200){
                resultMap = (Map <String, Object> ) JSON.deserializeUntyped(response.getBody());
                List<Object> listResultats = (List<Object>) resultMap.get('_data');
                for(Object item : listResultats){
                    Map<String,Object> data = (Map<String,Object>)item;
                    if(!offresSet.contains(Integer.valueOf(data.get('idOffre'))) && String.valueOf(data.get('statut')) == ACTIF_STATUT){
                        result = true;
                    }
                }
            }else{
                throw new CalloutException('HP_EM054_CoupureReduction.hasDGPContracts | Erreur Callout XData');
            }
            
        } catch (Exception ex) {
            System.debug('HP_EM054_CoupureReduction.hasDGPContracts | Exception : '+ex.getMessage());    
        }
        System.debug('HP_EM054_CoupureReduction.hasDGPContracts | Method Exit');
        return result;
    }

    /* Récupérer les offres Id pour Happe depuis le custom Setting HP_Offre__c*/
    private static Set<Integer> getIdOffres(){
        System.debug('HP_EM054_CoupureReduction.getIdOffres | Method Start');
        Set<Integer> resultSet = new Set<Integer>();
        List<HP_Offre__c> codeOffres = HP_Offre__c.getall().values();
        for(HP_Offre__c offre : codeOffres){
            resultSet.add(Integer.valueOf(offre.offreId__c));
        }
        System.debug('HP_EM054_CoupureReduction.getIdOffres | Method Exit');
        return resultSet;
    }

    /* Différer le case selon la raison et le contexte*/
    private static void differCase(Case aCase, String cause, Date treatmentDate){
        System.debug('HP_EM054_CoupureReduction.differCase | Method Start');
        switch on cause {
            when  'gaz_aide'{
                aCase.Description = aCase.HP_Client_Aide__c ? getCurrentDateFormatted() + ' - Différé car client aidé et période de trêve hivernale' :  getCurrentDateFormatted() + ' - Différé car contrat Gaz' ;
            }
            when 'blocage' {
                aCase.Description = getCurrentDateFormatted() + ' - Différé car blocage à la relance en cours sur le client';
            }
        }
        aCase.HP_TreatmentDate__c = treatmentDate;
        aCase.Status = DIFFERE_STATUT;
        System.debug('HP_EM054_CoupureReduction.differCase | Method Exit');
    }

    /* Récupérer cases à partir des Ids*/
    private static List<Case> retriveCases(List<Id> caseIds){
        return [SELECT  Id, 
                        Status, 
                        HP_Client_Aide__c, 
                        HP_TreatmentDate__c, 
                        HP_Energy__c, 
                        HP_Sous_type__c, 
                        HP_Type__c, 
                        HP_Contrat__r.HP_Porte_Feuille_Contrat__r.Xdata_Id__c,
                        Contact.ID_Tiers__c,
                        HP_Xdata_Contrat__c,
                        HP_PDL_PCE__c,
                        ContactId
                        FROM Case Where Id IN :caseIds];
    }

    /* Récupérer les infos relatives au plans d'apurement*/
    public static Map<String,String> hasApurement(Case aCase){
        System.debug('HP_EM054_CoupureReduction.hasApurement | Method Start');
        HP_Contrat__c cont = aCase.HP_Contrat__r;
        System.debug('Contrat : '+cont + ' Case : '+aCase);
        Map<String,String> resultApurementMap = new Map<String,String>();
        try {
            HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_VOIR_PLANS_APUREMENT, APUREMENT_PARAM+cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c);
            if(response.getStatusCode() == 200){
                HP_WRP049_AgilabPlansApurement result = HP_WRP049_AgilabPlansApurement.parse(response.getBody());
                for(HP_WRP049_AgilabPlansApurement.PlansApurement plan : result.output.plans_apurement){
                    if(plan.type_plan_apurement == 5 && plan.statut == 3){
                        resultApurementMap.put('idApurement', String.valueOf(plan.id_plan_apurement));
                        resultApurementMap.put('dateCreation', plan.date_creation);
                        break;
                    }
                }
            }else{
                throw new CalloutException('Erreure Agilab');
            }
        } catch (Exception ex) {
                System.debug('HP_EM054_CoupureReduction.hasApurement | Exception : '+ex.getMessage());
            }
        System.debug('HP_EM054_CoupureReduction.hasApurement | Method Exit');
        return resultApurementMap;
    }

    /* Annuler le case et rajouter la descriptionb selon la cause */
    private static void cancelCase(Case aCase, String cause){
        System.debug('HP_EM054_CoupureReduction.cancelCase | Method Start');
        switch on cause {
            when 'apurement' {
                Map<String,String> apurementMap = hasApurement(aCase);
                aCase.Description = getCurrentDateFormatted() + ' - Annulé car plan d’apurement '+ apurementMap.get('idApurement') +' de type Recouvrement en cours depuis le ' + apurementMap.get('dateCreation');
            }
            when 'soldeInferieur' {
                aCase.Description = getCurrentDateFormatted() + ' - Annulé car dette du client inférieure à 100€ strictement';    
            }
        }
        aCase.Status = ANNULER_STATUT;
        System.debug('HP_EM054_CoupureReduction.cancelCase | Method Exit');
    }

    /* Récupérer la date du blocage si ça existe*/
    public static Date hasBlocage(Case aCase){
        System.debug('HP_EM054_CoupureReduction.hasBlocage | Method Start');
        Date dateBlocage = null;
        Contact con = aCase.Contact;
        HP_WRP013_AgilabClientInfo outputData ;
        try {
            Map<Integer, String> responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_AFFICHIER_INFORMATION_AIDE, AIDE_PARAM + con.ID_Tiers__c);
            if(responseMap.containsKey(200)){
                Map<String,Object> resultMap = (Map<String,Object>) JSON.deserializeUntyped(responseMap.get(200));
                outputData = HP_WRP013_AgilabClientInfo.parseMap(resultMap);
            }else {
                throw new System.CalloutException('Appel en erreur à AGILAB');
            }

            for(HP_WRP013_AgilabClientInfo.Logement logement : outputData.output.logements){
                if(logement.id_contrat_xdata == String.valueOf(aCase.HP_Xdata_Contrat__c)){
                    List<String> dateDebutBlocageList = logement.blocage_a_la_relance.date_debut_blocage.split('-');
                    List<String> dateFinBlocageList = logement.blocage_a_la_relance.date_fin_blocage.split('-');
                    Date dateDebutBlocage = Date.newInstance(Integer.valueOf(dateDebutBlocageList[0]), Integer.valueOf(dateDebutBlocageList[1]), Integer.valueOf(dateDebutBlocageList[2]));
                    Date dateFinBlocage = Date.newInstance(Integer.valueOf(dateFinBlocageList[0]), Integer.valueOf(dateFinBlocageList[1]), Integer.valueOf(dateFinBlocageList[2]));
                    if(dateDebutBlocage < Date.today() && dateFinBlocage> Date.today()){
                        dateBlocage = dateFinBlocage;
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('HP_EM054_CoupureReduction.hasBlocage | Exception : '+ex.getMessage());  
        }
        System.debug('HP_EM054_CoupureReduction.hasBlocage | Method Exit');
        return dateBlocage;
    }

    /* Vérifier si le solde effectif est inférieur strictement à 100€ */
    public static Boolean hasSoldeInferieur(Case aCase){
        System.debug('HP_EM054_CoupureReduction.hasSoldeInferieur | Method Start');
        Boolean resultSolde = false;
        Contact con = aCase.Contact;
        HP_Contrat__c cont = aCase.HP_Contrat__r;
        Map<Integer,String> responseMap = new Map<Integer,String>();
        HP_WRP027_AgilabSolde outputData = new HP_WRP027_AgilabSolde();
        try {
            responseMap = HP_UTIL_HTTPUtils.calloutGetToMap(HP_Constantes.AGILAB_SOLDE_EFFECTIF,AIDE_PARAM+con.ID_Tiers__c);
            outputData = (HP_WRP027_AgilabSolde)HP_ParseUtils.parse(responseMap.get(200),HP_WRP027_AgilabSolde.class);
            for(Map<String, Double> soldeMap :  outputData.output.soldes){
                if(soldeMap.containsKey(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c)){
                    if(soldeMap.get(cont.HP_Porte_Feuille_Contrat__r.Xdata_Id__c) > -100){
                        resultSolde = true;
                    }
                }
            }
        } catch (Exception ex) {
            System.debug('HP_EM054_CoupureReduction.hasSoldeInferieur | Exception : '+ex.getMessage() + 'Stack : '+ex.getStackTraceString()+' Line Number : '+ex.getLineNumber());   
        }
        System.debug('HP_EM054_CoupureReduction.hasSoldeInferieur | Method Exit');
        return resultSolde;
    }

    private static String getCurrentDateFormatted(){
        return String.valueOf(Date.today().day()) + '/' + String.valueOf(Date.today().month()) + '/' + String.valueOf(Date.today().year());
    }
}