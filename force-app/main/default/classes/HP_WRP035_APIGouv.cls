/**
 * @File Name          : HP_WRP035_APIGouv.cls
 * @Description        : 
 * @Author             : Mouhamadoune Coulibaly
 * @Group              : 
 * @Last Modified By   : Mouhamadoune Coulibaly
 * @Last Modified On   : 08/04/2020 à 18:25:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    08/04/2020   Mouhamadoune Coulibaly     Initial Version
**/
public with sharing class HP_WRP035_APIGouv {

    public class Geometry {
        @AuraEnabled
        public String type_Z {get;set;} // in json: type
        @AuraEnabled
		public List<Double> coordinates {get;set;} 

		public Geometry(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'coordinates') {
							coordinates = arrayOfDouble(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Geometry consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    @AuraEnabled
    public String type_Z {get;set;} // in json: type
    @AuraEnabled
    public String version {get;set;}
    @AuraEnabled
    public List<Features> features {get;set;}
    @AuraEnabled
    public String attribution {get;set;}
    @AuraEnabled
    public String licence {get;set;}
    @AuraEnabled
    public String query {get;set;}
    @AuraEnabled
    public Integer limit_Z {get;set;} // in json: limit

	public HP_WRP035_APIGouv(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'type') {
						type_Z = parser.getText();
					} else if (text == 'version') {
						version = parser.getText();
					} else if (text == 'features') {
						features = arrayOfFeatures(parser);
					} else if (text == 'attribution') {
						attribution = parser.getText();
					} else if (text == 'licence') {
						licence = parser.getText();
					} else if (text == 'query') {
						query = parser.getText();
					} else if (text == 'limit') {
						limit_Z = parser.getIntegerValue();
					} else {
						System.debug(LoggingLevel.WARN, 'HP_WRP035_APIGouv consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Features {
        @AuraEnabled
        public String type_Z {get;set;} // in json: type
        @AuraEnabled
        public Geometry geometry {get;set;} 
        @AuraEnabled
		public Properties properties {get;set;} 

		public Features(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'geometry') {
							geometry = new Geometry(parser);
						} else if (text == 'properties') {
							properties = new Properties(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Features consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Properties {
        @AuraEnabled
        public String label {get;set;} 
        @AuraEnabled
        public Double score {get;set;}
        @AuraEnabled
        public String housenumber {get;set;}
        @AuraEnabled
        public String id {get;set;}
        @AuraEnabled
        public String type_Z {get;set;} // in json: type
        @AuraEnabled
        public String name {get;set;}
        @AuraEnabled
        public String postcode {get;set;}
        @AuraEnabled 
        public String citycode {get;set;}
        @AuraEnabled
        public Double x {get;set;}
        @AuraEnabled
        public Double y {get;set;}
        @AuraEnabled
        public String city {get;set;}
        @AuraEnabled
        public String context {get;set;}
        @AuraEnabled
        public Double importance {get;set;}
        @AuraEnabled
		public String street {get;set;} 

		public Properties(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'label') {
							label = parser.getText().replaceAll('ã©', 'é');
						} else if (text == 'score') {
							score = parser.getDoubleValue();
						} else if (text == 'housenumber') {
							housenumber = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'type') {
							type_Z = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'postcode') {
							postcode = parser.getText();
						} else if (text == 'citycode') {
							citycode = parser.getText();
						} else if (text == 'x') {
							x = parser.getDoubleValue();
						} else if (text == 'y') {
							y = parser.getDoubleValue();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'context') {
							context = parser.getText();
						} else if (text == 'importance') {
							importance = parser.getDoubleValue();
						} else if (text == 'street') {
							street = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Properties consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static HP_WRP035_APIGouv parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new HP_WRP035_APIGouv(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Double> arrayOfDouble(System.JSONParser p) {
        List<Double> res = new List<Double>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getDoubleValue());
        }
        return res;
    }







    private static List<Features> arrayOfFeatures(System.JSONParser p) {
        List<Features> res = new List<Features>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Features(p));
        }
        return res;
    }



}