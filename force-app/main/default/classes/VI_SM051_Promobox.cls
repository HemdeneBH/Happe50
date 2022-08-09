/*
*@Author: Paul Ghoussoub
*@Description: Appel vers l'API Promobox
*@CreatedDate: 18/04/22
*@LastModified: 25/04/22
*/
public class VI_SM051_Promobox {
    /* @author Paul Ghoussoub
	* @date 25/04/22
	* @description appel pour récupérer les code promos pour les offres proposées
	* @parameters parcours en cours - code pack de l'offre - code de l'offre elec - code de l'offre gaz - contexte - cache partition
	*/
    public static List<Promotion> recupererCodePromo(VI_Parcours__c parcours,String identifiantPack,String offreElec,String offreGaz,String contexte, String partitionName){
        List<Promotion> promotionsResultat=new List<Promotion>();
        String res;
        String lieuDeConsommation;
        String motifDeSouscription;
        String ContexteDeSouscription;
        String typeComptage;
        String CAR;
        String CAE;
        User parcoursOwner;
        if(!Test.isRunningTest()){
            parcoursOwner= [SELECT Id, AccountId,account.VI_Groupe_Fonctionnel__c FROM User WHERE Id =:parcours.OwnerId];
        }
        ComposantElec composantElec=new ComposantElec();
        ComposantGaz composantGaz=new ComposantGaz();
        ComposantElecOptionVerte composantElecOptionVerte;
        ComposantGazOptionVerte composantGazOptionVerte;
        if(parcours.VI_ChoixParcours__c=='CHF'){
            ContexteDeSouscription='CHGT_FOURN';
            if(parcours.VI_ChoixEnergie__c=='Electricité'){
                motifDeSouscription='Z003';
            }
            else if(parcours.VI_ChoixEnergie__c=='Gaz'){
                motifDeSouscription='Z004';
            }
            else if(parcours.VI_ChoixEnergie__c=='Electricité + Gaz'){
                motifDeSouscription='Z005';
            }
        }
        else if(parcours.VI_ChoixParcours__c=='EM'){
            ContexteDeSouscription='MES_EMM';
            motifDeSouscription='Z002';
        }
        
        if(parcours.VI_ChoixEstimation__c=='Estimer la consommation d\'énergie'){
            typeComptage=parcours.VI_SaisieEstimationConsoElec_HP_HC__c=='Oui'?'HPHC':'SIMPLE';
            if(parcours.VI_Estimation_conso_gaz__c!=null){
                CAR=String.valueOf(parcours.VI_Estimation_conso_gaz__c.intValue());
            }
            if(parcours.VI_Estimation_conso_elec_HC__c != null ){
                CAE= String.valueOf((parcours.VI_Estimation_conso_elec_HP__c + parcours.VI_Estimation_conso_elec_HC__c).intValue());
            }
            else if(parcours.VI_Estimation_conso_elec_HP__c != null){
                CAE= String.valueOf(parcours.VI_Estimation_conso_elec_HP__c.intValue());
            }
        }
        else if(parcours.VI_ChoixEstimation__c=='Saisir la consommation d\'énergie'){
            typeComptage=parcours.VI_SaisieConsommationElec_HP_HC__c?'HPHC':'SIMPLE';
            if(parcours.VI_ConsommationGazKwHSaisieConso__c!=null){
                CAR=String.valueOf(parcours.VI_ConsommationGazKwHSaisieConso__c.intValue());
            }
            if(parcours.VI_SaisieConsommationElec_HP_HC__c == true ){
                CAE = String.valueOf((parcours.VI_SaisieConsommationHeuresPleines__c + parcours.VI_SaisieConsommationHeuresCreuses__c).intValue());
            }
            else if(parcours.VI_SaisieConsommationHeuresPleines__c != null){ 
                CAE= String.valueOf(parcours.VI_SaisieConsommationHeuresPleines__c.intValue());
            }
        }
        
        if(parcours.VI_ChoixEnergie__c=='Electricité' || parcours.VI_ChoixEnergie__c=='Electricité + Gaz'){
            lieuDeConsommation=(parcours.VI_PDLRechercheLocal__c!=null&&!String.isBlank(parcours.VI_PDLRechercheLocal__c))?parcours.VI_PDLRechercheLocal__c:null;
            composantElec.ConsommationAnnuelleEstime=CAE;
            composantElec.SecteurdActivite=parcours.VI_Secteur_Activite_Elec__c;
            composantElec.CodeOffre=offreElec;
            composantElec.PuissanceSouscrite=parcours.VI_EstimationPuissance__c;
            composantElec.ContexteDeSouscription=ContexteDeSouscription;
            composantElec.TypeDeComptage=typeComptage;
        }
        if(parcours.VI_ChoixEnergie__c=='Gaz' || parcours.VI_ChoixEnergie__c=='Electricité + Gaz'){
            composantGaz.ConsommationAnnuelleEstime=CAR;
            composantGaz.SecteurdActivite=parcours.VI_Secteur_Activit_Gaz__c;
            composantGaz.CodeOffre=offreGaz;
            composantGaz.ContexteDeSouscription=ContexteDeSouscription;
            if(parcours.VI_GazPlageConso__c!=null){
                composantGaz.PlageDeConsommation=String.valueOf(parcours.VI_GazPlageConso__c.intValue());
            }
            if(parcours.VI_ChoixEnergie__c=='Gaz'){
                system.debug('parcours.VI_PCERechercheLocal__c '+parcours.VI_PCERechercheLocal__c);
                lieuDeConsommation=(parcours.VI_PCERechercheLocal__c!=null&&!String.isBlank(parcours.VI_PCERechercheLocal__c))?parcours.VI_PCERechercheLocal__c:null;
            }
            else if(parcours.VI_ChoixEnergie__c=='Electricité + Gaz'){
                lieuDeConsommation=(parcours.VI_PDLRechercheLocal__c!=null&&!String.isBlank(parcours.VI_PDLRechercheLocal__c))?parcours.VI_PDLRechercheLocal__c:null;
            }
        }
        
       /* if(parcours.VI_CodeOptionPanierClient__c!=null && !String.isBlank(parcours.VI_CodeOptionPanierClient__c)){
            composantElecOptionVerte = new ComposantElecOptionVerte();
            composantElecOptionVerte.SecteurdActivite=parcours.VI_Secteur_Activite_Elec__c;
            composantElecOptionVerte.CodeOffre=parcours.VI_CodeOptionPanierClient__c;
            composantElecOptionVerte.PuissanceSouscrite=parcours.VI_EstimationPuissance__c;
            composantElecOptionVerte.TypeDeComptage=typeComptage;
        }
        
        if(parcours.VI_CodeOptionGazPanierClient__c!=null && !String.isBlank(parcours.VI_CodeOptionGazPanierClient__c)){
            composantGazOptionVerte = new ComposantGazOptionVerte();
            composantGazOptionVerte.SecteurdActivite=parcours.VI_Secteur_Activite_Elec__c;
            composantGazOptionVerte.CodeOffre=parcours.VI_CodeOptionGazPanierClient__c;
            if(parcours.VI_GazPlageConso__c!=null){
                composantGazOptionVerte.PlageDeConsommation=String.valueOf(parcours.VI_GazPlageConso__c.intValue());
            }
        }*/

        Map<String, Object> parametresPromobox= createInput(parcours.VI_TypeParcours__c,identifiantPack,parcours.VI_IDReferenceClient__c,
                                                            parcours.VI_IDReferenceClient__c,lieuDeConsommation,null,motifDeSouscription,
                                                            ((parcoursOwner!=null&&parcoursOwner.account!=null)?parcoursOwner.account.VI_Groupe_Fonctionnel__c:null),
                                                            composantElec,composantGaz,composantElecOptionVerte,composantGazOptionVerte,parcours.VI_ChoixEnergie__c);
        
        String token;
        if (!Test.isRunningTest()){ 
            token = VI_SM013_GetTokenService.getToken(contexte, partitionName);
            system.debug('token '+token);
            if (token == null) {
                system.debug('Token not found ...');
            }
        }
        else {
            token = 'ABCDEFU';
        }
        
        String consumerKey = MP_Xdata_credentials__c.getInstance(Contexte+'_ConsumerKeySymphonie').Value__c;
        String consumerSecret = MP_Xdata_credentials__c.getInstance(Contexte+'_ConsumerSecretSymphonie').Value__c;
        
        Blob headerValue=Blob.valueOf(consumerKey+':'+consumerSecret);
        string authHeader='Basic '+EncodingUtil.base64Encode(headerValue);
          
        HttpResponse httpResponse =  VI_UTIL001_HttpUtilities.makeHttpCall(token,'POST', contexte+ '_Promobox', null, parametresPromobox,null,'application/xml',null,authHeader, contexte);
        system.debug(VI_UTIL001_HttpUtilities.handleResponse(httpResponse.getBody()));
        //List<codePromoWrapper> responseWrapper =(List<codePromoWrapper>) JSON.deserialize(httpResponse.getBody(),List<codePromoWrapper>.class);
        Object responseWrapper =JSON.deserializeUntyped(httpResponse.getBody());
        system.debug('¤ responseWrapper : '+responseWrapper);
        List< Object> responseWrapperList = ( List< Object>) responseWrapper;
        System.debug('The List is: ' + responseWrapperList);
        if(responseWrapperList!=null && responseWrapperList.size()>0){
            Map<String,Object> responseWrapperContent = ( Map<String,Object>) responseWrapperList[0];
            system.debug('responseWrapperContent.size() '+responseWrapperContent.size());
            system.debug('responseWrapperContent '+responseWrapperContent);
            if(responseWrapperContent!=null && responseWrapperContent.size()>0){
                for (String currentKey : responseWrapperContent.keySet()) {
                    Map<String,Object> currentObject = ( Map<String,Object>) responseWrapperContent.get(currentKey);
                    if(currentKey=='Message'){
                        system.debug('responseWrapperContent.get(currentKey) '+responseWrapperContent.get(currentKey));
                        Message returnMessage=new Message();
                        returnMessage.Status=(String)currentObject.get('Status');
                        returnMessage.StatusMessage=(String)currentObject.get('StatusMessage');
                    }
                    else if(currentKey.contains('Promotion')){
                        Promotion newPromotion=new Promotion();
                        newPromotion.NumPromotion=(String)currentObject.get('NumPromotion');
                        newPromotion.CodePromo=(String)currentObject.get('CodePromo');
                        newPromotion.LibelleSurFacture=(String)currentObject.get('LibelleSurFacture');
                        newPromotion.NomPromotion=(String)currentObject.get('NomPromotion');
                        newPromotion.DescriptifPromotion=(String)currentObject.get('DescriptifPromotion');
                        newPromotion.DebutValidity=(String)currentObject.get('DebutValidity');
                        newPromotion.FinValidity=(String)currentObject.get('FinValidity');
                        newPromotion.CanalDeVente=(String)currentObject.get('CanalDeVente');
                        promotionsResultat.add(newPromotion);
                    }
                }
            }
        }
        system.debug('promotionsResultat '+promotionsResultat);
        return promotionsResultat;
    }
    
    /* @author Paul Ghoussoub
	* @date 25/04/22
	* @description input à envoyer pour récuperer les codes promos correspondants
	*/
    public static Map<String, Object> createInput(String canalDeVente,String IdentifiantPack,String NumeroClient,
                                                  String CompteDeContrat,String LieuDeConsommation,String PartenaireDeVente,
                                                  String motifDeSouscription,String CodeEnseigne,
                                                  ComposantElec composantElec,ComposantGaz composantGaz,
                                                  ComposantElecOptionVerte composantElecOptionVerte,ComposantGazOptionVerte composantGazOptionVerte,
                                                  String energieParcours)
    {
        String todayDate;
        Map<String, Object> parametresPromobox= new Map<String, Object>();
        Map<String, Object> PropositionCommercialeMap= new Map<String, Object>();    
        Map<String, Object> ComposantElecMap= new Map<String, Object>();  
        Map<String, Object> ComposantGazMap= new Map<String, Object>();  
        Map<String, Object> ComposantElecOptionVerteMap= new Map<String, Object>();  
        Map<String, Object> ComposantGazOptionVerteMap= new Map<String, Object>();  

       /* if(ComposantGazOptionVerte!=null){
            ComposantGazOptionVerteMap.put('PourcentageVert','10');
            if(ComposantGazOptionVerte.PlageDeConsommation!=null)ComposantGazOptionVerteMap.put('PlageDeConsommation', ComposantGazOptionVerte.PlageDeConsommation);//'6000'
            if(ComposantGazOptionVerte.CodeOffre!=null)ComposantGazOptionVerteMap.put('CodeOffre', ComposantGazOptionVerte.CodeOffre);//'CHGT_FOURN'
            ComposantGazOptionVerteMap.put('SecteurdActivite','5G');
             if(ComposantGazOptionVerteMap.get('CodeOffre')!=null){
                PropositionCommercialeMap.put('ComposantOptionGaz+', ComposantGazOptionVerteMap);
            }
        }
        
        if(composantElecOptionVerte!=null){
            if(composantElecOptionVerte.TypeDeComptage!=null)ComposantElecOptionVerteMap.put('TypeDeComptage', composantElecOptionVerte.TypeDeComptage);
            if(composantElecOptionVerte.PuissanceSouscrite!=null)ComposantElecOptionVerteMap.put('PuissanceSouscrite', composantElecOptionVerte.PuissanceSouscrite);//'GBUGR2'
            if(composantElecOptionVerte.CodeOffre!=null)ComposantElecOptionVerteMap.put('CodeOffre', composantElecOptionVerte.CodeOffre);//'GBUGR2'
            ComposantElecOptionVerteMap.put('SecteurdActivite','5E');
            if(ComposantElecOptionVerteMap.get('CodeOffre')!=null){
                PropositionCommercialeMap.put('ComposantOptionVert+', ComposantElecOptionVerteMap);
            }
        }*/
        
        if(energieParcours=='Gaz' || energieParcours=='Electricité + Gaz'){
            if(composantGaz.ConsommationAnnuelleEstime!=null)ComposantGazMap.put('ConsommationAnnuelleEstime', composantGaz.ConsommationAnnuelleEstime);//'6000'
            if(composantGaz.PlageDeConsommation!=null)ComposantGazMap.put('PlageDeConsommation', composantGaz.PlageDeConsommation);//'6000'
            if(composantGaz.ContexteDeSouscription!=null)ComposantGazMap.put('ContexteDeSouscription', composantGaz.ContexteDeSouscription);//'CHGT_FOURN'
            if(composantGaz.CodeOffre!=null)ComposantGazMap.put('CodeOffre', composantGaz.CodeOffre);//'GBUGR2'
            ComposantGazMap.put('SecteurdActivite','5G');
            PropositionCommercialeMap.put('ComposantGaz', ComposantGazMap);
        }
        if(energieParcours=='Electricité' || energieParcours=='Electricité + Gaz'){
            if(composantElec.ConsommationAnnuelleEstime!=null)ComposantElecMap.put('ConsommationAnnuelleEstime', composantElec.ConsommationAnnuelleEstime);//'6000'
            if(composantElec.TypeDeComptage!=null)ComposantElecMap.put('TypeDeComptage', composantElec.TypeDeComptage);
            if(composantElec.ContexteDeSouscription!=null)ComposantElecMap.put('ContexteDeSouscription', composantElec.ContexteDeSouscription);//'CHGT_FOURN'
            if(composantElec.PuissanceSouscrite!=null)ComposantElecMap.put('PuissanceSouscrite', composantElec.PuissanceSouscrite);//'GBUGR2'
            if(composantElec.CodeOffre!=null)ComposantElecMap.put('CodeOffre', composantElec.CodeOffre);//'GBUGR2'
            ComposantElecMap.put('SecteurdActivite','5E');
            PropositionCommercialeMap.put('ComposantElec', ComposantElecMap);
        }
        
        if(motifDeSouscription!=null) PropositionCommercialeMap.put('MotifDeSouscription',motifDeSouscription);
        if(PartenaireDeVente!=null) PropositionCommercialeMap.put('PartenaireDeVente',PartenaireDeVente);
        if(LieuDeConsommation!=null) PropositionCommercialeMap.put('LieuDeConsommation',LieuDeConsommation);
        if(CompteDeContrat!=null) PropositionCommercialeMap.put('CompteDeContrat','000'+CompteDeContrat);  
        if(NumeroClient!=null) PropositionCommercialeMap.put('NumeroClient','0'+NumeroClient);
        if(IdentifiantPack!=null) PropositionCommercialeMap.put('IdentifiantPack',IdentifiantPack);//'GBUGR2_P'
        if(CodeEnseigne!=null)PropositionCommercialeMap.put('CodeEnseigne',CodeEnseigne);//'EMDM'
        parametresPromobox.put('PropositionCommerciale', PropositionCommercialeMap);
        todayDate=String.valueOf(Date.today().year());
        todayDate+=Date.today().month()<10?'0'+String.valueOf(Date.today().month()):String.valueOf(Date.today().month());DateTime.now().minute();
        todayDate+=Date.today().Day()<10?'0'+String.valueOf(Date.today().Day()):String.valueOf(Date.today().Day());
        parametresPromobox.put('DateDeVente',todayDate);//'20220408'
        
        if(canalDeVente!=null){
            if(canalDeVente=='PURE PLAYERS') parametresPromobox.put('CanalDeVente', 'PP');//'CRC' to test
            else if(canalDeVente=='VENTE DIRECTE')parametresPromobox.put('CanalDeVente', 'PAP');
            else if(canalDeVente=='STORE')parametresPromobox.put('CanalDeVente', 'CO');
            else if(canalDeVente=='DISTRIBUTION')parametresPromobox.put('CanalDeVente', 'DIS');
        }
        return parametresPromobox;
    }
    
    public class ComposantElec {
        public String SecteurdActivite;
        public String CodeOffre;
        public String PuissanceSouscrite;
        public String ContexteDeSouscription;
        public String TypeDeComptage;
        public String ConsommationAnnuelleEstime;
    }
    
    public class ComposantGaz {
        public String SecteurdActivite;
        public String CodeOffre;
        public String ContexteDeSouscription;
        public String PlageDeConsommation;
        public String ConsommationAnnuelleEstime;
    }
    
    public class ComposantElecOptionVerte {
        public String SecteurdActivite;
        public String CodeOffre;
        public String PuissanceSouscrite;
        public String TypeDeComptage;
    }
    
    public class ComposantGazOptionVerte {
        public String SecteurdActivite;
        public String CodeOffre;
        public String PlageDeConsommation;
    }
    
    
    
    public class codePromoWrapper {
        @AuraEnabled
        public Message Message;
        @AuraEnabled
        public Promotion Promotion;
        
    }
    
    public class Message {
        @AuraEnabled
        public String Status;
        @AuraEnabled
        public String StatusMessage;
    }
    
    
    public class Promotion {
        @AuraEnabled
        public String NumPromotion;
        @AuraEnabled
        public String CodePromo;
        @AuraEnabled
        public String LibelleSurFacture;
        @AuraEnabled
        public String NomPromotion;
        @AuraEnabled
        public String DescriptifPromotion;
        @AuraEnabled
        public String DebutValidity;
        @AuraEnabled
        public String FinValidity;
        @AuraEnabled
        public String CanalDeVente;
    }
}