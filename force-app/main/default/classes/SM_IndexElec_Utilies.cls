/**
 * @Author: Maha Ghayouba
 * @CreatedDate: 13/02/2019
 * @ClassName: SM_IndexElec_Utilies
**/
global class SM_IndexElec_Utilies implements vlocity_cmt.VlocityOpenInterface {
    
    global Boolean invokeMethod (String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {
        if (methodName == 'transformInputsWS') {
            return transformInputsWS(input, output);
        }     
        return false;
    }
          
    /**
     * @Author: Maha Ghayouba
     * @CreatedDate: 13/02/2019
     * @Return: Boolean {OK / KO}
     * @Description: Build Json dynamically to be added in DataRaptor for Index_V1 ELEC WS input XML
    **/
    public Boolean transformInputsWS (Map<String,Object> input, Map<String,Object> output) {           
        List<Object> listCadran = new List<Object>();    
  
        for(Integer i=1; i<=input.size(); i++) {
            if( input.containsKey('cadran#code' + String.valueOf(i)) && String.isNotBlank(String.valueOf(input.get('cadran#code' + String.valueOf(i))))
            && (input.containsKey('index#valeur' + String.valueOf(i)) && input.get('index#valeur' + String.valueOf(i)) != NULL)) { 
                Map<String, Map<String,Object>> cadran = new Map<String, Map<String,Object>>();
                cadran.put('index', new Map<String,Object> {'valeur' => input.get('index#valeur' + String.valueOf(i)), 'passageAzero' => input.get('index#passageAzero' + String.valueOf(i))});
                cadran.put('cadran', new Map<String,Object> {'code' => input.get('cadran#code' + String.valueOf(i))});
  
                listCadran.add(cadran);
            }  
        }
        if(listCadran.size() > 0) {
            output.put('cadran', listCadran);
        }
        return true;          
    }

}