/**
* @description       : Just-in-time provisioning for SSO users (FT1-4178/FT1-4179)
* @author            : Ahmed LAAMRI
* @group             : 
* @last modified on  : 28-05-2021
* @last modified by  : David ATTALI
* Modifications Log 
* Ver   Date         Author          Modification
* 1.0   21-04-2021   Ahmed LAAMRI    Initial Version
* 1.1   28-05-2021   David ATTALI    CallCenter InternalName and comments
* 1.2   11-02-2022   Nourelimane SMOUNI  Fix Authentification problem due to firstName on 3 leters 
**/
global class SM_SM06_JitHandler implements Auth.SamlJitHandler {    
    
    private class JitException extends Exception{}    
    
    /**
    * @description Handle user fields mapping
    * @param Boolean create, User u, Map<String, String> attributes, String federationIdentifier, boolean isStandard
    * @return void
    */
    private void handleUser(boolean create, User u, Map<String, String> attributes, String federationIdentifier, boolean isStandard) {       
        
        try {
            
            if(create && attributes.containsKey('federationIdentifier')) {
                u.FederationIdentifier = attributes.get('federationIdentifier');
            } else {
                u.FederationIdentifier = federationIdentifier;
            }
            
            if (attributes.containsKey('firstName')) {
                u.FirstName = attributes.get('firstName');
            }
            
            if (attributes.containsKey('lastName')) {
                u.LastName = attributes.get('lastName');
            }
            
            if (attributes.containsKey('email')) {
                u.Email = attributes.get('email');  
                u.Username = attributes.get('email');
                u.Distributor_Login__c = attributes.get('email');
            }
            
            if (attributes.containsKey('uid')) {
                u.gaia__c = attributes.get('uid');
                u.identifiantUnique__c = attributes.get('uid');
            }
            
            // Set alias
            if  (u.FirstName != null && u.FirstName.length() >= 3 &&  u.LastName != null) {
                u.Alias = u.LastName.substring(0, 1) + u.FirstName.substring(0, 3);
            }  
            
            u.IsActive = true;
            
            u.LOCALESIDKEY='fr_FR_EURO';
            u.LANGUAGELOCALEKEY = 'fr';
            u.TIMEZONESIDKEY = 'Europe/Paris';
            u.EMAILENCODINGKEY = 'ISO-8859-1';

            // Set CallCenter
            u.CallCenterId = [SELECT Id FROM CallCenter WHERE InternalName = 'PureCloudForSalesforceLightning'].Id;
            
            // Set Okta group on user (used later in the flows)
            u.SM_TECH_GroupOKTA__c = attributes.get('groups'); 
			SM_OKTA_Presta_Site__mdt[] prestaSites;
            // Department dependent mapping
            if (attributes.containsKey('department')) {
                
                String departement =  attributes.get('department');
                
                // Get SM_OKTA_Presta_Site__mdt
                prestaSites = [SELECT SMILE_Prestataire__c, SMILE_Site__c, SMILE_Trigramme_Prestataire__c, TelephoneSite__c,SMILE_Trigramme_Site__c, SMILE_Equipe__c
                                                          FROM SM_OKTA_Presta_Site__mdt WHERE OKTA_Department__c = :departement];
                
                
                if(prestaSites.size() > 0){
                    
                    u.Prestataire__c = prestaSites[0].SMILE_Prestataire__c;
                    u.Site__c = prestaSites[0].SMILE_Site__c;
                    u.Trigramme_Presta__c = prestaSites[0].SMILE_Trigramme_Prestataire__c;
                    u.Trigramme_Site__c = prestaSites[0].SMILE_Trigramme_Site__c;
                    u.Equipe__c = prestaSites[0].SMILE_Equipe__c;
                    u.Phone = prestaSites[0].TelephoneSite__c;
                    
                } else {
                    u.Prestataire__c = 'ENGIE';
                    u.Trigramme_Presta__c ='ENG';
                }
            }

            
            
            
            String groups =  attributes.get('groups');

            // Get SM_OKTA_Persona__mdt
            SM_OKTA_Persona__mdt[] personas;
            if (attributes.containsKey('groups')) {
                personas = [SELECT SMILE_Dashboard_Homepage__c,   SMILE_Permission_Sets__c,SMILE_Profile__c,SMILE_Public_Groups__c,
                            SMILE_Queues__c, SMILE_Role__c FROM SM_OKTA_Persona__mdt WHERE OKTA_Group__c = :groups];                              
            }   
            
            // Get SM_OKTA_Presta_Role__mdt
            SM_OKTA_Presta_Role__mdt[] prestaRoles;
            if (String.isNotBlank(u.Prestataire__c)) {
                prestaRoles = [SELECT Role__c FROM SM_OKTA_Presta_Role__mdt WHERE Prestataire__c = :u.Prestataire__c];                                                                  
            }   
            
            // Set dashboard homepage
            if(String.isNotBlank(personas[0].SMILE_Dashboard_Homepage__c)){
                u.dashboard_homepage__c = personas[0].SMILE_Dashboard_Homepage__c;
            }
            
            // Set knowledge and service permissions
            u.UserPermissionsKnowledgeUser = true;
            u.UserPermissionsSupportUser = true;
            
            // Set profile
            if(personas.size() > 0 ){
                if(String.isNotBlank(personas[0].SMILE_Profile__c)){
                    String profileName = personas[0].SMILE_Profile__c;
                    u.ProfileId  = [SELECT Id FROM profile WHERE Name = :profileName].Id;
                }
                // Set role   
            	if(String.isNotBlank(personas[0].SMILE_Role__c) ){
                    
                if(create) {
                    String role; 
                    
                    //TrigrammePresta_TrigrammeSite_Conseiller_1
                    system.debug('personas[0].SMILE_Role__c = '+personas[0].SMILE_Role__c);
                    
                    //exemple de valeur : TrigrammePresta_TrigrammeSite_Conseiller_1'
                    role= personas[0].SMILE_Role__c.replace('TrigrammePresta',u.Trigramme_Presta__c);// remplace trigramme Presta
                    
                    role= role.replace('TrigrammeSite',u.Trigramme_Site__c );// remplace trigramme site
                        
                    if (personas[0].SMILE_Role__c=='Prestataire'){
                        role = prestaRoles[0].Role__c;   	
                    }
                    
                    if(prestaSites.size() > 0){
                        system.debug('personas[0].SMILE_Role__c = '+personas[0].SMILE_Role__c);
                        system.debug('prestaSites[0].SMILE_Prestataire__c = '+prestaSites[0].SMILE_Prestataire__c);
                        system.debug('prestaSites[0].SMILE_Site__c = '+prestaSites[0].SMILE_Site__c);
                        if (personas[0].SMILE_Role__c == 'LibellePrestataire' )
                            role = prestaSites[0].SMILE_Prestataire__c;
                        if (personas[0].SMILE_Role__c == 'LibelleSite' )
                            role = prestaSites[0].SMILE_Site__c;
                    }
                    
                    system.debug('role final = '+role);
                    
                    
                    if(String.isNotBlank(role)){                      
                       u.userRoleId = [SELECT Id from UserRole WHERE DeveloperName = :role].Id;
                    }
                  }
              }  
    
            }
            

                system.debug('username = '+u.UserName);
                system.debug('lasname = '+u.LastName);
                system.debug('firstname = '+u.FirstName);
                system.debug('alias = '+u.Alias);
            	system.debug('userRoleId = '+u.userRoleId);
                system.debug('fin');
                
       
                
            
            	if(!create) {
                    if(String.isNotBlank(personas[0].SMILE_Permission_Sets__c) ){
            		Set<String> PsetSetName = new Set<String> (personas[0].SMILE_Permission_Sets__c.split(','));
                    system.debug('personas[0].SMILE_Permission_Sets__c = '+personas[0].SMILE_Permission_Sets__c);
                    system.debug('PsetSetName = '+PsetSetName);
                    system.debug('UserId = '+u.Id);
                    Set<Id> PsetSetId = findPermissionSet ( PsetSetName);
                    system.debug('PsetSetId = '+PsetSetId);
                    updateUserPermissionSet (u.Id, PsetSetId);
				}
            		update(u);
            }
             
            
            
        } catch(Exception e) {
        }
    }
    
    /**
    * @description Handle Just-in-time provisioning
    * @param boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion
    * @return void
    */
    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               handleUser(create, u, attributes, federationIdentifier, true);
                           }
    
    /**
    * @description Create a user
    * @param Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion
    * @return User
    */
    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               
                               User u = new User();
                               
                               handleJit(true, u, samlSsoProviderId, communityId, portalId,
                                         federationIdentifier, attributes, assertion);
                               
                               return u;
                           }
    
    /**
    * @description Update a user
    * @param Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion
    * @return void
    */
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion) {
                               
                               // This class only handle creation of users for the moment
                                User u = [SELECT Id,Alias,LastName,FirstName,ProfileId,Prestataire__c,Department,Site__c ,City, Trigramme_Presta__c ,
                 						Trigramme_Site__c ,Equipe__c ,Phone,userRoleId FROM User WHERE Id=:userId];
        
                                handleJit(false, u, samlSsoProviderId, communityId, portalId,
                                federationIdentifier, attributes, assertion);
                           }
    
    
    public Boolean updateUserPermissionSet (Id userId, Set<Id>  permissionSetIds) {
        Boolean result = false;
        try {
            if (permissionSetIds != null && userId != null) { 
                result = true;
                /*
                List<PermissionSetAssignment> existingPermissionSetAssignmentToDelete = findPermissionSetAssignment (userId,permissionSetIds);
                if (!existingPermissionSetAssignmentToDelete.isEmpty()) {
                    delete existingPermissionSetAssignmentToDelete;
                }
				*/
                List<PermissionSetAssignment> psaListToInsert = new List<PermissionSetAssignment>(); 
                
                for (String psId : permissionSetIds) {
                      psaListToInsert.add(new PermissionSetAssignment(PermissionSetId = psId, AssigneeId = userId));
                    }
                if (!psaListToInsert.isEmpty()) {
                    Database.insert(psaListToInsert, false);
                }
            }
        } catch(Exception e) {
            System.debug('### An error occurred updating user Permission Set: ' + e.getMessage());
            result = false;
        }
        
        return result;  
    }

	public List<PermissionSetAssignment> findPermissionSetAssignment (Id userId,Set<Id> PermissionSetIds) {
        return findPermissionSetAssignment (new Set<Id> {userId},PermissionSetIds);
    }
    
    public List<PermissionSetAssignment> findPermissionSetAssignment (Set<Id> userIds,Set<Id> PermissionSetIds) {
        return [SELECT Id, PermissionSetId,PermissionSet.isOwnedByProfile, AssigneeId 
            FROM PermissionSetAssignment WHERE AssigneeId IN :userIds AND PermissionSetId NOT IN :PermissionSetIds AND PermissionSet.isOwnedByProfile = false];  
    }
    
    
    
    
    public Set<Id> findPermissionSet (Set<String> PersmissionSetNames) {
			Set<Id> permissionSetIds = new Set<Id>(New Map<Id, PermissionSet>([SELECT Id FROM PermissionSet WHERE Name IN :PersmissionSetNames]).keySet());
        return permissionSetIds;
       
    }
    
}