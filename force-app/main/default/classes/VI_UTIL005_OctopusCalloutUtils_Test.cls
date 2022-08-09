/*
*@Author: Eloi Dereeper
*@Description: Class test pour VI_UTIL005_OctopusCalloutUtils
*@CreatedDate: 27/11/2020
*@LastModified: 27/11/2020
*/
@isTest
public class VI_UTIL005_OctopusCalloutUtils_Test {
    
    public static Boolean isTestingPopulateDoc = false;
    
    @isTest
    public static void test_initContext(){
        VI_UTIL005_OctopusCalloutUtils.initContext('application', 'version', true);
    }
    
    @isTest
    public static void test_initValue(){
        VI_UTIL005_OctopusCalloutUtils.initValue('value');
    }
    
    @isTest
    public static void test_initConsommationPort(){
        VI_UTIL005_OctopusCalloutUtils.initConsommationPort();
    }
    
    @isTest
    public static void test_populateXmlNode(){
        
        // Test de la première méthode, liée à la MAJ personne.
        
        // Création du XMLNode
        Dom.Document doc = new DOM.Document();
        DOM.XmlNode node = doc.createRootElement('Node', '', '');
        
        // Création du majPersonneInputDt et des éléments qui le composent
        gdfsuezComBefCalypsoPersonneV8.Personne personne = new gdfsuezComBefCalypsoPersonneV8.Personne();
        
        gdfsuezBefCalypsoPersonneV8.majPersonneInputDt majPersonneInput = new gdfsuezBefCalypsoPersonneV8.majPersonneInputDt();
        majPersonneInput.personne = personne;
        
        // Création du contextDt et des éléments qui le composent
        gdfsuezComBefChpPivotV8.contextDt_systemPath_element systemPath = new gdfsuezComBefChpPivotV8.contextDt_systemPath_element(); 
        
        gdfsuezComBefChpPivotV8.contextDt context = new gdfsuezComBefChpPivotV8.contextDt();
        context.version = '3';
        context.systemPath = systemPath;
        context.allowCache =true;
        
        VI_UTIL005_OctopusCalloutUtils.populateXmlNode(node, majPersonneInput, context);
        
        // Test de la première méthode, liée à la MAJ personne.
        
        // Création du creerPersonneInputDt
        gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt creerPersonneInput = new gdfsuezBefCalypsoPersonneV8.creerPersonneInputDt();
        creerPersonneInput.personne = personne;
        
        VI_UTIL005_OctopusCalloutUtils.populateXmlNode(node, creerPersonneInput, context);
    }
    
    @isTest
    public static void test_populateDocAndSubsequentMethods(){
        isTestingPopulateDoc = true;
        Dom.Document doc = new DOM.Document();
        
        VI_UTIL005_OctopusCalloutUtils.populateDoc(doc, 'certificateName', 'VI', '3', 'VIToken');
    }
    
    @isTest
    public static void test_AddHeader(){
        isTestingPopulateDoc = true;
        Dom.Document doc = new DOM.Document();
        DOM.XmlNode node  =  VI_UTIL005_OctopusCalloutUtils.populateDocConso(doc);
        VI_UTIL005_OctopusCalloutUtils.AddHeader(node, 'certificateName', 'VI', '3', 'VIToken');
    }
    
    @isTest
    public static void test_initConsommationPort2(){
        VI_UTIL005_OctopusCalloutUtils.initConsommationPort('callout:VI_AuthOctopus');
    }
    
}