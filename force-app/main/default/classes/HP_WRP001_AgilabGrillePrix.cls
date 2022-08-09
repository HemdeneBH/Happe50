/**
* @author Vincent Albiser
* @date Creation 26/11/2019
* @description Structure de réponse d'une grille tarifaire Agilab
*/
public with sharing class HP_WRP001_AgilabGrillePrix {

    //spécifique électrique
    @AuraEnabled
    public String elecTypeComptage;

    //spécifique gaz
    @AuraEnabled
    public String gazPlageConso;
    
    //commun
    @AuraEnabled
    public String status;
    @AuraEnabled
    public String message;
    @AuraEnabled
    public String codePromo;
    
    @AuraEnabled
    public String aboTtc;
    @AuraEnabled
    public String aboHt;

    @AuraEnabled
    public List<Consommation> consos;

    @AuraEnabled
    public String transactionId;
    
    public class Consommation {
        @AuraEnabled
        public String typeConso;
        @AuraEnabled
        public String consoTtc;
        @AuraEnabled
        public String consoHt;
	}
    
    public List<Periode> periodes;
    public class Periode {
        public String reduction;
        public String duree;
	}

    @AuraEnabled
    public String reductionEnCours;

    /**
    * @author Vincent Albiser
    * @date Creation 26/11/2019
    * @description Wrapper de la réponse Agilab
    * @param data, réponse Agilab
    * @return Strucure de réponse d'une grille tarifaire
    */
    public HP_WRP001_AgilabGrillePrix(String data){

        Map<String, Object> m = (Map<String, Object>) System.JSON.deserializeUntyped(data);

        this.status = (String) m.get('status');
        this.message = (String) m.get('message');

        Map<String, Object> output = (Map<String, Object>) m.get('output');

        String techComptage = null;
        for(String outputKey : output.keySet()){

            switch on outputKey {
                when 'code_promo' {
                    this.codePromo = (String) output.get('code_promo');
                }
                when 'Comptage simple', 'Comptage HPHC' { // elec
                    this.elecTypeComptage = outputKey;
                    techComptage = outputKey;
                }
                when '<1000kWh','1000kWh-6000kWh','6000kWh-30000kWh','>30000kWh' { // gaz
                    this.gazPlageConso = outputKey;
                    techComptage = outputKey;
                }
                when 'remise' {

                    List<Periode> pList = new List<Periode>();
                    
                    Map<String, Object> remise = (Map<String, Object>) output.get(outputKey);
                    for(String remiseKey : remise.keySet()){

                        Map<String, Object> periode = (Map<String, Object>) remise.get(remiseKey);

                        if(periode.containsKey('consommation')){
                            Periode p = new Periode();
                            Map<String, Object> pConso = (Map<String, Object>) periode.get('consommation'); 
                            Map<String, Object> pCriteres = (Map<String, Object>) pConso.get('criteres');
                            p.duree = (String) pConso.get('duree');
                            for(String critereKey : pCriteres.keySet()){ // 1 seul élément ici (car dépendant de la puissance du contrat)
                                p.reduction = (String) pCriteres.get(critereKey);
                            }
                            pList.Add(p);
                        }
                    }
                    this.periodes = pList;
                }
            }
        }

        if(techComptage != null){
            Map<String, Object> comptage = (Map<String, Object>) output.get(techComptage);
            Map<String, Object> cAbo = (Map<String, Object>) comptage.get('abonnement');
            for(String key : cAbo.keySet()){ // 1 seul élément ici (car dépendant de la puissance du contrat)
                Map<String, Object> montants = (Map<String, Object>) cAbo.get(key);
                this.aboTtc = (String) montants.get('ttc_arrondi');
                this.aboHt = (String) montants.get('htt');
            }
            Map<String, Object> cConso = (Map<String, Object>) comptage.get('consommation');
            for(String key : cConso.keySet()){ // 1 seul élément ici (car dépendant de la puissance du contrat)

                List<Consommation> consoList = new List<Consommation>();

                Map<String, Object> cTypeIndex = (Map<String, Object>) cConso.get(key);
                for(String indexKey : cTypeIndex.keySet()){ // 'HP' ou 'HC' ou vide

                    Consommation conso = new Consommation();

                    Map<String, Object> montants = (Map<String, Object>) cTypeIndex.get(indexKey);
                    conso.typeConso = (String) indexKey;
                    switch on conso.typeConso {
                        when 'heures pleines','Heures Pleines' {
                            conso.typeConso = 'HP';
                        }
                        when 'heures creuses','Heures Creuses' {
                            conso.typeConso = 'HC';
                        }
                    }
                    conso.consoTtc = (String) montants.get('ttc_arrondi');
                    conso.consoHt = (String) montants.get('htt');

                    consoList.add(conso);                
                }
                this.consos = consoList;
            }
        }

        //TODO exception
    }
}