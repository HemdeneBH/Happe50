import { LightningElement } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import HP_EC_icon_confirm from '@salesforce/resourceUrl/HP_EC_icon_confirm'


export default class Hp_ec_popinIbanForm extends LightningElement {
    titleText = 'Mon IBAN';

    iconClose = HP_EC_close_icon_light;
    iconConfirm = HP_EC_icon_confirm;

    submitted = false;

    closePopin (event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('closepopin', {
            detail: true,
            bubbles: true,
            composed: true
        }));
    }

    // Handle Input change
    handleInput (event) {
        const current = event.target;
        const next = current.nextElementSibling;
        const prev = current.previousElementSibling;
        const parent = current.parentNode;

        current.classList.add('changed');

        if (current.value.length == current.maxLength && current.selectionEnd == current.maxLength && next) {
            next.focus();
            next.select();
        }

        if (current.value.length == 0 && prev) {
            prev.focus();
            prev.select();
        }

        // Joins the values of every text input and update the hidden input
        var value = Array.from(parent.childNodes).map(e => e.value.toUpperCase()).join('') || '';
        var total = parent.parentNode.querySelector('input[name]');
        if (total) {
            total.value = value; 
        }

        this.validateForm(current.form);
    }

    // Handle Input Navigation with Arrow Keys
    handleKeydown (event) {
        const current = event.target;
        const next = current.nextElementSibling
        const prev = current.previousElementSibling

        if (event.code && event.code == 'ArrowRight') {
            if (current.selectionEnd == current.value.length && next) {
                event.preventDefault();
                next.focus();
                next.select();
            }
        }

        if (event.code && event.code == 'ArrowLeft') {
            if (current.selectionStart == 0 && prev) {
                event.preventDefault();
                prev.focus();
                prev.select();
            }
        }
    }

    // Handle form submit event
    handleSubmit (event) {
        var form = event.target;

        this.submitted = true;

        if (this.validateForm(form)) {
            return true;
        } else {
            event.preventDefault();
            return false;
        }
    }

    // Form validation
    validateForm (form) {
        var submit = form.querySelector('button[type=submit]');
        var IBAN = form['IBAN'];
        var BIC = form['BIC'];

        if (validateIBAN(IBAN)) {
            IBAN.parentNode.classList.remove('invalid');
            IBAN.parentNode.classList.add('valid');
        } else {
            IBAN.parentNode.classList.remove('valid');
            if (this.submitted) {
                IBAN.parentNode.classList.add('invalid');
            }
        }

        if (validateBIC(BIC)) {
            BIC.parentNode.classList.remove('invalid');
            BIC.parentNode.classList.add('valid');
        } else {
            BIC.parentNode.classList.remove('valid');
            if (this.submitted) {
                BIC.parentNode.classList.add('invalid');
            }
        }

        if (validateIBAN(IBAN) && validateBIC(BIC)) {
            submit.disabled = false;
            return true;
        } else if (this.submitted) {
            submit.disabled = true;
        }
        return false;
    }
}

function validateIBAN (IBAN) {
    var regex = new RegExp('[A-Z]{2}[0-9]{2}[A-Z0-9]{1,30}');
    if (IBAN && regex.test(IBAN.value)) {
        return true;
    }

    return false
}

function validateBIC (BIC) {
    if (BIC && BIC.value.length >= 8) {
        return true;
    }
    return false;
}