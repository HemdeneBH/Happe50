global with sharing class CustomPricingVariableCalcHookImpl implements vlocity_cmt.VlocityOpenInterface{

    global Boolean invokeMethod(String methodName, Map<String, Object> input, Map<String, Object> output, Map<String, Object> options)  
    {
        try
        {
            if (methodName.equalsIgnoreCase('calculate.PreInvoke'))
            {
                // dump the input
                //System.debug('--- calculate.PreInvoke input: ' + JSON.serialize(input));
            }
            else if (methodName.equalsIgnoreCase('calculate.PostInvoke'))
            {                
                // log the output
                System.debug('--- calculate.PostInvoke input: ' + JSON.serialize(input));
                System.debug('--- calculate.PostInvoke output: ' + JSON.serialize(output));
                Id itemId = (Id)input.get('itemId');
                Boolean isRoot = (Boolean)input.get('isRoot');
                Map<Id, Map<String, Object>> priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
                
                Map<String, Object> variableValuesMap = (Map<String, Object>)output.get('pricingVariableMap');

                Decimal OT_TAX1_CALC = (Decimal)variableValuesMap.get('OT_TAX1_CALC');

                if (OT_TAX1_CALC == null) OT_TAX1_CALC = 0.0;
                Decimal OT_STD_PRC_TOTAL = (Decimal)variableValuesMap.get('OT_STD_PRC_TOTAL');
                
                // First apply Tax1
                if ((OT_TAX1_CALC != null && OT_TAX1_CALC != 0.0) && OT_STD_PRC_TOTAL != null)
                {                        
                    OT_STD_PRC_TOTAL = OT_STD_PRC_TOTAL/OT_TAX1_CALC;
                    variableValuesMap.put('OT_STD_PRC_TOTAL', OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
                    // Only for root items, we copy the OT_STD_PRC_TOTAL to EFF_OT_STD_PRC_TOTAL
                    // since root EFF_OT_STD_PRC_TOTAL get rolled up to the header
                    if (isRoot)
                    {
                        variableValuesMap.put('EFF_OT_STD_PRC_TOTAL', OT_STD_PRC_TOTAL.setScale(2, RoundingMode.HALF_UP));
                    } 
                }
                // Apply Tax2
                Decimal OT_TAX2 = (Decimal)variableValuesMap.get('OT_TAX2');
                Decimal OT_TAX2_AMT = 0.0;
                if (OT_TAX2 != null && OT_STD_PRC_TOTAL != null)
                {
                    OT_TAX2_AMT = OT_STD_PRC_TOTAL * OT_TAX2;
                    Decimal OT_STD_TAX_ADD = OT_STD_PRC_TOTAL + OT_TAX2_AMT;                    
                    variableValuesMap.put('OT_STD_TAX_ADD', OT_STD_TAX_ADD.setScale(2, RoundingMode.HALF_UP));                                        
                }
                // add this line's ROLLUP_OT_TAX2_AMT (which is the rollup of its children OT_TAX2_AMT)
                // to this line's OT_TAX2_AMT
                Decimal ROLLUP_OT_TAX2_AMT = (Decimal)variableValuesMap.get('ROLLUP_OT_TAX2_AMT');
                if (ROLLUP_OT_TAX2_AMT == null) ROLLUP_OT_TAX2_AMT = 0.0;
                OT_TAX2_AMT += ROLLUP_OT_TAX2_AMT;  
                variableValuesMap.put('OT_TAX2_AMT', OT_TAX2_AMT.setScale(2, RoundingMode.HALF_UP)); 
                
                System.debug('updated variableValuesMap: '+ JSON.serialize(variableValuesMap));                
            }
            return true;
        }
        catch (Exception ex)
        {
            System.debug('--- Exception: ' + ex.getMessage());
            System.debug('--- Stack Trace: ' + ex.getStackTraceString());
            throw ex;
        }
    }
}