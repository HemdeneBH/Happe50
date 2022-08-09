/**
 * @description       : 
 * @author            : Ali AJELLAL
 * @group             : 



 * @last modified on  : 06-07-2021



 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-28-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/

public with sharing class HP_SM60_SouscriptionClientHappe {

    public static String SAVE_2 ='SAVE_2';
    public static String SAVE_2_CONFIRMED = 'SAVE_2_CONFIRMED';

    @InvocableMethod
	public static void updateHappeClient(final List<Id> souscriptionIds){  
                      
                System.debug('********souscriptionIds*****' +souscriptionIds);
                // recuperer la souscription avec les infos               
                List<HP_Souscription__c>  souscriptionList = [select Id, HP_Statut__c,HP_Contact__c, HP_Contact__r.Id_Tiers__c from HP_Souscription__c where id in :souscriptionIds];
                System.debug('********souscriptionList.size()*****' +souscriptionList.size());
                if(souscriptionList.size() == 0) return;

                String sousString = json.serialize(souscriptionList);
                String idXdataPersonne = String.valueOf(souscriptionList[0].HP_Contact__r.Id_Tiers__c);
                System.debug('********idXdataPersonne.()*****' +idXdataPersonne);

                // vérifier si la personne a des souscriptions au statut SAVE_2 et SAVE_2_CONFIRMED
                List<HP_Souscription__c> souscriptionListToCheck = [select Id, HP_Statut__c  from HP_Souscription__c where (
                    (HP_Statut__c =: SAVE_2 or  HP_Statut__c =: SAVE_2_CONFIRMED)  and id NOT IN:  souscriptionIds and HP_Contact__c =: souscriptionList[0].HP_Contact__c) ];
                // D'uatres souscription en cours
                System.debug('********souscriptionListToCheck.size()*****' +souscriptionListToCheck.size() );
                if(souscriptionListToCheck.size() > 0) return;

              if(System.IsBatch() == false )  callXdata(sousString, idXdataPersonne);              

    }
    
    @future(callout=true)
    public static void callXdata(String jsonString ,String idXdataPersonne) {
        List<HP_Souscription__c> souscriptionList = (List<HP_Souscription__c>)Json.deserialize(jsonString,List<HP_Souscription__c>.class);
      
        String resultContrat = HP_UTIL_HTTPUtils.calloutGet(HP_Constantes.XDATA_CONTRATS, '?idPersonne='+idXdataPersonne).getBody();
        System.debug('********resultContrat*****' +resultContrat);
        // A ce stad, le client n'a pas de souscription au statut save2/save2 confirmed 
        Integer idTiers = Integer.valueof(idXdataPersonne);
        List<contact> contact = [ select Id, salutation, lastName, firstName, Id_Tiers__c, No_Voie__c,MailingStreet,




        MailingCity,MailingPostalCode, HP_isHappe__c from contact where ID_Tiers__c = :idTiers];
        System.debug('********contact*****' +contact);
        List<contact> contactToUpdate = new List<contact>();







        if(resultContrat == null) return;
        Map<String,Object> resultAsMap = (Map<String,Object>) JSON.deserializeUntyped(resultContrat);
        List<Object> listresponse = (List<Object>) resultAsMap.get('_data');
        System.debug('********listresponse*****' +listresponse);

        // filtrer les conrats HAPPE et leurs status xdata via le codeOffre
        HP_UTIL_CustomSetting.loadCustomSettingOffre();	
        Map<String, HP_Offre__c>  offres =HP_UTIL_CustomSetting.codeOffreByXdataId;  
        Boolean containsHappeContrat = false;



        Set<String> listOffreHappe = new Set<String>();
        Map<String, String> codeOffreCodeStatut = new Map<String,String>(); 
        Map<String,List<String>> codeOffreCodeStatutMap = new Map<String,List<String>>();





        for (Object item : listresponse) {
            Map<String,Object> data = (Map<String,Object>)item;
            String codeOffre = String.valueOf(data.get('codeOffre'));
            String codeStatutCrm = String.valueOf(data.get('codeStatutCrm'));
            if(codeOffre != null && offres.containsKey(codeOffre)){
                // stock les code offre happe
                listOffreHappe.add(codeOffre);
                codeOffreCodeStatut.put(codeOffre,codeStatutCrm);



                if(codeOffreCodeStatutMap.containsKey(codeOffre)){
                    List<String> crmStatuts = codeOffreCodeStatutMap.get(codeOffre);
                    crmStatuts.add(codeStatutCrm);
                    codeOffreCodeStatutMap.put(codeOffre, crmStatuts);
                }else {
                    codeOffreCodeStatutMap.put(codeOffre, new List<String> { codeStatutCrm });
                   
                }
            }
        }
        // get the crmStatu

        System.debug('********codeOffreCodeStatut*****' +codeOffreCodeStatut);
        System.debug('********codeOffreCodeStatutMap*****' +codeOffreCodeStatutMap);




        System.debug('********listOffreHappe*****' +listOffreHappe);
        // checker le statut des contrats happe
        Boolean hasActifHappeContrat = false;
        for (String codeOffre : listOffreHappe) {



            if(codeOffreCodeStatutMap.containsKey(codeOffre)){
                for (String codeCrm : codeOffreCodeStatutMap.get(codeOffre)) {
                    System.debug('********is active code codeCrm*****' +codeCrm);
                    System.debug('********is active code*****' +isContratXdataActif(codeCrm));
                    if(isContratXdataActif(codeCrm))  hasActifHappeContrat = true;
                }
               
            }
           



        }
    
        Boolean hasNoContratHappe = listresponse.size()>0 && listOffreHappe.size() == 0 ;
        Boolean hasActifHappeContrats = listresponse.size()>0 && hasActifHappeContrat;
        // le client n'a pas de contrat || pas contrat chez happe || pas de contrat actif chez happe



        System.debug('********contact != null &&  contact.size() > 0 *****' + (contact != null &&  contact.size() > 0) );
        System.debug('********listresponse.size() == 0 ||  hasNoContratHappe *****' + (listresponse.size() == 0 ||  hasNoContratHappe) );
        System.debug('********hasActifHappeContrats *****' + hasActifHappeContrats );




        if(contact != null &&  contact.size() > 0 && (listresponse.size() == 0 ||  hasNoContratHappe || !hasActifHappeContrats)){
             // MAJ personnes ds XDATA
             Map<String, Object> clientToPersist = new Map<String, Object>();

             clientToPersist.put('civilite',contact[0].Salutation);
             clientToPersist.put('nom',contact[0].LastName);
             clientToPersist.put('prenom',contact[0].FirstName);
             clientToPersist.put('numVoie',contact[0].No_Voie__c);
             clientToPersist.put('voie',contact[0].MailingStreet);
             clientToPersist.put('codePostal',contact[0].MailingPostalCode);
             clientToPersist.put('ville',contact[0].MailingCity);
             clientToPersist.put('estClientHappe',false);
             clientToPersist.put('prospect',false);
             clientToPersist.put('Client',false);
             System.debug('***clientToPersist*******' + clientToPersist);
             Integer updateInt = HP_CALL001_XDATA.updatePersonne(idXdataPersonne, JSON.serialize(clientToPersist));
             System.debug('********updateInt*****' +updateInt);




             if(updateInt == 204){
                 // update slforce object
                 for (contact cnt :  contact) {
                    cnt.HP_isHappe__c = false;
                    contactToUpdate.add(cnt);
                 }

             }
            }

            if(contactToUpdate.size() >0) Database.update(contactToUpdate);

    }
    
    public static Boolean isContratXdataActif(String code){
       return code == 'E0004' || code == 'H0105' || code == 'H0101' || code == 'E0007' || code == ' H0102' ;





    }

}