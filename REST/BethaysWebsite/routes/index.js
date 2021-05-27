var express = require('express');
var router = express.Router();
const apiHelper = require('../helpers/apiHelper');

/* GET home page. */
router.get('/', function(req, res, next) {
  apiHelper.callApi('http://localhost:7000/api/')
    .then(response => {
      console.log(response); 
      res.render('index', 
        {"title": "Bethany shop", data: response.data}); 
    })
});

module.exports = router;
