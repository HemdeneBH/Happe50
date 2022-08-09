import { LightningElement, api, track } from 'lwc';
import HP_EC_close_icon_light from '@salesforce/resourceUrl/HP_EC_close_icon_light';
import HP_EC_mail from '@salesforce/resourceUrl/HP_EC_mail'
import HP_EC_icon_tick from '@salesforce/resourceUrl/HP_EC_icon_tick'

export default class Hp_ec_popinMessages extends LightningElement {
    titleText = 'Messagerie';

    iconClose = HP_EC_close_icon_light;
    iconMail = HP_EC_mail;
    iconTick = HP_EC_icon_tick;

    showMessages = true;
    showChat = false;
    showCalls = false;

    newMessage = false;
    messageSent = false;

    @api
    get openedmessage() {
        return this.messages;
    }

    set openedmessage(value) {
        this.messages = this.messages.map(msg => {
            if (msg.id == value) {
                return {...msg, open: true};
            }
            return {...msg, open: false};
        });
    }

    handleShowMessages () {
        this.showChat = false;
        this.showCalls = false;
        this.showMessages = true;
    }

    handleShowChat () {
        this.showMessages = false;
        this.showCalls = false;
        this.showChat = true;
    }

    handleShowCalls () {
        this.showMessages = false;
        this.showChat = false;
        this.showCalls = true;
    }

    handleNewMessage () {
        this.newMessage = !this.newMessage;
        this.messageSent = false;
    }
    

    handleChatClick(event){
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('chatpopin', { bubbles:true, detail: true}));
        return false;
    }

    handleNewFile(event) {
        var input = event.target;
        for(var i=0; i<input.files.length; i++){
            this.files.push({id: this.files.length, name: input.files[i].name});
        }
    }

    handleDeleteFile(event) {
        if (event.target.hasAttribute('data-id')) {
            event.preventDefault();
            event.stopPropagation();
            event.stopImmediatePropagation();
            this.files = this.files.filter(file => file.id != event.target.dataset.id);
        }
    }

    handleMessageSent () {
        this.template.querySelectorAll('select, input, textarea').forEach(element => {
            element.disabled = true;
        });
        this.template.querySelectorAll('.file').forEach(element => {
            element.classList.add('disabled');
        });
        this.messageSent = true;
    }

    handleSelectChange(event) {
        switch (event.target.value) {
            case 'messages':
                this.handleShowMessages();
            break;
            case 'chat':
                this.handleShowChat();
            break;
            case 'calls':
                this.handleShowCalls();
            break;
        }
    }

    closePopin(){
        this.dispatchEvent(new CustomEvent('closepopin', { detail: true}));
    }

    handleToggleMessage (event) {
        this.messages = this.messages.map(msg => {
            if (msg.id == event.detail.id) {
                return {...msg, open: !msg.open, read: true};
            }
            return msg;
        });
    }

    handleToggleChat (event) {
        if (event.target.hasAttribute('data-id')) {
            console.log('toggle chat', event)
            event.preventDefault();
            event.stopPropagation();
            event.stopImmediatePropagation();
            this.chatSessions = this.chatSessions.map(chat => {
                if (chat.id == event.target.dataset.id) {
                    return {...chat, open: !chat.open};
                }
                return chat;
            });
        }
    }

    /* Fake data */
    @track files = [
        {id: 0, name: "IBAN"},
        {id: 1, name: "Carte d'identité"}
    ];

    messages = [
        {
            id: 0,
            category: "Ma souscription",
            title: "Votre contrat personnalisé pour l'année 2021",
            date: "13.01.2021 à 11h04",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: false,
            sent: false
        },
        {
            id: 1,
            category: "Facture et paiement",
            title: "Réponse à votre demande de remboursement est en cours de vérification",
            date: "11.01.2021 à 08h15",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: false,
            sent: false
        },
        {
            id: 2,
            category: "Services",
            title: "Nouvelles fonctionnalités de votre espace client",
            date: "05.01.21 à 09h00",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: false,
            sent: false
        },
        {
            id: 3,
            category: "Ma souscription",
            title: "Je n'ai pas reçu mon contrat",
            date: "13.01.2021 à 11h04",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: true,
            sent: true
        },
        {
            id: 4,
            category: "Facture et paiement",
            title: "Je souhaite être remboursé du mois de juin 2020",
            date: "13.01.2021 à 11h04",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: false,
            sent: true
        },
        {
            id: 5,
            category: "Services",
            title: "Découvrez le parrainage happ-e - De nombreux avantages vous attendent",
            date: "13.01.2021 à 11h04",
            content: "Cher Matthieu,<br/><br/>Pour bien démarrer l’année 2021, nous vous proposons de nouveaux services afin de vous simplifier la vie!<br/><strong>Découvrez le paiement à plusieurs !</strong><br/>Hélène, votre conseillère happ-e :)",
            read: true,
            sent: false
        }
    ];

    calls = [
        {
            id: 0,
            category: "Facture et paiement",
            date: "13.01.2021 à 11h04",
            duration: "33 minutes",
            content: "Vous avez reçu un appel de votre conseiller",
        },
        {
            id: 1,
            category: "Facture et paiement",
            date: "13.01.2021 à 11h04",
            duration: "33 minutes",
            content: "Vous avez reçu un appel de votre conseiller",
        },
        {
            id: 2,
            category: "Facture et paiement",
            date: "13.01.2021 à 11h04",
            duration: "33 minutes",
            content: "Vous avez reçu un appel de votre conseiller",
        },
        {
            id: 3,
            category: "Facture et paiement",
            date: "13.01.2021 à 11h04",
            duration: "33 minutes",
            content: "Vous avez reçu un appel de votre conseiller",
        },
        {
            id: 4,
            category: "Facture et paiement",
            date: "13.01.2021 à 11h04",
            duration: "33 minutes",
            content: "Vous avez reçu un appel de votre conseiller",
        },
    ];

    chatContent = [
        {
            id: 0,
            time: 45,
            content: "Bonjour, je suis Soufiane, votre conseiller Happ-e. Comment puis-je vous aider ?",
            sent: false
        },
        {
            id: 1,
            time: 153,
            content: "je souhaiterais payer ma facture gaz de 58,45 mais elle n’apparait pas dans mon compte client, comment faire ?",
            sent: true
        },
        {
            id: 2,
            time: 265,
            content: "D’accord, pouvez-vous me confirmer votre adresse postale s’il vous plait ?",
            sent: false
        },
        {
            id: 3,
            time: 285,
            content: "14 rue des petits jardins",
            sent: true
        },
        {
            id: 4,
            time: 306,
            content: "Très bien, merci",
            sent: true
        }
    ];

    chatSessions = [
        {
            id: 0,
            agent: "Soufiane K",
            origin: "HP Digital",
            date: "13.01.2021 à 11h04",
            content: this.chatContent,
            open: false
        },
        {
            id: 1,
            agent: "Soufiane K",
            origin: "HP Digital",
            date: "13.01.2021 à 11h04",
            content: this.chatContent,
            open: false
        },
        {
            id: 2,
            agent: "Soufiane K",
            origin: "HP Digital",
            date: "13.01.2021 à 11h04",
            content: this.chatContent,
            open: false
        },
        {
            id: 3,
            agent: "Soufiane K",
            origin: "HP Digital",
            date: "13.01.2021 à 11h04",
            content: this.chatContent,
            open: false
        }
    ];
}