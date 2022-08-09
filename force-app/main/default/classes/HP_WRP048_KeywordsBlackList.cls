/**
 * @description       : 
 * @author            : Badr Eddine Belkarchi
 * @group             : 
 * @last modified on  : 12-22-2021
 * @last modified by  : Badr Eddine Belkarchi
**/
public with sharing class HP_WRP048_KeywordsBlackList {
    
    public List<KeywordBlackList> keywordBlackList;

    public class KeywordBlackList {
     public String keyword;
    }
   
    public static HP_WRP048_KeywordsBlackList parse(String json) {
     return (HP_WRP048_KeywordsBlackList) System.JSON.deserialize(json, HP_WRP048_KeywordsBlackList.class);
    }
}