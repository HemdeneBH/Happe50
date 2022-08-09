/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 05-31-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
public inherited sharing class SM_WS101_PrestaServiceElec {       

   /**
    * @author Khalil OUKIL
    * @date 31/03/2022
    * @param stub An instance of the auto-generated class
    * @param request The SOAP Web service request being invoked
    * @param response A collection of key/value pairs representing the response to send for the request
    * @param infoArray List of various parameters
    * @description call the soap service to read elec service
    * @return N/A
    */
   public static void search(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
   }
   
   /**
    * @author Khalil OUKIL
    * @date 31/03/2022
    * @param requestType HTTP Method
    * @param bodyDocument Request content
    * @param bodyNodeKey key to find the body node
    * @param bodyNodeNs Namespace of the body node
    * @param responseNodeKey key to find the response node
    * @param responseNodeNs Namespace of the response node
    * @description call the http service read elec service
    * @return Dom.XmlNode the node containing the response
    */
   public static Dom.XmlNode search(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){

       Dom.XmlNode prestaResponseNode;
       return prestaResponseNode;
       
   }

     
   public static Dom.XmlNode create(String requestType, DOM.Document bodyDocument, String bodyNodeKey, String bodyNodeNs, String responseNodeKey, String responseNodeNs){

       Dom.XmlNode contratResponseNode;

       return contratResponseNode;
   }
   
    public static void create(Object stub, Object request, Map<String,Object> response, List<String> infoArray){
      
   }
}