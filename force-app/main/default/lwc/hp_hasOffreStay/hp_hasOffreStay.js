import { api, LightningElement, track, wire } from 'lwc';

import getAllContractsOfClient from '@salesforce/apex/HP_SM068_AncienneteClientController.getAllContractsOfClient';

export default class Hp_hasOffreStay extends LightningElement {

    @api idtiers;
    @track displayStay = false;


    @wire(getAllContractsOfClient, { idXdataPersonne: '$idtiers' })
    wiredBody({ error, data }) {
        if (data) {
            // console.log(JSON.stringify(data));
            this.displayStay = this.hasCodeOffreStay(data);
        }
    }

    hasCodeOffreStay(contrats) {
        var isCodeOffreStayExist = false;

        for (var i = 0; i < contrats.length; i++) { 
            if ((contrats[i].codeOffre == 'EITR2_STAY_H') || (contrats[i].codeOffre == 'GITR2_STAY_H'))
                isCodeOffreStayExist = true;
        }

        return isCodeOffreStayExist;
    }

}