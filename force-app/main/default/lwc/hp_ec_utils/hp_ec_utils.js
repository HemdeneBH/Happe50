export function filterDocumentBytype(arrayDocument, type) {
        console.log(' ##### filter module ');
        const factures = [];
        arrayDocument.forEach( item => {
            console.log(' json module ', JSON.stringify(item)  );
            item.documents.forEach (document => {
                if(document.type_document == type) {
                    factures.push(document);
                }
            })
        })
        return factures;
}

export function groupingArrayObjectByProperty(objectArray, property){
    return objectArray.reduce( (acc, obj) => {
        let key = obj[property];
        if(!acc[key]){
            acc[key] = [];
        }
        acc[key].push(obj);
        return acc;
    }, {})
}