import { LightningElement, api } from 'lwc';

export default class Hp_ec_consumptionBar extends LightningElement {
    @api consumption;
    @api type;
    @api showValue;
    @api showPrice;
    @api displayDetails;
    @api alertTreshold;
    @api maxValue;
    @api maxPrice;
    @api communicatingMeter;

    @api showConsoDates;
    @api showYear;

    get valueType () {
        // return (this.consumption.value >= this.alertTreshold) ? 'alert' : this.type;
        return this.type;
    }

    get showMeasuredValue () {
        return this.showValue && (this.communicatingMeter || !this.consumption.estimated);
    }

    get showEstimatedValue () {
        return this.showValue && !this.communicatingMeter && this.consumption.estimated;
    }

    get isActive () {
        return this.consumption.active;
    }

    get valueRatio () {
        return this.consumption.value / this.maxValue * 100;
    }

    get priceRatio () {
        return this.consumption.conso / this.maxPrice * 100;
    }

    get subscriptionRatio () {
        return this.consumption.subscription / this.maxPrice * 100;
    }

    get taxRatio () {
        return this.consumption.tax / this.maxPrice * 100;
    }

    get formattedMonthDate () {
        var date = new Date(this.consumption.month);
        var options = { month: 'short'};
        return date.toLocaleDateString(undefined, options);
    }

    get formattedConsoStartDate () {
        const startDate = new Date(this.consumption.startDate);
        return formatDateToString(startDate);
    }

    get formattedConsoEndDate () {
        const endDate = new Date(this.consumption.endDate);
        return formatDateToString(endDate);
    }

    get year () {
        // var date = new Date(this.consumption.date);
        // return date.getFullYear();
        return this.consumption.year;
    }

    get styleSubscription () {
        return `height: ${this.subscriptionRatio}%;`
    }

    get styleTax () {
        return `height: ${(this.subscriptionRatio + this.taxRatio)}%;`
    }

    get styleValue () {
        return `height: ${this.valueRatio || 0}%;`
    }

    get stylePrice () {
        return `height: ${this.priceRatio || 0}%;`
    }

}

function formatDateToString(date) {
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const day = date.getDate();
    return ('0' + day).slice(-2) + '.' + ('0' + month).slice(-2) + '.' + year.toString().slice(-2);
}