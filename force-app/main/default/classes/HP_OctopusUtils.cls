/**
 * @File Name          : HP_OctopusUtils.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 23/03/2020 à 14:41:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/03/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public  class HP_OctopusUtils {

    public static  String CERTIFICAT;
	public static  String END_POINT; 
	public static final String CONTENT_TYPE = 'Content-Type';
	public static final String CHARSET = 'text/xml;charset=utf-8';
	//public static final String LOGIN_USER = 'homologation@engie.com';//FIXME merge or explain disting login per env or per service
	//public static final String DEFAULT_USER_LOGIN = 'happe@engie.com';//TODO use custom metadata or setting
	public static final String VERSION1 = '2.00';
	public static final String CONTEXT = '0';
	//public static final String TYPE_OFFRE = 'INDUSTRIELLE';
	public static final String DATE_TIME_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss';
	
	static {
		CERTIFICAT = HP_UTIL_MetadataManager.getConfigByKey('HP_OCTOPUS_CERTIFICAT');
		END_POINT = HP_UTIL_MetadataManager.getConfigByKey('HP_OCTOPUS_ENDPOINT');
    }
	public enum EnrolmentType {
		CHF,
		MES,
		CFN
	}

	public enum Salutation {
		MR,
		MME
	}
	
	public static final Map<HP_EnrolmentRestResourceModel.EnrolmentType, EnrolmentType> ENROLMENT_TYPE_BY_ENROLMENT_TYPE_ELEC  = new Map<HP_EnrolmentRestResourceModel.EnrolmentType, EnrolmentType> {
		HP_EnrolmentRestResourceModel.EnrolmentType.SWITCH_SUPLIER => EnrolmentType.CFN,
		HP_EnrolmentRestResourceModel.EnrolmentType.MOVING_IN => EnrolmentType.MES
	};

	public static final Map<HP_EnrolmentRestResourceModel.EnrolmentType, EnrolmentType> ENROLMENT_TYPE_BY_ENROLMENT_TYPE  = new Map<HP_EnrolmentRestResourceModel.EnrolmentType, EnrolmentType> {
		HP_EnrolmentRestResourceModel.EnrolmentType.SWITCH_SUPLIER => EnrolmentType.CHF,
		HP_EnrolmentRestResourceModel.EnrolmentType.MOVING_IN => EnrolmentType.MES
	};

	public static final Map<HP_EnrolmentRestResourceModel.Salutation, Salutation> OCTOPUS_SALUTATION_BY_SALUTATION = new Map<HP_EnrolmentRestResourceModel.Salutation, Salutation> {
		HP_EnrolmentRestResourceModel.Salutation.MR => Salutation.MR,
		HP_EnrolmentRestResourceModel.Salutation.MME => Salutation.MME
	};

	public class PortTemplate {
		public final String endpoint_x;
		public final Map<String, String> inputHttpHeaders_x;

		public PortTemplate(final String serviceName) {
			this.endpoint_x = (HP_OctopusUtils.END_POINT + serviceName);
			this.inputHttpHeaders_x = new Map<String, String> {
				HP_OctopusUtils.CONTENT_TYPE => HP_OctopusUtils.CHARSET
			};
		}
	}

	public static Object buildPort(final String serviceName, final System.Type type) {
		final Object port = new PortTemplate(serviceName);
		return HP_ParseUtils.convert(port, type);
	}

	public static gdfsuezComBefChpPivot.contextDt buildContext(String systemId, String version) {
		// Créer le contexte d'appel, à créer avec une méthode pour tout les appels octopus
		gdfsuezComBefChpPivot.system_element osource = new gdfsuezComBefChpPivot.system_element();
		osource.systemId = systemId;
		gdfsuezComBefChpPivot.contextDt context = new gdfsuezComBefChpPivot.contextDt();
		context.version = version;
		//  context.allowCache = false ;
		context.systemPath = new gdfsuezComBefChpPivot.systemPath_element();
		context.systemPath.system_x = new gdfsuezComBefChpPivot.system_element[] {
			osource
		};
		return context;
	}

	public static Object buildContext(String systemId, String version, final System.Type type) {
		Object context = buildContext(systemId, version);
		return HP_ParseUtils.convert(context, type);
	} 
}