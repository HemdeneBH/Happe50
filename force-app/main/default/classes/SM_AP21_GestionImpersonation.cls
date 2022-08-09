global class SM_AP21_GestionImpersonation {


    @AuraEnabled(cacheable=true)
    public static String getURLImpersonationForContact(String contactID) {
        String refbp;
        Contact[] cts = [select Identifiant_Buisness_Partener__c from contact where id = :contactID ];
        if(cts==null || cts.size()!=1){
            return 'https://Ididnotfindthe.customer';
        }
        return getURLImpersonation(cts[0].Identifiant_Buisness_Partener__c);
    }
    
    
public static String getURLImpersonation(String refBP) {
    
    String LienVisualiserEC;
    
    String JetonClair;
    String JetonChiffre;
    String JetonChiffreFinal;
    
    String loginConseiller;
    String currentToken; 
    
    String modulus = Label.SM_CL02_Encryption_Modulus;
    String exponent = Label.SM_CL03_Encryption_Exponent;     
     
    SM_AP22_ImpersonationEncryption service = new SM_AP22_ImpersonationEncryption(modulus,exponent); 
    
    // Login and Id Conseiller
    loginConseiller = UserInfo.getUserName();    
    
    // get Current Token    
    currentToken = SM_Utils_TokenOctopus.getOctopusToken(true);
    
    string uname = SM_Utils_TokenOctopus.getOctopusUsername();
    if(uname==null) uname = 'HV1002';
	/*
    User[] usrs = [select FederationIdentifier from User where id = :userinfo.getUserId() ];
    if(usrs.size()>0 && usrs[0].FederationIdentifier != null && usrs[0].FederationIdentifier != ''){
        uname = usrs[0].FederationIdentifier.left(uname.indexof('@'));
    }
	*/
    
    JetonClair = uname + ';'+currentToken+';Conseillers;'+refBP;  
    //JetonClair = loginConseiller+';'+currentToken+';Conseillers;'+refBP;   
    
    // JetonClair Encryption
     
    
    JetonChiffre = service.encrypt(JetonClair);
    
    JetonChiffreFinal = EncodingUtil.urlEncode(JetonChiffre, 'UTF-8');
    
    LienVisualiserEC = Label.SM_CL01_URL_CEL+JetonChiffreFinal;

    
	return LienVisualiserEC;        
}
}