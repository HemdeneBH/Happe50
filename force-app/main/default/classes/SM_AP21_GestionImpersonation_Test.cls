@isTest
public class SM_AP21_GestionImpersonation_Test {
    
    @isTest
    public static void gestionGenUrlTest() {        
        String urlimperso = SM_AP21_GestionImpersonation.getURLImpersonation('123456789');
        system.assert(urlimperso.startsWithIgnoreCase('https'));
    }


    @isTest
    public static void gestionImpersonationTest() {        
        String urlError = SM_AP21_GestionImpersonation.getURLImpersonationForContact('123456789');
        System.assertEquals('https://Ididnotfindthe.customer',urlError, 'the octopus token service should return a value');
    }

}