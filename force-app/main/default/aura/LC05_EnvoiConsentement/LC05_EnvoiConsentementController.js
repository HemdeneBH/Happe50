({
	doInit : function(component, event, helper) {
		var action = component.get('c.initDatas');

		action.setParams({
			contactId : component.get('v.recordId')
		});
		action.setCallback(this, function(response){
			if (component.isValid() && response.getState()==='SUCCESS') {
				var content = JSON.parse(response.getReturnValue());
				component.set('v.lead', content.lead);
				component.set('v.consentementEngie', content.xdataConsent ? 'Oui' : (content.xdataConsent === null ? 'Non trouvé' : 'Non'));
				component.set('v.consentementPartenaire', content.xdataConsentPartenaire ? 'Oui' : (content.xdataConsentPartenaire === null ? 'Non trouvé' : 'Non'));
				component.set('v.xdataId', content.xdataId);
				component.set('v.datas', content);
				if (content.error)
					component.set('v.errorMessage',content.error);
			}
			else
				component.set('v.errorMessage',helper.getErrors(response));
		});
		$A.enqueueAction(action);
	},

	cancelModal : function(component, event, helper){
		$A.get("e.force:closeQuickAction").fire();
	},

	handleSendConsent : function(component, event, helper) {
		var action = component.get('c.sendXDataConsent');
		console.log('step1');
		action.setParams({
			leadConsent : JSON.stringify(component.get('v.lead'))
		});
		action.setCallback(this, function(response) {
			console.log(response.getState());
			if (response.getState() === 'SUCCESS' && component.isValid()) {
				var content = JSON.parse(response.getReturnValue());
				if (content.error) {
					console.log(content.error);
					component.set('v.errorMessage', content.error);
				}
				else
					$A.get("e.force:closeQuickAction").fire();
			}
			else {
				component.set('v.errorMessage', helper.getErrors(response));
			}
		});
		$A.enqueueAction(action);
	}
})