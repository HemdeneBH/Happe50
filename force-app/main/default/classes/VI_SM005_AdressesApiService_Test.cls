/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM005_AdressesApiService.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/
@isTest 
public class VI_SM005_AdressesApiService_Test {
    @testSetup
    static void testSetup(){
        List<Group> ownerQueue = [Select Id,DeveloperName from Group where Type = 'Queue'];
        
        system.debug('query queue '+ownerQueue);
        Id profileId = [Select Id From Profile Where Name ='VI_PurePlayer'].Id;
        Account acc = VI_TestUtility.createAccount('Marketshot');
        /* Start DDPCM 1319 */
        acc.VI_TypeParcours__c = 'PURE PLAYERS';
        acc.VI_Type_Enseigne__c = 'INDIRECTE';
        /* End DDPCM 1319 */
        insert acc;
        Contact con = VI_TestUtility.createContact('test','Contact','test@gmail.com',acc.Id);
        insert con;
        User u = VI_TestUtility.createCommunityUser(con.Id,profileId,'Test','Test');
        insert u;
    }
    
    @isTest
    public static void testSearchAdress() {
        List<String> listt=new List<String>();
        listt.add('element');
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock(); 
        multimock.setStaticResource('VI_AdressesApiService');
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        /* Start DDPCM 1319 */
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' AND isActive = true and Profile.Name ='VI_PurePlayer'
                 Limit 1];
        /* End DDPCM 1319 */
        System.runAs(u){
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            VI_SM005_AdressesApiService.getAddressByIdResponse testresponse=new VI_SM005_AdressesApiService.getAddressByIdResponse();
            testresponse=VI_SM005_AdressesApiService.searchAddress('abcd','abcd','abcd','abcd' , 'abcd','OUI','abcd','abcd','abcd','abcd','abcd', 'abcd', 'VI', 'local.VIToken');
            system.assertEquals(testresponse.data[0].numeroVoie,'215');
            VI_SM005_AdressesApiService.searchAddress('abcd','abcd','abcd','OUI','','','abcd','abcd', 'abcd','abcd','abcd','abcd','VI', 'local.VIToken');
            VI_SM005_AdressesApiService.searchAddressById('asds','sadsa','VI', 'local.VIToken');
            VI_SM005_AdressesApiService.searchAddressById('asds',null,'VI', 'local.VIToken');
            VI_SM005_AdressesApiService.getAddressById('avcx','20','VI', 'local.VIToken');
            VI_SM005_AdressesApiService.searchAddressByPCE('12334566', 'MORANGIS',null,null,'VI', 'local.VIToken');
            VI_SM005_AdressesApiService.searchAddressByPDL('12334566', 'MORANGIS',null,null,'VI', 'local.VIToken');
            VI_SM005_AdressesApiService.addressUnicityWrp wrp=new VI_SM005_AdressesApiService.addressUnicityWrp();
            wrp.idPce='avd';
            wrp.idPdl='asd';
            wrp.hashCode();
            VI_SM005_AdressesApiService.addressUnicityWrp wrp2=new VI_SM005_AdressesApiService.addressUnicityWrp();
            wrp.equals(wrp2);
            
            VI_SM005_AdressesApiService.PdlPceModel pce=new VI_SM005_AdressesApiService.PdlPceModel('test','test','test','test');
            VI_SM005_AdressesApiService.AdresseModel adress=new VI_SM005_AdressesApiService.AdresseModel('test',pce,'test','test','test','test','test','test','test');
            system.assertequals(adress.citycode,'test');
            
            Test.stopTest();
        }
        
        
    }
    
    @isTest
    public static void testMethod2() {
        /* Start DDPCM 1319 */
        User u =[Select id 
                 From user 
                 Where firstname='Test' And lastname='Test' AND isActive = true and Profile.Name ='VI_PurePlayer'
                 Limit 1];
        /* End DDPCM 1319 */
		System.runAs(u){
            List<String> listt=new List<String>();
            listt.add('element');
            StaticResourceCalloutMock multimock = new StaticResourceCalloutMock(); 
            multimock.setStaticResource('VI_AdressesApiService2');
            multimock.setStatusCode(200);
            multimock.setHeader('Content-Type', 'application/json');
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, multimock);
            String retourIban=VI_SM005_AdressesApiService.getIdBanIfSameAddr('test');
            system.assertEquals('91432_0780_00018', retourIban);
            Test.stopTest();       
        }
    }
}