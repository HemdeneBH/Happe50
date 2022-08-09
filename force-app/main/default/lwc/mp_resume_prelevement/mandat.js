export default class MandatWrapper{

	constructor(id, 
		numeroMandat, 
		statut, 
		codeFournisseur, 
		dateSignature, 
		dateValidation, 
		dateModification, 
		idPersonne, 
		idBusinessPartner, 
		coordonneesBancaire) {
			this.id = id;
			this.numeroMandat = numeroMandat;
			this.statut = statut;
			this.codeFournisseur = codeFournisseur;
			this.dateSignature = dateSignature;
			this.dateValidation = dateValidation;
			this.dateModification = dateModification;
			this.idPersonne = idPersonne;
			this.idBusinessPartner = idBusinessPartner;
			this.coordonneesBancaire = coordonneesBancaire;
		}
}