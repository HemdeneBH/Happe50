/*
*@Author: Paul Ghoussoub
*@Description: Classe de test de VI_SM050_Installation
*@CreatedDate: 22/03/22
*@LastModified: 22/03/22
*/
@isTest
public class VI_SM050_Installation_Test {
    @isTest
    public static void callInstallations_test1() {
        
        StaticResourceCalloutMock multimock = new StaticResourceCalloutMock();
        multimock.setStaticResource('VI_Installations_Mock');
        
        multimock.setStatusCode(200);
        multimock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, multimock);
        VI_SM050_Installation.InstallationsWrapper testdata=VI_SM050_Installation.callInstallations('1234', 'VI', 'local.VIToken');
        system.debug('testdata '+testdata);
        system.assertEquals(testdata.data[0].idLocal,123);
        system.assertEquals(testdata.data[0].id,123);
        system.assertEquals(testdata.data[0].idPointDeLivraison,123);
        system.assertEquals(testdata.data[0].numeroPointDeLivraison,'string');
        system.assertEquals(testdata.data[0].numeroInstallation,'string');
        system.assertEquals(testdata.data[0].secteurActivite,'n/a');
        system.assertEquals(testdata.data[0].typeTarif,'string');
        system.assertEquals(testdata.data[0].typeService,'string');
        system.assertEquals(testdata.data[0].uniteReleve,'string');
        system.assertEquals(testdata.data[0].dateDebutContrat,'2022-03-22');
        system.assertEquals(testdata.data[0].datePremiereMiseEnService,'2022-03-22');
        system.assertEquals(testdata.data[0].dateDerniereVisite,'2022-03-22');
        system.assertEquals(testdata.pagination.pageActuelle,'string');
        system.assertEquals(testdata.pagination.elementParPage,0);
        system.assertEquals(testdata.pagination.pagePrecedente,'string');
        system.assertEquals(testdata.pagination.pageSuivante,'string');
        
        Test.stopTest();
    }
    
}