public inherited sharing class HP_EM047_Holiday {
    
    @AuraEnabled(cacheable=true)
    public static boolean isHoliday(String daterdv) {
        Date dt = Date.valueOf(daterdv);
        List<Holiday> hdList = [Select Id From Holiday where ActivityDate = :dt];
        return hdList.size() > 0;
    }
}