/**
 * @description       : 
 * @author            : Slimene Belhaj Ali
 * @group             : 
 * @last modified on  : 02-18-2021
 * @last modified by  : Slimene Belhaj Ali
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-18-2021   Slimene Belhaj Ali   Initial Version
**/
public class HP_SM054_RedirectHome {
    public HP_SM054_RedirectHome() {
        Auth.SessionManagement.finishLoginFlow();
    }
    
   public PageReference init() {
        return new PageReference('/lightning/page/home');
    }
}