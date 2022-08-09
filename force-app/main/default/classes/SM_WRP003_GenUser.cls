/**
 * @description       : Handle the response structure of the Genesys user
 * @author            : Mohamed Aamer
 * @last modified on  : 01-18-2022
 * @last modified by  : Mohamed Aamer
**/
public class SM_WRP003_GenUser{

	public class Addresses {
	}

	public Integer total;
	public Integer pageCount;
	public Integer pageSize;
	public Integer pageNumber;
	public String currentPage;
	public List<String> types;
	public List<Results> results;

	public class PrimaryContactInfo {
		public String address;
		public String mediaType;
		public String type;
	}

	public class Results {
		public String id;
		public String name;
		public String email;
		public List<PrimaryContactInfo> primaryContactInfo;
		public List<Addresses> addresses;
		public String state;
		public String username;
		public Integer version;
	}

	
	public static SM_WRP003_GenUser parse(String json) {
		return (SM_WRP003_GenUser) System.JSON.deserialize(json, SM_WRP003_GenUser.class);
	}
}