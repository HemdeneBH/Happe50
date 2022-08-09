/*
*@Author: Paul Ghousoub
*@Description: Classe test de VI_SM009_PdlElec.
*@CreatedDate: 04/11/2020
*@LastModified: 05/11/2020
*/ 
@isTest
public class VI_SM009_PdlElec_Test {
    @isTest 
    static void testCallout() {
        Datetime dt=datetime.newInstance(2020, 11, 4); 
        Datetime dt2=datetime.newInstance(2019, 11, 4);
        Test.startTest();
        
        VI_SM009_PdlElec.lirePdl('01199999844520','SMILE','2.0','callout:AuthOctopus');
        VI_SM009_PdlElec.IndexInfo testIndexRetour=new VI_SM009_PdlElec.IndexInfo();
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','REEL','abcd','abcd','abcd',dt,'abcd','REEL','abcd','abcd','abcd');
        system.debug('testIndexRetour1= '+testIndexRetour);
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','abcd','abcd','abcd','abcd',dt,'abcd','BCD','abcd','abcd','abcd');
        system.assertEquals(testIndexRetour.hc,'abcd'); 
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','abcd','abcd','abcd','abcd',dt2,'abcd','BCD','abcd','abcd','abcd');
        system.assertEquals(testIndexRetour.hc,'abcd');
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','REEL','abcd','abcd','abcd',dt2,'abcd','REEL','abcd','abcd','abcd');
        system.assertEquals(testIndexRetour.hc,'abcd');
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','REEL','abcd','abcd','abcd',dt2,'abcd','BCD','abcd','abcd','abcd');
        system.assertEquals(testIndexRetour.hc,'abcd');
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd','BCD','abcd','abcd','abcd',dt2,'abcd','REEL','abcd','abcd','abcd');
        system.assertEquals(testIndexRetour.hc,'abcd');
        testIndexRetour=VI_SM009_PdlElec.getIndex(dt,'abcd',null,null,null,null,null,null,null,null,null,null);
        testIndexRetour=new VI_SM009_PdlElec.IndexInfo();
        Test.stopTest();
    }
}