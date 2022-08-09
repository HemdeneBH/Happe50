/**
 *@description       : Tableau qui affiche la liste de contacts pour choisir un payeur divergent
  @author            : AE
  @group             : FT2
  @last modified on  : 09-29-2021
  @last modified by  : AE
 */
import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class SM_vlocity_PayeurDivergentTableau extends OmniscriptBaseMixin(LightningElement)  {
    // Initialisation des données à afficher 
    @api 
    tableData = [];

    theme = "slds";
    //Initialisation de la taille du tableau
    
    @api sizeTab = 0;
    //Initialisation des colonnes a afficher dans le tableau
    columns = [{
        "fieldName": "Identifiant_Buisness_Partener__c",
        "label": "N° DE CLIENT",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "false",
        "visible": "true"
        },
        {
        "fieldName": "Salutation",
        "label": "CIVILITÉ",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "LastName",
        "label": "NOM",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "FirstName",
        "label": "PRÉNOM",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "MailingPostalCode",
        "label": "CODE POSTAL",
        "searchable": false,
        "sortable": true,
        "type": "number",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "MailingCity",
        "label": "LOCALITÉ",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "No_Voie__c",
        "label": "N°",
        "searchable": false,
        "sortable": true,
        "type": "number",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "MailingStreet",
        "label": "VOIE",
        "searchable": false,
        "sortable": true,
        "type": "text",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        },
        {
        "fieldName": "Id",
        "label": "",
        "searchable": false,
        "sortable": true,
        "type": "url",
        "editable": "false",
        "userSelectable": "true",
        "visible": "true"
        }
    ];
    get resultat () {
        if(this.sizeTab == 0 || this.sizeTab == 1){
            return false;
        }else{
            return true;
        }
    }   
    connectedCallback() {
        if(this.tableData){
            this.sizeTab = this.tableData.length;
        }
    }
}