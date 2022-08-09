@isTest(seeAllData = true)
public class Test_CustomPricingPlanStepImpl {
    
        public static Map<String, Object> testCreateOrderWithProducts() {
        Id pricebookId = Test.getStandardPricebookId();        
        Account acc = new Account(name='EngieTest');
        insert acc;
        
        Order ord = new Order(AccountId = acc.id,vlocity_cmt__Phone__c='0523400003',Status = 'Draft',EffectiveDate = Date.today(),Pricebook2Id = pricebookId);
        insert ord;
        
        vlocity_cmt__ObjectClass__c objType = new vlocity_cmt__ObjectClass__c(Name = 'OT - Panneau',vlocity_cmt__IsActive__c = true,vlocity_cmt__ObjectApiName__c = 'Product2');
        insert objType;
        
        Product2 prod = new Product2(Name ='Panneau',ProductCode ='MyPower_040',isActive =true,vlocity_cmt__ObjectTypeId__c=objType.Id);
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod.Id,UnitPrice = 100.00,IsActive = true);
        insert pbEntry;

        vlocity_cmt__ObjectClass__c objType2 = new vlocity_cmt__ObjectClass__c(Name = 'OT - Matériel',vlocity_cmt__IsActive__c = true,vlocity_cmt__ObjectApiName__c = 'Product2');
        insert objType2;
        
        Product2 prod2 = new Product2(Name ='Matériel',ProductCode ='MyPower_010',isActive =true,vlocity_cmt__ObjectTypeId__c=objType2.Id);
        insert prod2;
        
        PricebookEntry pbEntry2 = new PricebookEntry(Pricebook2Id = pricebookId,Product2Id = prod2.Id,UnitPrice = 100.00,IsActive = true);
        insert pbEntry2;
        
        
        OrderItem oli = new OrderItem(OrderId = ord.Id,Quantity = 5,Product2Id = prod.Id,PricebookEntryId= pbEntry.Id,UnitPrice = 100.00,vlocity_cmt__OneTimeCalculatedPrice__c = 100.00,vlocity_cmt__OneTimeCharge__c = 100.00,
        vlocity_cmt__JSONAttribute__c='{"ACAT_MyPOWER":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002Vf68UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TRANCHE_PUISS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tranche de puissance associée","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v797UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"3,1 kWc à 3,99 kWc","id":40,"displayText":"3,1 kWc à 3,99 kWc"},{"value":"2,7 kWc à 2,99 kWc","id":20,"displayText":"2,7 kWc à 2,99 kWc"},{"value":"6 kWc à 8,99 kWc","id":60,"displayText":"6 kWc à 8,99 kWc"},{"value":"9 kWc","id":70,"displayText":"9 kWc"},{"value":"3 kWc","id":30,"displayText":"3 kWc"},{"value":"4 kWc à 5,99 kWc","id":50,"displayText":"4 kWc à 5,99 kWc"},{"value":"1,8 kWc à 2,69 kWc","id":10,"displayText":"1,8 kWc à 2,69 kWc"}],"default":[],"selectedItem":{"value":"1,8 kWc à 2,69 kWc","id":10,"displayText":"1,8 kWc à 2,69 kWc"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002Vf63UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PILOTAGE_ECS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pilotage ECS","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v796UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Oui","id":10,"displayText":"Oui"},{"value":"Non","id":20,"displayText":"Non"}],"default":[],"selectedItem":{"value":"Oui","id":10,"displayText":"Oui"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VKSvUAO","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_COURANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"8","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de courant","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v798UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Monophasé","id":10,"displayText":"Monophasé"},{"value":"Triphasé","id":20,"displayText":"Triphasé"}],"default":[],"selectedItem":{"value":"Monophasé","id":10,"displayText":"Monophasé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VhtyUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PUISS_TOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Puissance totale des panneaux","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9jQUAQ","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Supérieure à 3 kWc","id":10,"displayText":"Supérieure à 3 kWc"},{"value":"Inférieure ou égale à 3 kWc","id":20,"displayText":"Inférieure ou égale à 3 kWc"}],"default":[],"selectedItem":{"value":"Supérieure à 3 kWc","id":10,"displayText":"Supérieure à 3 kWc"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VhttUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_ANN_CONSTRUCTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Année de construction","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9jLUAQ","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Avant 2016","id":10,"displayText":"Avant 2016"},{"value":"Après 2016","id":20,"displayText":"Après 2016"}],"default":[],"selectedItem":{"value":"Avant 2016","id":10,"displayText":"Avant 2016"}},"$$AttributeDefinitionEnd$$":null}]}');
        insert oli;

        OrderItem oli2 = new OrderItem(OrderId = ord.Id,Quantity = 5,Product2Id = prod2.Id,PricebookEntryId= pbEntry2.Id,UnitPrice = 100.00,vlocity_cmt__OneTimeCalculatedPrice__c = 100.00,vlocity_cmt__OneTimeCharge__c = 100.00,
        vlocity_cmt__JSONAttribute__c='{"ACAT_MyPOWER":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002Vf68UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TRANCHE_PUISS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tranche de puissance associée","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v797UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"3,1 kWc à 3,99 kWc","id":40,"displayText":"3,1 kWc à 3,99 kWc"},{"value":"2,7 kWc à 2,99 kWc","id":20,"displayText":"2,7 kWc à 2,99 kWc"},{"value":"6 kWc à 8,99 kWc","id":60,"displayText":"6 kWc à 8,99 kWc"},{"value":"9 kWc","id":70,"displayText":"9 kWc"},{"value":"3 kWc","id":30,"displayText":"3 kWc"},{"value":"4 kWc à 5,99 kWc","id":50,"displayText":"4 kWc à 5,99 kWc"},{"value":"1,8 kWc à 2,69 kWc","id":10,"displayText":"1,8 kWc à 2,69 kWc"}],"default":[],"selectedItem":{"value":"1,8 kWc à 2,69 kWc","id":10,"displayText":"1,8 kWc à 2,69 kWc"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002Vf63UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PILOTAGE_ECS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pilotage ECS","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v796UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Oui","id":10,"displayText":"Oui"},{"value":"Non","id":20,"displayText":"Non"}],"default":[],"selectedItem":{"value":"Oui","id":10,"displayText":"Oui"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VKSvUAO","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_COURANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"8","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de courant","displaysequence__c":"null","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v798UAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Monophasé","id":10,"displayText":"Monophasé"},{"value":"Triphasé","id":20,"displayText":"Triphasé"}],"default":[],"selectedItem":{"value":"Monophasé","id":10,"displayText":"Monophasé"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VhtyUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PUISS_TOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Puissance totale des panneaux","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9jQUAQ","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Supérieure à 3 kWc","id":10,"displayText":"Supérieure à 3 kWc"},{"value":"Inférieure ou égale à 3 kWc","id":20,"displayText":"Inférieure ou égale à 3 kWc"}],"default":[],"selectedItem":{"value":"Supérieure à 3 kWc","id":10,"displayText":"Supérieure à 3 kWc"}},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002c0lCQAQ","attributeid__c":"a0L9E000002VhttUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_ANN_CONSTRUCTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Année de construction","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9jLUAQ","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"value":"Avant 2016","id":10,"displayText":"Avant 2016"},{"value":"Après 2016","id":20,"displayText":"Après 2016"}],"default":[],"selectedItem":{"value":"Avant 2016","id":10,"displayText":"Avant 2016"}},"$$AttributeDefinitionEnd$$":null}]}'
        );
        insert oli2;

        Map<String, Object> dynMap = new Map<String, Object>();
        dynMap.put('Order',ord);
        dynMap.put('OrderItem',oli);
        dynMap.put('OrderItem_2',oli2);
        dynMap.put('ProceBookEntry',pbEntry);
        
        return dynMap;
    }
    
    private static void createCalculationProcedure()
    {
        // create matrix header
        vlocity_cmt__CalculationMatrix__c parent = new vlocity_cmt__CalculationMatrix__c(Name='TauxDeMargeMatrix');
        insert parent;

        // Create matrix version
        vlocity_cmt__CalculationMatrixVersion__c version = new vlocity_cmt__CalculationMatrixVersion__c(Name='TauxDeMargeMatrix_V2', vlocity_cmt__VersionNumber__c=2, vlocity_cmt__IsEnabled__c=false, vlocity_cmt__CalculationMatrixId__c=parent.Id, vlocity_cmt__StartDateTime__c = DateTime.now().addDays(-10), vlocity_cmt__EndDateTime__c = DateTime.now().addDays(10), vlocity_cmt__Priority__c=1);
        insert version;

        List<vlocity_cmt__CalculationMatrixRow__c> lineItems = new List<vlocity_cmt__CalculationMatrixRow__c>();

        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, Name='Header',
            vlocity_cmt__InputData__c='{"name":"Reference Product Name","listValues":null,"lineItemId":"a0S9E000001ndh7UAA","label":null,"headerType":"Input","displayOrder":1,"dataType":"Text","columnKey":"a045f"}'
        ));

        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, Name='Header',
            vlocity_cmt__InputData__c='{"name":"Reference External Id","listValues":null,"lineItemId":"a0S9E000001ndh8UAA","label":null,"headerType":"Input","displayOrder":2,"dataType":"Text","columnKey":"e47cbc"}'
        ));

        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, Name='Header',
            vlocity_cmt__InputData__c='{"name":"Characteristic Name","listValues":null,"lineItemId":"a0S9E000001ndh9UAA","label":null,"headerType":"Input","displayOrder":3,"dataType":"Text","columnKey":"7adaec"}'
        ));

        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, Name='Header',
            vlocity_cmt__InputData__c='{"name":"Characteristic Value","listValues":null,"lineItemId":"a0S9E000001ndhAUAQ","label":null,"headerType":"Input","displayOrder":4,"dataType":"Text","columnKey":"bdc6ca"}'
        ));

        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, Name='Header',
            vlocity_cmt__InputData__c='{"name":"Tax1","listValues":null,"lineItemId":"a0S9E000001ndh6UAA","label":null,"headerType":"Output","displayOrder":5,"dataType":"Text","columnKey":"d12c4e"}'
        ));

        
        insert lineItems;
        lineItems = new List<vlocity_cmt__CalculationMatrixRow__c>();
        
        lineItems.add(new vlocity_cmt__CalculationMatrixRow__c(vlocity_cmt__CalculationMatrixVersionId__c=version.Id, 
            vlocity_cmt__InputData__c='{"Characteristic Value":"1,8 kWc à 2,69 kWc;Oui;Monophasé","Characteristic Name":"ATT_TRANCHE_PUISS;ATT_PILOTAGE_ECS;ATT_TYPE_COURANT","Reference External Id":"MyPower_010","Reference Product Name":"Matériel"}', 
            vlocity_cmt__OutputData__c='{"Tax1":"0.25"}'
        ));
                
       insert lineItems;

       update new vlocity_cmt__CalculationMatrixVersion__c(Id=version.Id, vlocity_cmt__IsEnabled__c=true);

       //service
       vlocity_cmt__CalculationProcedure__c newconfig1 = new vlocity_cmt__CalculationProcedure__c(Name='TauxDeMargeProcedure');
       insert newConfig1;
       
       vlocity_cmt__CalculationProcedureVersion__c newversion = new vlocity_cmt__CalculationProcedureVersion__c(Name='TauxDeMargeProcedure V1', vlocity_cmt__VersionNumber__c=1, vlocity_cmt__IsEnabled__c=false, vlocity_cmt__CalculationProcedureId__c=newConfig1.Id, vlocity_cmt__StartDateTime__c = DateTime.now().addDays(-10), vlocity_cmt__EndDateTime__c = DateTime.now().addDays(10), vlocity_cmt__Priority__c=1,
           vlocity_cmt__Constants__c='[]',
           vlocity_cmt__Variables__c ='{\"name":\"Tax1\",\"alias\":\"Tax1\",\"dataType\":\"Number\"}' 
        );
       insert newversion;
       
       List<vlocity_cmt__CalculationProcedureStep__c> steps = new List<vlocity_cmt__CalculationProcedureStep__c> ();
       
       vlocity_cmt__CalculationProcedureStep__c step1 = new vlocity_cmt__CalculationProcedureStep__c (Name='Step 1', vlocity_cmt__Sequence__c=1,vlocity_cmt__Function__c='Matrix Lookup', vlocity_cmt__CalculationMatrixId__c=parent.Id, vlocity_cmt__IsIncludedInResult__c=true, vlocity_cmt__CalculationProcedureVersionId__c=newversion.Id,
           vlocity_cmt__Input__c='[{"name":"Reference Product Name","listValues":null,"label":null,"dataType":"Text","columnKey":"a045f"},{"name":"Reference External Id","listValues":null,"label":null,"dataType":"Text","columnKey":"e47cbc"},{"name":"Characteristic Name","listValues":null,"label":null,"dataType":"Text","columnKey":"7adaec"},{"name":"Characteristic Value","listValues":null,"label":null,"dataType":"Text","columnKey":"bdc6ca"}]',
           vlocity_cmt__OutputJSON__c='[{"name":"Tax1","listValues":null,"label":null,"dataType":"Text","columnKey":"d12c4e"}]',
           vlocity_cmt__OutputMappingJSON__c='{"Tax1":"TauxDeMargeMatrix__Tax1"}');
       vlocity_cmt__CalculationProcedureStep__c step2 = new vlocity_cmt__CalculationProcedureStep__c (Name='Step 2', vlocity_cmt__Sequence__c=1,vlocity_cmt__Function__c='Calculation', vlocity_cmt__CalculationMatrixId__c=parent.Id, vlocity_cmt__IsIncludedInResult__c=true, vlocity_cmt__CalculationProcedureVersionId__c=newversion.Id,
           vlocity_cmt__Input__c='[]',
           vlocity_cmt__OutputJSON__c='{"name":"Tax1","dataType":"Number","alias":"Tax1"}',
           vlocity_cmt__OutputMappingJSON__c='{"Tax1":"Tax1"}',
           vlocity_cmt__CalculationFormulaLong__c='TauxDeMargeMatrix__Tax1',
           vlocity_cmt__CalculationFormulaTags__c='[{"text":"Tax1 ( TauxDeMargeMatrix )","alias":"TauxDeMargeMatrix__Tax1","userDefined":false,"dataType":"Text"}]');
       steps.add(step1);
       steps.add(step2);
       insert steps;
    }
        
        private static testMethod void testCalculateTax1() {
        //Order orderRecord = TestFactory.testCreateOrder();
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
            
        //createCalculationProcedure();
        
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem_2');
        system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itemlist = [Select Id,PriceBookEntry.Product2.ProductCode,Quantity,Product2.Name,PricebookEntryId,UnitPrice,PriceBookEntry.Product2.Name,
                     vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__JSONAttribute__c,vlocity_cmt__OneTimeCharge__c, vlocity_cmt__PricingLogData__c from OrderItem where Id =: ordItem.Id]; 
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', ord);
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList', itemlist);
        
        Test.startTest();
            
        CustomPricingPlanStepImpl objclass1 = new CustomPricingPlanStepImpl();
        Boolean result = objclass1.invokeMethod('CalculateTax1',null,null,null);
                    
        Test.stopTest();
    }
    
     private static testMethod void testGetMatrixPrice() {
         
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
            
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem');
        optionsMap.put('Characteristic Name','ATT_PUISS_PANNEAU');
        optionsMap.put('Characteristic Value','300 Wc');
        system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();
        itmelists = [Select Id,PriceBookEntry.Product2.ProductCode,Quantity,Product2.Name,PricebookEntryId,UnitPrice,PriceBookEntry.Product2.Name,
                     vlocity_cmt__OneTimeCalculatedPrice__c,OrderItem.vlocity_cmt__JSONAttribute__c,vlocity_cmt__OneTimeCharge__c from OrderItem where Id =: ordItem.Id];      
        //itmelists.add(ordItem);
        //vlocity_cmt.PricingPlanService.getFromPricingContext('Parent');
        //vlocity_cmt.PricingPlanService.getFromPricingContext('LineItemList');
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', ord);
        vlocity_cmt.PricingPlanService.putInPricingContext('ParentObjectName', 'Order');
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList',itmelists);
        String productCode = 'MyPower_040'; 
        Test.startTest();
        CustomPricingPlanStepImpl objclass1 = new CustomPricingPlanStepImpl();
        //objclass1.CharactersticNameValue charvalue = new objclass1.CharactersticNameValue('ATT_PUISS_PANNEAU','300 Wc');
           Boolean result1 = objclass1.invokeMethod('GetMatrixPrice',new map<String, object>{'parent'=>ord,'itemList'=>itmelists},outPutMap,optionsMap);
        //Boolean result1 = objclass1.invokeMethod('GetMatrixPrice',null,null,null);
        
        Test.stopTest();
    }
    
    private static testMethod void testCalculateTax2AttribBased() 
    {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
            outPutMap.put('error', 'OK');
            outPutMap.put('errorCode', 'INVOKE-200');
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem');
        system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        //itmelists.add(ordItem);
        itmelists = [Select Id,PriceBookEntry.Product2.ProductCode,Quantity,Product2.Name,PricebookEntryId,UnitPrice,PriceBookEntry.Product2.Name,
                     vlocity_cmt__OneTimeCalculatedPrice__c,OrderItem.vlocity_cmt__JSONAttribute__c,vlocity_cmt__OneTimeCharge__c from OrderItem where Id =: ordItem.Id];      
        
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', ord);
        //vlocity_cmt.PricingPlanService.putInPricingContext('ParentObjectName', 'Order');
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList',itmelists);
        String productCode = 'MyPower_040';
        Test.startTest();        
            CustomPricingPlanStepImpl objclass1 = new CustomPricingPlanStepImpl();          
            Boolean result = objclass1.invokeMethod('CalculateTax2AttribBased',null,null,null);        
        Test.stopTest();
    }
    private static testMethod void testCalculateTax2() 
    {
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = testCreateOrderWithProducts();               
        Order ord = (Order) ordMap.get('Order');        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem');
        system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();
        itmelists = [Select Id,PriceBookEntry.Product2.ProductCode,Product2Id,PriceBookEntry.Product2.Name, Product2.Name,
                    Quantity,PricebookEntryId,OrderItem.vlocity_cmt__JSONAttribute__c,UnitPrice,vlocity_cmt__OneTimeCalculatedPrice__c,vlocity_cmt__OneTimeCharge__c from OrderItem where Id =: ordItem.Id];      
        //itmelists.add(ordItem);
        //Map<String,Object> inputmapsample = new Map<string,object>();
        //inputmapsample.put('itemList',itmelists);
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', ord);
        vlocity_cmt.PricingPlanService.putInPricingContext('ParentObjectName', 'Order');
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemList',itmelists);
        String productCode = 'MyPower_040';
        Test.startTest();                
            CustomPricingPlanStepImpl objclass1 = new CustomPricingPlanStepImpl();          
            Boolean result = objclass1.invokeMethod('CalculateTax2',null,null,null);        
        Test.stopTest();
    }
    
    private static testMethod void testRollupTax2() 
    {
        
        Map<String, Object> inputMap = new Map<String, Object>();
        Map<String, Object> optionsMap = new Map<String, Object>();
        Map<String, Object> outPutMap = new Map<String, Object>();
        Map<String, Object> ordMap = testCreateOrderWithProducts();
        Map<String, Object> rowmap= new Map<String, Object>();  
         
        Order ord = (Order) ordMap.get('Order');
        inputMap.put('Order',ord);        
        PricebookEntry prientry = (PricebookEntry) ordMap.get('ProceBookEntry'); 
        OrderItem ordItem = (OrderItem) ordMap.get('OrderItem');
        system.debug('ordItem::'+ordItem); 
        system.debug('Item Pricebook entry===>'+prientry);
        list<OrderItem> itmelists = new list<OrderItem>();        
        itmelists.add(ordItem);
        vlocity_cmt.PricingPlanService.putInPricingContext('Parent', ord);
        vlocity_cmt.PricingPlanService.putInPricingContext('ParentObjectName', 'Order');
        vlocity_cmt.PricingPlanService.putInPricingContext('LineItemObjectName', 'OrderItem');
               
        Test.startTest();
        
         
            CustomPricingPlanStepImpl objclass1 = new CustomPricingPlanStepImpl();
            Boolean result = objclass1.invokeMethod('RollupTax2',null,null,null);
            objclass1.invokeExternalPriceService(ord,itmelists,'MyPowerPricingProcedure',itmelists ,new map<String, object>{'matrix'=>ord});
            String prodattr='{"ACAT_MyPOWER":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002cFH4QAM","attributeid__c":"a0L9E000002VTh9UAG","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_BOITIER","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de boitier","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002uk1sUAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ballon mécanique","id":10,"value":"Ballon mécanique"},{"displayText":"Ballon électronique","id":20,"value":"Ballon électronique"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf68UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TRANCHE_PUISS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tranche de puissance associée","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kOUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf63UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PILOTAGE_ECS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pilotage ECS","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kEUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VKSvUAO","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_COURANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"8","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de courant","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kTUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhtyUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PUISS_TOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Puissance totale des panneaux","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kJUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhttUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_ANN_CONSTRUCTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Année de construction","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9k9UAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"Picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"Picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
            objclass1.getAttributes(prodattr,new map<String, object>{'row'=>ord},new map<String, object>{'data'=>ord}); 
        objclass1.getPropertyValue2 (ord,'MyPowerPricingProcedure');
        objclass1.getPropertyValue(new map<String, object>{'valueMap'=>ord});
        
         rowmap.put('Reference Product Name','Panneau');
         rowmap.put('Reference External Id','MyPower_011');
         rowmap.put('Characteristic Name','ATT_PUISS_PANNEAU');
         rowmap.put('Characteristic Value','300 Wc');
         //String rowmap1 = '{ID=8029E000000obNkQAI, ItemID=8029E000000obNkQAI, Quantity=5.00, Reference External Id=MyPower_040, Reference Product Name=Panneau}';
        objclass1.getDelimitedRowNode (rowmap,new map<String, object>{'data'=>ord});
        
        String prodattr1='{"ACAT_MyPOWER":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002cFH4QAM","attributeid__c":"a0L9E000002VTh9UAG","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_BOITIER","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de boitier","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002uk1sUAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ballon mécanique","id":10,"value":"Ballon mécanique"},{"displayText":"Ballon électronique","id":20,"value":"Ballon électronique"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf68UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TRANCHE_PUISS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tranche de puissance associée","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kOUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf63UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PILOTAGE_ECS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pilotage ECS","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kEUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VKSvUAO","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_COURANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"8","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de courant","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kTUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhtyUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PUISS_TOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Puissance totale des panneaux","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kJUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhttUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_ANN_CONSTRUCTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Année de construction","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9k9UAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
        objclass1.getAttributes(prodattr1,new map<String, object>{'row'=>ord},new map<String, object>{'data'=>ord}); 

        //String prodattr2='{"ACAT_MyPOWER":[{"$$AttributeDefinitionStart$$":null,"objectid__c":"01t9E000002cFH4QAM","attributeid__c":"a0L9E000002VTh9UAG","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_BOITIER","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de boitier","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":true,"isconfigurable__c":true,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"Product2","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002uk1sUAA","isrequired__c":true,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[{"displayText":"Ballon mécanique","id":10,"value":"Ballon mécanique"},{"displayText":"Ballon électronique","id":20,"value":"Ballon électronique"}],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf68UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TRANCHE_PUISS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Tranche de puissance associée","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kOUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002Vf63UAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PILOTAGE_ECS","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Pilotage ECS","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kEUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","selectedItems":"yes","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VKSvUAO","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_TYPE_COURANT","attributeconfigurable__c":true,"attributedisplaysequence__c":"8","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Type de courant","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kTUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","selectedItems":"yes","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhtyUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_PUISS_TOT","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Puissance totale des panneaux","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9kJUAQ","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null},{"$$AttributeDefinitionStart$$":null,"objectid__c":"a249E000000NybCQAS","attributeid__c":"a0L9E000002VhttUAC","attributecategoryid__c":"a0K9E000001f5E3UAI","categorycode__c":"ACAT_MyPOWER","categoryname__c":"MyPower","attributeuniquecode__c":"ATT_ANN_CONSTRUCTION","attributeconfigurable__c":true,"attributedisplaysequence__c":"1","attributefilterable__c":true,"attributecloneable__c":true,"isactive__c":true,"attributedisplayname__c":"Année de construction","displaysequence__c":"40","categorydisplaysequence__c":40,"customconfiguitemplate__c":null,"formatmask__c":null,"hasrule__c":false,"isconfigurable__c":false,"ishidden__c":false,"valueinnumber__c":null,"objecttype__c":"vlocity_cmt__ObjectClass__c","querycode__c":null,"isreadonly__c":false,"isquerydriven__c":false,"querylabel__c":null,"id":"a0I9E000002v9k9UAA","isrequired__c":false,"rulemessage__c":null,"uidisplaytype__c":"Dropdown","value__c":null,"valuedatatype__c":"multi picklist","valuedescription__c":null,"attributeRunTimeInfo":{"dataType":"multi picklist","uiDisplayType":"Dropdown","values":[],"default":[]},"$$AttributeDefinitionEnd$$":null}]}';
         //objclass1.getAttributes(prodattr2,new map<String, object>{'row'=>ord},new map<String, object>{'data'=>ord}); 
        
        CustomPricingPlanStepImpl.CharactersticNameValue charvalue = new CustomPricingPlanStepImpl.CharactersticNameValue('ATT_PUISS_PANNEAU','300 Wc');
      
      
     
        Test.stopTest();
        
        
    }
    
}