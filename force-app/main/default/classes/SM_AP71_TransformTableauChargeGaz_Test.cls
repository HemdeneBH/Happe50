@isTest
public with sharing class SM_AP71_TransformTableauChargeGaz_Test {
public SM_AP71_TransformTableauChargeGaz_Test() {

}


public  static testMethod void test(){

        
String input = '{ "causedBy": "La date et la plage horaire demandées ne sont pas disponibles. Choisissez une nouvelle date et ou plage horaire dans la liste.","libelle": "La date et la plage horaire demandées ne sont pas disponibles. Choisissez une nouvelle date et ou plage horaire dans la liste.", "codeRetour": "OCTOPUS_CreerPrestationServiceGaz_04",  "tableauDeChargeGaz": {   "creneauDisponible": [     {       "creneauHoraire": {         "code": {           "#text": "dma"         },         "libelleCourt": {           "#text": "Début matinée"         }      },       "date": {          "#text": "2019-10-19T00:00:00"        }     },     {       "creneauHoraire": {          "code": {            "#text": "mjo"          },         "libelleCourt": {           "#text": "Milieu de journée"         }       },    "date": {        "#text": "2019-10-19T00:00:00"     }    },  {        "creneauHoraire": {         "code": {           "#text": "mat"        },        "libelleCourt": {          "#text": "Matin"         }       },        "date": {        "#text": "2019-10-20T00:00:00"       }    }   ] },  "idDistributeur": "W00006JV", "prestationServiceFournisseurCree": "false", "prestationServiceDistributeurCree": "false"}';

Map<String,Object> inputMpa  = (Map<String,object> )Json.deserializeUntyped(input) ;
Map<String,object> outMap = new Map<String,object>() ;
SM_AP71_TransformTableauChargeGaz obj = new SM_AP71_TransformTableauChargeGaz() ;
obj.invokeMethod('transformTableauCharge',inputMpa,outMap,null) ;

}
}