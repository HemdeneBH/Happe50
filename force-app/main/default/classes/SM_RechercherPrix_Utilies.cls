/*
* @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
* @Date: 09/01/2019
* @Description: Utility class for Service Octopus "rechercherPrixEtRemisesServices"
*/
global class SM_RechercherPrix_Utilies implements vlocity_cmt.VlocityOpenInterface{

  /*
  * @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: January 2019
  * @Description: invokeMethod used by vlocity integration procedure: IP_SM_RecherchePrix
  */
  global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options){
    if (methodName == 'transformInputsWS'){
      return transformInputsWS(input, output);
    }     
      return false;
  }

  /*
  * @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: 09/01/2019
  * @Description: transformInputsWS used to populate objects Contexte and rechercherPrixEtRemisesServices
  */
  public Boolean transformInputsWS (Map<String, Object> input, Map<String, Object> output){           
    getrechercherPrixEtRemisesServices(input,output);
    getContexte(input,output);
    
    return true;           
  }

  /*
  * @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: 09/01/2019
  * @Description: getrechercherPrixEtRemisesServices using codeCommune, codePostal, datePropositionCommerciale and dateEffetContrat, contstruct list of 3 products to request as object
  */
  public Boolean getrechercherPrixEtRemisesServices(Map<String, Object> input, Map<String, Object> output){
    Object codeCommune = input.get('codeCommune');
    Object codePostal = input.get('codePostal');

    Object dateEffetContrat = input.get('dateEffetContrat');
    Object datePropositionCommerciale = input.get('datePropositionCommerciale');

    List <Object> listrecherchePrixItems = new List <Object>();
    listrecherchePrixItems.add(constructRecherchePrix(codeCommune, codePostal, dateEffetContrat, datePropositionCommerciale, 'PREV_FACTC_P', 'PREV_FACT'));
    listrecherchePrixItems.add(constructRecherchePrix(codeCommune, codePostal, dateEffetContrat, datePropositionCommerciale, 'PREV_FACTC_P', 'PREV_FACT2'));
    listrecherchePrixItems.add(constructRecherchePrix(codeCommune, codePostal, dateEffetContrat, datePropositionCommerciale, 'PREV_FACT_P', 'PREV_FACT'));

    Map<String, Object> maprechercherPrixEtRemisesServices = new Map<String, Object>();
    maprechercherPrixEtRemisesServices.put('rechercherPrixEtRemisesServicesInput',listrecherchePrixItems);
    output.put('rechercherPrixEtRemisesServices',maprechercherPrixEtRemisesServices);

    return true;
  }

  /*
  * @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: 09/01/2019
  * @Description: getContexte build Contexte as object to be passed in integration procedure
  */
  public Boolean getContexte(Map<String, Object> input, Map<String, Object> output){
    Map<String, Object> mapcontexte= new Map<String, Object>();
    mapcontexte.put('version', '1.0');

    Map<String, Object> mapsystem= new Map<String, Object>();
    mapsystem.put('systemId', '0');
    Map<String, Object> mapsystemPath= new Map<String, Object>();
    mapsystemPath.put('system', mapsystem);
    
    mapcontexte.put('systemPath', mapsystemPath);  
    mapcontexte.put('allowCache', 'false');
    
    output.put('contexte', mapcontexte);
    
    return true;
  }
  
  /*
  * @Author: Jason Goolaup ~ goolaup.jasondavid@external.engie.com
  * @Date: 09/01/2019
  * @Description: constructRecherchePrix build object for 1 product. Called by getrechercherPrixEtRemisesServices
  */
  private Map<String, Object> constructRecherchePrix(Object codeCommune, Object codePostal, Object dateEffetContrat, Object datePropositionCommerciale, Object idOffre, Object idPack){
    Map<String, Object> maprechercherPrixEtRemisesInput = new Map<String, Object>();
    
    Map<String, Object> mapIdentifiantsLieu = new Map<String, Object>();
    mapIdentifiantsLieu.put('codeCommune', codeCommune);
    mapIdentifiantsLieu.put('codePostal', codePostal);
    maprechercherPrixEtRemisesInput.put('identifiantsLieu', mapIdentifiantsLieu);
    
    maprechercherPrixEtRemisesInput.put('idPack', idOffre);
    maprechercherPrixEtRemisesInput.put('idOffre', idPack);
    maprechercherPrixEtRemisesInput.put('dateEffetContrat', dateEffetContrat);
    maprechercherPrixEtRemisesInput.put('datePropositionCommerciale', dateEffetContrat);

    return maprechercherPrixEtRemisesInput;
  }

}