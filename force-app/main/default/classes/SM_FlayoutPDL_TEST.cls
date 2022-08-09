@isTest
public class SM_FlayoutPDL_TEST {
    /*
*	@description : Appel depuis la vue 360
*/
    @isTest(SeeAllData = false)
    public static void lirePdl(){
        System.assertNotEquals(SM_FlayoutPDL.lirePdl('01199999844520'), null,'error');     
    }
}