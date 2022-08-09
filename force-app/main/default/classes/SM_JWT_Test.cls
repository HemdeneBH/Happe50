@isTest
public class SM_JWT_Test {
    
    @isTest static void SM_JWT_Test(){
        Test.startTest();
            SM_JWT jwt = new SM_JWT('RS256','smileselfsignedcert','3MVG9ZPHiJTk7yFxC.OFBbiscfkrVnG6.xtdKZFbW6K.8oTrGusBIsQGUVuyarsQYqblZ0fPlMTESsxYv7qJH', 'xx@mail.com', 'https://test.salesforce.com');
        Test.stopTest();
    }

}