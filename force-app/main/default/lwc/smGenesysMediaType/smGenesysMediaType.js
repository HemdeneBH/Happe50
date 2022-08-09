/**
 * @description       : Handle WS Call to Genesys in order to choose adn show the media type from Smile UI
 * @author            : Mohamed Aamer
 * @last modified on  : 01-31-2022
 * @last modified by  : Mohamed Aamer
 * @version           : 1.0
**/
import { LightningElement} from 'lwc';
import getGenesysUserId from '@salesforce/apex/SM_CTRL009_MediaGenesys.getGenesysUserId';
import getAllMedias from '@salesforce/apex/SM_CTRL009_MediaGenesys.getMedias';
import getAllowedMedia from '@salesforce/apex/SM_CTRL009_MediaGenesys.getAllowedMediaTypes';
import getMediaConfig from '@salesforce/apex/SM_CTRL009_MediaGenesys.getMediaConfig';
import getFederationId from '@salesforce/apex/SM_CTRL009_MediaGenesys.getFederationId';
import patchMedias from '@salesforce/apex/SM_CTRL009_MediaGenesys.patchMedias';
import { consoleLogHandler } from 'c/smConsoleLog';
import { toastHandler } from 'c/smToastEvent';
import ConfigError from '@salesforce/label/c.SM_GENESYS_CONFIG_ERROR';
import UpdateSuccess from '@salesforce/label/c.SM_GENESYS_UPDATE_SUCCESS';
import UpdateError from '@salesforce/label/c.SM_GENESYS_UPDATE_ERROR';
import NoUserError from '@salesforce/label/c.SM_GENESYS_NO_USER_ERROR';
import GenesysIdError from '@salesforce/label/c.SM_GENESYS_ID_ERROR';
import FederationIdError from '@salesforce/label/c.SM_GENESYS_FEDERATION_ID_ERROR';
import GenesysMediasError from '@salesforce/label/c.SM_GENESYS_MEDIAS_ERROR';
export default class SmGenesysMediaType extends LightningElement {

    strAllMedia=[];lisOfAllowedMedias=[];errorMedias=false;errorMessage;isOneMediaType=false;
    res=[]; listOfObjects=[]; ListOfMed=[];
    mediaConf = {};
    label = {
        ConfigError,
        UpdateSuccess,
        UpdateError,
        NoUserError,
        GenesysIdError,
        FederationIdError,
        GenesysMediasError
    }
    
    connectedCallback(){
        this.init();
    }

    init(){
        //Get Media config from custom settings
        getMediaConfig().then(result => {
            consoleLogHandler('getMediaConfig result: ',JSON.stringify(result));
            this.mediaConf.baseEndpoint = result.PrimaryNamedEndpoint__c+result.Resource__c;
            this.mediaConf.pageSize = result.Page_Size__c;
            consoleLogHandler('getMediaConfig list: ',JSON.stringify(this.mediaConf));
            this.getMediaTypes();
        })
        .catch(error => {
            consoleLogHandler('@@error getMediaConfig: ',JSON.stringify(error));
            this.errorMessage = this.label.ConfigError;
            this.listOfObjects = false;
            this.errorMedias = true;
        });
    }

    getMediaTypes(){
        //get allowed media types defined in a custom metadata Type
        getAllowedMedia().then(result => {
            this.lisOfAllowedMedias = result;
            consoleLogHandler('getAllowedMedia list: ',JSON.stringify(this.lisOfAllowedMedias));
            this.federationId();
        }).catch(error => {
            this.lisOfAllowedMedias= undefined;
            consoleLogHandler('@@error getAllowedMedia: ',JSON.stringify(error));
            this.errorMessage = this.label.ConfigError;
            this.listOfObjects = false;
            this.errorMedias = true;
        });
    }

    federationId(){
        getFederationId().then(result => {
            consoleLogHandler('federationId : ',JSON.stringify(result));
            if(result){
                this.mediaConf.federationId = result;
                this.getGenUserId();
            }else{
                this.errorMessage = this.label.FederationIdError;
                this.listOfObjects = false;
                this.errorMedias = true;
            }
        }).catch(error => {
            consoleLogHandler('@@error federationId: ',JSON.stringify(error));
            this.errorMessage = this.label.FederationIdError;
            this.listOfObjects = false;
            this.errorMedias = true;
        });
    }

    //Get Genesys User's ID from session, othewise from genesys API call
    getGenUserId(){
        sessionStorage.clear();
        //Check if genesys user's ID already exist in sessionSotrage
        if(sessionStorage.getItem('id')){
            //Add UserId   in the session Storage
            this.mediaConf.genUserId = sessionStorage.getItem('id');
            this.mediaConf.pageSize=sessionStorage.getItem('size');
            consoleLogHandler('getGenUserId from session storage: ',this.mediaConf.genUserId);
            this.getAllGenMedia();
        } else{//call Genesys API to get the Genesys User's ID
            getGenesysUserId({baseEndpoint:this.mediaConf.baseEndpoint, federationId:this.mediaConf.federationId})
            .then(result => {
                if(result){
                    //Aucun utilisateur trouvé dans Genesys en se basant sur le federationID
                    if(result === 'noUser'){
                        this.errorMessage = this.label.NoUserError;
                        this.listOfObjects = false;
                        this.errorMedias = true;
                    } else {
                        consoleLogHandler('getGenUserId from call : ',result);
                        this.mediaConf.genUserId = result;
                        //Set User Id & pageSize in the session  storage to save getGenesysUserId callout while session is active
                        sessionStorage.setItem('id',this.mediaConf.genUserId);
                        sessionStorage.setItem('size',this.mediaConf.pageSize);
                        this.getAllGenMedia();
                    }
                    
                } else {
                    //le federationID n'est pas renseigné au niveau du User
                    this.errorMessage = this.label.FederationIdError;
                    this.listOfObjects = false;
                    this.errorMedias = true;
                }
            })
            .catch(error => {
                consoleLogHandler('@@error getGenUserId from call : ',JSON.stringify(error));
                this.genUserId = undefined;
                this.errorMessage = this.label.GenesysIdError;
                this.listOfObjects = false;
                this.errorMedias = true;
            });
        }
    }
      

    //Get All User's Media from Genesys API
    getAllGenMedia() {
        getAllMedias({baseEndpoint:this.mediaConf.baseEndpoint, genUserId: this.mediaConf.genUserId, pageSize:this.mediaConf.pageSize})
            .then((result) => {
                consoleLogHandler('getAllMedias result : ',JSON.stringify(result.entities));
                this.strAllMedia = result.entities;
                this.handleGrouping();
            })
            .catch((error) => {
                consoleLogHandler('@@error getAllMedias : ',error);
                this.strAllMedia = undefined;
                this.errorMessage = this.label.GenesysMediasError;
                this.listOfObjects = false;
                this.errorMedias = true;
            });
    }

    //construct Media by Media Type (FA,SFBO,SORTANT) 
    handleGrouping(){
        let mediaTypes = Object.entries(this.lisOfAllowedMedias);
       this.res=[]
       let allMedias = Object.entries(this.strAllMedia);
       this.listOfObjects=[];
       const isObject = (value) => typeof value === "object" && value !== null;
       allMedias.forEach(([key, value]) => {
            mediaTypes.forEach(([k, v],i) => {
                //Filter Media entities by Media Types allowed in Salesforce configured in a custom Metadata
                if (!this.res.includes(v.Libelle_interface_switch_conseiller__c) && value.name.startsWith(v.Prefixe_queue_genesys__c)) {
                    this.res.push(v.Libelle_interface_switch_conseiller__c,value.joined);
                    var singleObj = {};
                    singleObj['type'] = v.Libelle_interface_switch_conseiller__c;
                    singleObj['val'] = value.joined;
                    singleObj['prefix'] = v.Prefixe_queue_genesys__c;
                    this.listOfObjects.push(singleObj);
                }
                //If at least one Media of the queue is TRUE then the Media type will be checked in UX
                if(this.res.includes(v.Libelle_interface_switch_conseiller__c) && value.joined && isObject(this.listOfObjects)&& value.name.startsWith(v.Prefixe_queue_genesys__c)){
                    var elementPos = this.listOfObjects.map(function(x) {return x.type; }).indexOf(v.Libelle_interface_switch_conseiller__c);
                    this.listOfObjects[elementPos].val=true;
                }
            });
        });
        consoleLogHandler('handleGrouping final list: ',JSON.stringify(this.listOfObjects));
        consoleLogHandler('number of media types: ',this.listOfObjects.length);
        // If there's only one media type, then disable 'modifier' button
        if (this.listOfObjects.length <= 1) {
            this.isOneMediaType = true;
            this.handleUpdateButton(false);
        }
    }

    // Update JSON of Medias after toggle
    changeToggle(event){
        //Enable 'Modifier' button when initial config is changed
        //this.handleUpdateButton(true);
        this.ListOfMed=this.listOfObjects;
        var elementPos = this.ListOfMed.map(function(x) {return x.type; }).indexOf(event.target.name);
        var objectFound = this.ListOfMed[elementPos];
        objectFound.val=event.target.checked;
        consoleLogHandler('changeToggle modified list : ',JSON.stringify(this.ListOfMed));
        
        //If there's more than one media type
        if(!this.isOneMediaType){
            //check if all media types are disabled
            //search at least one activated media type
            var enabledMedia = this.ListOfMed.find(media => media.val === true);
            enabledMedia ? this.handleUpdateButton(true) : this.handleUpdateButton(false);
        }
    }

    //submit updated Media JSON
    handleSubmit(){
        this.listPatch=[];
        let pref = Object.entries(this.ListOfMed);
        let lst = Object.entries(this.strAllMedia);
        lst.forEach(([key, value]) => {
             pref.forEach(([k, v],i) => {         
             if (value.name.startsWith(v.prefix)) {
                 var singleObj = {};
                 singleObj['id'] = value.id;
                 singleObj['name'] = value.name;
                 singleObj['joined'] = v.val;
                 this.listPatch.push(singleObj);
             }
             });
         });
        consoleLogHandler('handleSubmit listToPatch: ',JSON.stringify(this.listPatch));
        this.patchGroupMedia();
    }

    // CAll Patch API to update Medias 
    patchGroupMedia(){
        patchMedias({baseEndpoint:this.mediaConf.baseEndpoint, genUserId: this.mediaConf.genUserId, objMedias: this.listPatch})
        .then((result) => {  
            consoleLogHandler('patchGroupMedia result : ',result);
            if(result==200){
                toastHandler(this,'Success!',this.label.UpdateSuccess,'success');
                //Disable 'Modifier' button
                this.handleUpdateButton(false);
            }else {
                toastHandler(this,'Fail!',this.label.UpdateError,'fail');
            }
        })
        .catch((error) => {
            consoleLogHandler('@@error patchGroupMedia : ',error);
            toastHandler(this,'Fail!',this.label.UpdateError,'fail');
        });
    }

    //Handle 'Modifier' button enabling 
    handleUpdateButton(toEnable){
        let updateBlock = this.template.querySelector('[data-id="updateBlock"]');
        if(toEnable){
            this.template.querySelector('[data-id="updateBlock"]').className='update';
        }else{
            this.template.querySelector('[data-id="updateBlock"]').className='update disable';
        }
        consoleLogHandler('updateBlock : ',updateBlock);
    }
}