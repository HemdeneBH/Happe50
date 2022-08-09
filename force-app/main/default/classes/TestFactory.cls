@isTest
public class TestFactory {

    public static Map<String, Object> testCreateOrderWithProducts() {

        Id pricebookId = Test.getStandardPricebookId();
		system.debug('pricebookId====>'+pricebookId);
        
        Account acc = new Account(name='EngieTest');
            
        insert acc;

        Order ord = new Order(
                        AccountId = acc.id,
                        vlocity_cmt__Phone__c='0523400003',
                        Status =  'Draft',
                        EffectiveDate = Date.today(),
                        Pricebook2Id = pricebookId
                        );
        insert ord;
        
        //Object Type Creation
        
        vlocity_cmt__ObjectClass__c objType = new vlocity_cmt__ObjectClass__c(
        	Name = 'OT - Panneau',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__ObjectApiName__c = 'Product2'
        );
        insert objType;
        
        vlocity_cmt__AttributeCategory__c attriCat = new vlocity_cmt__AttributeCategory__c(
            Name = 'MyPower',
            vlocity_cmt__ApplicableSubType__c = 'Product Attribute',
            vlocity_cmt__ApplicableTypes__c = 'Product2',
            vlocity_cmt__Code__c = 'ACAT_MyPOWER',
            vlocity_cmt__IsActive__c = true,
            vlocity_cmt__UIControlType__c = 'On-Off',
            vlocity_cmt__DisplaySequence__c = 40.0
        );
        
        insert attriCat;
        
        vlocity_cmt__Picklist__c vlpick = new vlocity_cmt__Picklist__c(
            Name = 'Type de courant',
            vlocity_cmt__Code__c = 'PKL_TYPE_COURANT',
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__IsActive__c = true
        );
        
        insert vlpick;
        
        vlocity_cmt__Attribute__c vloatt = new vlocity_cmt__Attribute__c(
        	Name = 'Type de courant',
            vlocity_cmt__ActiveFlg__c = true,
            vlocity_cmt__AttributeCategoryId__c = attriCat.Id,
            vlocity_cmt__PicklistId__c= vlpick.Id,
            vlocity_cmt__ValueType__c = 'Picklist',
            vlocity_cmt__Code__c = 'ATT_TYPE_COURANT'
            
          ); 
        insert vloatt;
        
        vlocity_cmt__CalculationProcedure__c calprocd = new vlocity_cmt__CalculationProcedure__c(
        	Name = 'MyPowerPricingProcedure'
        ); 
        insert calprocd;
        
        vlocity_cmt__CalculationProcedureVersion__c calcprocdver = new vlocity_cmt__CalculationProcedureVersion__c(
            Name ='MyPowerPricingProcedureV2',
            vlocity_cmt__CalculationProcedureId__c =calprocd.Id,
            vlocity_cmt__IsEnabled__c = true,
            vlocity_cmt__Priority__c = 2            
        );
        insert calcprocdver;
        
        vlocity_cmt__CalculationMatrix__c calcMatrix = new vlocity_cmt__CalculationMatrix__c(
        	Name = 'MyPowerPricingMatrix'
        );
        insert calcMatrix;
        
        vlocity_cmt__CalculationMatrixVersion__c calmatver = new vlocity_cmt__CalculationMatrixVersion__c(
        	Name = 'MyPowerPricingMatrix v2',
            vlocity_cmt__IsEnabled__c = true,
            vlocity_cmt__CalculationMatrixId__c = calcMatrix.Id,
            vlocity_cmt__Priority__c = 2,
            vlocity_cmt__VersionNumber__c = 2
        );
        
        insert calmatver;
        
        vlocity_cmt__CalculationProcedureVariable__c procdvar = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'Reference Product Name',
            vlocity_cmt__Alias__c ='ReferenceProductName',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'Reference Product Name'
        );
        insert procdvar;
        
        vlocity_cmt__CalculationProcedureVariable__c procdvar1 = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'NRC',
            vlocity_cmt__Alias__c ='MyPowerPricingMatrix__NRC',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'NRC ( MyPowerPricingMatrix )'
        );
        insert procdvar1;
        
        vlocity_cmt__CalculationProcedureVariable__c procdvar2 = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'MRC',
            vlocity_cmt__Alias__c ='MyPowerPricingMatrix__MRC',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'MRC ( MyPowerPricingMatrix )'
        );
        insert procdvar2;
     	
         vlocity_cmt__CalculationProcedureVariable__c procdvar3 = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'Reference External Id',
            vlocity_cmt__Alias__c ='ReferenceExternalId',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'Reference External Id'
        );
        insert procdvar3;
        
        vlocity_cmt__CalculationProcedureVariable__c procdvar4 = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'Characteristic Name',
            vlocity_cmt__Alias__c ='CharacteristicName',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'Characteristic Name'
        );
        insert procdvar4;
        
         vlocity_cmt__CalculationProcedureVariable__c procdvar5 = new vlocity_cmt__CalculationProcedureVariable__c(
        	Name = 'Characteristic Value',
            vlocity_cmt__Alias__c ='CharacteristicValue',
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__DataType__c = 'Text',
            vlocity_cmt__MatrixName__c = 'MyPowerPricingMatrix',
            vlocity_cmt__TypeaheadDisplayName__c = 'Characteristic Value'
        );
        insert procdvar5;
        
        vlocity_cmt__CalculationProcedureStep__c prodStep = new vlocity_cmt__CalculationProcedureStep__c(
        	Name = 'a0V9E0000024Zmr',
            vlocity_cmt__CalculationMatrixId__c=calcMatrix.Id,
            //vlocity_cmt__CalculationProcedureId__c =calprocd.Id,
            vlocity_cmt__CalculationProcedureVersionId__c = calcprocdver.Id,
            vlocity_cmt__Function__c = 'Matrix Lookup',
            vlocity_cmt__Input__c = '[{"columnKey":"266c7","dataType":"Text","label":null,"listValues":null,"name":"Reference Product Name"},{"columnKey":"c16c44","dataType":"Text","label":null,"listValues":null,"name":"Reference External Id"},{"columnKey":"981f40","dataType":"Text","label":null,"listValues":null,"name":"Characteristic Name"},{"columnKey":"539618","dataType":"Text","label":null,"listValues":null,"name":"Characteristic Value"}]',
            vlocity_cmt__IsIncludedInResult__c = true,
            vlocity_cmt__OutputJSON__c = '[{"columnKey":"a9cb31","dataType":"Text","label":null,"listValues":null,"name":"NRC"},{"columnKey":"151201","dataType":"Text","label":null,"listValues":null,"name":"MRC"}]',
            vlocity_cmt__OutputMappingJSON__c = '{"NRC":"MyPowerPricingMatrix__NRC","MRC":"MyPowerPricingMatrix__MRC"}',
            vlocity_cmt__Sequence__c = 1
        );
        insert prodStep;
        
        vlocity_cmt__CalculationMatrixRow__c calMatrixrow = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = 'f0f92add94cac7acfc89990b39275931',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Monocristallin - Full Black 300 ZX5;300 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"151.23"}'
        );
        insert calMatrixrow;
        
        vlocity_cmt__CalculationMatrixRow__c calMatrixrow1 = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = 'b7b754e7f97989899813d62955c6e112',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Monocristallin 300 ZX5;300 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"145.08"}'
        );
        insert calMatrixrow1;
        
        vlocity_cmt__CalculationMatrixRow__c calMatrixrow2 = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = '5f3e393dcaf3e21d3ca5d0b2f2d69e02',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Monocristallin 310 VL4;310 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"143.67"}'
        );
        insert calMatrixrow2;
        
		vlocity_cmt__CalculationMatrixRow__c calMatrixrow3 = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = '434e4bc790cf9089d3fa116512c78072',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Polycristallin 270 VL5;270 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"101.43"}'
        );
        insert calMatrixrow3;
	
		vlocity_cmt__CalculationMatrixRow__c calMatrixrow4 = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = 'f1bd315b3d5dfd7d51c8576fec0713f1',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Polycristallin 275 GX5;275 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"123.26"}'
        );		       
        insert calMatrixrow4;
        
        vlocity_cmt__CalculationMatrixRow__c calMatrixrow5 = new vlocity_cmt__CalculationMatrixRow__c(
        	Name = 'c89cc4d75ea0bf5e1b20ea0f12e7f8f0',
            vlocity_cmt__CalculationMatrixVersionId__c = calmatver.Id,
            vlocity_cmt__InputData__c = '{"Characteristic Value":"Polycristallin 275 VL5;275 Wc","Characteristic Name":"ATT_TYPE_PANNEAU;ATT_PUISS_PANNEAU","Reference External Id":"MyPower_011","Reference Product Name":"Panneau"}',
            vlocity_cmt__OutputData__c = '{"MRC":"0","NRC":"105"}'
        );		       
        insert calMatrixrow5;
        
        
        Product2 prod = new Product2(
             Name = 'Panneau',
             ProductCode = 'MyPower_011',                         
             isActive = true,
             vlocity_cmt__ObjectTypeId__c = objType.Id
        );
        insert prod;
        
        
        PricebookEntry pbEntry = new PricebookEntry(
             Pricebook2Id = pricebookId,
             Product2Id = prod.Id,
             UnitPrice = 100.00,
             IsActive = true
        );
        insert pbEntry;
		system.debug('pbEntry==>'+pbEntry);
        
        OrderItem oli = new OrderItem(
             OrderId = ord.Id,
             Quantity = 5,
             Product2Id = prod.Id,
             PricebookEntryId = pbEntry.Id,
             UnitPrice = 100.00,
             vlocity_cmt__OneTimeCalculatedPrice__c = 100.00,
             vlocity_cmt__OneTimeCharge__c = 100.00
             //vlocity_cmt__JSONAttribute__c = '{"Equip":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000001iBnpQAE","attributeid__c":"a0G9E000001ZcCVUA0","attributecategoryid__c":"a0F9E000001gbbuUAA","categorycode__c":"Equip","categoryname__c":"Equipment","attributeuniquecode__c":"Physical_Device","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"isactive__c":true,"attributedisplayname__c":"Physical Device","displaysequence__c":"null","formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D9E000001GcsbUAC","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":null,"value__c":"true","valuedatatype__c":"Checkbox","valuedescription__c":null,"attributecloneable__c":true,"categorydisplaysequence__c":1,"customconfiguitemplate__c":null,"attributeRunTimeInfo":{"dataType":"Checkbox","default":true,"value":true},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000001iBnpQAE","attributeid__c":"a0G9E000001XZH0UAO","attributecategoryid__c":"a0F9E000001gbbuUAA","categorycode__c":"Equip","categoryname__c":"Equipment","attributeuniquecode__c":"Model","attributeconfigurable__c":true,"attributedisplaysequence__c":"3","attributefilterable__c":true,"isactive__c":true,"attributedisplayname__c":"דגם","displaysequence__c":"1","formatmask__c":null,"hasrule__c":false,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":true,"isquerydriven__c":false,"querylabel__c":null,"id":"a0D9E0000017MpfUAE","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Text","value__c":null,"valuedatatype__c":"Text","valuedescription__c":null,"attributecloneable__c":true,"categorydisplaysequence__c":1,"customconfiguitemplate__c":null,"attributeRunTimeInfo":{"dataType":"Text","uiDisplayType":"Text","value":null},"$$AttributeDefinitionEnd$$":null}]}'
        );

        insert oli;

        Map<String, Object> dynMap = new Map<String, Object>();
        dynMap.put('Order',ord);
        dynMap.put('OrderItem',oli);
        dynMap.put('ProceBookEntry',pbEntry);
        return dynMap;
    }
}