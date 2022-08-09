public class MP_ByPassTrigger {
    public static Boolean isByPassTrigger(String name) {
        ByPassSettings__c bps = ByPassSettings__c.getInstance();
        if (bps != null && name != null && bps.get(name) != null && (Boolean)bps.get(name))
            return true;
        return false;
    }
}