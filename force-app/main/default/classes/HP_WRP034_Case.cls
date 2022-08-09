/**
 * @File Name          : HP_WRP034_Case.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : Badr Eddine Belkarchi
 * @Last Modified On   : 02-15-2022
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/03/2020   Vincent Albiser     Initial Version
**/
global class HP_WRP034_Case {

    global class Request {  
        public String context;
        public String description;
        public String selfcareId;
        public Integer porteFeuilleContratXdataId;
        public Integer contratXdataId;
        public String energie;
        public String pdl;
        public ContactInfo contactInfo; 
    }

    global class ContactInfo {
        public  String firstname;   
        public  String lastname;
        public  String email;
        public  Integer xdataId;
        public  Boolean clientAide;
    }
}