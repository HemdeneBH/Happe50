({
	getErrors: function(response){
        var message = '';
        if(response.getError() != 'undefined' && response.getError().length != 'undefined'){
            for(var i = 0; i< response.getError().length; i++){
                var currError = response.getError()[i];

                if(currError.message){
                     message += (message ==''?'':'\n') + currError.message;
                }

                if(currError.pageErrors != undefined && currError.pageErrors.length!='undefined'){
                    for(var i = 0; i< currError.pageErrors.length; i++){
                        message += (message ==''?'':'\n') + currError.pageErrors[i].message;
                    }
                }
                if(currError.fieldErrors != undefined && currError.fieldErrors.length!='undefined'){
                    for(var key in currError.fieldErrors){
                        if(currError.fieldErrors[key] != 'undefined' && currError.fieldErrors[key].length != 'undefined'){
                            for(var k = 0 ; k < currError.fieldErrors[key].length; k++)
                                message += (message ==''?'':'\n') + currError.fieldErrors[key][k].message;
                        }
                        
                    }
                }
            }
            
        }
        return message;
    },
})