/**
 * @File Name          : HP_SM007_PrestationDistributeurManager.cls
 * @Description        : class permet de gerer les prestations distributeur
 * @Author             : Slimene Belhaj Ali
 * @Group              : 
 * @Created On         : 10/01/2020
**/
public with sharing class HP_SM007_PrestationDistributeurManager {

    /**
    * @description charger la prestation en fonction de priorité définie
    * @author Slimene Belhaj Ali | 10/01/2020
    * @param String numeroCompteur Xdata numero compteur
    * @return Prestation_distributeur__c 
    **/
    @AuraEnabled(cacheable=true)
    public static Prestation_distributeur__c loadPrestationDistrubuteurToCardService(String numeroCompteur) {
        return HP_EM007_PrestationDistributeurManager.loadPrestationDistrubuteurToCardService(numeroCompteur);
    }
}