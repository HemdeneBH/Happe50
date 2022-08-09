/**
 * @description       : 
 * @author            : Hemdene Ben Hammouda
 * @group             : 
 * @last modified on  : 04-08-2022
 * @last modified by  : Hemdene Ben Hammouda
**/
import { LightningElement, api, track, wire } from 'lwc';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import styles from '@salesforce/resourceUrl/HP_EC_variables';
import init from '@salesforce/apex/HP_EC_LoadCustomerData.init';
import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_portalTemeLogin extends LightningElement {
    @track  hasRenderedOnce;
    @wire(init) initStatus;

  contactPopin = false;
  messagesPopin = false;
  chatPopin = false;

  openedMessageID = null;

  connectedCallback() {
    loadStyle(this, styles);
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
    let userPrefTheme = localStorage.getItem('theme');
    console.log(userPrefTheme);
    if (!userPrefTheme) {
      console.log('set default theme');
      userPrefTheme = 'darkTheme'; //default theme
      localStorage.setItem('theme', userPrefTheme);
    }
    console.log('Init theme : ' + userPrefTheme);
    this.template.host.className = userPrefTheme;
  }

  attachListeners() {
    console.log('Listener added');
    this.template.addEventListener('stylechange', this.handleStyleEvent.bind(this));
  }

  handleStyleEvent(event) {
    console.log('event received');
    const themeToLoad = event.detail;
    console.log('theme :' + themeToLoad);
    this.switchStyle(themeToLoad);
  }

  switchStyle(styleName) {
    switchTheme.call(this, styleName);
  }

}