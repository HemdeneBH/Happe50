/*
*   @Projet : Smile
*   @description Création d'un utilisateur sur la community si celui n'existe pas
*   @author Guillaume / Mickaël
*   @sprint Sprint 23/24
*/@RestResource(urlMapping='/bptousr')
global class SM_AP58_Bptousr {

    @HttpGet
    global static string getusrid(){

        SM_Digsvc__c ds = SM_Digsvc__c.getInstance();
        String usrnamepostfix = ds.usrnamepostfix__c;
        
        String bp = RestContext.request.params.get('bp');
        System.debug('*** looking for bp : ' + bp);
        System.debug('*** params : ' + RestContext.request.params);

        Id accid;
        Id cttid;
        
        Contact ct;
        List<Contact> cts = [select accountid, id, firstname, lastname from contact where Identifiant_Buisness_Partener__c = :bp];
        System.debug('*** found : ' + cts);
        if(cts.size()==1){
            accid = cts[0].accountid;
            cttid = cts[0].id;
        }else{
            // while debugging...
            // TODO: return null if user does not exist
            account ac = new account(name = 'ac' + bp);
            insert ac;
            accid = ac.id;
            ct = new Contact(firstname = 'client', lastname = 'last'+ bp, accountid = ac.id, Identifiant_Buisness_Partener__c = bp);
            insert ct;
            cttid = ct.id;
        }
        

        /*
        -> username must be email format
        -> Portail account owner must have a role
        -> mandatory TimeZoneSidKey='Europe/Paris', LocaleSidKey='fr_FR', LanguageLocaleKey='fr'
        -> account owner must have a role  ==> owner = xdata // role = en haut de la hiérarchie
        */

        Id profileId = [Select Id From Profile Where Name='SelfSvc_Digital'][0].id;


        User u = new User();
        u.Username = 'clientbp.' + bp + usrnamepostfix;
        u.Email = 'clientbp.' + bp + usrnamepostfix;
        u.FirstName = 'f' + bp;
        u.LastName = 'l' + bp;
        u.CommunityNickname = 'cnn' + bp;
        u.alias = bp.right(8);
        u.ProfileId = profileId;
        u.ContactId = cttid;
        u.emailencodingkey='UTF-8';
        u.TimeZoneSidKey='Europe/Paris';
        u.LocaleSidKey='fr_FR';
        u.LanguageLocaleKey='fr';
            u.IsActive = true;

        System.debug('*** trying to create user : ' + u);
        


        try {
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail= false;
            Database.saveresult sr = Database.insert(u,dlo);
            for(Database.Error err : sr.getErrors()) {
                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                System.debug('fields that affected this error: ' + err.getFields());
            }  
        } catch(Exception ex) {
            return null;
        }
        
        return u.username;
    }

}