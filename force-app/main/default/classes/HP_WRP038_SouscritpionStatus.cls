/**
 * @File Name          : HP_WRP038_SouscritpionStatus.cls
 * @Description        : 
 * @Author             : Antoine Latour
 * @Group              : 
 * @Last Modified By   : Antoine Latour
 * @Last Modified On   : 25/09/2020 à 12:00:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/09/2020   Antoine Latour     Initial Version
**/

global with sharing class HP_WRP038_SouscritpionStatus {

	global class Request {
		public final List<String> souscriptionIdList;

		global Request(List<String> souscriptionIdList){
			this.souscriptionIdList = souscriptionIdList;
		}
	}

	global class Response {

		public final List<SouscriptionStatus> souscriptionInfos;

		global Response(List<HP_Souscription__c> souscriptionList){
			this.souscriptionInfos = new List<SouscriptionStatus>();
			for(HP_Souscription__c souscription : souscriptionList) {
				this.souscriptionInfos.add(new SouscriptionStatus(souscription));
			}
		}
	}

	global class SouscriptionStatus {

        public final String digitalSouscriptionId;
        public final String status;
        public final String salesforceSouscriptionId;
		

		global SouscriptionStatus(HP_Souscription__c souscription){
			this.status                   = souscription.HP_Statut__c;
			this.digitalSouscriptionId    = souscription.HP_Souscription_Digital_Id__c;
			this.salesforceSouscriptionId = souscription.Id;
		}
	}

}