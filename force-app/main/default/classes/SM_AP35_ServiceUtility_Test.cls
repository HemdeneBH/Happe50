@isTest
    public class SM_AP35_ServiceUtility_Test {
        @isTest
        public static void countActiveServices() {
                        

			Map<String , object>inputMap = new Map<String, object>() ;
			Map<String , object>outputMap = new Map<String, object>() ;
            
            Map<String , object>mapActiveServiceList = new Map<String, object>();
            Map<String , object>mapInactiveServiceList = new Map<String, object>();
            List<Object> listVlocityFormula = new List<Object>();
            mapActiveServiceList.put('VLOCITY-FORMULA-LIST',listVlocityFormula);
            mapInactiveServiceList.put('VLOCITY-FORMULA-LIST',listVlocityFormula);
            
            inputMap.put('ActiveServiceList',mapActiveServiceList);
            inputMap.put('InactiveServiceList',mapInactiveServiceList);
       
            SM_AP35_ServiceUtility service = new SM_AP35_ServiceUtility ();
          
			service.invokeMethod('countServices', inputMap,  outputMap, null) ;
		//	
		List<SM_AP35_ServiceUtility.ServiceModel> activeList = new List<SM_AP35_ServiceUtility.ServiceModel>();
		SM_AP35_ServiceUtility.ServiceModel serv1 = new SM_AP35_ServiceUtility.ServiceModel('27/04/2016','27/04/2017','DEGEX','Actif');
        SM_AP35_ServiceUtility.ServiceModel serv2 = new SM_AP35_ServiceUtility.ServiceModel('28/04/2016','28/04/2017','DEGEX','Actif');
        activeList.add(serv1);
        activeList.add(serv2);
        service.sortActiveService(activeList);
            
       List<SM_AP35_ServiceUtility.ServiceModel> inactiveList = new List<SM_AP35_ServiceUtility.ServiceModel>();
        inactiveList.add(serv1);
        inactiveList.add(serv2);
        service.sortInactiveService(inactiveList);

    }
    }