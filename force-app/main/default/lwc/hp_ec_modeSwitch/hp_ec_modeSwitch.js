/**
 * @description       : 
 * @author            : Clément Bauny
 * @group             : 
 * @last modified on  : 02-24-2022
 * @last modified by  : Clément Bauny
**/
import { LightningElement, api} from 'lwc';

import {switchTheme, loadUserTheme} from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_modeSwitch extends LightningElement {

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    handleThemeChange (event) {
        var newTheme = event.detail;
        window.localStorage.setItem('theme', newTheme);

        const styleEvent = new CustomEvent("stylechange", {
            detail: newTheme,
            bubbles: true, 
            composed: true
        });

        this.dispatchEvent(styleEvent);
        updateOptionsArray(this.themeOptions, newTheme);
    }

    themeOptions = [
        {
            value: 'lightTheme',
            label: "Clair",
            checked: true
        },
        {
            value: 'darkTheme',
            label: "Sombre",
            checked: false
        }
    ];

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
        var currentTheme = window.localStorage.getItem('theme');
        this.themeOptions = updateOptionsArray(this.themeOptions, currentTheme);
    }
}

function updateOptionsArray(array, value) {
    return array.map(option => {
        if (option.value == value) {
            return {...option, checked: true};
        }
        return {...option, checked: false};
    });
}