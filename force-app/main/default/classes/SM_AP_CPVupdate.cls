/****************************************************
* @Project: Smile
* @Created by: Hamza EL HARRAOUI
* @LastModified : Hayfa GARBOUT
* @CreatedDate: 22/02/2021
* @Description: Rest Service for CPV Notifications from Octopus to Update CPVs
****************************************************/


@RestResource(urlMapping='/updateListCPV')
global class SM_AP_CPVupdate {
    
    private static String yesValue = 'Oui';
    Map<Id, List<Order>> mapCaseOrdersCPV;
    Map<Order, CPVinfo> mapOrderCPVInfo;

    @HttpPost
    global static String updateTheCPVs(list<CPVinfo> CPVinfos) {
        try{
            Map<String, CPVinfo> mapPcIdPCV = getPCIDS(CPVinfos);
            if(mapPcIdPCV.keySet().size() > 0){
                List<Case> casesList = getListCases(mapPcIdPCV.keySet());
                updateCasesAndOrdersByPC(casesList,mapPcIdPCV);
            }
            return 'ok';
        }
        catch(CPVException ex){
            if(!Test.isRunningTest()){
                RestContext.response.statusCode = 500;
            }
            return ex.getMessage();
        }
    }

    global class CPVinfo {
        global String pcId;
        //(ID ORDER)
        global String bpId;
        //(Référence client)
        global String dateSignature;
        global String urlPdf;
        global String canal;
    }

    private static Map<String, CPVinfo> getPCIDS(list<CPVinfo> cpvInfos){
        
        Map<String, CPVinfo> mapPcIdPCV = new Map<String, CPVinfo>();

        for(CPVinfo cpv : cpvInfos){
            if(!String.isBlank(cpv.pcID)){
                mapPcIdPCV.put(cpv.pcID, cpv);
            }
        }
        return mapPcIdPCV;
    }

    private static List<Case> getListCases(Set<String> pcIds){
        return SM_DM003_Case.retrieveCasesByPcIds(pcIds);
    }

    private static void updateCasesAndOrdersByPC(List<Case> casesList, Map<String, CPVinfo> mapPcIdPCV){

        List<Case> casesToUpdate = new List<Case>();
        List<Order> ordersToUpdate = new List<Order>();

        for(Case caseToUpdate : casesList) {
            CPVinfo cpvInfo;
            List<Order> ordersCPV = caseToUpdate.Orders__r;
            //Le cas Parcours Options seules,les informations CPV sont portées par l'objet Order
            if (caseToUpdate.Subject == 'Options') {
                for (Order orderToUpdate : ordersCPV) {
                    cpvInfo = mapPcIdPCV.get(orderToUpdate.Numero_PC__c);
                    orderToUpdate.CPV_canal_envoi__c = cpvInfo.canal;
                    orderToUpdate.Lien_CPV__c = cpvInfo.urlPdf;
                    orderToUpdate.CPV_Envoyee__c = yesValue;
                    ordersToUpdate.add(orderToUpdate);
                }
            } else {// Le Cas aquisition, les informations CPV sont portées par le Case
                cpvInfo = mapPcIdPCV.get(caseToUpdate.Orders__r[0].Numero_PC__c);
                caseToUpdate.CPV_E_Canal_d_envoi__c = cpvInfo.canal;
                caseToUpdate.CPV_E_Lien_CPV__c = cpvInfo.urlPdf;
                caseToUpdate.CPV_E_Envoyee__c = yesValue;
            }
            if(!String.isBlank(cpvInfo.dateSignature)){
                caseToUpdate.CPV_E_Date_de_signature__c = Date.parse(cpvInfo.dateSignature);
                caseToUpdate.CPV_E_Signee__c = yesValue;
                // On a ajouté un update diffèrent pour les cases smile
                // Ajout d'un update different pour les cases Hramonica + Identification des cases smile selon RT et Origin
                // Case Smile
                if (caseToUpdate.RecordType.DeveloperName == 'Acquisition' ||
                (caseToUpdate.RecordType.DeveloperName == 'Service' && (caseToUpdate.Origin == 'Phone' ||caseToUpdate.Origin == 'Téléphone'))){
                        caseToUpdate.Status = System.Label.SM_CL21_Case_status_PreCloturee;
                        caseToUpdate.Sous_statut__c = System.Label.SM_CL21_CaseSubStatusConforme;
                    }
                // Case Harmonica
                else if (caseToUpdate.RecordType.DeveloperName == 'Acquisition_Harmonica' ||(caseToUpdate.RecordType.DeveloperName == 'Service' && caseToUpdate.Origin == 'Tunnel en ligne')){
                        caseToUpdate.Status = System.Label.SM_CL45_Case_status_ATraiter;
                        caseToUpdate.Sous_statut__c = System.Label.SM_CL45_CaseSubStatusSign;
                    }
                // Other Case
                else {
                    caseToUpdate.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
                    caseToUpdate.Sous_statut__c = System.Label.SM_CL21_CaseSubStatusCustomerFeedback;
                }
            }
            casesToUpdate.add(caseToUpdate);
        }

        Savepoint sp = Database.setSavepoint();
        try{
            update casesToUpdate;
            update ordersToUpdate;
        }
        catch(exception ex){
            Database.rollback(sp);
        }
    }
    
    private class CPVException extends Exception {}
}