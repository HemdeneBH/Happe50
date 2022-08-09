/**
 * @File Name          : HP_WRP0016_AgilabPersonne.cls
 * @Description        : Structure de réponse de API Personne Agilab
 * @Author             : Sara El-Hannaoui
 * @Last Modified By   : Mohamed Aamer
 * @Last Modified On   : 20/01/2020 à 16:00:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/12/2019   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_WRP0016_AgilabPersonne {
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