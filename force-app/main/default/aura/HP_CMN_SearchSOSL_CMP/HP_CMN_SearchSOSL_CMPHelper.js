({
	doSearch : function(component, event, helper) {
        console.log('doSearch: START');
       
        var queryString = component.get("v.query");
        console.log('doSearch: queryString fetched',queryString);
        var queryValue = component.get("v.queryValue");
        console.log('doSearch: queryValue fetched',queryValue);
        
        var realQuery = queryString.replace('%%',queryValue);
		console.log('doSearch: realQuery set',realQuery);
        
        var queryAction = component.get("c.executeSearch");
        queryAction.setParams({
            "searchQuery": realQuery
        });
        queryAction.setCallback(this, function(response){
            console.log('doSearch: response received',response);
            
            if (response.getState() == "SUCCESS"){
                var searchResults = response.getReturnValue();
                console.log('doSearch: OK response received',searchResults);
                
                var objects = component.get("v.objects");
                console.log('doSearch: objects',objects);
                
                var results = [];
                searchResults.forEach(function(item, itemKey) {
                    //console.log('doSearch: pushing item',item);
                    //console.log('doSearch: for object',objects[itemKey]);
                    
                    var resultItems = [];
                    item.forEach(function(line){
                        resultItems.push({label:line[((objects[itemKey]).elements)[0]],
                                          detail:line[((objects[itemKey]).elements)[1]],
                                          id:line.Id });
                    });
                    
                    results.push({name:objects[itemKey].name,
                                  values:resultItems});
                });
                component.set('v.results', results);
                console.log('doSearch: results',results);
            } else {
                console.log('doSearch: KO response received',response.getError());
                component.set('v.results', "");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                 "title": "Problème d'execution de la recherche",
                 "type": "error",
                 "message": response.getError()[0].message
                });
                console.log('doSearch: firing showToast',toastEvent);
                toastEvent.fire();
            }
            
            console.log('doSearch: END');
        });
        console.log('doSearch: queryAction set',queryAction);
                
        $A.enqueueAction(queryAction);
        console.log('doSearch: queryAction sent');
	}
})