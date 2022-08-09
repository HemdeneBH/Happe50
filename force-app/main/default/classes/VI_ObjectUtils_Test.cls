@isTest
public class VI_ObjectUtils_Test {
    @isTest
    static void testMethod1(){
        VI_ObjectUtils.getPicklistOptionsBySObjectName('Case', 'Status');
        VI_ObjectUtils.getRecordTypeId('Task','SMILE');
        VI_ObjectUtils.getRecordTypesMap('Task');
        VI_ObjectUtils.isSandboxOrg();
    }
}