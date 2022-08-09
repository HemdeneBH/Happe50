@isTest(SeeAllData=true)
public with sharing class SM_AP90_BPMfelmodifstatut_TEST {
    static testMethod void modifstatusfel_test() {
        Test.setMock(HttpCalloutMock.class, new SM_AP90_BPMfelModifStatut_Mock());
        Map < String, Object > options = new Map<String,Object>();
        //options.put('email','toto@gmail.com');
        options.put('idcompteclient','1233453');
        options.put('idpersonne','2343432');
        options.put('idContrat','2343432');
        options.put('emailprincipalsel','2343432');
        options.put('emailsaisie','2343432');
        options.put('emailprincipal','2343432');
        options.put('idPropositionCommerciale','2343432');
        Map < String, Object > outmap = new Map<String,Object>();
        System.debug('### options '+options);
        Map < String, Object > options2 = new Map<String,Object>();
        options2.put('emailprincipal','2343432');
        SM_AP90_BPMfelmodifstatut remoteaction = new SM_AP90_BPMfelmodifstatut();
        boolean res2 = remoteaction.invokeMethod('methodName', options2, outmap, options2);
        boolean res = remoteaction.invokeMethod('methodName', options, outmap, options);
        System.assertEquals(true, res);
        //SM_AP90_BPMfelmodifstatut.modifstatusfel(options,outmap,options);
    }
}