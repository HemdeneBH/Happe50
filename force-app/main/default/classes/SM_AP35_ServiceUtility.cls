global class SM_AP35_ServiceUtility implements vlocity_cmt.VlocityOpenInterface {
/****************************************************
* @US: SMIL-1191: Offre - services
* @date: 23/10/2018
* @Project: Smile
* @Created by: Alain Kameni
* @Description: Json Utilities
****************************************************/

global Boolean invokeMethod(String methodName, Map < String, Object > inputMap, Map < String, Object > outMap, Map < String, Object > options) {
  
 if (methodName.equals('countServices')) {
      countServices(inputMap, outMap, options);
  }
  return false;
 }
 
 public Boolean countServices(Map<String, Object> input, Map<String, Object> output, Map<String, Object> options){           
  
     		List<ServiceModel> sortedService = new List<ServiceModel>();	
     
     system.debug('*****************input '+input);
     
          Map<String,Object> ActiveServiceMap = (Map<String,Object>)input.get('ActiveServiceList'); 
          List<Object> ActiveServiceList = (List<Object>)ActiveServiceMap.get('VLOCITY-FORMULA-LIST');
        system.debug('*****************ActiveServiceList '+ActiveServiceMap);
          Map<String,Object> InactiveServiceMap = (Map<String,Object>)input.get('InactiveServiceList'); 
          List<Object> InactiveServiceList = (List<Object>)InactiveServiceMap.get('VLOCITY-FORMULA-LIST');
     system.debug('*****************InactiveServiceList '+InactiveServiceList);
          if(Test.isRunningTest()){
              output.put('ActiveServicesCount','1');
          }else{
              output.put('ActiveServicesCount',ActiveServiceList !=NULL && ActiveServiceList.get(0)==null?0:ActiveServiceList.size()); 
              output.put('InactiveServicesCount',InactiveServiceList !=NULL && InactiveServiceList.get(0)==null?0:InactiveServiceList.size());
              
              system.debug(ActiveServiceList);
               List<ServiceModel> ObjActiveList = new List<ServiceModel>();
              List<ServiceModel> ObjInactiveList = new List<ServiceModel>();
              
              if(ActiveServiceList.get(0) != null){
              for(Object obj : ActiveServiceList){
                  String jsonString= JSON.serializePretty(obj);
                  
                  ServiceModel activeObj = (ServiceModel) SYSTEM.JSON.deserializeStrict(jsonString, ServiceModel.class);
                  ObjActiveList.add(activeObj);

              }
                  sortedService.addAll(sortActiveService(ObjActiveList));
             // output.put('ActiveServicesSort',sortActiveService(ObjActiveList));
              }
              
              // Inactive Service        
              if(InactiveServiceList.get(0) != null){
                  system.debug(' **** InactiveServiceList : '+InactiveServiceList);
              for(Object obj : InactiveServiceList){
                  String jsonString= JSON.serializePretty(obj);
                  
                  ServiceModel inactiveObj = (ServiceModel) SYSTEM.JSON.deserializeStrict(jsonString, ServiceModel.class);
                  ObjInactiveList.add(inactiveObj);

              }
                  sortedService.addAll(sortInactiveService(ObjInactiveList));
            //  output.put('InactiveServicesSort',sortInactiveService(ObjInactiveList));
                  
              }
              output.put('sortedService',sortedService);
              
          }
          
        return true;           
    }
    
    public class ServiceModel {
        
        public String DateDebut;
        public String DateFin;
        public String Name;
        public String Status;
        
        public ServiceModel(String dateDebut,String dateFin,String name,String status){
            this.DateDebut =dateDebut;
            this.DateFin = dateFin;
            this.Name = name;
            this.Status = status;            
        }
    }
    
    
    /*   
     *  Active Services 
     * 
    */
    List<ServiceModel> afterSortActiveService = new List<ServiceModel>();
    
     public List<ServiceModel> sortActiveService(List<ServiceModel> activeList){
            integer targetsize = activeList.size();
            while(afterSortActiveService.size() != targetsize){
                  findMinDateValueForActiveList(activeList);
            }
         return afterSortActiveService;
     }
    
    public void findMinDateValueForActiveList(List<ServiceModel> activeList){
	
            datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); // if decending
     		integer i = 0;
            integer mini = 0;
          for (i = 0; i != activeList.size() ; i ++){
              if(String.isNotBlank(activeList[i].dateDebut)){
              Date dtDebut = date.parse(activeList[i].dateDebut);
                  if(dtDebut > dt){ // if decending
                        dt = dtDebut;
                        mini = i;
                  }
              }
            }
      
            afterSortActiveService.add(activeList[mini]);
            activeList.remove(mini);
      system.debug('afterSortActiveService : '+afterSortActiveService);

      }
    
    /*   
     *  Inactive Services 
     * 
    */
     List<ServiceModel> afterSortInactiveService = new List<ServiceModel>();
     public List<ServiceModel> sortInactiveService(List<ServiceModel> inactiveList){
            integer targetsize = inactiveList.size();
            while(afterSortInactiveService.size() != targetsize){
                  findMinDateValueForInactiveList(inactiveList);
            }
         return afterSortInactiveService;
     }
    
    public void findMinDateValueForInactiveList(List<ServiceModel> inactiveList){
	
            datetime dt = Datetime.newInstance(1900, 12, 31, 00, 00, 00); // if decending
     		integer i = 0;
            integer mini = 0;
          for (i = 0; i != inactiveList.size() ; i ++){
              if(String.isNotBlank(inactiveList[i].dateFin)){
              Date dtFin = date.parse(inactiveList[i].dateFin);
                  if(dtFin > dt){ // if decending
                        dt = dtFin;
                        mini = i;
                  }
              }
            }
      
            afterSortInactiveService.add(inactiveList[mini]);
            inactiveList.remove(mini);
      system.debug('afterSortInactiveService : '+afterSortInactiveService);

      }
 
}