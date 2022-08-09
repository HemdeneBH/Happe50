/**
 * generic mail helper class
 * */
public with sharing class MP_AP03_MailHelper {
    public static Id getOrgWideEmail() {
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName = 'monprojetpv'];
        if (owea.size() > 0) {
            return owea.get(0).Id;
        } else {
            return null;
        }
    }

}