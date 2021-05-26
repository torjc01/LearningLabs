const express = require('express'); 
const bodyParser = require('body-parser'); 
const cors = require('cors');

let HOST = "http://localhost";
let CORS_PORT = 8081; 


const app = express(); 

let corsOptions = {
    origin = `${HOST}:${CORS_PORT}/`
};