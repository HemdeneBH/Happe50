@isTest
public class SM_SM06_JitHandler_TEST {
    
    
 static testMethod void testCreateAndUpdateUser() {
        SM_SM06_JitHandler handler = new SM_SM06_JitHandler();
        Map<string,String> createdUser=  new Map<String, String>
        {   'language' => 'en_US' ,
            'Username'=>'testuserprovCreated@engie.com' ,
            'firstName'=>'firstNameTest', 
            'lastName'=>'lastNameTest',
            'Title'=>'Title',
            'CompanyName'=>'CompanyName',
            'AboutMe'=>'AboutMe',
            'Street'=>'Street',
            'State'=>'State',
            'City'=>'City',
            'Zip'=>'1111',
            'Country'=>'France',
            'MobilePhone'=>'0612345678',
            'Phone'=>'0612345678',
            'email'=>'testuserprovCreated@engie.com',
            'CommunityNickname'=>'testuserprovCreated', 
            'uid'=> '12OI1',
            'department'=> 'DGP_PART_Armatis_Caen',
            'groups'=> 'GG-APP-SMILE-Hyperviseur-partenaire-D77'
              }; 
        User u = handler.createUser(null,null,null,'testuserprovCreated@engie.com', createdUser ,null);
     	insert(u);
     	
     
        String uid = u.id;
     	System.assertNotEquals(uid, '');
     	
     
     	Map<string,String> updatedUser=  new Map<String, String>
        {   'language' => 'en_US' ,
            'Username'=>'testuserprovUpdated@engie.com' ,
            'firstName'=>'firstNameTestupdate', 
            'lastName'=>'lastNameTestupdate',
            'Title'=>'Title',
            'CompanyName'=>'CompanyName',
            'AboutMe'=>'AboutMe',
            'Street'=>'Street',
            'State'=>'State',
            'City'=>'City',
            'Zip'=>'1111',
            'Country'=>'France',
            'MobilePhone'=>'0612345678',
            'Phone'=>'0612345678',
            'email'=>'testuserprovUpdated@engie.com',
            'CommunityNickname'=>'testuserprovUpdated', 
            'uid'=> '12OI1',
            'department'=> 'DGP_PART_Armatis_Caen',
            'groups'=> 'GG-APP-SMILE-Hyperviseur-partenaire-D77'
              }; 
     
     
     	handler.updateUser(uid, null, null, null, 'testuserprovUpdated@engie.com', updatedUser, null);
     	List<User> updatedUserToUpdate = new List<User>();
        updatedUserToUpdate = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:uid];
     	//assert TODO
     	System.assertEquals(updatedUserToUpdate[0].LastName, 'lastNameTestupdate');
     	System.assertEquals(updatedUserToUpdate[0].firstName, 'firstNameTestupdate');
    }
}