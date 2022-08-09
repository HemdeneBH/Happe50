import { NavigationMixin } from 'lightning/navigation';
import { LightningElement, api} from 'lwc';

export default class CardInformationLogement extends NavigationMixin(LightningElement) {
    @api information

    get informationType() {
        return this.information ? this.information : ' _ ';
    }
}