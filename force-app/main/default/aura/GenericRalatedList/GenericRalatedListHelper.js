({
    //helpter load data 
    loadData : function(component) {
        //load action
        var action = component.get("c.loadDataFromConfig");
        //set parameters action
        var VFRec = component.get('v.VFRecordId');
        if(component.get('v.VFRecordId') != null && component.get('v.VFRecordId') != '')
            component.set('v.recordId', component.get('v.VFRecordId'));

        var searchFilds = component.get("v.searchFilds");
        var operator = component.get("v.operator");
        console.log('****searchFilds***:',searchFilds);
        console.log('****operator***:',operator);

        // console.log('****pageSize***:',component.get("v.pageSize").toString());
        // console.log('****pageNumber***:',component.get("v.pageNumber").toString());

        action.setParams({ fieldSetName : component.get("v.fieldSetName"),typeFieldSource : component.get("v.typeFieldSource"),  whereClause : component.get("v.whereClause"),objectName : component.get("v.objectName"),

                          parentName : component.get("v.parentId"),recordId : component.get("v.recordId"),importantField : component.get("v.importantField"),  searchFilds:component.get("v.searchFilds"), operator:component.get("v.operator"),
                        
                          pageSize : component.get("v.pageSize").toString(),pageNumber : component.get("v.pageNumber").toString()});

        var that = this;
        //set callback action
	        action.setCallback(this, function(response) {
            //test if state is seccess
            if(component.isValid() && response.getState() === "SUCCESS") {
                //get server data
                var result = response.getReturnValue();
                console.log('****NEW resuuuuuuuuuuuuuuuult***:', result);

                var dataResultCount = result.count;
                var data = result.data;
                var editAccess = result.editAccess;
                var deleteAccess = result.deleteAccess;

                //parsing data
                for(var i = 0; i < data.length; i ++) {
                	data[i].editAccess = (editAccess.indexOf(data[i].Id) > -1 ? true: false);
                	data[i].deleteAccess = (deleteAccess.indexOf(data[i].Id) > -1 ? true: false);
                    //get field name
                    var keys = Object.keys(data[i]);
                    for(var j = 0; j < keys.length; j ++) {
                        try {
                            //test if field is object (relationship)
                            if(data[i][keys[j]] instanceof Object) {
                                //update data to be showing in table
                               data[i][keys[j]+'NameLabel'] = data[i][keys[j]].Name;
                               data[i][keys[j]+'Name'] = '/' + data[i][keys[j]].Id;
                            }
                        }catch(e){}
                    }
                }
                var columns = result.columns;
                //Boolean is not supported by datatable component that why we strasfom it on yes no
                for(var i = 0; i < columns.length; i ++) {
                	if(columns[i].type == 'boolean') {
                		for(var j = 0; j < data.length; j ++) {
                			data[j][columns[i].fieldName] = (data[j][columns[i].fieldName] ? 'YES' :'NO');
                			columns[i].type = 'text';
                		}
                    } else if(columns[i].type == 'date') {
                        columns[i].typeAttributes = {  
                                                                            day: 'numeric',  
                                                                            month: 'short',  
                                                                            year: 'numeric',  
                                                                            hour: '2-digit',  
                                                                            minute: '2-digit',  
                                                                            second: '2-digit',  
                                                                            hour12: false};
                	}
                }
                //set data in component
                component.set("v.dataResultCount", dataResultCount);
                component.set("v.dataResult", data);
                component.set("v.dataDisplay", data);
                component.set("v.deleteAccess",  deleteAccess);
                component.set("v.editAccess", editAccess);
                var actions = that.getRowActions.bind(this, component);
                result.columns.push({ type: 'action', typeAttributes: { rowActions: actions } });
                component.set("v.columnsResult", result.columns);
                that.loadFormaterData(component);
                this.preparePagination(component);
            }
        });
        //invoke request 
        $A.enqueueAction(action);
    },
    //Prepare pagination after loading dataResult from server or after changing pageSize
    preparePagination: function (component) {
        var dataResult = component.get('v.dataResult');
        var dataCount = dataResult.length;
        var pageSize = component.get("v.pageSize");

        var totalPages = Math.ceil(dataCount/pageSize) > 0 ? Math.ceil(dataCount/pageSize) : 1;

        component.set("v.totalPages", totalPages);
        component.set("v.pageNumber", 1);
        component.set("v.dataCount", dataCount);

        this.loadPageData(component);
    },
    //Prepare pagination after filtering
    preparefilterPagination: function (component) {
        var dataSearch = component.get('v.dataSearch');
        var dataCount = dataSearch.length;
        var pageSize = component.get("v.pageSize");

        var totalPages = Math.ceil(dataCount/pageSize) > 0 ? Math.ceil(dataCount/pageSize) : 1;

        component.set("v.totalPages", totalPages);
        component.set("v.pageNumber", 1);
        component.set("v.dataCount", dataCount);

        this.loadPageData(component);
    },
    //load dataDisplay from dataResult OR dataSearch for the appropriate page
    loadPageData: function (component) {
    
        var pageSize = component.get("v.pageSize");
        var pageNumber = component.get("v.pageNumber");

        if(!component.get("v.textSearch") || component.get("v.textSearch").length === 0) {
            var dataResult = component.get("v.dataResult");
            var dataDisplay = dataResult.slice((pageNumber-1)*pageSize, pageNumber*pageSize);
            component.set("v.dataDisplay", dataDisplay);
        } else {
            var dataSearch = component.get("v.dataSearch");
            var dataDisplay = dataSearch.slice((pageNumber-1)*pageSize, pageNumber*pageSize);
            component.set("v.dataDisplay", dataDisplay);
        }
        
    },
    //Helper sort data
    sortData: function (cmp, fieldName, sortDirection, dataKey) {
        //get data from component
        var data = cmp.get("v." + dataKey);
        //define direction sort
        var reverse = sortDirection !== 'asc';
        //sort data
        data.sort(this.sortBy(fieldName, reverse));
        //set data in component
        cmp.set("v." + dataKey, data);
        this.loadPageData(cmp);
    },
    //define condition sorting
    sortBy: function (field, reverse, primer) {
        //get sorting field
        var key = primer ? function(x) {return primer(x[field])} : function(x) {return x[field]};
        //reverse direction sort
        reverse = !reverse ? 1 : -1;
        //Condition defined by sorting
        return function (a, b) {
            var a1 = key(a);
            var b1 = key(b);
            return reverse * ((a1 > b1) - (b1 > a1));
        }
    },
    //Helper filter data
    filterData : function(cmp) {
        //get data
        var data =  cmp.get("v.dataResult");
        //get text rearching
        var searchtext =  cmp.get("v.textSearch");

        if(!cmp.get("v.textSearch") || cmp.get("v.textSearch").length === 0)
            this.preparePagination(cmp);
        else {
        var resultFilter = [];
        //Parsing data
        for(var i = 0; i < data.length; i ++) {
            //get fields name
            var keys = Object.keys(data[i]);
            for(var j = 0; j < keys.length; j ++) {
                try {
                    //test if serching text in data
                    if(data[i][keys[j]].toString().toLowerCase().indexOf(searchtext.toLowerCase()) >= 0) {
                        //Add row in result
                        resultFilter.push(data[i]);
                        break;
                    }
                }catch(e){}
            }
        }
        //set data in component
            cmp.set("v.dataSearch",resultFilter);
            this.preparefilterPagination(cmp);
        }
    },
    //Load data section from all data
    loadFormaterData : function(component) {
		var dataList = [];
        var data = component.get('v.dataResult');
        var columns = component.get('v.columnsResult');
        var maxdefined = (component.get('v.maxItemDisplay') != null ? component.get('v.maxItemDisplay'): 2);
        var maxItem = (data.length > maxdefined ? maxdefined : data.length);
        for(var i = 0; i < maxItem; i ++) {
            var currentObject = {editAccess :data[i].editAccess , deleteAccess : data[i].deleteAccess, Id : data[i].Id};
            currentObject.data = [];
            for(var j = 0; j < columns.length; j ++) {
            	if( columns[j].type == 'action') {
	        		continue;
	            }
                try {
                // if it is lookup
                if(columns[j].type == 'url'){
                	currentObject.data.push({fieldName :  columns[j].fieldName, label : columns[j].label, link : data[i][columns[j].fieldName], value : data[i][columns[j].fieldName + 'Label'], type : columns[j].type});
                }else if(columns[j].type == 'date') {
                    var currentDate = new Date(data[i][columns[j].fieldName]);
                    if(currentDate.getSeconds() == 0 && currentDate.getMinutes() == 0) {
                        currentObject.data.push({fieldName :  columns[j].fieldName, label : columns[j].label,
                                                 value : data[i][columns[j].fieldName], type : columns[j].type, time: false});
                    } else {
                        currentObject.data.push({fieldName :  columns[j].fieldName, label : columns[j].label,
                                                 value : data[i][columns[j].fieldName], type : columns[j].type,
                                                 time: true, hour : currentDate.getHours()
                                                 , minute : currentDate.getMinutes(), second : currentDate.getSeconds()});
                    }
                }else {
                	currentObject.data.push({fieldName :  columns[j].fieldName, label : columns[j].label, value : data[i][columns[j].fieldName], type : columns[j].type});
                }


                } catch(e) {}
            }
            dataList.push(currentObject);
        }
        component.set('v.dataFormatter', dataList);
	},
	//get dynamic menu list
	 getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        actions.push({
            'label': 'Voir',
            'name': 'View'
        });
        var editAccess = cmp.get("v.editAccess");
        var deleteAccess = cmp.get("v.deleteAccess");
        if(/*editAccess.indexOf(row.Id) > -1 &&*/ cmp.get('v.hasEdit'))   {
        actions.push({
                'label': 'Edit',
                'name': 'Edit'
            });
        } 
         if(/*deleteAccess.indexOf(row.Id) > -1 && */cmp.get('v.hasDelete'))   {
        	 actions.push({
                'label': 'Delete',
                'name': 'Delete'
            });
        }      
            setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    //edit record 
    editRecord : function(component, recordId) {
        if( component.get("v.customCreationManagement")) {
            this.loadCustomCreationManager(component, "EDIT", recordId);
            return;
        }
    	var editRecordEvent = $A.get("e.force:editRecord");
    	editRecordEvent.setParams({
    		"recordId": recordId
    	});
    	editRecordEvent.fire();
    },
    //delete record
    deleteRecord : function(cmp, recordId) {
	    if (!confirm('Are you sure you want to delete this record ?')) {
	    	return;
	    }
    	var action = cmp.get("c.deleteRecord");
	    action.setParams({ 
	        "recordId": recordId,
	        "objectName" : cmp.get("v.objectName")
	    });
	    var that = this;
	    action.setCallback(this, function(response) {
	        var state = response.getState();
	        if (state === "SUCCESS") {
	           var toastEvent = $A.get("e.force:showToast");
			    toastEvent.setParams({
			        "title": "Success!",
			        "message": "The record has been deleted successfully."
			    });
			    toastEvent.fire();
	        }
	    });
	    $A.enqueueAction(action);
    },
     loadCustomCreationManager : function(component, mode, objectId) {
          $A.createComponent(
            "c:" + component.get('v.creationComponentName'),
            {
                parentObjectId: component.get('v.recordId'),
                sObjectType: component.get("v.sObjectType"),
                mode : mode,
                currentObjectId: objectId,
                viewCustomObjectManagement : true,
            "parentId": component.get('v.parentId')
            },
            function(creationComponent, status, errorMessage){
                if (status === "SUCCESS") {
                    component.set("v.creationComponent", creationComponent);
                    component.set('v.preview', true);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                    // Show offline error
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
            }
        );
     },
    //maneger event
    eventManager : function(cmp, event, recordId) {
        switch (event) { 
            case 'Edit':
                this.editRecord(cmp, recordId);
                break;
            case 'Delete':
               this.deleteRecord(cmp, recordId);
                break;
            case 'View':
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                "recordId":  recordId
                });
                navEvt.fire();
                break;
        }
    }
})