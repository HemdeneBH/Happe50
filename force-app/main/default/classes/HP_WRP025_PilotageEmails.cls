/**
 * @File Name          : HP_WRP025_PilotageEmails.cls
 * @Description        :
 * @Author             : Sara El-Hannaoui
 * @Group              :
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 14/02/2020 à 16:16:03
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    14/02/2020   Sara El-Hannaoui     Initial Version
 **/
public with sharing class HP_WRP025_PilotageEmails {
	public Boolean success;
	public Data data;
	public String message;
	public Integer code;

	public class ListeEmails {
		public Integer id;
		public String content;
		public Integer idClient;
		public String body;
		public String date_x;
		public String statut;
		public Integer source;
	}

	public class Data {
		public String numPage;
		public Integer totalPages;
		public List<ListeEmails> listeEmails;
	}

}