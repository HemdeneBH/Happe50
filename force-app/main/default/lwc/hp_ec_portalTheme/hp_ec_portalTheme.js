/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 04-11-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/HP_EC_variables';
import init from '@salesforce/apex/HP_EC_LoadCustomerData.init';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';
import { MessageContext } from 'lightning/messageService';
import { publishMC, subscribeMC, unsubscribeMC } from 'c/hp_ec_utl_lightningMessageManager';

//import jsStyle from "@salesforce/resourceUrl/HP_EC_StyleManager";
//import hp_ec_menuItem from '../hp_ec_menuItem/hp_ec_menuItem';

 /**
 * @slot headerMobile
 * @slot header
 * @slot menu
 * @slot main
 * @slot offre
 * @slot footer
 */


export default class Hp_ec_portalTheme extends LightningElement {

  //@track  theme;
  @track  hasRenderedOnce;
  @wire(init) initStatus;
  @wire(MessageContext) messageContext;

  openedMessageID = null;

  connectedCallback() {
    loadStyle(this, styles);
    this.handleSubscription();
    let currentAddr = sessionStorage.getItem('currentAddress');
    console.log(currentAddr);
    if (currentAddr) {
      this.handlePublish(currentAddr);
    }
    
  }

  renderedCallback() {
 
    if (this.hasRenderedOnce) {
      return;
    }
    this.attachListeners();
    this.loadUserThemeLayout();
    this.hasRenderedOnce = true;
  }

  loadUserThemeLayout() {
    //let userPrefTheme = localStorage.getItem('LSKey[c]theme');
    let userPrefTheme = localStorage.getItem('theme');
    console.log(userPrefTheme);
    if (!userPrefTheme) {
      console.log('set default theme');
      userPrefTheme = 'darkTheme'; //default theme
      //localStorage.setItem('LSKey[c]theme', userPrefTheme);
      localStorage.setItem('theme', userPrefTheme);
    }
    console.log('Init theme : ' + userPrefTheme);
    this.template.host.className = userPrefTheme;
  }

  attachListeners() {
    console.log('Listener added');
    this.template.addEventListener('stylechange', this.handleStyleEvent.bind(this));
    //this.template.addEventListener('addresschange', this.handleAddrEvent.bind(this));
  }

  handleStyleEvent(event) {
    console.log('event received');
    const themeToLoad = event.detail;
    console.log('theme :' + themeToLoad);
    this.switchStyle(themeToLoad);
  }

  handleAddrEvent(event) {
    console.log('1: Addr event received : ' + event.detail);
    this.handlePublish(event.detail);
//    sessionStorage.setItem('currentAddress', event.detail);
  }

  handleSubscription() {
    if (!this.subscription) {
        subscribeMC(this, this.messageContext, this.handleLightningMessage);
    }
  } 

  handleLightningMessage(self, subscription, message) {

  }

  handlePublish(message) {
    console.log('Message published : ' + message);
    publishMC(this.messageContext, message, 'SelectedPortfolio');
  }

  switchStyle(styleName) {
    switchTheme.call(this, styleName);
  }

  openPopin(event) {
    event.stopPropagation();
    const popins = this.template.querySelector('c-hp_ec_popins');
    if (popins) {
      popins.openPopin(event);
    }
  }

  closePopin(event) {
    event.stopPropagation();
    const popins = this.template.querySelector('c-hp_ec_popins');
    if (popins) {
      popins.closePopin(event);
    }
  }
}