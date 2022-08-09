/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 04-14-2022
 * @last modified by  : Clément Bauny
**/
import {
    APPLICATION_SCOPE,
    createMessageContent,
    MessageContext,
    publish,
    releaseMessageContext,
    subscribe,
    unsubscribe
} from 'lightning/messageService';

import ECMC from '@salesforce/messageChannel/hp_ec_clientPortal__c';

const   publishMC = (messageContext, lmsMsg, lmsChannelType) => {
    const message = {
        messageData:{
            message: lmsMsg
        },
        messageType: lmsChannelType
    };
    sessionStorage.setItem(lmsChannelType, lmsMsg);
    publish(messageContext, ECMC, message);
}

const subscribeMC = (self, messageContext, callbk) => {
    const subscription =  subscribe(
            messageContext, ECMC, (message) => {
                callbk(self, subscription, message);
            }, {scope: APPLICATION_SCOPE}); 
}

const getCurrentMessageValue = (lmsChannelType) => {
    const value = sessionStorage.getItem(lmsChannelType);
    return value;
}

const unsubscribeMC = (subscription) => {
    unsubscribe(subscription);
}

export {
    publishMC,
    subscribeMC,
    unsubscribeMC,
    getCurrentMessageValue
};