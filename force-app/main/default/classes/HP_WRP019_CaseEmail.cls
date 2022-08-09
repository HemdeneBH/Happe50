/**
 * @File Name          : HP_WRP019_CaseEmail.cls
 * @Description        :
 * @Author             : Colince FOTSO
 * @Group              :
 * @Last Modified By   : Vincent Albiser
 * @Last Modified On   : 09/02/2020 à 23:34:20
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    28/01/2020   Colince FOTSO     Initial Version
 **/
public class HP_WRP019_CaseEmail {

	public class Request {
		public String reason;
		public String civility;
		public String firstName;
		public String lastName;
		public String emailAddress;
		public String message;
		public String streetNumber;
		public String streetLabel;
		public String postalCode;
		public String town;
		public List<Attachment> attachments;
	}

	public class Attachment {
		public final String filename;
		public final String body;
	}

}