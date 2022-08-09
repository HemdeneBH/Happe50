/**
 * @description       : Controller for RechercherPrixServices operation of the PrixEtRemisesV3 WS (FT1-4381)
 * @author            : David Attali
 * @group             : 
 * @last modified on  : 01-21-2021
 * @last modified by  : David ATTALI
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   01-21-2021   David ATTALI    Initial Version
**/
global class SM_CTRL005_RechercherPrixServices implements vlocity_cmt.VlocityOpenInterface {
    
    /**
     * @description Call a method from a remote action (Vlocity)
     * @param String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options 
     * @return Boolean
     */
    public Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        
        try {
            if (methodName.equals('getPrixServices')) {
                getPrixServices(inputMap, outputMap, options);
            }
        } catch (Exception e) {
            outputMap.put('exception', 'An exception occurred: ' + e.getMessage());
            System.debug('An exception occurred: ' + e.getMessage());
            return false;
        }
        
        return true;
    }
    
    /**
     * @description Get service prices
     * @param Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options 
     * @return Void
     */
    private void getPrixServices(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        
        String idOffre = (String)inputMap.get('idOffre');
        System.debug('idOffre ' + idOffre);	
        
        SM_SM005_RechercherPrixServices.WrapperInput wrapperInput = new SM_SM005_RechercherPrixServices.WrapperInput();   
        
        if (idOffre == 'EFOPT_VERT') {
            wrapperInput.idOffre = 'EFOPT_VERT';
            Integer puissance = ((Double)inputMap.get('puissance')).intValue();
            wrapperInput.puissance = String.valueOf(puissance);
            System.debug('puissance ' + wrapperInput.puissance);
            wrapperInput.typeDeComptage = (String)inputMap.get('typeDeComptage');
            System.debug('typeDeComptage ' + (String)inputMap.get('typeDeComptage'));
            
        } else if (idOffre == 'GOPT_VERT') {
           
            wrapperInput.idOffre = 'GOPT_VERT';
            Integer plageDeConsommation = ((Double)inputMap.get('plageDeConsommation')).intValue();
            wrapperInput.plageDeConsommation = String.valueOf(plageDeConsommation);
            System.debug('plageDeConsommation ' + wrapperInput.plageDeConsommation);           
            if(inputMap.get('tauxGazVert') != null){
                Integer tauxGazVert = ((Double)inputMap.get('tauxGazVert')).intValue();
                wrapperInput.tauxGazVert = String.valueOf(tauxGazVert);
            }   
        }
          
        if(wrapperInput.idOffre != null) {
            
            
            
              SM_SM005_RechercherPrixServices.WrapperOutput wrapperOutput;
            
              wrapperOutput = SM_SM005_RechercherPrixServices.getPrixServices(wrapperInput);
            
            outputMap.put('code', wrapperOutput.code);
            outputMap.put('libelle', wrapperOutput.libelle);
            
            if(wrapperOutput.code == 'OCTOPUS_RechercherPrixService_01') {
                
                if(wrapperOutput.idOffre == 'GOPT_VERT'){
                    
                    Map<String, String> mapPlageDeConsommationToPrice = new Map<String, String>();
                    
                    for(SM_SM005_RechercherPrixServices.AdditionalPrice additionalPrice : wrapperOutput.additionalPrices){
                        
                        String ZZCAE = additionalPrice.criterias.get('ZZCAE');
                        String ZZTAUX = additionalPrice.criterias.get('ZZTAUX');
                        
                        if(String.valueOf(Integer.valueOf(ZZCAE)) == wrapperInput.plageDeConsommation){
                            mapPlageDeConsommationToPrice.put('ZZTAUX_'+String.valueOf(Integer.valueOf(ZZTAUX)), String.valueOf(Decimal.valueOf(additionalPrice.prixMensuelTTC).setScale(2)).replace('.', ','));
                        }
                    }
                    
                    outputMap.put('additionalPrices', mapPlageDeConsommationToPrice);
                }
                
                System.debug('prixMensuelTTC' + '_' + wrapperOutput.idOffre + ' : ' + wrapperOutput.prixMensuelTTC);
                outputMap.put('prixMensuelTTC' + '_' + wrapperOutput.idOffre, String.valueOf(Decimal.valueOf(wrapperOutput.prixMensuelTTC).setScale(2)).replace('.', ','));
                

            } else {
                outputMap.put('prixMensuelTTC' + '_' + wrapperOutput.idOffre, null);
            }
        }
    }
}