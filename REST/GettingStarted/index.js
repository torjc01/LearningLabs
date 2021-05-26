// Bring in the express server and create the application
const express = require('express'); 

let app = express(); 
let pieRepo = require('./repos/pierepo');
let router = express.Router();   // Use express Router project 
let errorHelper = require('./helpers/errorHelpers');
let cors = require('cors');


// Constants definitions 
const PORT = 7000; 
const HOST_NAME = 'http://localhost';

// Configure middleware to support JSON data parsing in request object
app.use(express.json()); 

// Configure cors 
app.use(cors()); 

// Create GET to return a list of all pies 
router.get('/', function(req, res, next){
    pieRepo.get(function(data){
        res.status(200).json({
            "status": 200, 
            "statusText": "OK", 
            "message": "All pies retrieved", 
            "data": data
        }); 
    }, function(err){
        next(err);
    }); 
}); 

// Create GET/search?id=n&name=str to search for pies by id and/or name
router.get('/search', function(req, res, next){
    //console.log(`id: ${req.query.id} name: ${req.query.name}`);
    console.log(req.query.id); 
    console.log(req.query.name); 
    let searchObject = {
        "id"   : req.query.id, 
        "name" : req.query.name
    };
    
    pieRepo.search(searchObject, function(data){
        if(data){
            res.status(200).json({
                "status": 200,
                "statusText": "OK", 
                "message": "All pies retrieved", 
                "data": data
            });
        } else {
            res.status(404).json({
                "status": 404,
                "statusText": "Not found", 
                "message": `No pies found for parameters id: ${searchObject.id} and name: ${searchObject.name}. `
            });
        }
        
    }, function(err){
        console.log(`Erro: ${err}`)
        next(err);
    });
});

router.get('/fuck', function(req, res, next){res.send('fuck you')} ); 

// Create GET/id to return a single pie
router.get('/:id', function(req, res, next){
    pieRepo.getById(req.params.id, function(data){
        if(data){
            res.status(200).json({
                "status": 200, 
                "statusText": "OK", 
                "message": "All pies retrieved", 
                "data": data
            }); 
        } else {
            res.status(404).json({
                "status": 404, 
                "statusText": "Not found", 
                "message": `The pie id:${req.params.id} could not be found`,
                "error": {
                    "code": "NOT_FOUND", 
                    "message": `The pie id:${req.params.id} could not be found`
                }
            }); 
        }
    }, function(err){
        next(err);
    })
}); 

router.post('/', function(req, res, next){
    pieRepo.insert(req.body, function(data){
        res.status(201).json({
            "status": 201,
            "statusText": "Created", 
            "message": "New pie added", 
            "data": data
        });
    }, function(err){
        next(err);
    });
});

router.put('/:id', function(req, res, next){
    pieRepo.getById(req.params.id, function(data){
        if(data){
            pieRepo.update(req.body, req.params.id, function (data){
                res.status(200).json({
                    "status": 200,
                    "statusText": "OK", 
                    "message": `Pie ${req.params.id} updated`, 
                    "data": data
                });
            });
        } else {
            res.status(404).json({
                "status": 404,
                "statusText": "Not found", 
                "message": `Pie ${req.params.id} could not be found`, 
                "error": {
                    "code": "NOT_FOUND", 
                    "message": `Pie ${req.params.id} could not be found`
                }
            });
        }
        
    }, function(err){
        next(err);
    });
})

router.delete('/:id', function(req, res, next){
    pieRepo.getById(req.params.id, function(data){
        if(data) {
            // Attempt to delete data 
            pieRepo.delete(req.params.id, function(data){
                res.status(200).json({
                    "status": 200,
                    "statusText": "OK", 
                    "message": `Pie ${req.params.id} deleted`, 
                    "data": data
                });
            });
        } else {
            res.status(404).json({
                "status": 404,
                "statusText": "Not found", 
                "message": `Pie ${req.params.id} could not be found`, 
                "error": {
                    "code": "NOT_FOUND", 
                    "message": `Pie ${req.params.id} could not be found`
                }
            })
        }
    }, function(err){
        next(err);
    })    
});
   
router.patch('/:id', function(req, res, next){
    pieRepo.getById(req.params.id, function(data){
        if(data){
            pieRepo.update(req.body, req.params.id, function(data){
                res.status(200).json({
                    "status": 200,
                    "statusText": "OK", 
                    "message": `Pie ${req.params.id} patched`, 
                    "data": data
                });
            })
        } else {
            res.status(404).json({
                "status": 404,
                "statusText": "Not found", 
                "message": `Pie ${req.params.id} could not be found`, 
                "error": {
                    "code": "NOT_FOUND", 
                    "message": `Pie ${req.params.id} could not be found`
                }
            })
        }
    });
});

// Configure router so all routes are prefixed with /api/v1
app.use('/api/', router); 

// **********************************************************
// ***** Boilerplate for error treatment 
// **********************************************************
// Configure exception to the console
app.use(errorHelper.logErrorToConsole); 
// Configure exception to file
app.use(errorHelper.logErrorsToFile); 
// Configure client error handler 
app.use(errorHelper.clientErrorHandler); 
// Configure catch-all expception middleware last 
app.use(errorHelper.errorHandler);


// Create server to linsten on PORT 
let server = app.listen(PORT, function(){
    console.log(`Node server is running on ${HOST_NAME}:${PORT}`);
});
