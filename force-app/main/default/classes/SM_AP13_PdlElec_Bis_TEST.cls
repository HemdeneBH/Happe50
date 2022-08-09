@isTest
public class SM_AP13_PdlElec_Bis_TEST {
   
	@testSetup 
	static void setup() {
			SM_AP08_TestLib.insertCS_SMOCTOPUS();
	}

	/*
	* @Author: Raouaa Jmour
	* @Date: 27/01/2020
	* @Description: method to test lirePDL in SM_AP13_PdlElec_Bis
	*/
	@isTest 
	static void testCallout() {
			Test.startTest();

			Map < String, Object > input = new Map < String, Object > ();
			Map < String, Object > chois = new Map < String, Object > ();
			input.put('pdl', '01199999844520');
			Map < String, Object > output = new Map < String, Object > ();
			SM_AP13_PdlElec_Bis service = new SM_AP13_PdlElec_Bis();
			service.invokeMethod('lirePdlElec', input, output, null);

			Datetime dateDernierIndexReleve = Datetime.now() ;
			String natureIndexReleve= 'REEL' ;
			String natureIndexReleveCode='REEL'; 
			String indexBaseReleve='1400';
			String indexHPReleve='1400';
			String indexHCReleve ='1400';
			Datetime dateDernierIndexPublies = Datetime.now() ;
			String natureIndexPublies ='REEL';
			String natureIndexCodePublies='REEL';
			String indexBasePublies ='1300';
			String indexHPPublies ='1400';
			String indexHCPublies='1400';
			
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
			natureIndexCodePublies = null ;	
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
			natureIndexCodePublies = 'REEL' ;
			natureIndexReleveCode = null ;	
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
			natureIndexCodePublies = 'REEL' ;
			natureIndexReleveCode = 'REEL' ;
			dateDernierIndexPublies = Datetime.now()-2 ;
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
			natureIndexReleveCode = 'ESTI' ;
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
			natureIndexCodePublies = 'ESTI' ;
			SM_AP13_PdlElec_Bis.getIndex( dateDernierIndexReleve,  natureIndexReleve,  natureIndexReleveCode,  indexBaseReleve,  indexHPReleve,  indexHCReleve,  dateDernierIndexPublies,  natureIndexPublies,  natureIndexCodePublies,  indexBasePublies,  indexHPPublies,  indexHCPublies);
		  




			Test.stopTest();
	}
}