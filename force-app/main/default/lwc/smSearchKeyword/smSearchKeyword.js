/*
Description: Searh Keyword in an array of objects
Parameters:
    keyword: keyword to search
    array: array of objects 
    objElem: the object attribute to use for match keyword
*/
export function searchInArrayOfObj(keyword, array, objElem){
    let value = keyword;
    let result = [];
    if (typeof keyword !== 'boolean') {
        value = keyword.toLowerCase();
        result = array.filter(obj => {
            var elem = obj[objElem].toLowerCase();
            return elem.includes(value);
        });
    } else {
        result = array.filter(obj => {
            var elem = obj[objElem];
            return elem == value;
        });
    }
    return result;
}

/*
Description: Searh Multiple Keywords in an array of objects
Parameters:
    keywordList: list of keywords to search
    array: array of objects 
    objElem: the object attribute to use for match keyword
*/
export function searchMultipleInArrayOfObj(keywordList, array, objElem){
    let result=[];
    keywordList.forEach(keyword => {
        let arrayElem = searchInArrayOfObj(keyword, array, objElem);
	    result = [...result, ...arrayElem];
    });
    return result;
}

/*
Description: filter by date range in an array of objects
Parameters:
    fromDate: from date
    toDate: to date
    array: array of objects 
    objElem: the object attribute to use for match date range
*/
export function filterArrayOfObjByDates(fromDate, toDate, array, objElem){
    let fromDateFormat = new Date(fromDate);
    let toDateFormat = new Date(toDate);
    let result = array.filter(obj => {
        var elemDate = obj[objElem];
        var elemDateFormat = new Date(elemDate);
        return (elemDateFormat >= fromDateFormat && elemDateFormat <= toDateFormat);
    });
    return result;
}