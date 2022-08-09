@isTest(SeeAllData=true)
public class SM_DelaiePaiementMessageError_test {

    static testMethod void getData_test(){
       String errorLabel = SM_DelaiePaiementMessageError.getErrorMessage('1');
       System.assertNotEquals(null, errorLabel);
    }
}