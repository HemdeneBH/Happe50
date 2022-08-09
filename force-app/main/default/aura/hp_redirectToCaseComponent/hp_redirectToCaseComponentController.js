({
    onInit : function(component) {
        const empApi = component.find('empApi');

        empApi.onError($A.getCallback(error => {
            console.error('EMP API error: ', JSON.stringify(error));
        }));

        empApi.subscribe('/event/HP_new_diabolocom_case__e', -1, $A.getCallback(eventReceived => {
            console.log('Received event ', JSON.stringify(eventReceived));
            var userId = $A.get( "$SObjectType.CurrentUser.Id");
            console.log('userId ', userId);
            if(eventReceived.data.payload.HP_UserId__c == userId) {
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                "recordId": eventReceived.data.payload.HP_caseId__c,
                "slideDevName": "Detail"
                });
                navEvt.fire();
            }
            
        }))
        .then(subscription => {

            console.log('Subscription request sent to: ', subscription.channel);
            component.set('v.subscription', subscription);
        });
    }

})