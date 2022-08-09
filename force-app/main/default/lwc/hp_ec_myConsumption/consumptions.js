export default function getFakeConsumptions() {
    return [
        {
            date: new Date(2021, 0).getTime(),
            type: 'elec',
            value: 355,
            units: 'kWh',
            priceValue: 91,
            priceUnits: 'euros',
            subscription: 40,
            tax: 20,
            estimated: false,
            active: true
        },
        {
            date: new Date(2021, 1).getTime(),
            type: 'elec',
            value: 370,
            units: 'kWh',
            priceValue: 74,
            priceUnits: 'euros',
            subscription: 20,
            tax: 20,
            estimated: true,
            active: true
        },
        {
            date: new Date(2021, 2).getTime(),
            type: 'elec',
            value: 395,
            units: 'kWh',
            priceValue: 79,
            priceUnits: 'euros',
            subscription: 20,
            tax: 20,
            estimated: false,
            active: true
        },
        {
            date: new Date(2021, 3).getTime(),
            type: 'elec',
            value: 345,
            units: 'kWh',
            priceValue: 69,
            priceUnits: 'euros',
            subscription: 20,
            tax: 20,
            estimated: true,
            active: true
        },
        {
            date: new Date(2021, 4).getTime(),
            type: 'elec',
            value: 280,
            units: 'kWh',
            priceValue: 56,
            priceUnits: 'euros',
            subscription: 20,
            tax: 20,
            estimated: false,
            active: true
        },
        {
            date: new Date(2021, 5).getTime(),
            type: 'elec',
            value: 250,
            units: 'kWh',
            priceValue: 50,
            priceUnits: 'euros',
            subscription: 20,
            tax: 20,
            estimated: true,
            active: true
        },
        {
            date: new Date(2020, 6).getTime(),
            type: 'elec',
            value: 245,
            units: 'kWh',
            priceValue: 49,
            priceUnits: 'euros',
            estimated: false,
            active: false
        },
        {
            date: new Date(2020, 7).getTime(),
            type: 'elec',
            value: 300,
            units: 'kWh',
            priceValue: 60,
            priceUnits: 'euros',
            estimated: false,
            active: false
        },
        {
            date: new Date(2020, 8).getTime(),
            type: 'elec',
            value: 320,
            units: 'kWh',
            priceValue: 64,
            priceUnits: 'euros',
            estimated: false,
            active: false
        },
        {
            date: new Date(2020, 9).getTime(),
            type: 'elec',
            value: 325,
            units: 'kWh',
            priceValue: 65,
            priceUnits: 'euros',
            estimated: false,
            active: false
        },
        {
            date: new Date(2020, 10).getTime(),
            type: 'elec',
            value: 320,
            units: 'kWh',
            priceValue: 64,
            priceUnits: 'euros',
            estimated: false,
            active: false
        },
        {
            date: new Date(2020, 11).getTime(),
            type: 'elec',
            value: 325,
            units: 'kWh',
            priceValue: 65,
            priceUnits: 'euros',
            estimated: false,
            active: false
        }
    ];
}