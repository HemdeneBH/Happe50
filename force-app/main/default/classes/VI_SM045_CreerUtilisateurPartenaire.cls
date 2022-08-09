public without sharing class VI_SM045_CreerUtilisateurPartenaire {
    public static void creerUtilisateur(Map<id,Contact> newContacts){
        Id partnerRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','PartenaireContactRT');
        List<User> listUsersToCreate=new List<User>();
        List<User> listUsersToUpdate=new List<User>(); 
        Set<Id> accountIds=new Set<Id>();
        Set<Id> setExistingPartnerContacts=new Set<Id>();
        for(Contact contactCreated:newContacts.values()){
            accountIds.add(contactCreated.AccountId);
        }
        Profile profilPartenaire=[Select id,name from Profile where name='VI_PurePlayer' limit 1];
        Map<id,account> mapPartnerAccountsAttachedToContacts=new Map<id,account>([Select id,name from account where id in:accountIds]);
        
        Boolean isSandbox = true;
        List<Organization> orgs = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(!orgs.isEmpty()) {
            isSandbox = orgs.get(0).IsSandbox;
        }
        
        String profilPartenaireId=profilPartenaire.id;
        for(Contact contactCreated:newContacts.values()){
            system.Debug('contactCreated.RecordTypeId '+contactCreated.RecordTypeId);
            system.Debug('partnerRecordTypeid '+partnerRecordTypeid);
            if(contactCreated.RecordTypeId==partnerRecordTypeid){
                system.debug('in if');
                User newUser=new User();
                if(Trigger.isInsert){
                    newUser=new User();
                    newUser.ProfileId=profilPartenaireId;
                    newUser.FirstName=contactCreated.FirstName;
                    newUser.LastName=contactCreated.LastName;
                    if(contactCreated.LastName.length()<=4){
                        newUser.Alias=contactCreated.FirstName.substring(0,1) + contactCreated.LastName.substring(0,contactCreated.LastName.length());
                    }
                    else{
                        newUser.Alias=contactCreated.FirstName.substring(0,1) + contactCreated.LastName.substring(0,4);
                    }
                    if(newUser.alias.length()==2){
                        newUser.Alias+='aaa';
                    }
                    else if(newUser.alias.length()==3){
                        newUser.Alias+='aa';
                    }
                    else if(newUser.alias.length()==4){
                        newUser.Alias+='a';
                    }
                    system.debug('contactCreated.VI_TECH_Prenom_sans_espace__c '+contactCreated.VI_TECH_Prenom_sans_espace__c);
                    
                    newUser.Username=contactCreated.FirstName.replaceAll( '\\s+', '') +'.'+contactCreated.LastName.replaceAll( '\\s+', '')+contactCreated.VI_TECH_Compte_sans_espace__c+'@engie.com';
                    if(isSandbox){
                        newUser.Username+='.'+Label.VI_CurrentSandboxName;
                    }
                    system.debug('username '+newUser.username);
                    newUser.CommunityNickname=contactCreated.FirstName+' '+contactCreated.LastName+' '+mapPartnerAccountsAttachedToContacts.get(contactCreated.AccountId).name;
                    
                    newUser.Email=contactCreated.Email;
                    newUser.IsActive=contactCreated.VI_Utilisateur_actif__c;
                    
                    newUser.EmailEncodingKey = 'ISO-8859-1';
                    newUser.TimeZoneSidKey = 'Europe/Paris';
                    newUser.LocaleSidKey = 'fr_FR_EURO';
                    newUser.LanguageLocaleKey = 'fr';
                    newUser.ContactId=contactCreated.id;
                    newUser.UserPermissionsKnowledgeUser=true;
                    newUser.UserPermissionsSFContentUser=true;
                    listUsersToCreate.add(newUser);
                }
                else if(Trigger.isUpdate){
                    setExistingPartnerContacts.add(contactCreated.id);
                }
            }
        }
        if(listUsersToCreate!=null && listUsersToCreate.size()>0){
            insert listUsersToCreate;
            for(user u:listUsersToCreate){
                if(u.IsActive){
                    System.resetPassword(u.Id,True);
                }
            }
        }
        if(setExistingPartnerContacts!=null && setExistingPartnerContacts.size()>0){
            updateUsers(setExistingPartnerContacts);
        }
    }
    
    @future
    public static void updateUsers(Set<Id> contactIds){
        List<User> usersToUpdate=[SELECT id,contact.firstname,contact.lastname,contact.email,contact.VI_Utilisateur_actif__c from User where contactId in:contactIds];
        if(usersToUpdate!=null && usersToUpdate.size()>0){
            Boolean bypassAlreadyTrue=false;
            User currentUser=new user(id=UserInfo.getUserId());
            User currentUserInfo=[SELECT id,ByPass_VR__c from User where id=:UserInfo.getUserId()];
            if(currentUserInfo.ByPass_VR__c){
                bypassAlreadyTrue=true;
            }
            else{
                currentUser.ByPass_VR__c=true;
                update currentUser;
            }
            
            for(User userToUpdate:usersToUpdate){
                userToUpdate.firstname=userToUpdate.contact.firstname;
                userToUpdate.lastname=userToUpdate.contact.lastname;
                userToUpdate.email=userToUpdate.contact.email;
                userToUpdate.IsActive=userToUpdate.contact.VI_Utilisateur_actif__c;
            }
            update usersToUpdate;
            if(!bypassAlreadyTrue){
                currentUser.ByPass_VR__c=false;
                update currentUser;
            }
        }
    }
    
    public static void remplirUserNameContact(List<Contact> newContacts){
        Boolean isSandbox = true;
        List<Organization> orgs = [SELECT IsSandbox FROM Organization LIMIT 1];
        if(!orgs.isEmpty()) {
            isSandbox = orgs.get(0).IsSandbox;
        }
        Id partnerRecordTypeid=VI_ObjectUtils.getRecordTypeId('Contact','PartenaireContactRT');
        Set<Id> accountIds=new Set<Id>();
        for(Contact contactCreated:newContacts){
            accountIds.add(contactCreated.AccountId);
        }
        Map<id,account> mapPartnerAccountsAttachedToContacts=new Map<id,account>([Select id,name from account where id in:accountIds]);
        for(Contact contactCreated:newContacts){
            if(contactCreated.RecordTypeId==partnerRecordTypeid){
                if(contactCreated.FirstName!=null){
                    contactCreated.VI_Nom_d_utilisateur__c=contactCreated.FirstName.replaceAll( '\\s+', '')+'.'+contactCreated.LastName.replaceAll( '\\s+', '')+mapPartnerAccountsAttachedToContacts.get(contactCreated.AccountId).name.replaceAll( '\\s+', '')+'@engie.com';
                }
                if(isSandbox){
                    contactCreated.VI_Nom_d_utilisateur__c+='.'+Label.VI_CurrentSandboxName;
                }
                system.debug('contactCreated.VI_Nom_d_utilisateur__c '+contactCreated.VI_Nom_d_utilisateur__c);
            }
        }
    }
}