public class MP_LWC02_Download {
    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getfileIds(String recordId){
        Set<Id> contentDocumentIds = new Set<Id>();
        List<ContentVersion> contentVersionIds = new List<ContentVersion>();
        
        if(String.isNotBlank(recordId)) {
            for(ContentDocumentLink cdl : [SELECT ContentDocumentId,LinkedEntityId,ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:recordId]) {
                contentDocumentIds.add(cdl.ContentDocumentId);
            }
        }

        if(contentDocumentIds.size() > 0) {
            for(ContentVersion cdv : [SELECT Id, Title, FileExtension, ContentDocumentId FROM ContentVersion WHERE isLatest = true AND ContentDocumentId IN :contentDocumentIds]) {
                contentVersionIds.add(cdv);
            }
        }

        return contentVersionIds;
    }
}