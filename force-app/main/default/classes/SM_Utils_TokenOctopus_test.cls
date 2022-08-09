@isTest
public class SM_Utils_TokenOctopus_test {

	@isTest
	public static void testWithCache(){
		String tok1 = SM_Utils_TokenOctopus.getOctopusToken(true);
		System.assertEquals('1234567890',tok1, 'the octopus token service should return a value');
	}

    @isTest
	public static void testWithoutCache(){
		String tok2 = SM_Utils_TokenOctopus.getOctopusToken(false);
		System.assertEquals('1234567890',tok2, 'the octopus token service should return a value');
    }

    @isTest
	public static void testLoginValid(){
        String tok3 = SM_Utils_TokenOctopus.checkOctopusUser();
		System.assertEquals('1234567890',tok3, 'the octopus token service should return a value');
    }

    @isTest
	public static void testInsertTokInDom(){
        String docinit ='<d1><header/></d1>';
        DOM.Document d1 = new DOM.Document();
		d1.load(docinit);
		Dom.XmlNode n1 = d1.getRootElement();
		SM_Utils_TokenOctopus.addOcTokenToSOAPReq(n1);
		System.assert((docinit.length()<d1.toXmlString().length()), 'the octopus header with token service content size is not ok');
        
        
	}

}