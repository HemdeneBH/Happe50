/**
 * @description       : 
 * @author            : Mohamed Aamer
 * @group             : 
 * @last modified on  : 08-19-2020
 * @last modified by  : Mohamed Aamer
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   08-19-2020   Mohamed Aamer   Initial Version
**/
import { LightningElement } from 'lwc';
import SM_ImageBleu from '@salesforce/resourceUrl/SM_ImageBleu';
import SM_ImageRouge from '@salesforce/resourceUrl/SM_ImageRouge';
import SM_ImageBleu2 from '@salesforce/resourceUrl/SM_ImageBleu2';
import SM_ImageRouge2 from '@salesforce/resourceUrl/SM_ImageRouge2';
import SM_ImageBleu3 from '@salesforce/resourceUrl/SM_ImageBleu3';
import SM_ImageRouge3 from '@salesforce/resourceUrl/SM_ImageRouge3';
import SM_ImageBleu4 from '@salesforce/resourceUrl/SM_ImageBleu4';

export default class CarouselDemo extends LightningElement {

    options = { autoScroll: true, autoScrollTime: 2 };
    items = [
        {
            image: SM_ImageBleu,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageRouge,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageBleu2,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageRouge2,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageBleu3,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageRouge3,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }, 
        {
            image: SM_ImageBleu4,
            header: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            description: 'Sortie de trêve hivernale : Reprise des coupures / résiliations non-paiement',
            href: 'https://images.pexels.com/photos/132037/pexels-photo-132037.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
        }
    ]
}