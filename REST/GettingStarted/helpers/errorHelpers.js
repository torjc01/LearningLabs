let logRepo = require('../repos/logRepo');
let errorHelpers = {

    logErrorToConsole: function(err, req, res, next){
        console.error("Log entry: " + JSON.stringify(errorHelpers.errorBuilder(err))); 
        console.error("*".repeat(80)); 
        next(err);
    },

    logErrorsToFile: function(err, req, res, next){
        let errorObject = errorHelpers.errorBuilder(err); 
        errorObject.requestInfo = {
            "hostname": req.hostname, 
            "path": req.path, 
            "app": req.app
        }
        logRepo.write(errorObject, function(data){
            console.log(data); 
        }, function(err){
            console.log(err);
        });
        next(err);
    }, 
    clientErrorHandler: function(err, req, res, next){
        if(req.xhr){
            res.status(500).json({
                "status": 500,
                "statusText": "Internal Server Error", 
                "message": "XMLHttpRequest error",
                "error": {
                    "errno": 0, 
                    "call" : "XMLHttpRequest call",
                    "code": "INTERNAL_SERVER_ERRROR", 
                    "message": "XMLHttpRequest error",
                }
            });
        } else {
            next(err); 
        }
    }, 

    errorHandler: function(err, req, res, next){
        res.status(500).json(errorHelpers.errorBuilder(err));
    },

    // Builds the error messages that are going to be sent
    errorBuilder: function(err){
        return{
            "status": 500,
            "statusText": "Internal Server Error", 
            "message": err.message,
            "error": {
                "errno": err.errno, 
                "call" : err.syscall,
                "code": "INTERNAL_SERVER_ERRROR", 
                "message": err.message
            }
        }
    }
}

module.exports = errorHelpers;