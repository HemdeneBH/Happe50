/**
    ** This class is used to implement  custom function used in vlocity component
    ** @author FT3
    ** @date 07/03/22
    **/
global class SM_AP96_ArrayToJsonIP implements vlocity_cmt.VlocityOpenInterface {
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options){
    if(methodName == 'splitdataToJson'){
    String arguments = (String)inputs.get('arguments');
    
    output.put('result', splitdataToJson(arguments));
    }
    return true ;
    }
    
    /** @Method : splitdataToJson
    ** @params : arguments
    ** @return : Map<String , List<Map<String, String>>>
    ** @Description : Build the JsonFormat ({"Equipements":[{"Equip":"congelateur"},{"Equip":"piscine"}]})
    **/
    public   Map<String , List<Map<String, String>>> splitdataToJson(String arguments){
        List<Map<String, String>> splitedData = new List<Map<String, String>>();
        List <String> dataTosplit= arguments.split(';');
        Map<String , List<Map<String, String>>> finalData= new Map<String , List<Map<String, String>>>();
        for(String data : dataTosplit ){
            if(data != null){
            Map<String , String> dataMap= new Map<String, String>();
            dataMap.put('Equip' , data);
            splitedData.add(dataMap);
                }
        }
        finalData.put('Equipements', splitedData);
        System.debug('splitedData' +splitedData );
        System.debug('finalData' +finalData );
        return finalData;
    }

}