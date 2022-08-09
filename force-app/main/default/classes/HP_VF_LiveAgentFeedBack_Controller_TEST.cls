/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 02-17-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/

@isTest
public with sharing class HP_VF_LiveAgentFeedBack_Controller_TEST {

    @isTest
    static void SaveNoteSatTest(){
        Test.StartTest(); 
        PageReference feedbackPage = Page.HP_LiveAgent_feedback; 
        feedbackPage.getParameters().put('score', '5');
        feedbackPage.getParameters().put('oed', 'true');
        feedbackPage.getParameters().put('verbatim', 'test verbatim');
        feedbackPage.getParameters().put('chatDetails', '{}');
        feedbackPage.getParameters().put('attachedRecords', '{}');
        feedbackPage.getParameters().put('show', 'true');
        
        Test.setCurrentPage(feedbackPage);
        HP_VF_LiveAgentFeedBack_Controller vfPageFeedBack = new HP_VF_LiveAgentFeedBack_Controller();
        vfPageFeedBack.getShow();
        vfPageFeedBack.oed = true;
        vfPageFeedBack.score = '5';
        vfPageFeedBack.verbatim = 'test verbatim';
        vfPageFeedBack.chatDetails = '{}';
        vfPageFeedBack.attachedRecords = '{}';

        
        vfPageFeedBack.saveNoteSat();
        Test.StopTest();    
    }
}