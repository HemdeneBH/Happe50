/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 


 * @last modified on  : 03-03-2021


 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   02-19-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/


global with sharing class HP_WRP039_Devis {

	global class Request {
		public final String digitalId;

		global Request(String digitalId){
			this.digitalId = digitalId;
		}
    }
    
    global class Response {

		public final List<souscriptionInfos> souscriptionInfos;

		global Response(List<HP_Souscription__c> souscriptionList){
			this.souscriptionInfos = new List<souscriptionInfos>();

			for(HP_Souscription__c souscription : souscriptionList) {
				this.souscriptionInfos.add(new souscriptionInfos(souscription));
			}
			
		}

		global boolean isListEmpty(){
			return this.souscriptionInfos.size() == 0;
		}






    }
    
    global class souscriptionInfos {

        public final String digitalSouscriptionId;




		public final String name;
        public final String typeSouscription;
        public final String typeEnergy;
        public final String pdl;
		public final String pce;
		

		global souscriptionInfos(HP_Souscription__c souscription){
			this.digitalSouscriptionId  = souscription.HP_Souscription_Digital_Id__c;




            this.typeSouscription = souscription.HP_type_Souscription__c;
            this.typeEnergy = souscription.HP_Type_Energie__c;
            this.pdl = souscription.HP_NumPDL__c;
			this.pce = souscription.HP_NumberPCE__c;
			this.name = souscription.Name;



		}
	}

	global class APIException extends Exception {}

}