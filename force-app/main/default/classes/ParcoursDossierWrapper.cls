public class ParcoursDossierWrapper {
    
    public String title;
    public String title_Dessus;
    public Boolean isFirst;
    public Boolean isSuccess;
    public Boolean isError;
    public Boolean isGrey;
    public Boolean isCurrent;
    public List<ButtonWrapper> listButtons;
    public String EtapeNumber;
    public String EtapeStatus;
    public String datePresta;
    public Boolean isLineGreen;
    public Boolean isLineGrey;
    
    public class ButtonWrapper{
        public String label;
        public String action;
        public Map<String, Object> mapStringObject(){
            Map<String, Object> mapReturn = new Map<String, Object>();
            mapReturn.put('label',this.label);
            mapReturn.put('action',this.action);
            return mapReturn;
        }
    }
    
    public Map<String, Object> mapStringObject(){
        Map<String, Object> mapReturn = new Map<String, Object>();
        mapReturn.put('title',this.title);
        mapReturn.put('title_Dessus',this.title_Dessus);
        mapReturn.put('isFirst',this.isFirst);
        mapReturn.put('isSuccess',this.isSuccess);
        mapReturn.put('isError',this.isError);
        mapReturn.put('isGrey',this.isGrey);
        mapReturn.put('isCurrent',this.isCurrent);
        mapReturn.put('datePresta',this.datePresta);
        mapReturn.put('isLineGreen',this.isLineGreen);
        mapReturn.put('isLineGrey',this.isLineGrey);
        List<Map<String, Object>> listMapReturnButtons = new  List<Map<String, Object>>();
        System.debug('### aka listButtons ' + this.listButtons);
        if(this.listButtons != null ){
            for(ButtonWrapper buttonWrapper : this.listButtons){
                listMapReturnButtons.add(buttonWrapper.mapStringObject());
            } 
        }
        mapReturn.put('listButtons',listMapReturnButtons);
        return mapReturn;
    }
}