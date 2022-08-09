({
    //Init component
    init : function(component, event, helper) {

        var dtForm = component.get("v.dataFormatter");

        // load data from server
        helper.loadData(component);
        //component.set('v.customIcon', 'custom:custom' + (Math.floor(Math.random() * 113) + 1));


    },
    newRecord : function(component, event, helper) {
        if( component.get("v.customCreationManagement")) {
            helper.loadCustomCreationManager(component, "CREATE");
            return;
        }
        var createAcountContactEvent = $A.get("e.force:createRecord");
        var defaultFieldValues = {};
        defaultFieldValues[component.get('v.parentId')] = component.get('v.recordId');
        var windowHash = window.location.hash;
        createAcountContactEvent.setParams({
            entityApiName: component.get('v.objectName'),
            defaultFieldValues: defaultFieldValues,
            inContextOfRecordId : component.get('v.recordId'),
            navigationLocation : 'RELATED_LIST_ROW',
            navigationLocationId :  component.get('v.objectName')
        });


        createAcountContactEvent.fire();
    },
    //Update sorting
    updateColumnSorting: function (cmp, event, helper) { 
        //get sorting field name
        var fieldName = event.getParam('fieldName');
        //get direction sort 
        var sortDirection = event.getParam('sortDirection');
        //set sort parameter in component
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        //sort data
        helper.sortData(cmp, fieldName, sortDirection, 'dataResult');
        helper.sortData(cmp, fieldName, sortDirection, 'dataSearch');
    },
    //filtring data
    filterData: function (cmp, event, helper) {
        //filtering data
        helper.filterData(cmp);
    },
    showPreview: function (cmp, event, helper) {
        cmp.set("v.preview", true);
    },
    showTable: function (cmp, event, helper) {
        cmp.set("v.preview", false);
    },
    //select action on data table
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        helper.eventManager(cmp, action.name, row.Id);


    },
    //select action on section
    handleMenuSelect: function (cmp, event, helper) {
        var values = event.getParam('value').split('\.');
        helper.eventManager(cmp, values[0], values[1]);
    },
    //For VF Functions
    handleMenuEdit: function (cmp, event, helper) {
        var eventTarget = event.currentTarget;
        var recordIdFromList = eventTarget.dataset.record;


        helper.eventManager(cmp, 'Edit', recordIdFromList);
    },
    //For VF Functions
    handleMenuDelete: function (cmp, event, helper) {
        var eventTarget = event.currentTarget;
        var recordIdFromList = eventTarget.dataset.record;

        helper.eventManager(cmp, 'Delete', recordIdFromList);

    },
    linkRecord: function (cmp, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
        "recordId":  event.target.id
        });
        navEvt.fire();



    },
    //For 'Suivante' pagination Button
    onNext : function(component, event, helper) { 
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber+1);
        // load dataDisplay for the next page
        helper.loadPageData(component);
    },
    //For 'Précédente' pagination Button
    onPrev : function(component, event, helper) {        
        var pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber-1);
        // load dataDisplay for the previous page
        helper.loadPageData(component);
    },
    //For 'Première' pagination Button
    onFirst: function(component, event, helper) {        
        component.set("v.pageNumber", 1);
        // load dataDisplay for the first page
        helper.loadPageData(component);
    },
    //For 'Dernière' pagination Button
    onLast: function(component, event, helper) {        
        component.set("v.pageNumber", component.get("v.totalPages"));
        // load dataDisplay for the last page
        helper.loadPageData(component);
    },
    //Prepare pagination after changing pageSize
    onPageSizeChange: function(component, event, helper) {
        if(!component.get("v.textSearch") || component.get("v.textSearch").length === 0)
            helper.preparePagination(component);
        else
            helper.preparefilterPagination(component);
    },

})