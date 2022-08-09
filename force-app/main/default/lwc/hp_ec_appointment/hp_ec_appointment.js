import { LightningElement } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import HP_EC_icon_alert from '@salesforce/resourceUrl/HP_EC_icon_alert';

export default class Hp_ec_appointment extends LightningElement {
    showAppointment = true;

    showFormStep = true;
    showSelectorStep = false;
    showConfirmationStep = false;
    showErrorStep = false;

    disableSubmit = true;

    today = new Date();
    selectedDate = new Date('05/05/2022');

    iconClose = HP_EC_close_icon_light;
    iconAlert = HP_EC_icon_alert;

    get todayISOString () {
        return this.today.toISOString().split("T")[0];
    }

    get selectedDateISOString () {
        return this.selectedDate.toISOString().split("T")[0];
    }

    get showDateAlert () {
        const daysDifference = Math.ceil(
            Math.abs(this.selectedDate - this.today) / (1000 * 60 * 60 * 24)  // Days between now and selected date
        );
        return daysDifference <= 1;
    }

    handleClose () {
        this.showAppointment = false;
    }

    handleStep () {
        if (this.showFormStep) {
            this.showFormStep = false;
            this.showSelectorStep = true;
        } else if (this.showSelectorStep) {
            this.showSelectorStep = false;
            this.showConfirmationStep = true;
        } else if (this.showConfirmationStep) {
            this.showConfirmationStep = false;
            this.showErrorStep = true;
        } else if (this.showErrorStep) {
            this.showErrorStep = false;
            this.showFormStep = true;
        }
    }

    handleDateFocus (event) {
        if (event.target && event.target.showPicker) {
            event.target.showPicker();
        }
    }

    handleDateChange (event) {
        if (event.target && event.target.value) {
            this.selectedDate = new Date(event.target.value);
        }
    }

    handleChange (event) {
        if (event.target && event.target.value) {
            event.target.parentElement.classList.add('has-content');
        } else if (event.target) {
            event.target.parentElement.classList.remove('has-content');
        }
    }

    handleNotification (event) {
        var mail = this.template.querySelector('input[name=email-notification]');
        var sms = this.template.querySelector('input[name=sms-notification]');

        if ((mail && mail.checked) || (sms && sms.checked)) {
            this.disableSubmit = false;
        } else {
            this.disableSubmit = true;
        }
    }
}