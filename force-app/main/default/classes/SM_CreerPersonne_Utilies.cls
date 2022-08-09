global class SM_CreerPersonne_Utilies implements vlocity_cmt.VlocityOpenInterface
{
/************************************************************
*@author Alain Kameni - Vlocity
*@date September 2018
*@description Utility for Service Octopus "CreerPersonne"
*@version 1
*************************************************************/
        global Boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options)
        {
            if (methodName == 'transformInputsWS')
            {
                return transformInputsWS(input, output);
            }     
            return false;
        }
                
        public Boolean transformInputsWS (Map<String, Object> input, Map<String, Object> output)
        {           
            getListcanalCommunication(input,output);
            getListProfilMarketing(input,output);
            return true;           
        }
        
        //get list of canalCommunication       
        public Boolean getListcanalCommunication(Map<String, Object> input, Map<String, Object> output)
        {
            List <Object> listcanalCommunication = new List <Object> (); // tag list "canalCommunication"            
            for(Integer i=1; i<=input.size(); i++)
            {
                /*
                if((input.containsKey('canalCommunication#telephone'+String.valueOf(i)) && input.get('canalCommunication#telephone'+String.valueOf(i))!=null)
                ||(input.containsKey('canalCommunication#type#code'+String.valueOf(i)) && input.get('canalCommunication#type#code'+String.valueOf(i))!=null)
                ||(input.containsKey('canalCommunication#mail'+String.valueOf(i)) && input.get('canalCommunication#mail'+String.valueOf(i))!=null)
                )*/
                if((input.containsKey('canalCommunication#telephone'+String.valueOf(i)) && input.get('canalCommunication#telephone'+String.valueOf(i))!=null && input.get('canalCommunication#telephone'+String.valueOf(i))!='')
                ||(input.containsKey('canalCommunication#mail'+String.valueOf(i)) && input.get('canalCommunication#mail'+String.valueOf(i))!=null && input.get('canalCommunication#mail'+String.valueOf(i))!=''))
                { 
                    Map <String,Object> canalCommunication = new Map<String,Object>();
                    if(input.containsKey('canalCommunication#telephone'+String.valueOf(i)) && (input.get('canalCommunication#telephone'+String.valueOf(i)))!=null)
                     {
                         canalCommunication.put('telephone',input.get('canalCommunication#telephone'+String.valueOf(i)));
                     }
                     if(input.containsKey('canalCommunication#type#code'+String.valueOf(i)) && input.get('canalCommunication#type#code'+String.valueOf(i))!=null)
                     {
                         canalCommunication.put('type',new Map <String,String> {'code'=> (String)input.get('canalCommunication#type#code'+String.valueOf(i))});
                     }
                     if(input.containsKey('canalCommunication#mail'+String.valueOf(i)) && input.get('canalCommunication#mail'+String.valueOf(i))!=null)
                     {
                         canalCommunication.put('mail',input.get('canalCommunication#mail'+String.valueOf(i)));
                     }
                    
                    listcanalCommunication.add(canalCommunication);
                }  
            }
            if(listcanalCommunication.size()>0){
                output.put('canalCommunication',listcanalCommunication);
            }
            return true;
        }
        
        // get List of profilMarketing
        public Boolean getListProfilMarketing(Map<String, Object> input, Map<String, Object> output)
        {        
            List <Object> listProfilMarketing = new List <Object>(); // tag list "profilMarketing"           
            for(Integer i=1; i<=input.size(); i++)
            {
                if((input.containsKey('profilMarketing#designation#code'+String.valueOf(i)) && input.get('profilMarketing#designation#code'+String.valueOf(i))!=null)
                ||(input.containsKey('profilMarketing#valeurDesignation'+String.valueOf(i)) && input.get('profilMarketing#valeurDesignation'+String.valueOf(i))!=null)
                )
                {                    
                    Map <String,Object> profilMarketing = new Map<String,Object>();                   
                     if(input.containsKey('profilMarketing#designation#code'+String.valueOf(i)) && input.get('profilMarketing#designation#code'+String.valueOf(i))!=null)
                     {
                         profilMarketing.put('designation',new Map <String,String> {'code'=>(String)input.get('profilMarketing#designation#code'+String.valueOf(i))});
                     }
                     if(input.containsKey('profilMarketing#valeurDesignation'+String.valueOf(i)) && input.get('profilMarketing#valeurDesignation'+String.valueOf(i))!=null)
                     {
                         profilMarketing.put('valeurDesignation',input.get('profilMarketing#valeurDesignation'+String.valueOf(i)));
                     }
                    
                    listProfilMarketing.add(profilMarketing);
                } 
            }
            if(listProfilMarketing.size()>0){
                output.put('profilMarketing',listProfilMarketing);
            }
            return true;
        }       
 }