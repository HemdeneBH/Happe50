({
	doInit : function(component, event, helper) {
        console.log('doInit: START');
        
        //component.set("v.objects",JSON.parse(component.get("v.objectString")));
        // preventing recursive loop
        //if (helper.QUERY_DONE) return;
        //helper.QUERY_DONE = true;
        //helper.doSearch(component, event, helper);
        var queryString = component.get("v.query");
        console.log('doSearch: queryString fetched',queryString);
        
        //var regexp = /RETURNING\s+(\w+\([\w,]+\)[,]\s*)*/gi;
        //var regexp = /\w+\s*\([\w,\s]+.*\)/gi
        var regexp = /\w+\s*\([\w,\s]+( WHERE[ \w\W]*)*\)/gi
        //console.log('doInit: regexp',regexp);
        var tagList = queryString.match(regexp);
        //console.log('doInit: tagList',tagList);
        
        var objects = [];
        var regexp2 = /\w+/gi
        tagList.forEach(function(item){
            console.log('doInit: processing',item);
            var elements = item.match(regexp2);
            console.log('doInit: elements',elements);
            var tmpName = elements.shift();
            console.log('doInit: tmpName',tmpName);
            var appendix = tmpName.indexOf('__');
            console.log('doInit: appendix',appendix);
            if (appendix > 0) {
                tmpName=tmpName.substr(0,appendix); 
                console.log('doInit: appendix removed from tmpName',tmpName);
            }
            objects.push({name: tmpName,
                          elements: elements});
        });
        console.log('doInit: objects',objects);
        component.set("v.objects",objects);
        
        console.log('doInit: END');
    },
    doSearch : function(component, event, helper) {
        helper.doSearch(component, event, helper);
	},
    navigateToObject: function(component, event, helper) {
        console.log('navigateToObject: START');
        
        var objectId = event.getSource().get("v.title");
        console.log('navigateToObject: objectId', objectId);
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
                 "recordId": objectId
        });
        console.log('navigateToObject: firing navigation');
        navEvt.fire();
    }
})