@JsonAccess(deserializable='always' serializable='always')
public with sharing class ListWrapper {

    public String rowId;
    public String valueChb;
    public String url;
    public String value;
    
    public ListWrapper(String rowId, String valueChb, String value, String url) {
        this.rowId = rowId;
        this.valueChb = valueChb;
        this.value = value;
        this.url = url;
    }

}