var portName = process.argv[2];
console.log(`Hello and welcome to node ${portName}.`);

let serialPort = require('serialport'); 

//list serial ports 
/*serialPort.list(function(err, ports){
    ports.forEach(function(port) {
        console.log(port.comName);
    });
}); */
	
let myPort = new serialPort(portName, 9600);
let Readline = serialPort.parsers.Readline
let parser = new Readline();
myPort.pipe(parser); 

myPort.on('open', showPortOpen);
parser.on('data', readSerialData);
myPort.on('close', showPortClose);
myPort.on('error', showError);

/**
 * 
 */
function showPortOpen() {
    console.log('port open. Data rate: ' + myPort.baudRate);
}

/**
 * 
 * @param {*} data 
 */
function readSerialData(data) {
    console.log(`Serial data read ${data}`);
}

/**
 * 
 */
function showPortClose() {
    console.log('port closed.');
}

function showError(error) {
    console.log('Serial port error: ' + error);
}