/**
 * @File Name          : HP_WRP004_AgilabPersonne.cls
 * @Description        : Structure de réponse de API Personne Agilab
 * @Author             : Sara El-Hannaoui
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 24/12/2019 à 11:18:04
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/12/2019   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_WRP004_AgilabPersonne {
	public static final String AGILAB_FUNCTIONAL_ID_PREFIX = '950';
	public String status;
	public String message;
	public Output output;
	public Integer functionalId;

	public class Output {
		public Integer id;
	}

	public void functionalIdHandler(){
		this.functionalId =   Integer.valueOf(AGILAB_FUNCTIONAL_ID_PREFIX + String.valueOf(this.output.id));
	}
}