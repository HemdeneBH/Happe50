/****************************************************
* @Project: Smile
* @Created by: Hamza EL HARRAOUI
* @LastModified : Hamza EL HARRAOUI
* @CreatedDate: 10/01/2019
* @Description: Rest Service for CPV Notifications from Octopus to Update CPVs
****************************************************/


@RestResource(urlMapping='/updateListCPV')
    global class SM_AP_CPVupdate {

        private static String OUI = 'Oui';

        @HttpPost
        global static String updateTheCPVs(list<CPVinfo> CPVinfos) {
                try{
                    List<String> pcIDsRequest = getPCIDS(CPVinfos);
                    List<Order> listOrders = findOrdersByListPCID(pcIDsRequest);
                    List<Case> casesToUpdate = findCasesByOrderNumbers(listOrders);
                    updateCases(casesToUpdate,CPVinfos,listOrders);
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
        

        private static List<String> getPCIDS(list<CPVinfo> CPVinfos){
            List<String> listPCIDS = new List<String>();
            for(CPVinfo cpv : CPVinfos){
                listPCIDS.add(cpv.pcID);
            }
            return listPCIDS;
        }
        private static List<String> getOrderNumbers(list<Order> orders){
            List<String> orderNumbers = new List<String>();
            for(Order orderItem : orders){
                orderNumbers.add(orderItem.OrderNumber);
            }
            return orderNumbers;
        }
        private static List<Order>  findOrdersByListPCID(List<String> pcIDs){
            List<Order> orders = [SELECT Id,type__c,OrderNumber FROM ORDER WHERE Numero_PC__c IN :pcIDs];
            return orders;
        }

        private static List<Case>  findCasesByOrderNumbers(List<Order> orders){
            List<String> orderNumbers = getOrderNumbers(orders);
            List<Case> casesToUpdate = [SELECT id FROM Case WHERE Order_Number__c IN :orderNumbers];
            if(casesToUpdate.size()!= orders.size()){
                throw new CPVException('Unexcpected exception : No case found for a given pcID');
            }
            return casesToUpdate;
        }

        private static void updateCases(List<Case> listCases, List<CPVinfo> CPVinfo, List<Order> listOrders){
            for(Integer i=0; i< listCases.size();  i++){
                updateCaseData(listCases.get(i),CPVinfo.get(i), listOrders.get(i));
            }
            update listCases;
        }

        private static void updateCaseData(Case caseToUpdate, CPVinfo CPVinfo, Order order){
            if('Elec'.equals(order.type__c) || 'Gaz'.equals(order.type__c) || 'Duo'.equals(order.type__c)){
                caseToUpdate.CPV_E_Canal_d_envoi__c = CPVinfo.canal;
                caseToUpdate.CPV_E_Lien_CPV__c = CPVinfo.urlPdf;
                if(!String.isBlank(CPVinfo.dateSignature)){
                    caseToUpdate.CPV_E_Date_de_signature__c = Date.parse(CPVinfo.dateSignature);
                    caseToUpdate.CPV_E_Signee__c = OUI;
                }
                
                caseToUpdate.CPV_E_Envoyee__c = OUI;                
            }
            else{
                caseToUpdate.CPV_SA_Canal_d_envoi__c = CPVinfo.canal;
                caseToUpdate.CPV_SA_Lien_CPV__c = CPVinfo.urlPdf;
                if(!String.isBlank(CPVinfo.dateSignature)){
                    caseToUpdate.CPV_SA_Date_de_signature__c = Date.parse(CPVinfo.dateSignature);
                    caseToUpdate.CPV_SA_Signee__c = OUI;
                }
                caseToUpdate.CPV_SA_Envoyee__c = OUI;
            }

            if(!String.isBlank(CPVinfo.dateSignature)){
                caseToUpdate.Status = System.Label.SM_CL20_CaseStatusToBeProcessed;
                caseToUpdate.Sous_statut__c = System.Label.SM_CL21_CaseSubStatusCustomerFeedback;
            }
           

        }
        private class CPVException extends Exception {}
}