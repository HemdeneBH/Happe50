import { NavigationMixin } from "lightning/navigation";
import { LightningElement, api } from "lwc";
export default class CardError extends NavigationMixin(LightningElement) {
    @api errorMessage;
}