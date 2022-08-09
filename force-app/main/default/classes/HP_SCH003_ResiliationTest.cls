/**
 * @File Name          : HP_SCH003_ResiliationTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 28/04/2020 à 15:23:49
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/04/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public class HP_SCH003_ResiliationTest {

	@isTest
    public static void testschedule() {
			Test.StartTest();
			HP_SCH003_Resiliation testsche = new HP_SCH003_Resiliation();
			String sch = '0 0 23 * * ?';
			system.schedule('Test', sch, testsche );
			Test.stopTest();
	}
}