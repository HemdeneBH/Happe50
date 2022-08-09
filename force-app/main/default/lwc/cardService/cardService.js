import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api, track} from 'lwc';

export default class CardService extends NavigationMixin(LightningElement) {
    // @api listrecord;
    // @api index;
    @api selecteditem;
    @track selecteditem;
    @track columns = [
            {key: "services", value: "Services"},
            {key: "dateActivation", value: "Date d'activation"},
            {label: "dateResiliation", value: "Date de résiliation"}]

    get showSpinner() {
        return this.selecteditem && this.selecteditem.key >=0 && this.selecteditem.loadService;
    }

    get isServicesClose() {
        return this.selecteditem && this.selecteditem.listServices && this.selecteditem.listServices.length && !this.selecteditem.closeservice;
    }

    get isServicesOpen() {
        return this.selecteditem && this.selecteditem.listServices && this.selecteditem.listServices.length && this.selecteditem.closeservice;
    }

    get nothing() {
        return !this.isServicesClose && !this.isServicesOpen
    }
    
    handleOpenRecordClick() {
        let eventName = 'popupevent';
        const event = new CustomEvent(eventName, { bubbles: true, composed: true, detail: {type: 'service'} });
        this.dispatchEvent(event);
    }
}