/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_UTIL002_Utilities.
*@CreatedDate: 06/11/2020
*@LastModified: 06/11/2020
*/
@isTest
public class VI_UTIL002_Utilities_Test {
    
    @isTest
    static void testEncodeFormData(){
        Map < String, String > values=new Map < String, String >();
        values.put('key', 'value');
        VI_UTIL002_Utilities.encodeFormData(values);
    }
    
    @isTest
    static void testformatPhoneNumber(){
        VI_UTIL002_Utilities.formatPhoneNumber('12345678901244');
    }
    
    /*@isTest
    static void testgetIdBanIfSameAddr(){
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        
        multimock.setStaticResource('VI_AdressesApiService');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_UTIL002_Utilities.getIdBanIfSameAddr('abcd');
        Test.stopTest();
    }
    
    @isTest
    static void testaddressUnicityWrp(){
        VI_UTIL002_Utilities.addressUnicityWrp wrp= new VI_UTIL002_Utilities.addressUnicityWrp();
        wrp.idPce='abcd';
        wrp.idPdl='abcd';
        wrp.equals(wrp);
        wrp.hashCode();
    }*/
    
    @isTest
    static void testremoveDuplicatesAdress(){
        Map <String, Object>  obj= new Map <String, Object>();
        List <object> listObj=new List<Object>();
        obj.put('idPointDeLivraison','idPointDeLivraison');
        obj.put('idPointDeComptage','idPointDeComptage');
        listObj.add(obj);
        VI_UTIL002_Utilities.removeDuplicatesAdress(listObj);
        
    }
    
    @isTest
    static void testtransformDatatoOmniscriptAdresses(){
        Map <String, Object>  obj= new Map <String, Object>();
        List <object> listObj=new List<Object>();
        obj.put('idPointDeLivraison','idPointDeLivraison');
        obj.put('idPointDeComptage','idPointDeComptage');
        
        obj.put('numeroVoie','numeroVoie');
        obj.put('libelleVoie','libelleVoie');
        obj.put('codePostal','codePostal');
        obj.put('ville','ville');
        obj.put('codeINSEE','codeINSEE');
        obj.put('complementAdresse','complementAdresse');
        obj.put('idBAN','idBAN');
        
        
        listObj.add(obj);
        
        VI_UTIL002_Utilities.transformDatatoOmniscriptAdresses(listObj,true);
    }
    
    @isTest
    static void testcheckIfpdlExist(){
        VI_SM005_AdressesApiService.PdlPceModel mod=new VI_SM005_AdressesApiService.PdlPceModel('123456789', '123456789', '', '');
        VI_SM005_AdressesApiService.AdresseModel addModel=new VI_SM005_AdressesApiService.AdresseModel('addrLabel', mod, 'citycode', 'postcode', 'complementAdresse', 'noVoie', 'libelleVoie', 'ville', 'idBan');
        List<VI_SM005_AdressesApiService.AdresseModel> listobj= new List<VI_SM005_AdressesApiService.AdresseModel>();
        listobj.add(addModel);
        VI_UTIL002_Utilities.checkIfpdlExist(listobj,'Elec','123456789');
        VI_UTIL002_Utilities.checkIfpdlExist(listobj,'Gaz','123456789');
    }
    /*
    @isTest
    static void testtransformDatatoOmniscriptQuestionConsentement(){
        List < Object > apiData=new List < Object >();
        Map <String, Object> obj=new Map <String, Object>();
        obj.put('id','id');
        obj.put('idQuestionnaire','idQuestionnaire');
        obj.put('codeQuestionnaireQuestion','codeQuestionnaireQuestion');
        obj.put('detailQuestion','detailQuestion');
        obj.put('libelleQuestion','libelleQuestion'); 
        apiData.add(obj);
        VI_UTIL002_Utilities.transformDatatoOmniscriptQuestionConsentement(apiData);
        
    }*/
}