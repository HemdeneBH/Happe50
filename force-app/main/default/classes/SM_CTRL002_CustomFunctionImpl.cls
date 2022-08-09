/************************************************************
*@author RJM
*@date 19/10/2020
*@description Custom Functions Vlocity
*@version 4
* Ver   Date         Author           Modification
* 1.0   10-19-2020   Raouaa JMOUR     Initial Version
* 4.0   22-03-2022   Patrick THAI     Added base64Decode
*************************************************************/


global class SM_CTRL002_CustomFunctionImpl implements vlocity_cmt.VlocityOpenInterface {
    
    static final Map<Integer, Integer> MULTIPLIERS = new Map<Integer, Integer> {
        1 => 10,
        2 => 100,
        3 => 1000,
        4 => 10000,
        5 => 100000,
        6 => 1000000
    };
    
    public SM_CTRL002_CustomFunctionImpl() {

    }

    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
       
        if (methodName == 'transformPrice')
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', transformPrice(arguments));
        }
        else if (methodName == 'stringBlob')
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', stringBlob(arguments));
        }



        else if(methodName == 'checkListInAnother'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', checkListInAnother(arguments));
        }


        else if (methodName.equalsIgnoreCase('base64Decode'))
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', base64Decode(arguments));
        }
       

       
        return true;
    }

    String transformPrice(List<Object> arguments)
    {
        String result = '';
        
       
        
        Decimal d= (Decimal) arguments[0];

        Integer places = Integer.valueOf(arguments[1]);
        
        // Round first
        Decimal dd = d.setScale(places);
        
        // Format to get thousand separators
        String w = dd.longValue().format();
            
        Integer multiplier = MULTIPLIERS.get(places);
        
        String f = String.valueOf(multiplier + Math.mod((dd * multiplier).longValue(), multiplier));
        
        result = w + ',' + f.substring(1);

        System.debug(result);
    
    
        return result;
    }
    


    Blob stringBlob(List<Object> arguments){
        System.debug('### aka Test ' + arguments);
        String json = JSON.serialize(arguments[0]);
        Blob stringBlob = Blob.valueOf(json);
        return stringBlob;
    }

    
    Boolean checkListInAnother(List<Object> arguments){
        List<String> listNumeroFactureL1String = new List<String>();
        
        Map<String, Object> mapNumeroFacture1 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(arguments[0]));
        Map<String, Object> mapNumeroFacture2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(arguments[1]));
        List<Object> listNumeroFactureL1 = (List<Object>) mapNumeroFacture1.get('VLOCITY-FORMULA-LIST');
        List<Object> listNumeroFactureL2 = (List<Object>) mapNumeroFacture2.get('VLOCITY-FORMULA-LIST');
        System.debug('### aka listNumeroFactureL1 ' + listNumeroFactureL1);
        System.debug('### aka listNumeroFactureL2 ' + listNumeroFactureL2);

        if(!listNumeroFactureL1.contains(null) && !listNumeroFactureL2.contains(null)){
            if(listNumeroFactureL1.size()>0 && listNumeroFactureL2.size()>0){

            for(Object numeroFactureL1 : listNumeroFactureL1){
                listNumeroFactureL1String.add(String.valueOf(numeroFactureL1));
            }
            for(Object numeroFactureL2 : listNumeroFactureL2){
                if(listNumeroFactureL1String.contains(String.valueOf(numeroFactureL2))){
                    return true;
                }
                
            }
        }

        }

        
        return false;
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // Reverse function to the IP/DR BASE64ENCODE() function
    //
    String base64Decode (List<Object> arguments){
        String inputString  = String.valueOf(arguments[0]);
        String outputString = EncodingUtil.base64Decode(inputString).toString();
        return outputString;
    }

}