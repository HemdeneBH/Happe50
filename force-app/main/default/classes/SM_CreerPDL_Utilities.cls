/*
* @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
* @Date: 18/01/2019
* @Description: Utility class for Service Octopus "creerPdlElec" and "creerPdlGaz"
*/
global class SM_CreerPDL_Utilities implements vlocity_cmt.VlocityOpenInterface{

  /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: January 2019
  * @Description: invokeMethod used by vlocity Omniscript: MoveIn
  */
  global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
    if (methodName == 'prepareRequestCreerPDLPCECasSouscrire'){
      return prepareRequestCreerPDLPCECasSouscrire(input, output);
    } 
    else if (methodName == 'preparerDonneesCreerPDLPCECasNVLogement'){
      return preparerDonneesCreerPDLPCECasNVLogement(input, output);
    }
      else if(methodName == 'preparerDonneesCreerPDLLocal'){
          return preparerDonneesCreerPDLLocal(input, output);
      }

      return false;
  }


  
    
    /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 27/03/2019
  * @Description: build json request for the IP : IP_SM_Creer_PDL_SOAP
  */
  public Boolean prepareRequestCreerPDLPCECasSouscrire(Map<String, Object> inputMap, Map<String, Object> output){
    Map<String, Object> infos= new Map<String, Object>();
    Map<String, Object> insideMap = (Map<String, Object>)inputMap.get('ChoixElements1');
    String typeEnergieDemandee = (String) inputMap.get('typeEnergieDemandee');
    String numeroPointDeLivraison;
    
    if('GAZ'.equals(typeEnergieDemandee)){
      numeroPointDeLivraison = (String) insideMap.get('selectedPCEValFormula');
      infos.put('idPDLGaz', numeroPointDeLivraison);
    }
    else if('ELEC'.equals(typeEnergieDemandee)){
      numeroPointDeLivraison = (String) insideMap.get('selectedPDLValFormula');
      infos.put('idPDLElec', numeroPointDeLivraison);
    } 

    infos.put('typePointDeLivraisonACreer',typeEnergieDemandee);
    infos.put('idLocal', (String) inputMap.get('numeroLocal'));



    output.put('CreerPDLInput', infos);
    
    return true;
  }
       /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 27/03/2019
  * @Description: build json request for the IP : IP_SM_Creer_PDL_SOAP
  */
  public Boolean preparerDonneesCreerPDLPCECasNVLogement(Map<String, Object> inputMap, Map<String, Object> output){
    String numeroPDLElec;
    String numeroPDLGaz;
    String typePointDeLivraisonACreer;
      
    Map<String, Object> infos= new Map<String, Object>();
      
    Map<String, Object> infoPDLPCEToBeCreatedMap = (Map<String, Object>)inputMap.get('InfoPDLPCEToBeCreated');
    numeroPDLGaz = (String) infoPDLPCEToBeCreatedMap.get('numPCEToBeCreated');
    numeroPDLElec = (String) infoPDLPCEToBeCreatedMap.get('numPDLToBeCreated');
    
    
    if(!String.isBlank(numeroPDLGaz)){
      infos.put('idPDLGaz', numeroPDLGaz);
      infos.put('typePointDeLivraisonACreer','GAZ');
    }
    if(!String.isBlank(numeroPDLElec)){
      infos.put('idPDLElec', numeroPDLElec);
      infos.put('typePointDeLivraisonACreer','ELEC');
    }
    if(!String.isBlank(numeroPDLElec) && !String.isBlank(numeroPDLGaz)){
      infos.put('typePointDeLivraisonACreer','DUO');
    }

    infos.put('idLocal', (String) inputMap.get('numeroLocal'));



    output.put('CreerPDLInput', infos);
    
    return true;
  }
    public class IOException extends Exception {
    }    
     /*
  * @Author: Hamza EL HARRAOUI ~ hamza.elharraoui@external.engie.com
  * @Date: 27/03/2019
  * @Description: build json request for the IP : IP_SM_Creer_PDL_LOCAL
  */
  public Boolean preparerDonneesCreerPDLLocal(Map<String, Object> inputMap, Map<String, Object> output){
      String numeroPDLElec;
      String numeroPDLGaz;
      String numeroVoie;
      String libelleVoie;
      String complementAdresse;
      String ville;
      String codePostal;
      String codePays;
      
      Map<String, Object> creationPDLLocalInput= new Map<String, Object>();
      
      Map<String, Object> infoPDLPCEToBeCreatedMap = (Map<String, Object>)inputMap.get('InfoPDLPCEToBeCreated');
      numeroPDLGaz = (String) infoPDLPCEToBeCreatedMap.get('numPCEToBeCreated');
      numeroPDLElec = (String) infoPDLPCEToBeCreatedMap.get('numPDLToBeCreated');
      
      Map<String, Object> choixElements1Map = (Map<String, Object>)inputMap.get('ChoixElements1');
      
      numeroVoie = (String) choixElements1Map.get('nVoieValue');
      libelleVoie  = (String) inputMap.get('adresseFormatSAP');
      complementAdresse = (String) choixElements1Map.get('AddressIndication');
      ville = (String) choixElements1Map.get('cityValue'); 
      codePostal = (String) choixElements1Map.get('postcodeValue');
      codePays = 'FR';
      
      if(String.isBlank(numeroVoie) || String.isBlank(libelleVoie) || String.isBlank(ville) || String.isBlank(codePostal) ){
          System.debug(numeroVoie+libelleVoie+ville+codePostal);
          throw new IOException('[SM_CreerPDL_Utilities:preparerDonneesCreerPDLLocal] : Adresse logement non remplie');
      }
      
      
      Map<String,Object> listePDLMap = new Map<String,Object>();
      List<Map<String,Object>> PDL = new List<Map<String,Object>>();
      if(!String.isBlank(numeroPDLGaz)){
          Map<String,Object> pdlInfoGaz = new Map<String, Object>();
          pdlInfoGaz.put('idPDL', numeroPDLGaz);
          pdlInfoGaz.put('secteurActivite',new Map<String,Object>{'code'=>'5G'});
          pdlInfoGaz.put('typeNiveauReseau',new Map<String,Object>{'code'=>'Z010'});
          pdlInfoGaz.put('reseau',new Map<String,Object>{'code'=>'GDFD'});
          PDL.add(pdlInfoGaz);
      }
      if(!String.isBlank(numeroPDLElec)){
          Map<String,Object> pdlInfoElec = new Map<String, Object>();
          pdlInfoElec.put('idPDL', numeroPDLElec);
          pdlInfoElec.put('secteurActivite',new Map<String,Object>{'code'=>'5E'});
          pdlInfoElec.put('typeNiveauReseau',new Map<String,Object>{'code'=>'Z020'});
          pdlInfoElec.put('reseau',new Map<String,Object>{'code'=>'EDFD'});
          PDL.add(pdlInfoElec);
      }
      listePDLMap.put('PDL',PDL);
      
      Map<String,Object> adresseCreerMap = new Map<String, Object>();
      adresseCreerMap.put('NVoie',numeroVoie);
      adresseCreerMap.put('libelleVoie',libelleVoie);
      if(!String.isBlank(complementAdresse)){
          adresseCreerMap.put('complementAdresse',complementAdresse);
      }
      adresseCreerMap.put('ville',ville);
      adresseCreerMap.put('CP',codePostal);
      adresseCreerMap.put('pays',new Map<String,Object>{'code'=>codePays});
      
      creationPDLLocalInput.put('adresseCreer',adresseCreerMap);
      
      creationPDLLocalInput.put('listePDL',listePDLMap);
      output.put('creationPDLLocalInput', creationPDLLocalInput);
      
      return true;
  }
  
 

}