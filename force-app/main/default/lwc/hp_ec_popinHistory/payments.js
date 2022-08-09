export default function getPayments() {
    return [
        {
            "id": 0,
            "type": "debit",
            "name": "Mensualité d'aout 2021",
            "description": "Sera prélevée le 25.08.2021",
            "price": "42.42 €"
        },
        {
            "id": 1,
            "type": "paid",
            "name": "Facture annuelle 2020",
            "description": "Soldée le 25.08.2021",
            "price": "42.42 €"
        },
        {
            "id": 2,
            "type": "refund",
            "name": "Mensualité d'avril 2020",
            "description": "Remboursée le 25.08.2021",
            "price": "42.42 €"
        },
        {
            "id": 2,
            "type": "unpaid",
            "name": "Mensualité de juin 2020",
            "description": "En attente depuis le 25.08.2021",
            "price": "42.42 €"
        }
    ];
};