@IsTest
public with sharing class HP_SM050_LiveChatTranscript_TEST {
    @isTest static void processAndSendEmail_Test() {
        List<HP_SM050_LiveChatTranscript.ChatParam> params = new List<HP_SM050_LiveChatTranscript.ChatParam>();
        HP_SM050_LiveChatTranscript.ChatParam param = new HP_SM050_LiveChatTranscript.ChatParam();
        param.email = 'test@test.com';
        param.prenomAgent = 'xxx';
        param.dateCase = System.now();
        param.xdataId = 123;
        param.body = 'Origine du Chat : HP Digital<br/>( 45s ) Soufiane K: Bonjour, je suis Soufiane, votre conseiller happ-e, comment puis-je vous aider ?';
		params.add(param);
        HP_SM050_LiveChatTranscript.processAndSendEmail(params);
    }
}