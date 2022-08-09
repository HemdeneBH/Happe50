@isTest
public class SM_HarmonicaCaseAssignment_TEST {
    
    static testMethod void assignChildCaseToParentOwner_test(){
        RecordType serviceRecType = [SELECT id 
                                     FROM  RecordType 
                                     WHERE developerName = 'Service' 
                                     AND SobjectType = 'Case'];
        
        Profile prfl = [SELECT Id 
                        FROM Profile 
                        WHERE Name ='SM_Utilisateur métier restriction faible']; 
        
        
        User usr = new User(Alias= 'TestTest', Email= 'TestTestTest1234586@myorg.com'
                            , EmailEncodingKey='UTF-8', LastName='TestTestTest1234586', LanguageLocaleKey='en_US'
                            , LocaleSidKey='en_US', ProfileId = prfl.Id, TimeZoneSidKey='America/New_York'
                            , UserName= 'TestTestTest1234586@myorg.com'); 
        insert usr;
        
        Case serviceCaseParent = new Case();
        serviceCaseParent.Subject = 'harmonica changement fournisseur';
        serviceCaseParent.RecordTypeId = serviceRecType.id;
        serviceCaseParent.Origin = 'Tunnel en ligne';
        serviceCaseParent.status = 'En traitement';
        serviceCaseParent.OwnerId = usr.Id;
        insert serviceCaseParent;
        
        Case harmonicaCaseChild = new Case();
        harmonicaCaseChild.Subject = 'harmonica changement fournisseur';
        harmonicaCaseChild.RecordTypeId = serviceRecType.id;
        harmonicaCaseChild.ParentId = serviceCaseParent.Id;
        harmonicaCaseChild.Status = 'Nouveau';
        insert harmonicaCaseChild;
        
        //create user and assign the ParentCase to that user 
        /*Blob b = Crypto.GenerateAESKey(128);
String h = EncodingUtil.ConvertTohex(b);
String uid = h.SubString(0,8);*/
        
        list<Case> listCase = new list<Case>();
        listCase.add(serviceCaseParent);
        Case caseparent = [SELECT id, RecordType.Id, RecordType.DeveloperName, Origin, Status
                           FROM Case 
                           WHERE Id=:serviceCaseParent.Id];
        
        Test.startTest();
        SM_HarmonicaCaseAssignment.assignChildCaseToParentOwner(new Map<Id, Case>{caseparent.Id => caseparent}, new Map<Id, Case>{caseparent.Id => caseparent});
        
        List<Case> assignedCasesToUser = [SELECT Id, OwnerId 
                                          FROM Case 
                                          WHERE OwnerId=:Usr.Id];
        
        System.assertEquals(2, assignedCasesToUser.size());
        Test.stopTest();
    }
    
}