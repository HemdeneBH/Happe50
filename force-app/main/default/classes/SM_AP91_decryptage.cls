public class SM_AP91_decryptage {

    public static string callapidecryptage(String valuetodecrypt){

        String decryptedvalue;

        String endPointParams = '?urlParamsCrypt='+valuetodecrypt;
        HttpResponse res = CalloutManager.sendRequest('Debranchement', endPointParams, 'POST', CalloutManager.Scope.WRITE,null,null);
        system.debug('## res '+res.getbody());
        system.debug('## res '+res);
        
        if(res !=null && res.getbody() != null){
            decryptedvalue = res.getbody();
        }
        
        return decryptedvalue;
    }
}