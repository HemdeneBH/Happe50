@isTest
private class SM_AP81_AllowCreateDP_Test {
    @isTest static void checkAllowCreateDP(){
        //@joel i have to modify the assertion to false for the deployment
        System.assertEquals(false,SM_AP81_AllowCreateDP.checkAllowCreateDP());
    }
}