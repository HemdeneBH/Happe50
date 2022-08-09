import { LightningElement, api } from 'lwc';
import { switchTheme, loadUserTheme } from 'c/hp_ec_utl_styleManager';

export default class Hp_ec_stepsBar extends LightningElement {
    @api totalSteps;
    @api activeStep;
    @api alertStep;

    renderedCallback() {
        if (this.hasRenderedOnce) {
            return;
        }
        loadUserTheme.call(this);
        this.hasRenderedOnce = true;
    }

    @api switchStyle(styleName) {
        switchTheme.call(this, styleName);
    }

    get total () {
        return parseInt(this.totalSteps) || 0;
    }

    get active () {
        return parseInt(this.activeStep) || 0;
    }

    get alert () {
        return parseInt(this.alertStep) || 0;
    }

    get steps () {
        var steps = [];

        for (var i = 1; i <= this.total; i++) {
            steps.push({
                id: i,
                active: i <= this.active || false,
                alert: i == this.alert || false
            });
        }
        return steps;
    }

}