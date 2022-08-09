/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 

 * @last modified on  : 04-19-2022

 * @last modified by  : Badr Eddine Belkarchi
 * Modifications Log 
 * Ver   Date         Author                  Modification
 * 1.0   06-09-2021   Hemdene Ben Hammouda   Initial Version
**/
public with sharing class HP_SM062_ConsommationManager {
    public static Map<String,String> paramsMap ;

    @AuraEnabled(cacheable=true)
    public static List<HP_WRP040_ConsommationManagerELEC> getConsommationELEC(Integer idClientXdata, String pdl){
        System.debug('HP_SM062_ConsommationManager.getConsommationELEC | Method Start');
        paramsMap = new Map<String,String>{
            'id_client_xdata' => String.valueOf(idClientXdata),
            'pdl' => pdl
            };
        List<HP_WRP040_ConsommationManagerELEC> resultList = new List<HP_WRP040_ConsommationManagerELEC>();
        Map<String, Object> responseMap = new Map<String, Object> ();
        if(String.isEmpty(pdl)){
                return resultList;
        }
        if(String.isEmpty(String.valueOf(idClientXdata))){
            throw new AuraHandledException(label.HP_ConsommationElecKo);
        }
        if(!String.isEmpty(pdl) && !String.isEmpty(String.valueOf(idClientXdata))){
            try {
                HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PERSONNE_CONSOMMATION, paramsMap);
                System.debug('@@Response : '+response);
                System.debug('@@Response Body : '+response.getBody());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                }else {
                    throw new AuraHandledException(label.HP_ConsommationElecKo);
                }
                if(responseMap.get('status')=='SUCCESS'){
                    resultList = deserializeELEC(response.getBody());
                }
            } catch (Exception e) {
                System.debug('HP_SM062_ConsommationManager.getConsommationELEC | Exception : '+e.getMessage());
                throw new AuraHandledException(label.HP_ConsommationElecKo);
            }
        }
        System.debug('HP_SM062_ConsommationManager.getConsommationELEC | Method Exit');
        return resultList;
    }

    @AuraEnabled(cacheable=true)
    public static List<HP_WRP041_ConsommationManagerGAZ> getConsommationGAZ(Integer idClientXdata, String pce){
        System.debug('HP_SM062_ConsommationManager.getConsommationGAZ | Method Start');
        paramsMap = new Map<String,String>{
            'id_client_xdata' => String.valueOf(idClientXdata),
            'pce' => pce
            };
        List<HP_WRP041_ConsommationManagerGAZ> resultList = new List<HP_WRP041_ConsommationManagerGAZ>();
        Map<String, Object> responseMap = new Map<String, Object> ();
        if(String.isEmpty(pce)){
            return resultList;
        }
        if(String.isEmpty(String.valueOf(idClientXdata))){
            throw new AuraHandledException(label.HP_ConsommationGazKo);
        }
        if(!String.isEmpty(pce) && !String.isEmpty(String.valueOf(idClientXdata))){
            try {
                HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PERSONNE_CONSOMMATION, paramsMap);
                System.debug('@@Response : '+response);
                System.debug('@@Response Body : '+response.getBody());
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
                    responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                }else {
                    throw new AuraHandledException(label.HP_ConsommationGazKo);
                }
                if(responseMap.get('status')=='SUCCESS'){
                    resultList = deserializeGAZ(response.getBody());
                }
            } catch (Exception e) {
                System.debug('HP_SM062_ConsommationManager.getConsommationGAZ | Exception : '+e.getMessage());
                throw new AuraHandledException(label.HP_ConsommationGazKo);
            }
        }
        System.debug('HP_SM062_ConsommationManager.getConsommationGAZ | Method Exit');
        return resultList;
    }

    public static list<HP_WRP040_ConsommationManagerELEC> deserializeELEC(String responseJSON){
        System.debug('HP_SM062_ConsommationManager.deserializeELEC | Method Start');
        list<HP_WRP040_ConsommationManagerELEC> listWrpELEC = new list<HP_WRP040_ConsommationManagerELEC>();
        try{
            Map<String, Object> recordMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);
            List<Object> listObj = (List<Object>) recordMap.get('output');
            for(Object obj : listObj){
                Map<String, Object> outputMap = (Map<String, Object>) obj;
                HP_WRP040_ConsommationManagerELEC wrpELEC = new HP_WRP040_ConsommationManagerELEC(outputMap);
                listWrpELEC.add(wrpELEC);
        }
        }catch(Exception ex){
            System.debug('HP_SM062_ConsommationManager.deserializeELEC | Exception : '+ex.getMessage());
        }
        System.debug('HP_SM062_ConsommationManager.deserializeELEC | Method Exit');
        return listWrpELEC;
    }

    public static list<HP_WRP041_ConsommationManagerGAZ> deserializeGAZ(String responseJSON){
        System.debug('HP_SM062_ConsommationManager.deserializeGAZ | Method Start');
        list<HP_WRP041_ConsommationManagerGAZ> listWrpGAZ = new list<HP_WRP041_ConsommationManagerGAZ>();
        try{
            Map<String, Object> recordMap = (Map<String, Object>) JSON.deserializeUntyped(responseJSON);
            List<Object> listObj = (List<Object>) recordMap.get('output');
            for(Object obj : listObj){
                Map<String, Object> outputMap = (Map<String, Object>) obj;
                HP_WRP041_ConsommationManagerGAZ wrpGAZ = new HP_WRP041_ConsommationManagerGAZ(outputMap);
                listWrpGAZ.add(wrpGAZ);
        }
        }catch(Exception ex){
            System.debug('HP_SM062_ConsommationManager.deserializeGAZ | Exception : '+ex.getMessage());
        }
        System.debug('HP_SM062_ConsommationManager.deserializeGAZ | Method Exit');
        return listWrpGAZ;
    }

    @AuraEnabled(cacheable=true)
    public static String getConsommationELEC_VersionEC(Integer idClientXdata, String pdl) {
        System.debug('HP_SM062_ConsommationManager.getConsommationELEC_VersionEC | Method Start');
        paramsMap = new Map<String,String>{
            'id_client_xdata' => String.valueOf(idClientXdata),
            'pdl' => pdl
            };

        HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PERSONNE_CONSOMMATION, paramsMap);
        System.debug('@@Response : '+response);
        System.debug('@@Response Body : '+response.getBody());

        System.debug('HP_SM062_ConsommationManager.getConsommationELEC_VersionEC | Method Exit');
        return response.getBody(); 
    }

    @AuraEnabled(cacheable=true)
    public static String getConsommationGAZ_VersionEC(Integer idClientXdata, String pce) {
        System.debug('HP_SM062_ConsommationManager.getConsommationGAZ_VersionEC | Method Start');
        paramsMap = new Map<String,String>{
            'id_client_xdata' => String.valueOf(idClientXdata),
            'pce' => pce
            };

        HttpResponse response = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.AGILAB_PERSONNE_CONSOMMATION, paramsMap);
        System.debug('@@Response : '+response);
        System.debug('@@Response Body : '+response.getBody());

        System.debug('HP_SM062_ConsommationManager.getConsommationGAZ_VersionEC | Method Exit');
        return response.getBody(); 
    }

public class HP_WRP040_ConsommationManagerELEC {
    @AuraEnabled
    public String idFacture {get;set;}
    @AuraEnabled
    public String typeReleve {get;set;}
    @AuraEnabled
    public String raison {get;set;}
    @AuraEnabled
    public String categorie {get;set;}
    @AuraEnabled
    public String typeComptage {get;set;}
    @AuraEnabled

    public Date dateReleve {get;set;}

    @AuraEnabled
    public String dateDebut {get;set;}
    @AuraEnabled
    public String dateFin {get;set;}
    @AuraEnabled
    public String indexDebut {get;set;}
    @AuraEnabled
    public String indexFin {get;set;}
    @AuraEnabled
    public String consommationCadran {get;set;}
    @AuraEnabled
    public String modeRedressement {get;set;}
    @AuraEnabled
    public String changementOffre {get;set;}
    @AuraEnabled
    public String motifRectification {get;set;}
    @AuraEnabled
    public String typeCompteur {get;set;}
    @AuraEnabled
    public String rangCadran {get;set;}

    public HP_WRP040_ConsommationManagerELEC(Map<String, Object> outputMap){
        this.idFacture = !String.isEmpty(String.valueOf(outputMap.get('id_facture'))) ? String.valueOf(outputMap.get('id_facture')) : '--';
        this.typeReleve = !String.isEmpty(String.valueOf(outputMap.get('id_releve'))) ? String.valueOf(outputMap.get('id_releve')) :'--';
        this.raison = !String.isEmpty(String.valueOf(outputMap.get('raison'))) ? String.valueOf(outputMap.get('raison')) : '--';
        this.categorie = !String.isEmpty(String.valueOf(outputMap.get('categorie'))) ? String.valueOf(outputMap.get('categorie')) : '--';
        this.typeComptage = !String.isEmpty(String.valueOf(outputMap.get('type_comptage'))) ? String.valueOf(outputMap.get('type_comptage')) : '--';

        this.dateReleve = !String.isEmpty(String.valueOf(outputMap.get('date_releve'))) ? Date.parse(String.valueOf(outputMap.get('date_releve'))) : null;

        this.dateDebut = !String.isEmpty(String.valueOf(outputMap.get('date_debut'))) ? convertDateFormat(String.valueOf(outputMap.get('date_debut'))) : '--';
        this.dateFin = !String.isEmpty(String.valueOf(outputMap.get('date_fin'))) ? convertDateFormat(String.valueOf(outputMap.get('date_fin'))) :'--';
        this.indexDebut = !String.isEmpty(String.valueOf(outputMap.get('index_debut'))) ? String.valueOf(outputMap.get('index_debut')) : '--';
        this.indexFin = !String.isEmpty(String.valueOf(outputMap.get('index_fin'))) ? String.valueOf(outputMap.get('index_fin')) : '--';
        this.consommationCadran = !String.isEmpty(String.valueOf(outputMap.get('conso_cadran'))) ? String.valueOf(outputMap.get('conso_cadran')) :'--';
        this.modeRedressement = !String.isEmpty(String.valueOf(outputMap.get('mode_redressement'))) ? String.valueOf(outputMap.get('mode_redressement')) : '--';
        this.changementOffre = !String.isEmpty(String.valueOf(outputMap.get('changement_offre'))) ? convertBooleanFormat(String.valueOf(outputMap.get('changement_offre'))) : '--';
        this.motifRectification = !String.isEmpty(String.valueOf(outputMap.get('motif_rectification'))) ? String.valueOf(outputMap.get('motif_rectification')) : '--';
        this.typeCompteur = !String.isEmpty(String.valueOf(outputMap.get('type_compteur'))) ? String.valueOf(outputMap.get('type_compteur')) : '--';
        this.rangCadran = getRangCadran(String.valueOf(outputMap.get('rang_cadran')),String.valueOf(outputMap.get('type_comptage')));
    }
    
    private String convertDateFormat(String input){
        if(input != null){
            return input.replace(input.right(4), input.right(2));
        }else {
            return null;
        }
    }

    private String convertBooleanFormat(String input){
        if(input != null){
            return input =='true' ? 'oui' : 'non';
        }else {
            return null;
        }
    }

    private String getRangCadran(String rangCadran,String typeComptage){
        String result='';
        if(String.isEmpty(rangCadran)){
            result= '--';
        }else if(typeComptage.toUppercase().contains('BASE') && rangCadran =='1'){
            result= 'Base';
        }else if(typeComptage.toUppercase().contains('HPHC') && rangCadran =='1'){
            result = 'HC';
        }else if(rangCadran =='2'){
            result = 'HP';
        }
        return result;
    }
}

public class HP_WRP041_ConsommationManagerGAZ {
    @AuraEnabled
    public String idFacture {get;set;}
    @AuraEnabled
    public String typeReleve {get;set;}
    @AuraEnabled
    public String raison {get;set;}
    @AuraEnabled
    public String categorie {get;set;}
    @AuraEnabled
    public String typeComptage {get;set;}
    @AuraEnabled
    public String dateReleve {get;set;}
    @AuraEnabled
    public String dateDebut {get;set;}
    @AuraEnabled
    public String dateFin {get;set;}
    @AuraEnabled
    public String volumeBrutGaz {get;set;}
    @AuraEnabled
    public String consommationCadran {get;set;}
    @AuraEnabled
    public String indexDebut {get;set;}
    @AuraEnabled
    public String indexFin {get;set;}
    @AuraEnabled
    public String kpcs {get;set;}
    @AuraEnabled
    public String originReleve {get;set;}
    @AuraEnabled
    public String typeCompteur {get;set;}

    public HP_WRP041_ConsommationManagerGAZ(Map<String, Object> outputMap){
        this.idFacture = outputMap.get('id_facture') != null ? String.valueOf(outputMap.get('id_facture')) : '--';
        this.typeReleve = outputMap.get('id_releve') != null ? String.valueOf(outputMap.get('id_releve')) :'--';
        this.raison = outputMap.get('raison')!= null ? String.valueOf(outputMap.get('raison')) : '--';
        this.categorie = outputMap.get('categorie') != null ? String.valueOf(outputMap.get('categorie')) : '--';
        this.typeComptage = outputMap.get('type_comptage') != null ? String.valueOf(outputMap.get('type_comptage')) : '--';
        this.dateReleve = outputMap.get('date_releve') != null ? convertDateFormat(String.valueOf(outputMap.get('date_releve'))) : '--';
        this.dateDebut = outputMap.get('date_debut') != null ? convertDateFormat(String.valueOf(outputMap.get('date_debut'))) : '--';
        this.dateFin = outputMap.get('date_fin') != null ? convertDateFormat(String.valueOf(outputMap.get('date_fin'))) :'--';
        this.volumeBrutGaz = outputMap.get('volume_brut_gaz') != null ? String.valueOf(outputMap.get('volume_brut_gaz')) : '--';
        this.consommationCadran = outputMap.get('conso_cadran') != null ? String.valueOf(outputMap.get('conso_cadran')) :'--';
        this.indexDebut = outputMap.get('index_debut') != null ? String.valueOf(outputMap.get('index_debut')) : '--';
        this.indexFin = outputMap.get('index_fin') != null ? String.valueOf(outputMap.get('index_fin')) : '--';
        this.kpcs = outputMap.get('kpcs') != null ? String.valueOf(outputMap.get('kpcs')) : '--';
        this.originReleve = outputMap.get('origine_releve') != null ? String.valueOf(outputMap.get('origine_releve')) : '--';
        this.typeCompteur = outputMap.get('type_compteur') != null ? String.valueOf(outputMap.get('type_compteur')) : '--';
    }
    
    private String convertDateFormat(String input){
        if(input != null){
            return input.replace(input.right(4), input.right(2));
        }else {
            return null;
        }
    }

    private String convertBooleanFormat(String input){
        if(input != null){
            return input =='true' ? 'oui' : 'non';
        }else {
            return null;
        }
    }
}
}