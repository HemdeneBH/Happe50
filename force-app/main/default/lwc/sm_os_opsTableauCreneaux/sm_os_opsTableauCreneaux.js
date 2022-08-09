import { LightningElement, api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

/*** --- WARNING --- ***/
// Ce composant est utilise dans Selfcare et dans Smile (dans Creation OPS, Modification OPS, Résiliation,contestation d'index) !!!
// Attention à ne pas créer de régression dans un autre Omniscript
/*** --- ***/

const jours = new Array("dimanche", "lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi");
const mois = new Array("jan", "fev", "mars", "avril", "mai", "juin", "juillet", "aout", "sept", "oct", "nov", "dec");

export default class Sm_os_opsTableauCreneaux extends OmniscriptBaseMixin(LightningElement) {
  @api selfcare;
  @api date;
  @api creneau;
  tableau = [];
  showSpinner = false;
  @api responseprestation;
  @api type;
  displayRange;
  displayFrom = 0;
  tableLength;
  dIndex = -1;
  cIndex = -1;

  getDateTitle(input) {
    //var date = new Date(date.substring(0,10));
    var date = new Date(input);
    return jours[date.getDay()] + ' ' + date.getDate() + ' ' + mois[date.getMonth()];
  }

  get tableauExist() {
    console.log("in tableauExist, this.omniJsonData : ", JSON.stringify(this.omniJsonData));
    var responseName = this.omniJsonDef.propSetMap.show.group.rules[0].field.split(':')[0];

    if (this.omniJsonData) {
      if (this.omniJsonData.target == 'c:smContactContestationIndexFrench'){
        return (this.omniJsonData[responseName] && this.omniJsonData[responseName].tableauDeCharges) ? true : false;
      } else{
        return this.omniJsonData[this.omniJsonDef.name] ? true : false;

    }
    } else {
      return false;
    }
  }

  getTableauContestationIndex() {
    if (this.tableauExist) {
      var responseName = this.omniJsonDef.propSetMap.show.group.rules[0].field.split(':')[0];
      // getting the data from the Omniscript element name
      var data = JSON.parse(JSON.stringify(this.omniJsonData[responseName].tableauDeCharges.creneauDisponible));
     console.log(data);
    


      // group creneaux by date
      let tableau = [];
      for (var i = 0; i < data.length; i++) {        
        console.log('entre'+tableau.filter(e => e.date === data[i].date["#text"]));
        if (tableau.length === 0 || tableau.filter(e => e.date === data[i].date["#text"]).length === 0) {
          let creneaux = data.filter(e => e.date["#text"] === data[i].date["#text"]);
          console.log('total'+creneaux);
          let tempCreneaux = [];
          for (let c of creneaux) {
            tempCreneaux.push({
              code: c.creneauHoraire.code["#text"],
              libelle: c.creneauHoraire.libelleCourt["#text"],
            })
          }
          console.log('creneaux',JSON.stringify(tempCreneaux));
          tableau.push({
            date: data[i].date["#text"],
            value: this.getDateTitle(data[i].date["#text"]),
            creneaux: tempCreneaux
          });
        }
        console.log('fin'+tableau);
      }
      this.tableLength = tableau.length;
      
      console.log("### Tableau: ", JSON.stringify(tableau));
      return tableau;
    }
  }
  getTableau() {
    if (this.omniJsonData.target == 'c:smContactContestationIndexFrench'){
      console.log("in contestation");
      return this.getTableauContestationIndex();
    }
      else{
    if (this.tableauExist) {
      // getting the data from the Omniscript element name
      var data = JSON.parse(JSON.stringify(this.omniJsonData[this.omniJsonDef.name].creneauDisponible));
      // group creneaux by date
      let tableau = [];
      for (var i = 0; i < data.length; i++) {
        if (tableau.length === 0 || tableau.filter(e => e.date === data[i].date_x).length === 0) {
          let creneaux = data.filter(e => e.date_x === data[i].date_x);
          let tempCreneaux = [];
          for (let c of creneaux) {
            tempCreneaux.push({
              code: c.creneauHoraire.code,
              libelle: c.creneauHoraire.libelleCourt,
            })
          }
          tableau.push({
            date: data[i].date_x,
            value: this.getDateTitle(data[i].date_x),
            creneaux: tempCreneaux
          });
        }
      }
      this.tableLength = tableau.length;
      console.log("### Tableau: ", JSON.stringify(tableau));
      return tableau;
    }
  }}

  connectedCallback() {
    var windowWidth = window.innerWidth;
    // display range is the number of days displayed, must be responsive for the selfcare
    this.displayRange = windowWidth > 800 ? 4 : 2;
  }

  handleSelect(event) {
    this.dIndex = event.detail.x + this.displayFrom;
    this.cIndex = event.detail.y;
    console.log("### handleSelect, x: ", this.dIndex, ", y: ", this.cIndex);
    let tableau = this.getTableau();
    console.log("handleSelect Date : ", [this.date] + " : " + tableau[this.dIndex].date);
    if (this.omniJsonData.target == 'c:smContactContestationIndexFrench'){
      this.omniApplyCallResp({ DateIntervention: tableau[this.dIndex].date });
    }
    else{
      this.omniApplyCallResp({ [this.date]: tableau[this.dIndex].date });
    }
    let creneauCode = tableau[this.dIndex].creneaux[this.cIndex].code;
    if (this.selfcare) {
      creneauCode = creneauCode.toUpperCase();
    }
    else {
      creneauCode = creneauCode.toLowerCase();
    }
    console.log("handleSelect Creneau : ", { [this.creneau]: creneauCode });
    this.omniApplyCallResp({ [this.creneau]: creneauCode });
  }

  get displayTableau() {
    console.log("in displayTableau");
    let tableau = this.getTableau();
    console.log("### Tableau in display: ", JSON.stringify(tableau));
    if (tableau) {
      if (this.dIndex > -1 && this.cIndex > -1) tableau[this.dIndex].creneaux[this.cIndex].selected = true;
      console.log("### displayTableau: ", JSON.stringify(tableau));
      return tableau.slice(this.displayFrom, this.displayFrom + this.displayRange);
    }
  }

  get prevIsActive() {
    return (this.displayFrom > 0) || this.type.toLowerCase() === 'gaz' ? true : false;
  }
  get prevClass() {
    var str = "navigation left";
    return this.prevIsActive ? str + " active" : str;
  }

  get nextIsActive() {
    return (this.displayFrom + this.displayRange < this.tableLength) || this.type.toLowerCase() === 'gaz' ? true : false;
  }
  get nextClass() {
    var str = "navigation right";
    return this.nextIsActive ? str + " active" : str;
  }

  navigateGaz(isNext) {
    this.showSpinner = true;
    let params = {
      options: '{}',
    };
    if (this.selfcare) {
      params.sClassName = 'SM_AP30_PrestationGaz';
      params.sMethodName = 'updatePrestationGaz';
    }
    else if(this.omniJsonData.target == 'c:smContactContestationIndexFrench') {
      params.sClassName = 'vlocity_cmt.IntegrationProcedureService';
      params.sMethodName = 'IP_SM_prestationservicegaz_contestation_index_SOAP';
    }
    else if (this.omniJsonData.OSmodifOPS == true) {
      params.sClassName = 'vlocity_cmt.IntegrationProcedureService';
      params.sMethodName = 'IP_SM_ModifierPrestationGaz_SOAP';
    }
    else {
      params.sClassName = 'vlocity_cmt.IntegrationProcedureService';
      params.sMethodName = 'IP_SM_CreerPrestationGaz_SOAP';
    }
    let inputMap = {};
    if (this.selfcare) {
      inputMap.TypeUser = 'Client';
      inputMap.OPSUpdate = this.omniJsonData.OPSUpdate;
    }
    else if(this.omniJsonData.target == 'c:smContactContestationIndexFrench') {
      inputMap.typeOffre= 'INDUSTRIELLE';
      inputMap.codePrestation= this.omniJsonData.operationreVerifierRecevabiliteIndexGaz.OPSCode;
      inputMap.natureDemande= this.omniJsonData.operationreVerifierRecevabiliteIndexGaz.natureDemande;
      inputMap.idPDLGaz= this.omniJsonData.pce;
      inputMap.idPersonne= this.omniJsonData.idBusinessPartner;
      inputMap.idPersonneResponsable= this.omniJsonData.indentifiantSAP;
      inputMap.idContrat= this.omniJsonData.idContratGaz;
      inputMap.typePrestationService= 'Z002';
      inputMap.dateRdvDate= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.DateIntervention;
      inputMap.origineDemande='CLIENT';
      inputMap.creneauHoraireCode= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Creneau;
      inputMap.civiliteCode= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Civilite;
      inputMap.nom= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Nom;
      inputMap.prenom= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Prenom;
      inputMap.telephone= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Telephone;
      inputMap.commentaireIntervention= this.omniJsonData.ReleveSpeciale.BlockRDVOPS.Commentaire;
      inputMap.typeDemandeTechniqueCode= this.omniJsonData.operationreVerifierRecevabiliteIndexGaz.typeDemande;
      inputMap.indexContesteDateIndex= this.omniJsonData.contestGaz.dateReleveFormat;
      inputMap.indexContesteValeurIndex= this.omniJsonData.contestGaz.indexFin;
      inputMap.indexContesteTypeIndexConteste=this.omniJsonData.contestGaz.typeReleve.code;
      inputMap.indexClientDateIndex= this.omniJsonData.FactureIndex.BlockContestGaz.Date;
      inputMap.indexClientValeurIndex= this.omniJsonData.indexGaz;
      inputMap.idPrestationServiceDistributeur= this.omniJsonData.prestationOPSGaz.idPrestationServiceDistributeur;
    }
    else {
      inputMap.OPSUpdate = this.omniJsonData.OPSUpdate;
      inputMap.idF = this.omniJsonData.idF;
      inputMap.idD = this.omniJsonData.idD;
    }
    console.log("inputMap: ", JSON.stringify(inputMap));
    inputMap.actionName = isNext == true ? 'NAVIGUER_SUIV' : 'NAVIGUER_PREC';
    console.log("Gaz actionName: ", inputMap.actionName);
    params.input = JSON.stringify(inputMap);
    console.log("params: ", params);
    this.omniRemoteCall(params)
      .then(res => {
        console.log("res: ", res);
        if (res.result && res.result.IPResult) {
          this.omniApplyCallResp(res.result.IPResult);
        }
        else {
          this.omniApplyCallResp(res.result);
        }
        this.showSpinner = false;
      }).catch(error => {
        console.log('error from query : ', error);
      });
    }

  handlePrev() {
    if (this.prevIsActive) {
      if (this.type.toLowerCase() === 'gaz') {
        this.dIndex = -1;
        this.cIndex = -1;
        this.navigateGaz(false);
      }
      else {
        this.displayFrom = (this.displayFrom >= this.displayRange) ? this.displayFrom - this.displayRange : 0;
      }
    }
  }

  handleNext() {
    if (this.nextIsActive) {
      // we should always display same number of days (displayRange) so we increment up to (this.tableLength - this.displayRange)
      if (this.type.toLowerCase() === 'gaz') {
        this.dIndex = -1;
        this.cIndex = -1;
        this.navigateGaz(true);
      }
      else {
        this.displayFrom = (this.displayFrom + 2 * this.displayRange < this.tableLength) ? this.displayFrom + this.displayRange : this.tableLength - this.displayRange;
      }
    }
  }
}