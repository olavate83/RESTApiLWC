import { LightningElement, track } from 'lwc';
import getExchangeRate from '@salesforce/apex/CurrencyConverterController.getExchangeRate';

const options = [
    { label: 'USD', value: 'USD' },
    { label: 'INR', value: 'INR' },
    { label: 'EUR', value: 'EUR' },
    { label: 'GBP', value: 'GBP' },
    { label: 'CAD', value: 'CAD' }
];

export default class HttpCalloutlwc extends LightningElement {
    @track fromCurrencyValue = 'USD';
    @track toCurrencyValue = 'INR';
    @track currencyOptions = options;
    @track toCurrencyOptions = options;
    @track conversionData;

    handleFromChange(event) {
        this.fromCurrencyValue = event.detail.value;
    }

    handleToChange(event) {
        this.toCurrencyValue = event.detail.value;
    }

    handleCurrencyConversion() {
        if (!this.fromCurrencyValue || !this.toCurrencyValue) {
            console.error('Please select both currencies before converting.');
            return;
        }

        getExchangeRate({ fromCurrency: this.fromCurrencyValue, toCurrency: this.toCurrencyValue })
            .then(result => {
                this.conversionData = result;
                window.console.log('Conversion Data ===> ', JSON.stringify(this.conversionData));
            })
            .catch(error => {
                console.error('Error in Conversion Rate Message:', error.body ? error.body.message : error.message);
            });
    }
}