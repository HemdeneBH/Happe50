/*
({
	doInit : function(component, event, helper) {
		var urlEvent = $A.get("e.force:navigateToURL");
		//alert(component.URL);
        urlEvent.setParams({"url": "https://sge.gdfsuez.net/sgePortail/"});
        urlEvent.fire();
        //$A.get("e.force:closeQuickAction").fire();
	}
})*/


({
	doInit : function(component, event, helper) {
		window.open(component.get('v.URL'),"_blank");
        var utilityBarAPI = component.find("utilitybar");
        var firstLoad = true;
        var eventHandler = function(response){
            if(response.panelVisible && !firstLoad) {
                window.open(component.get('v.URL'),"_blank");
                utilityBarAPI.minimizeUtility();
            } else {
                firstLoad = false;
            }
        };
        
        setTimeout(function() {
            utilityBarAPI.onUtilityClick({
               	eventHandler: eventHandler
                }).then(function(result){
                	utilityBarAPI.minimizeUtility();
                    console.log(result);
                }).catch(function(error){
                    console.log(error);
                });
        },1000);
     
	}
})