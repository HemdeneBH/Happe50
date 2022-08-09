/**
 * @File Name          : HP_WRP036_APIHourCodeOffre.cls
 * @Description        :  Structure de réponse de l'API Offre Xdata
 * @Author             : Sara El-Hannaoui
 * @Group              : 
 * @Last Modified By   : Sara El-Hannaoui
 * @Last Modified On   : 05/05/2020 à 15:31:42
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    05/05/2020   Sara El-Hannaoui     Initial Version
**/
public with sharing class HP_WRP036_APIHourCodeOffre {
    public Integer id;	
	public Integer idPack;	
	public String code;	
	public String libelle;	
	public String libelleLong;	
	public String type;	
	public boolean configurable;
	public String duale;	
	public String specificite;	
	public boolean optionnel;
	public boolean parDefaut;
	public String duree;	
	public String codeMarque;	
	public String libelleMarque;
}