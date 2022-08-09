/*
*@Author: Paul Ghousoub
*@Description: Generer par wsdl, classe de test: VI_SM043_ChiffrerURL_Test
*@CreatedDate: 7/9/2021
*@LastModified: 7/9/2021
*/
public class VI_gdfsuezComBefChpCalypsoChiffrement {
    public class chiffrerChaineOutputDt {
        public String chaineChiffree;
        private String[] chaineChiffree_type_info = new String[]{'chaineChiffree','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'chaineChiffree'};
    }
    public class chiffrerChaineInputDt {
        public String chaineAChiffrer;
        private String[] chaineAChiffrer_type_info = new String[]{'chaineAChiffrer','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'chaineAChiffrer'};
    }
    public class chiffrerChaine_element {
        public VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt chiffrerChaineInput;
        public VI_gdfsuezComBefChpPivotChiffrement.contextDt context;
        private String[] chiffrerChaineInput_type_info = new String[]{'chiffrerChaineInput','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'1','1','false'};
        private String[] context_type_info = new String[]{'context','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'chiffrerChaineInput','context'};
    }
    public class chiffrerChaineResponse_element {
        public VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineOutputDt chiffrerChaineOutput;
        public VI_gdfsuezComBefChpPivotChiffrement.retourTraitementMessagesDt messageRetours;
        private String[] chiffrerChaineOutput_type_info = new String[]{'chiffrerChaineOutput','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'0','1','false'};
        private String[] messageRetours_type_info = new String[]{'messageRetours','http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',null,'1','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1','false','false'};
        private String[] field_order_type_info = new String[]{'chiffrerChaineOutput','messageRetours'};
    }
    public class chiffrementPort {
        public String endpoint_x = 'http://localhost:8080/services/chiffrement/v1';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1', 'VI_gdfsuezComBefChpCalypsoChiffrement', 'http://gdfsuez.com/bef/chp/pivot', 'VI_gdfsuezComBefChpPivotChiffrement'};
        public VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element ChiffrerChaine(VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineInputDt chiffrerChaineInput,VI_gdfsuezComBefChpPivotChiffrement.contextDt context) {
            VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaine_element request_x = new VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaine_element();
            request_x.chiffrerChaineInput = chiffrerChaineInput;
            request_x.context = context;
            XMLSerializer serializer = new XMLSerializer();
            String serializedXML = serializer.serialize(request_x,true, null); 
            system.debug('serializedXML Input'+ serializedXML);
            VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element response_x;
            Map<String, VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element> response_map_x = new Map<String, VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'tns:ChiffrerChaine',
              'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',
              'chiffrerChaine',
              'http://gdfsuez.com/bef/chp/calypso/chiffrement/v1',
              'chiffrerChaineResponse',
              'VI_gdfsuezComBefChpCalypsoChiffrement.chiffrerChaineResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x;
        }
    }
}