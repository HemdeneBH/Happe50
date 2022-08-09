public with sharing class HP_SM050_LiveChatTranscript {

    @InvocableMethod(label='Chat send Email')
    public static void processAndSendEmail(List<ChatParam> params) {
        for(ChatParam item : params) {
            if(item.email == null || item.body == null) {
                continue;
            }
            
            String body = processBody(item.body);
            Map<String, String> paramEnvoi = new Map<String, String>{
                'email' => item.email,
                'contenu' => body,
               // 'idClient' =>(item.xdataId != null ?String.valueOf(item.xdataId) : null),
                'idFormulaireCode' => 'SF52',

                'idFormulaireLibCourt' => 'Mail happe',
                'canalCommunicationCode' => 'EMAIL',
                'canalCommunicationLibCourt' => 'Email',

                'objet' => 'Votre échange par chat avec ' + item.prenomAgent + (item.dateCase != null ? (' du ' + item.dateCase.format('dd/MM/yyyy')): '')

            };
            if (!Test.isRunningTest()) HP_UTIL_MailSmsEnvoi.envoiAsync(paramEnvoi);
        }
    }

    public static String processBody(String body) {
        body = body.replaceAll('\n', '');
        body = body.replaceAll('<p>', '\n');
        body = body.replaceAll('</p>', '\n');
        body = body.replaceAll('<br>', '\n').replaceAll('<br/>', '\n');
        body = body.replaceAll('\n\n', '\n');
        String[] chatLines = body.split('\n');
        String result = '';
        Boolean firstChatDemarre = true;
        for(String line : chatLines) {

            if((line.startsWith('Chat démarré') || line.startsWith('chat started')|| line.startsWith('Chat started')) && firstChatDemarre) {
                result += '<p>' + line + '</p>';

                firstChatDemarre = false;
                continue;
            }
                        
            if(line.startsWith('( ')) {

                result += '<p>' + line + '</p>';

            }
        }

        System.debug('@@body : ' + result);
        return result;
    }
    public class ChatParam {
        @InvocableVariable(required=true)
        public String email;
        @InvocableVariable(required=true)
        public String body;
        @InvocableVariable
        public String prenomAgent;
        @InvocableVariable
        public DateTime dateCase;
        @InvocableVariable
        public Integer xdataId;
    }
}