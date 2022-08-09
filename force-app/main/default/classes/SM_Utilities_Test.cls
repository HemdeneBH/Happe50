@isTest
public class SM_Utilities_Test {

    @isTest
    public static void getRecordTypeIdbyName(){
        Id recordtypeId = SM_Utilities.getRecordTypeIdByName('Contact', 'Contact Smile');
    }
}