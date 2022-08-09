/*
*@Author: Eloi Dereeper
*@Description: Classe test de VI_SM023_PrecoRepartitionCadrans
*@CreatedDate: 25/11/2020
*@LastModified: 25/11/2020
*/
@isTest
public class VI_SM023_PrecoRepartitionCadrans_Test {
    
    @isTest
    public static void preconiserRepartitionCadrans(){
        
        // Cas nominal, avec un FAT valide
        Map<String, Object> preconisation_Success = VI_SM023_PreconiserRepartitionCadrans.preconiserRepartitionCadrans('Loc', 'BTINFMU4', 'VI', '3', 'callout:AuthOctopus');
        System.assertEquals(0.35454, preconisation_Success.get('HPH'));
        System.assertEquals(0.21492, preconisation_Success.get('HPB'));
        System.assertEquals(0.24639, preconisation_Success.get('HCH'));
        System.assertEquals(0.18415, preconisation_Success.get('HCB'));
        
        // Cas d'une FAT non valide, avec un message retour indiquant que le traitement ne s'est pas effectué correctement.
        Map<String, Object> preconisation_Erreur = VI_SM023_PreconiserRepartitionCadrans.preconiserRepartitionCadrans('Loc', '', 'VI', '3', 'callout:AuthOctopus');
        System.assertEquals('La FTA fournie ne correspond à aucun code tarifaire distributeur connu', preconisation_Erreur.get('Erreur'));
    }

}