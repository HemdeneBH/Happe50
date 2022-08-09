import { LightningElement } from 'lwc';
import omniscriptMessaging from "vlocity_cmt/omniscriptMessaging";

export default class Os_NonBlockingErrorMessage extends omniscriptMessaging {
    evaluateValidity() {
        return true;
    }
}