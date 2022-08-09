/**
 * @File Name          : HP_WRP009_IndexUpdate.cls
 * @Description        : 
 * @Author             : Vincent Albiser
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 03/03/2020 à 16:42:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/01/2020   Vincent Albiser     Initial Version
**/

global with sharing class HP_WRP009_IndexUpdate {
    
    global class Request {  
        public  Integer xDataContractId;
        public  String energie;       
        public  Decimal indexGaz;    
        public  Decimal indexElec;     
        public  Decimal indexElecHC;   
    }

}