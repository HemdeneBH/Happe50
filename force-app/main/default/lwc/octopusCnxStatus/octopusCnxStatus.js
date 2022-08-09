import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';


import checkOctopusUser from '@salesforce/apex/SM_Utils_TokenOctopus.checkOctopusUser';
import getOctopusUsername from '@salesforce/apex/SM_Utils_TokenOctopus.getOctopusUsername';

export default class App extends NavigationMixin(LightningElement) {

    @track loginres = {
        loginok : true,
        resultStr : "Connexion Symphonie ok",
        resultMsg : "Connexion SAP via Octopus réussie"
    }

    @track username;
    handleUserChange(event) {
        this.username = event.target.value;
    }


    password;
    handlePassChange(event) {
        this.password = event.target.value;
    }


    updateStateCnx() {
        console.log("navigate to configure named credentials");
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/lightning/settings/personal/ExternalObjectUserSettings/home'
            }
        });
    }


    connectedCallback(){
        checkOctopusUser({})
        .then(result => {
            console.log('Validation de login octopus : ', result);
            let rslt = String(result);
			if(rslt.startsWith('OCTOPUS')){
                let elts = rslt.split("###",2);
                this.loginres = {
                    loginok : false,
                    resultStr : elts[0],
                    resultMsg : elts[1]
                };
                console.log('Validation de login octopus str : ', this.loginres);
			}
        })
        .catch(error => {
            console.log('Validation de login octopus error : ', error);
            this.loginres = {
                loginok : false,
                resultStr : "Composant en erreur",
                resultMsg : error
            };
        });

    getOctopusUsername({})
        .then(result => {
            console.log('Nom de login octopus : ', result);
            this.username = String(result);
        })
        .catch(error => {
            console.log('Nom de login octopus error : ', error);
        });
    }
}