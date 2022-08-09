/**
 * @File Name          : HP_UTIL_MailSmsEnvoi_QUEUEABLE.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 01/04/2020 à 13:02:35
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/03/2020   Vincent Albiser     Initial Version
**/
public class HP_UTIL_MailSmsEnvoi_QUEUEABLE implements Queueable, Database.AllowsCallouts{

    private Map<String, String> parametresQue;

    public HP_UTIL_MailSmsEnvoi_QUEUEABLE(Map<String, String> parametres) {
        this.parametresQue = parametres;
    }

    public void execute(QueueableContext context) {
        HP_UTIL_MailSmsEnvoi.envoiSync(parametresQue);
    }
}