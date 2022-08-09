global with sharing class CustomPricingPlanStepImpl implements vlocity_cmt.VlocityOpenInterface {
    private Boolean useDisplayText = false;
    private Boolean useAttributeCode = true;
    private String JSON_ATTR_FLD = 'vlocity_cmt__JSONAttribute__c';
    private String CALC_PROC_NAME = 'CALC_PROC_NAME';
    private String MATRIX_NAME = 'MATRIX_NAME';
    private String PROD_NAMES = 'PROD_NAMES';
    private String PROC_OUTPUT_MAP = 'PROC_OUTPUT_MAP';
    private String PRICE_DETAIL_MSG = 'PRICE_DETAIL_MSG';
    private static Boolean isDebugging = false; // Set to false to improve performance since debug serialization is costly.
    private static String cachePartition; // Name of the cache partition to store the matrix mapping
    public SObject parent;
    Cache.OrgPartition orgPart;

    static
    {
        String setting = getCpqConfigurationSetupValue('ENGIE_CustomPricingPlanStepImplLogging');
        if (setting.equalsIgnoreCase('True'))
        {
            isDebugging = true;
        }
        setting = getCpqConfigurationSetupValue('AttrMatrixInfoCachePartition');
        //System.debug('## SETTING cache Name'+ setting);
        if (String.isNotBlank(setting))
        {
            cachePartition = 'local.' + setting;
        }
        //System.debug('## cachePartition '+ cachePartition);
    }
    
    map<string, list<CalcMatrixdataWrapper>> cmrExtIDtoWrapperMap = new map<string, list<CalcMatrixdataWrapper>>();

    global Boolean invokeMethod (String methodName,
                                 Map<String, Object> input,
                                 Map<String, Object> output,
                                 Map<String, Object> options)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'invokeMethod(x4)');
        /* do not add code inside this block */


        //system.debug('methodName_start-->'+methodName);
        //system.debug('input_start-->'+input);
        //system.debug('output_start-->'+output);
        //system.debug('options_start-->'+options);
        
        try
        {        
            //System.debug('CustomPricingPlanStepImpl methodName: ' + methodName);
            if (methodName == 'GetMatrixPrice')
            {
                //------------PERFORMANCE FIX-----------------
                // Get the list of products referenced by the matrix
                Set<String> productNames = getProductNamesFromCustomSetting('ENGIE_MyPowerPricingMatrix_PRODS');
                if (productNames == null)
                {
                    // if no custom setting specified, define the default list of products
                    productNames = new Set<String>{'Panneau', 'Optimiseur', 'Onduleur', 
                    'Coffret AC', 'Coffret DC', 'Coffret Mesure', 'Cablage et Smart meter', 'Batterie de stockage', 
                    'Accroches, rails et autres accessoires', 'Prix facturé par panneau installé'};
                }
                //------------PERFORMANCE FIX-----------------
                
                // TODO: Make this configurable. Read from custom object or custom setting mapping
                Map<String, Object> matrixOptions = new Map<String, Object>();
                String calcProcName = 'MyPowerPricingProcedure';
                matrixOptions.put(CALC_PROC_NAME, calcProcName); // The calculation procedure to invoke
                matrixOptions.put(MATRIX_NAME, 'MyPowerPricingMatrix'); // The calculation procedure to invoke
                matrixOptions.put(PROD_NAMES, productNames); // Products we want to look up in the matrix
                matrixOptions.put(PRICE_DETAIL_MSG, 'Priced from MyPowerPricingProcedure'); // Message to show in the price details popup
                Map<String, String> calProcOutToItemFieldMap = new Map<String, String>{
                'RecurringCharge'=>'vlocity_cmt__RecurringCharge__c',
                'OneTimeCharge'=>'vlocity_cmt__OneTimeCharge__c'
                };
                matrixOptions.put(PROC_OUTPUT_MAP, calProcOutToItemFieldMap); // Mapping of the procedure output to line item field
                
                // Get the parent and line items
                @TestVisible SObject parent = (SObject)vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
                @TestVisible List<SObject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
                
                //------------PERFORMANCE FIX-----------------
                mapProductNames(itemList);
                                
                List<Object> procOut = getMatrixPrice(parent, getFilteredList(itemList, productNames), matrixOptions);
                
                if (procOut != null)
                {
                    invokeExternalPriceService(parent, itemList, calcProcName, procOut, matrixOptions);
                }            
                return true;
            }
            else if (methodName == 'CalculateTax1')
            {
                //------------PERFORMANCE FIX-----------------
                // Get the list of products referenced by the matrix
                Set<String> productNames = getProductNamesFromCustomSetting('ENGIE_TauxDeMargeMatrix_PRODS');
                if (productNames == null)
                {
                    // if no custom setting specified, define the default list of products
                    productNames = new Set<String>{'Matériel'};
                }
                //------------PERFORMANCE FIX-----------------
                // TODO: Make this configurable. Read from custom object or custom setting mapping
                Map<String, Object> matrixOptions = new Map<String, Object>();
                String calcProcName = 'TauxDeMargeProcedure';
                matrixOptions.put(CALC_PROC_NAME, calcProcName); // The calculation procedure to invoke
                matrixOptions.put(MATRIX_NAME, 'TauxDeMargeMatrix'); // The calculation procedure to invoke
                matrixOptions.put(PROD_NAMES, productNames); // Products we want to look up in the matrix
                matrixOptions.put(PRICE_DETAIL_MSG, 'Priced from TauxDeMargeProcedure'); // Message to show in the price details popup
                Map<String, String> calProcOutToItemFieldMap = new Map<String, String>{
                'RecurringCharge'=>'vlocity_cmt__RecurringCharge__c',
                'OneTimeCharge'=>'vlocity_cmt__OneTimeCharge__c'
                };
                matrixOptions.put(PROC_OUTPUT_MAP, calProcOutToItemFieldMap); // Mapping of the procedure output to line item field
                
                // Get the parent and line items
                SObject parent = (SObject)vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
                List<SObject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
                //system.debug('++++parent==>'+parent);
                //system.debug('++++itemList==>'+itemList);
                //system.debug('++++matrixOptions==>'+matrixOptions);
                List<Object> procOut = getMatrixPrice(parent, getFilteredList(itemList, productNames), matrixOptions);
                //system.debug('++++procOut==>'+procOut);
                
                if (procOut != null)
                {
                    Map<Id, Map<String, Object>> priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
                    if (!priceVarMap.isEmpty())
                    {
                        //System.debug('++++priceVarMap: '+ JSON.serialize(priceVarMap));
                        for (Object obj : procOut)
                        {
                            if (obj instanceOf Map<String, Object>)
                            {
                                Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                                Id itemId = (Id)matrixResultRow.get('ID');
                                Map<String, Object> valuesMap = priceVarMap.get(itemId);
                                Map<String, Object> variableValuesMap = (Map<String, Object>)valuesMap.get('PricingVariableValues');
                                Decimal OT_TAX1 = (Decimal)matrixResultRow.get('Tax1');
                                if (OT_TAX1 != null && variableValuesMap != null)
                                {
                                    Decimal OT_TAX1_CALC = 1 - OT_TAX1;
                                    variableValuesMap.put('OT_TAX1', OT_TAX1);
                                    variableValuesMap.put('OT_TAX1_CALC', OT_TAX1_CALC);                                     
                                }
                            }
                        }
                        if (isDebugging)
                        {
                            System.debug('priceVarMap: '+ JSON.serialize(priceVarMap));
                        }                    
                    }
                }  
                return true;      
            }
            else if (methodName == 'CalculateTax2AttribBased')
            {
                CalculateTax2AttribBased();
                return true;
            }
            else if (methodName == 'CalculateTax2')
            {
                CalculateTax2();
                return true;
            }
            else if (methodName == 'RollupTax2')
            {
                RollupTax2();
                return true;
            }
            return false;
        }
        catch(Exception ex)
        {
            System.debug(LoggingLevel.ERROR, ex);
            System.debug(LoggingLevel.ERROR, ex.getStackTraceString());
            throw ex;
        }                
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'invokeMethod(x4)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}            
    
    private static String getCpqConfigurationSetupValue(String setupName) 
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getCpqConfigurationSetupValue(x1)');
        /* do not add code inside this block */


        vlocity_cmt__CpqConfigurationSetup__c cpqSetup = vlocity_cmt__CpqConfigurationSetup__c.getInstance(setupName);
        String retval = null;
        if (cpqSetup != null
            //expected condition: there is a Custom Setting
            && cpqSetup.vlocity_cmt__SetupValue__c != null
            && cpqSetup.vlocity_cmt__SetupValue__c.length() > 0) 
        {
            retval = cpqSetup.vlocity_cmt__SetupValue__c;
        }
        return retval;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getCpqConfigurationSetupValue(x1)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}
    //------------PERFORMANCE FIX-----------------
    // Returns a set of product names given a CPQ Configuration Setup custom setting property
    private Set<String> getProductNamesFromCustomSetting(String name)
    {
        String setting = getCpqConfigurationSetupValue(name);
        if (String.isNotBlank(setting))
        {
            Set<String> prodNames = new Set<String>();
            for (String str : setting.split(';'))
            {
                prodNames.add(str.trim());
            }
            return prodNames;
        }
        return null;
    }
    
    //------------PERFORMANCE FIX-----------------
    // Returns a map of product name to the list of line items that reference the product
    // The map is saved to the Pricing Plan context map to be retrieved in a subsequent plan step.
    private Map<String, List<SObject>> mapProductNames(List<SObject> itemList)
    {        
        Map<String, List<SObject>> productNameToItemsMap = new Map<String, List<SObject>>();
        if (itemList == null) return productNameToItemsMap;
        for (SObject item : itemList)
        {
            // Each row in the input is itself a map
            String productName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');
            if (String.isNotBlank(productName))
            {
                List<SObject> objList = productNameToItemsMap.get(productName);
                if (objList == null)
                {
                    objList = new List<SObject>();
                    productNameToItemsMap.put(productName, objList);
                }
                objList.add(item);
            }
        }
        vlocity_cmt.PricingPlanService.putInPricingContext('ENGIE_PROD_NAME_TO_ITEMS', productNameToItemsMap);
        return productNameToItemsMap;
    }
    
    private void RollupTax2()
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'RollupTax2(x0)');
        /* do not add code inside this block */


        SObject parent = (SObject)vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
        String parentObjectName = (String)vlocity_cmt.PricingPlanService.getFromPricingContext('ParentObjectName');
        String itemObjectName = (String)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemObjectName');        
        Decimal totalTaxes = 0.0; // This variable is used to collect all the rolled up taxes of the roots.
        String query = 'SELECT Id, vlocity_cmt__ParentItemId__c, OneTimeTax2Amount__c FROM ' + itemObjectName +
                ' WHERE ' + parentObjectName + 'Id =\'' + parent.Id + '\' AND vlocity_cmt__ParentItemId__c = NULL' +
                ' ORDER BY vlocity_cmt__LineNumber__c';
        for (SObject rootItem : Database.query(query))
        {
            Decimal OT_TAX2_AMT = (Decimal)rootItem.get('OneTimeTax2Amount__c');
            if (OT_TAX2_AMT == null) OT_TAX2_AMT = 0.0;
            totalTaxes += OT_TAX2_AMT; 
        }        

        // Save the collected totalTaxes to the TOTAL_OT_TAX2_AMT of the parent/header object
        Map<String, Object> parentVarMap = vlocity_cmt.PricingPlanService.getParentPricingVariableValues();
        if (parentVarMap == null)
        {
            parentVarMap = new Map<String, Object>();
            vlocity_cmt.PricingPlanService.putInPricingContext('ParentPricingVariableValues', parentVarMap);
        }

        parentVarMap.put('TOTAL_OT_TAX2_AMT', totalTaxes.setScale(2, RoundingMode.HALF_UP));
        //System.debug('totalTaxes: ' + totalTaxes);
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'RollupTax2(x0)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}
    
    private void CalculateTax2()
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'CalculateTax2(x0)');
        /* do not add code inside this block */


        // Test matrix
        Map<String, Decimal> taxMatrix = new Map<String, Decimal>{'MyPower_040'=>0.20, 'MyPower_002'=>0.20};
        Map<Id, Map<String, Object>> priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
        
        List<SObject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
        //system.debug('itemList===>'+itemList);
        for (SObject item : itemList)
        {
            String productCode = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('ProductCode');
            //system.debug('productCode====>'+productCode);
            if (taxMatrix.keySet().contains(productCode))
            {
                Decimal OT_TAX2 = taxMatrix.get(productCode);
                Map<String, Object> valuesMap = priceVarMap.get(item.Id);
                if (valuesMap != null)
                {
                    Map<String, Object> variableValuesMap = (Map<String, Object>)valuesMap.get('PricingVariableValues');
                    if (OT_TAX2 != null && variableValuesMap != null)
                    {
                        variableValuesMap.put('OT_TAX2', OT_TAX2);
                    }              
                }
            }
        }

    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'CalculateTax2(x0)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}
    
    private void CalculateTax2AttribBased()
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'CalculateTax2AttribBased(x0)');
        /* do not add code inside this block */

        //------------PERFORMANCE FIX-----------------
        // Get the list of products referenced by the matrix
        Set<String> productNames = getProductNamesFromCustomSetting('ENGIE_TVAMatrix_PRODS');
        if (productNames == null)
        {
            // if no custom setting specified, define the default list of products
            productNames = new Set<String>{'Matériel', 'Installation'};
        }
        //------------PERFORMANCE FIX-----------------

        // TODO: Make this configurable. Read from custom object or custom setting mapping
        Map<String, Object> matrixOptions = new Map<String, Object>();
        String calcProcName = 'TVAProcedure';
        matrixOptions.put(CALC_PROC_NAME, calcProcName); // The calculation procedure to invoke
        matrixOptions.put(MATRIX_NAME, 'TVAMatrix'); // The calculation procedure to invoke
        matrixOptions.put(PROD_NAMES, productNames); // Products we want to look up in the matrix
        matrixOptions.put(PRICE_DETAIL_MSG, 'Priced from TVAProcedure'); // Message to show in the price details popup
        Map<String, String> calProcOutToItemFieldMap = new Map<String, String>{
        'RecurringCharge'=>'vlocity_cmt__RecurringCharge__c',
        'OneTimeCharge'=>'vlocity_cmt__OneTimeCharge__c'
        };
        matrixOptions.put(PROC_OUTPUT_MAP, calProcOutToItemFieldMap); // Mapping of the procedure output to line item field
        
        // Get the parent and line items
        SObject parent = (SObject)vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
        List<SObject> itemList = (List<SObject>)vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');

        List<Object> procOut = getMatrixPrice(parent, getFilteredList(itemList, productNames), matrixOptions);
        //System.debug('###### procOut: '+ JSON.serialize(procOut));
        if (procOut != null)
        {
            Map<Id, Map<String, Object>> priceVarMap = vlocity_cmt.PricingPlanService.getLineItemPricingVariableValues();
            if (priceVarMap != null)
            {
                for (Object obj : procOut)
                {
                    if (obj instanceOf Map<String, Object>)
                    {
                        Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                        Id itemId = (Id)matrixResultRow.get('ID');
                        Map<String, Object> valuesMap = priceVarMap.get(itemId);
                        Map<String, Object> variableValuesMap = (Map<String, Object>)valuesMap.get('PricingVariableValues');
                        Decimal OT_TAX2 = (Decimal)matrixResultRow.get('Tax2');
                        if (OT_TAX2 != null && variableValuesMap != null)
                        {
                            variableValuesMap.put('OT_TAX2', OT_TAX2);
                        }
                    }
                }
                if (isDebugging)
                {
                    System.debug('priceVarMap: '+ JSON.serialize(priceVarMap));
                }                    
            }
        }  
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'CalculateTax2AttribBased(x0)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}        
    // Returns a filtered list of items filtered by a set of product names
    private List<SObject> getFilteredList(List<SObject> itemList, Set<String> productNames)
    {        
        if (itemList == null || itemList.isEmpty() || productNames == null || productNames.isEmpty()) return itemList;
        List<SObject> filteredList = new List<SObject>();
        Map<String, List<SObject>> productNameToItemsMap = (Map<String, List<SObject>>)vlocity_cmt.PricingPlanService.getFromPricingContext('ENGIE_PROD_NAME_TO_ITEMS');
        // The map should have been created from the GetMatrix call. Just in case it wasn't, create it here.
        if (productNameToItemsMap == null)
        {
            productNameToItemsMap = mapProductNames(itemList);
        }
        if (productNameToItemsMap != null)
        {
            for (String prodName : productNames)
            {
                List<SObject> objList = productNameToItemsMap.get(prodName);
                if (objList != null)
                {
                    filteredList.addAll(objList);
                }
            }
        }
        return filteredList;
    }
    
    private List<Object> getMatrixPrice (SObject parent, List<SObject> itemList, Map<String, Object> matrixOptions)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getMatrixPrice(x3)');
        /* do not add code inside this block */


        List<Object> procOut;

        if (itemList == null || itemList.isEmpty()) return procOut;

        String calcProcName = (String)matrixOptions.get(CALC_PROC_NAME);

        //Make sure to get all attributes and values for comparision for a given matrix        
        List<sObject> procStepObj = [select vlocity_cmt__CalculationMatrixId__r.Name 
                                        from vlocity_cmt__CalculationProcedureStep__c  where vlocity_cmt__CalculationProcedureVersionId__r.vlocity_cmt__CalculationProcedureId__r.Name=:calcProcName limit 1];
        
        if (procStepObj.isEmpty())
        {
            System.debug('No matrix found in calculation procedure ' + calcProcName);
            return null;
        }

        //String matrixName = (String)matrixOptions.get(MATRIX_NAME);

        String matrixName = (String)procStepObj[0].getSobject('vlocity_cmt__CalculationMatrixId__r').get('Name');
        Id matrixId = (Id)procStepObj[0].get('vlocity_cmt__CalculationMatrixId__c');
        String cacheKey = 'AttrMatrixMap' + String.valueOf(matrixId);

        System.debug(LoggingLevel.ERROR, ' ---- matrixName ' + matrixName);
        System.debug(LoggingLevel.ERROR, ' ---- cacheKey ' + cacheKey);

        //System.debug('## cachePartition '+ cachePartition);

        if (String.isNotBlank(cachePartition))
        {
            orgPart = Cache.Org.getPartition(cachePartition);
            //System.debug('## orgPart '+ orgPart);
            if (orgPart == null)
            {
                System.debug(LoggingLevel.ERROR, cachePartition + ' not found.');
            } else {
                if(orgPart.contains(cacheKey))
                {
                    cmrExtIDtoWrapperMap =  (map<string, list<CalcMatrixdataWrapper>>) orgPart.get(cacheKey);
                    if (cmrExtIDtoWrapperMap != null)
                    {
                        System.debug('cmrExtIDtoWrapperMap retrieved from cache');
                        if (isDebugging)
                        {
                            System.debug('retrieved cmrExtIDtoWrapperMap: ' + cmrExtIDtoWrapperMap);
                        }
                    } else {
                        cmrExtIDtoWrapperMap = new map<string, list<CalcMatrixdataWrapper>>();
                    }       
                } 
            }
        }
        //System.debug('## cmrExtIDtoWrapperMap '+ cmrExtIDtoWrapperMap);

        if (cmrExtIDtoWrapperMap.isEmpty())
        {
            System.debug('loading matrix information for ' + matrixName);
            long startTime = System.currentTimeMillis();

            getCalcMatrixdata(matrixName);

            long elapsedTime = System.currentTimeMillis() - startTime;

            System.debug('getCalcMatrixdata took: ' + elapsedTime + ' ms.');

            if (orgPart != null)
            {
                System.debug('cached cmrExtIDtoWrapperMap using key: ' + cacheKey);
                if (isDebugging)
                {
                    System.debug('cached cmrExtIDtoWrapperMap: ' + cmrExtIDtoWrapperMap);
                }
                System.debug('cached cmrExtIDtoWrapperMap: ' + cmrExtIDtoWrapperMap);
                orgPart.put(cacheKey, cmrExtIDtoWrapperMap);
            }
        }
        //System.debug('## orgPart '+ orgPart);

        // Create matrix input here
        Set<String> productNames = (Set<String>)matrixOptions.get(PROD_NAMES);
        List<Object> matrixInput = createMatrixInput(parent, itemList, productNames);
        if (isDebugging)
        {
            System.debug('Calculation Procedure matrixInput: ' + JSON.serialize(matrixInput));            
        }
        long startTime = System.currentTimeMillis();
        if (matrixInput != null && !matrixInput.isEmpty())
        {
            procOut = invokeCalculationProcedure(calcProcName, matrixInput);
        }        
        if (isDebugging)
        {
            long elapsedTime = System.currentTimeMillis() - startTime;
            System.debug('invokeCalculationProcedure took: ' + elapsedTime + ' ms.');
            if (procOut != null)
            {
                System.debug('Calculation Procedure output: ' + JSON.serialize(procOut));
            }            
        }
        return procOut;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getMatrixPrice(x3)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    @TestVisible
    private void invokeExternalPriceService(SObject parent, List<SObject> itemList, String calcProcName, List<Object> procOut, Map<String, Object> matrixOptions)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'invokeExternalPriceService(x5)');
        /* do not add code inside this block */


        //system.debug('sobject--->'+parent);
        //system.debug('itemList--->'+itemList);
        //system.debug('calcProcName--->'+calcProcName);
        //system.debug('procOut--->'+procOut);
        //system.debug('matrixOptions--->'+matrixOptions);
        
        if (procOut != null)
        {
            Map<String, Object> itemFields = new Map<String, Object>();
            String message = (String)matrixOptions.get(PRICE_DETAIL_MSG);
            Map<String, String> fieldMap = (Map<String, String>)matrixOptions.get(PROC_OUTPUT_MAP);

            for (Object obj : procOut)
            {
                if (obj instanceOf Map<String, Object>)
                {
                    Map<String, Object> matrixResultRow = (Map<String, Object>)obj;
                    Map<String, Object> itemFieldDetails = new Map<String, Object>();
                    for (String fld : fieldMap.keySet())
                    {
                        String itemField = fieldMap.get(fld);
                        Map<String, Object> fieldVals = new Map<String, Object>();
                        fieldVals.put('value', matrixResultRow.get(fld));
                        fieldVals.put('detail', message);
                        itemFieldDetails.put(itemField, fieldVals);
                    }
                    itemFields.put(String.valueOf(matrixResultRow.get('ID')), itemFieldDetails);
                }
            }
            if (isDebugging)
            {
                System.debug('itemFields: ' + JSON.serialize(itemFields));
            }

            if (!itemFields.isEmpty())
            {
                Type t = Type.forName('vlocity_cmt.SetCartItemExternalPriceService');
                System.debug(t);
                if (t != null)
                {
                    vlocity_cmt.VlocityOpenInterface externalPriceService =
                        (vlocity_cmt.VlocityOpenInterface)t.newInstance();
                    Map<String, Object> externalPriceServiceInput = new Map<String, Object>();
                    Map<String, Object> externalPriceServiceOutput = new Map<String, Object>();
                    Map<String, Object> externalPriceServiceOptions = new Map<String, Object>();

                    if (!itemFields.isEmpty())
                    {
                        externalPriceServiceInput.put('parent', parent);
                        externalPriceServiceInput.put('itemList', itemList);
                        externalPriceServiceInput.put('itemFieldsInfo', itemFields);
                        // skip update to prevent this service from flushing to the database since the pricing plan service
                        // will update the itemList anyway, this saves one DML update
                        externalPriceServiceOptions.put('SkipUpdate', true);
                        externalPriceService.invokeMethod('setItemPrices', externalPriceServiceInput,
                            externalPriceServiceOutput, externalPriceServiceOptions);
                    }
                }
            }
        }
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'invokeExternalPriceService(x5)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    private List<Object> createMatrixInput (SObject parent, List<SObject> itemList, Set<String> productNames)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'createMatrixInput(x3)');
        /* do not add code inside this block */


        //system.debug('parent - mp'+parent);
        //system.debug('itemList - mp'+itemList);
        //system.debug('productNames - mp'+productNames);
        
        if (isDebugging)
        {
            System.debug('itemList: ' + JSON.serialize(itemList));
        }

        List<Object> matrixData = new List<Object>();
        //system.debug('item list--->'+itemList);
        for (SObject item : itemList)
        {
            // Each row in the input is itself a map
            String productName = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('Name');
            String productCode = (String)item.getSObject('PricebookEntry').getSObject('Product2').get('ProductCode');

            //if (productNames != null && !productNames.contains(productName))
            //{
                //continue;
            //}
            Map<String, Object> rowData = new Map<String, Object>();
            Map<String, Object> dummy = new Map<String, Object>();
            rowData.put('Reference Product Name', productName);
            rowData.put('Reference External Id', productCode);
            rowData.put('Quantity', item.get('Quantity'));
            rowData.put('ID', item.Id); // each row must have a unique key
            rowData.put('ItemID', item.Id);
            String jsonAttr = (String)item.get(JSON_ATTR_FLD);

            getAttributes(jsonAttr, rowData, dummy);
            if (isDebugging)
            {
                System.debug('rowData: ' + JSON.serialize(rowData));
            }

            matrixData.add(rowData);
        }

        return matrixData;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'createMatrixInput(x3)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    private List<Object> invokeCalculationProcedure (String procedureName, List<Object> inputData)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'invokeCalculationProcedure(x2)');
        /* do not add code inside this block */


        //system.debug('procedureName--icp'+procedureName);
        //system.debug('inputData--icp'+inputData);
        // Construct the matrix calculation service
        Type t = Type.forName('vlocity_cmt.PricingMatrixCalculationService');

        vlocity_cmt.VlocityOpenInterface matrixService = (vlocity_cmt.VlocityOpenInterface)t.newInstance();

        Map<String, Object> inputMap = new Map<String, Object>{
        'inputData' => inputData
        };
        Map<String, Object> outputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>{
        'configurationName' => procedureName, // String procedureName = 'TestCalculationProcedure'
        'inputKey' => 'inputData', // tells the service what is the key for the data in the inputMap,
        'mode' => null,
        'verbose' => true,
        'matchInputVariables' => true,
        'effectiveDate' => String.valueOf(System.Now()),
        'configurationVersionId' => null // Set the matrix version id. Null version id picks the latest version with highest priority
        };

        // invoke the calculation procedure
        matrixService.invokeMethod('calculate', inputMap, outputMap, optionsMap);

        //Parse the calculation procedure response
        List<Object> outList = (List<Object>)outputMap.get('output');
        List<Object> objectList;
        if (outList != null && !outList.isEmpty())
        {
            vlocity_cmt.PricingCalculationService.CalculationProcedureResults calcProcResults =
                (vlocity_cmt.PricingCalculationService.CalculationProcedureResults)outList[0];
            objectList = calcProcResults.calculationResults;
        }

        // return the objectList
        return objectList;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'invokeCalculationProcedure(x2)', ferretSeqNumber);
        }
        /* do not add code inside this block */
    }
    
    public void getAttributes (String prodAttrJSON, Map<String, Object> row, Map<String, Object> data)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getAttributes(x3)');
        /* do not add code inside this block */


        //System.debug(LoggingLevel.ERROR, 'getAttribute---prodAttrJSON ' + prodAttrJSON);
        //System.debug(LoggingLevel.ERROR, 'getAttribute --row ' + row);
        //System.debug(LoggingLevel.ERROR, 'getAttribute --data ' + data);
        
        if (String.isBlank(prodAttrJSON))
        {
            return;
        }
        Map<String, Object> rowMap = row;
        Object jsonAttr = JSON.deserializeUntyped(prodAttrJSON);
        //system.debug('jsonAttr'+jsonAttr);
        if (jsonAttr instanceof List<Object>)
        {
            System.debug(LoggingLevel.ERROR, 'jsonAttr is a List<Object>');
            return;
        }
        else if (jsonAttr == null)
        {
            System.debug(LoggingLevel.ERROR, 'jsonAttr is null');
            return;
        }
        Map<String, Object> attrMap = (Map<String, Object>)jsonAttr;
        Boolean bFirst = true;
        for (String key : attrMap.keySet())
            {
                System.debug(LoggingLevel.ERROR, 'key ' + key);

                Object attrs = attrMap.get(key);
                if (attrs instanceof List<Object>)
                {
                    //System.debug(LoggingLevel.ERROR, 'attrs ' + attrs);

                    List<Object> attrList = (List<Object>)attrs;
                    list<CalcMatrixdataWrapper> charactersticNameWrapperList = new list<CalcMatrixdataWrapper>();
                    for (Object attr : attrList)
                        {
                            //                    if (!bFirst)
                            //                    {
                            //                        rowMap = rowMap.clone();
                            //                        data.put('Row' + data.size(), rowMap);
                            //                    }
                            //                    else
                            //                    {
                            //                        bFirst = false;
                            //                    }
                            Map<String, Object> attrInfo = (Map<String, Object>)attr;
                            
                            String charName;
                            if (useAttributeCode)
                            {
                                charName = (String)attrInfo.get('attributeuniquecode__c');
                            }
                            else
                            {
                                charName = (String)attrInfo.get('attributedisplayname__c');
                            }
                            //String attrCode = (String)attrInfo.get('attributeuniquecode__c');

                            // Use the attribute display name
                            //String attrName = (String)attrInfo.get('attributedisplayname__c');

                            // Use the attribute display code instead
                            rowMap.put('Characteristic Name', charName);
                            Map<String, Object> attributeRunTimeInfo =
                                (Map<String, Object>)attrInfo.get('attributeRunTimeInfo');
                            if (attributeRunTimeInfo == null)
                            {
                                System.debug('attributeRunTimeInfo is null for ' + attrInfo);
                                continue;
                            }
                            String dataType = (String)attributeRunTimeInfo.get('dataType');
                            if (dataType == null)
                            {
                                System.debug(LoggingLevel.ERROR,
                                        'Unable to find the dataType for attribute name ' + charName);

                                continue;
                            }
                            //get initial value
                            Object propertyValue = attributeRunTimeInfo.get('value');
                            if (propertyValue == null)
                            {
                                propertyValue = attributeRunTimeInfo.get('default');
                            }
                            try
                            {
                                String normDataType = dataType.toLowerCase();
                                if (normDataType == 'multi picklist')
                                {
                                    propertyValue = attributeRunTimeInfo.get('selectedItems');
                                    if (propertyValue == null || ((List<Object>) propertyValue).isEmpty())
                                    {
                                        List<Object> values = (List<Object>)attributeRunTimeInfo.get('default');
                                        String valuesDelimited = '';
                                        for (Integer index = 0; index < values.size(); index++)
                                        {
                                            Map<String, Object> value = (Map<String, Object>)values[index];
                                            valuesDelimited += getPropertyValue(value) + ';';
                                        }
                                        if (valuesDelimited.length() > 0)
                                        {
                                            propertyValue = valuesDelimited.subString(0, valuesDelimited.length() - 1);
                                            rowMap.put('Characteristic Value', propertyValue);
                                        }
                                    }
                                    else
                                    {
                                        List<Object> values = (List<Object>)propertyValue;
                                        String valuesDelimited = '';
                                        for (Integer index = 0; index < values.size(); index++)
                                        {
                                            Map<String, Object> value = (Map<String, Object>)values[index];
                                            valuesDelimited += getPropertyValue(value) + ';';
                                        }
                                        if (valuesDelimited.length() > 0)
                                        {
                                            propertyValue = valuesDelimited.subString(0, valuesDelimited.length() - 1);
                                            rowMap.put('Characteristic Value', propertyValue);
                                        }
                                    }
                                }
                                else if (normDataType == 'picklist')
                                {
                                    propertyValue = attributeRunTimeInfo.get('selectedItem');
                                    if (propertyValue == null)
                                    {
                                        List<Object> values = (List<Object>)attributeRunTimeInfo.get('default');
                                        if (values != null && !values.isEmpty())
                                        {
                                            String valuesDelimited = null;
                                            Map<String, Object> value = (Map<String, Object>)values[0];
                                            valuesDelimited = getPropertyValue(value);
                                            propertyValue = valuesDelimited;
                                            rowMap.put('Characteristic Value', propertyValue);
                                        }
                                    }
                                    else
                                    {
                                        System.debug('propertyValue is ' + propertyValue);
                                        if (propertyValue instanceof Map<String, Object>)
                                        {
                                            Map<String, Object> value = (Map<String, Object>)propertyValue;
                                            propertyValue = getPropertyValue(value);
                                        }
                                        else if (propertyValue instanceof String)
                                        {
                                            propertyValue = getPropertyValue2(attributeRunTimeInfo.get('values'),
                                                (String)propertyValue);
                                            System.debug('getPropertyValue2 returned ' + propertyValue);
                                        }
                                        rowMap.put('Characteristic Value', propertyValue);
                                    }
                                }
                                else
                                {
                                    rowMap.put('Characteristic Value', propertyValue);
                                }

                                if (rowMap.containsKey('Reference External Id') &&
                                    cmrExtIDtoWrapperMap.containsKey((string) rowMap.get('Reference External Id')))
                                {
                                    charactersticNameWrapperList =
                                        cmrExtIDtoWrapperMap.get((string) rowMap.get('Reference External Id'));

                                    //System.debug(
                                            //'charactersticNameWrapperList returned ' + charactersticNameWrapperList);


                                    for (CalcMatrixdataWrapper cmWrapper : charactersticNameWrapperList)
                                    {
                                        if (cmWrapper.charactersticNameOrderMap.containsKey(charName) &&
                                                propertyValue != null)
                                        {
                                            if (cmWrapper.itemIDToSearchCount.containsKey(
                                                (string) rowMap.get('ItemID')))
                                            {
                                                Integer searchCount =
                                                    cmWrapper.itemIDToSearchCount.get((string) rowMap.get('ItemID')) +
                                                    1;
                                                cmWrapper.itemIDToSearchCount.put((string) rowMap.get('ItemID'),
                                                    searchCount);
                                            }
                                            else
                                            {
                                                cmWrapper.itemIDToSearchCount.put((string) rowMap.get('ItemID'), 1);
                                            }
                                            if (cmWrapper.ItemrRunTimeattrPositionMap.containsKey(
                                                (string) rowMap.get('ItemID')))
                                            {
                                                cmWrapper.ItemrRunTimeattrPositionMap.get(
                                                    (string) rowMap.get('ItemID')).put(
                                                    cmWrapper.charactersticNameOrderMap.get(charName),
                                                    new CharactersticNameValue(charName,
                                                        string.valueof(propertyValue)));
                                            }
                                            else
                                            {
                                                cmWrapper.runTimeattrPosition.put(
                                                    cmWrapper.charactersticNameOrderMap.get(charName),
                                                    new CharactersticNameValue(charName,
                                                        string.valueof(propertyValue)));
                                                cmWrapper.ItemrRunTimeattrPositionMap.put((string) rowMap.get('ItemID'),
                                                    cmWrapper.runTimeattrPosition);
                                            }
                                        }
                                    }
                                }
                            }
                            catch (Exception e)
                            {
                                System.debug(LoggingLevel.ERROR, 'Exception:::::' + e);
                                System.debug(LoggingLevel.ERROR,
                                        'Exception stack trace:::::' + e.getStackTraceString());
                                throw e;
                            }
                        } // end for loop
                    getDelimitedRowNode(rowMap, data);
                } // end if
                else if (attrs instanceof Map<String, Object>)
                    System.debug(LoggingLevel.ERROR, 'attrs is a Map<String, Object>');
            }
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getAttributes(x3)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}
    
    @TestVisible

    private String getPropertyValue2 (Object valuesList, String propertyValue)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getPropertyValue2(x2)');
        /* do not add code inside this block */


        //system.debug('valuesList--->'+valuesList);
        //system.debug('propertyValue--->'+propertyValue);
        
        
        if (valuesList instanceof List<Object>)
        {
            List<Object> objList = (List<Object>)valuesList;
            String internalVal, displayVal;
            for (Object obj : objList)
            {
                if (obj instanceof Map<String, Object>)
                {
                    Map<String, Object> valueMap = (Map<String, Object>)obj;
                    internalVal = String.valueOf(valueMap.get('value'));
                    displayVal = String.valueOf(valueMap.get('displayText'));
                    if (internalVal == propertyValue || displayVal == propertyValue)
                    {
                        if (this.useDisplayText)
                        {
                            return displayVal;
                        }
                        else
                        {
                            if (String.isBlank(internalVal))
                                return displayVal;
                            else
                                return internalVal;
                        }
                    }
                }
            }
        }
        return propertyValue;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getPropertyValue2(x2)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    public String getPropertyValue (Map<String, Object> valueMap)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getPropertyValue(x1)');
        /* do not add code inside this block */


        if (this.useDisplayText)
        {
            return String.valueOf(valueMap.get('displayText'));
        }
        String propertyValue = String.valueOf(valueMap.get('value'));
        if (String.isBlank(propertyValue))
        {
            propertyValue = String.valueOf(valueMap.get('displayText'));
        }
        return propertyValue;
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getPropertyValue(x1)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    @TestVisible
    private void getDelimitedRowNode (Map<String, Object> rowMap, Map<String, Object> data)
    {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getDelimitedRowNode(x2)');
        /* do not add code inside this block */


        list<CalcMatrixdataWrapper> charactersticNameWrapperList = new list<CalcMatrixdataWrapper>();
        Map<string, string> charactersticNameValueMap = new map<string, string>();
        string attrNamedelimited = '';
        string attrValuedelimited = '';
        if (cmrExtIDtoWrapperMap.containsKey((string) rowMap.get('Reference External Id')))
        {
            charactersticNameWrapperList = cmrExtIDtoWrapperMap.get((string) rowMap.get('Reference External Id'));

            //System.debug('charactersticNameWrapperList returned ' + charactersticNameWrapperList);

            for (CalcMatrixdataWrapper cmWrapper : charactersticNameWrapperList)
                {
                    if (integer.valueOf(cmWrapper.itemIDToSearchCount.get((string) rowMap.get('ItemID'))) ==
                        cmWrapper.charactersticNameOrderMap.size())
                    {
                        List < integer > attrNameposition = New List<Integer> (
                            cmWrapper.ItemrRunTimeattrPositionMap.get((string) rowMap.get('ItemID')).keySet());
                        attrNameposition.sort();
                        List < string > attrNameOrderedListName = new List < string > ();
                        List < string > attrNameOrderedListValue = new List < string > ();
                        for (integer i : attrNameposition)
                        {
                            attrNameOrderedListName.add(cmWrapper.runTimeattrPosition.get(i).name);
                            attrNameOrderedListValue.add(cmWrapper.runTimeattrPosition.get(i).value);
                        }
                        //rowMap = rowMap.clone();
                        rowMap.put('Characteristic Name', string.join(attrNameOrderedListName, ';'));
                        rowMap.put('Characteristic Value', string.join(attrNameOrderedListValue, ';'));
                        //data.put('Row' + (data.size()), rowMap);
                    }
                }
        }
        System.debug(LoggingLevel.ERROR, 'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap.size());
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getDelimitedRowNode(x2)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}
    @TestVisible
    // Query CalculationMarix data to get the characterstic name, value for future comparision.
    private void getCalcMatrixdata(string CalCulationMatrixName ) {

        /* the following was inserted by apex_changer.py */
        Integer ferretSeqNumber = FerretLogGeneratorV1.getSequenceNumber();
        try {
        FerretLogGeneratorV1.logMethodEntry('CustomPricingPlanStepImpl', 'getCalcMatrixdata(x1)');
        /* do not add code inside this block */


        //to be removed
        //System.debug(LoggingLevel.ERROR,'MATRIX NAME::' + CalCulationMatrixName);
        //System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap);
        for ( vlocity_cmt__CalculationMatrixRow__c cmr : [select id, name, vlocity_cmt__InputData__c, vlocity_cmt__OutputData__c
            from vlocity_cmt__CalculationMatrixRow__c where
            vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__CalculationMatrixId__r.name = :CalCulationMatrixName AND
            vlocity_cmt__CalculationMatrixVersionId__r.vlocity_cmt__IsEnabled__c = true AND name != 'Header' ] ) {
            object inputdata = JSON.deserializeUntyped(cmr.vlocity_cmt__InputData__c);
            if (isDebugging) { System.debug(LoggingLevel.ERROR,'cmr is..'+cmr); }
            
            if (inputdata instanceof Map<String, Object> ) {
                Map<string, Object> inputDataMap = ( Map<string, Object>)inputdata;

                if (isDebugging) { System.debug('inputdata returned after cmr ' + inputdata); }

                if (inputDataMap.ContainsKey('Reference External Id') && inputDataMap.ContainsKey('Characteristic Name') ) {
                    string externalId = string.valueof(inputDataMap.get('Reference External Id'));

                    if (isDebugging) { System.debug('externalId returned ' + externalId); }

                    string charactersticName = string.valueof(inputDataMap.get('Characteristic Name'));
                    Set<string> charNameSet = new set<string>();
                    boolean addRecordtoWrapper = true;
                    charNameSet.addAll(string.valueof(inputDataMap.get('Characteristic Name')).split(';'));
                    if (cmrExtIDtoWrapperMap.containsKey(externalId) && charNameSet.size() > 1) {
                        if (cmrExtIDtoWrapperMap.get(externalId).size() > 0) {
                            for (CalcMatrixdataWrapper cmWrapper : cmrExtIDtoWrapperMap.get(externalId)) {
                                if (cmWrapper.charactersticName.equalsIgnoreCase(charactersticName))
                                    addRecordtoWrapper = false;
                                break;
                            }
                        }
                        if (addRecordtoWrapper)
                            cmrExtIDtoWrapperMap.get(externalId).add(new CalcMatrixdataWrapper(charactersticName, charNameSet, 0, externalID));
                    } else if (charNameSet.size() > 1) {
                        list<CalcMatrixdataWrapper> calcMatrixDataList = new list<CalcMatrixdataWrapper>();
                        calcMatrixDataList.add(new CalcMatrixdataWrapper(charactersticName, charNameSet, 0, externalID));
                        cmrExtIDtoWrapperMap.put(externalId, calcMatrixDataList);
                    }
                }
            }
        }
        if (isDebugging)
        {
            System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap-Size::' + cmrExtIDtoWrapperMap.size());
            System.debug(LoggingLevel.ERROR,'cmrExtIDtoWrapperMap' + JSON.serialize(cmrExtIDtoWrapperMap));
        }
    

        /* the following was inserted by apex_changer.py */
        } finally {
        FerretLogGeneratorV1.logMethodExit('CustomPricingPlanStepImpl', 'getCalcMatrixdata(x1)', ferretSeqNumber);
        }
        /* do not add code inside this block */

}

    private class CalcMatrixdataWrapper {
        string charactersticName {
            get; set;
        }
        set<string> charactersticNameSet = new set<string>();
        map<string, string> runTimecharNameValueMap {
            set; get;
        }
        map<string, integer>charactersticNameOrderMap = new map<string, integer>();
        map<integer, CharactersticNameValue> runTimeattrPosition = new map<integer, CharactersticNameValue>();
        integer searchCount {
            get; set;
        }
        integer i = 1;
        string externalID = '';
        Map<String, Integer> itemIDToSearchCount = new Map<String, Integer>();
        Map<String, Map<integer, CharactersticNameValue> > ItemrRunTimeattrPositionMap = new Map<String, Map<integer, CharactersticNameValue> >();


        public CalcMatrixdataWrapper (string charactersticName,
                                      Set<string> charactersticNameSet,
                                      integer searchCount,
                                      String externalID)
            {
                this.charactersticName = charactersticName;
                this.charactersticNameSet = charactersticNameSet;
                this.searchCount = searchCount;
                this.externalID = externalID;
                for (string cName : charactersticNameSet)
                {
                    charactersticNameOrderMap.put(cName, i);
                    i++;
                }
            }
    }

    public class CharactersticNameValue {
        public string name;
        public string value;

        public CharactersticNameValue (string name, string value)
            {
                this.name = name;
                this.value = value;
            }
    }



    
    }