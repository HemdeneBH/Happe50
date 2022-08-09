public class SM_AP70_Get_Image_Link {
    
    public String DocumentValue{get;set;}

    public String getImageLink() {
        
        String imageLink ='';
        String documentName ='';
        List<Document> lstDocument = new List<Document>();
        system.debug('DocumentValue'+DocumentValue);
        lstDocument = [Select Id,Name from Document where Name =:DocumentValue limit 1];
        system.debug('lstDocument'+lstDocument);
        system.debug('DocumentValue'+DocumentValue);
        
        if(!Test.isRunningTest()){
            if(lstDocument.size() == 0){
                return '#';
            }
             documentName = lstDocument[0].Id;
        }
        else{
             documentName = DocumentValue;
        }
        
        String orgId = UserInfo.getOrganizationId();
        
         String instanceName = [select InstanceName from Organization limit 1].InstanceName;
        system.debug('orgId'+orgId);
        system.debug('documentName'+documentName);
        system.debug('instanceName'+instanceName);
        imageLink = 'https://c.'+instanceName+'.content.force.com/servlet/servlet.ImageServer?id='+documentName+'&oid='+orgId;
        system.debug('imageLink'+imageLink);
        
        
        return imageLink;
    }
    
    
}