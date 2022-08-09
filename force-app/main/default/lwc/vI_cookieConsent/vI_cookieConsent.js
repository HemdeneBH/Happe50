import { LightningElement, track, api } from "lwc";
import getCookieData from "@salesforce/apex/VI_CookieConsentService.getCookieData";

export default class CookieConsent extends LightningElement {
  // State
  @api displayType = "page";
  @api useRelaxedCSP = false;
  showCookieDialog;
  preview;
  loading = true;

  // Data
  cookiePreferences = [];
  @track cookieData;
  uniqueId;

  // Design
  @api headingLabel = "Manage Cookies";
  @api instructions = "Cookie Instructions";
  @api informationButtonLabel = "View Privacy Policy";
  @api informationButtonLink = "https://www.salesforce.com";
  @api viewCookiesLabel = "View Cookies";
  @api viewCookiesLink = "https://www.salesforce.com";
  @api confirmButtonLabel = "Confirm Preferences";
  @api rejectButtonLabel = "Leave Site";
  @api cookieFooterRelative = false;
  @api cookieFooterPadding = "small";
  @api cookieFooterButtonAlignment = "center";
  @api cookieFooterBackgroundColor = "rgb(0,0,0)";
  @api cookieFooterLinkColor = "rgb(250, 250, 250)";
  @api cookieFooterTextColor = "rgb(250, 250, 250)";
  @api previewInBuilder = false;
  error;

  connectedCallback() {
   this.getCookieSectionsAndData();
  }

  checkIfInPreview() {
    let urlToCheck = window.location.href;
    if (!urlToCheck) {
      urlToCheck = window.location.hostname;
    }
    urlToCheck = urlToCheck.toLowerCase();
    this.preview = urlToCheck.indexOf("sitepreview") >= 0 || urlToCheck.indexOf("livepreview") >= 0;
  }




  getCookieSectionsAndData() {
    getCookieData()
      .then(data => {
        this.cookieData = [...data];
        this.loading = false;
      })
      .catch(error => {});
  }




  get pageState() {
    return this.displayType === "page";
  }


}