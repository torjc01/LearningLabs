let WebSocketServer = require('ws').Server;
const SERVER_PORT = 8081;               // port number for the webSocket server
let wss = new WebSocketServer({port: SERVER_PORT}); // the webSocket server
let connections = new Array;          // list of connections to the server

wss.on('connection', handleConnection);
 
function handleConnection(client) {
  console.log("New Connection"); // you have a new client
  connections.push(client); // add this client to the connections array
 
  client.on('message', sendToSerial); // when a client sends a message,
 
  client.on('close', function() { // when a client closes its connection
    console.log("connection closed"); // print it out
    let position = connections.indexOf(client); // get the client's position in the array
    connections.splice(position, 1); // and delete it from the array
  });
}

function sendToSerial(data) {
    console.log("sending to serial: " + data);
    myPort.write(data);
  }

// This function broadcasts messages to all webSocket clients
function broadcast(data) {
    for (myConnection in connections) {   // iterate over the array of connections
      connections[myConnection].send(data); // send the data to each connection
    }
  }

  function readSerialData(data) {
    console.log(data);
    // if there are webSocket connections, send the serial data
    // to all of them:
    if (connections.length > 0) {
      broadcast(data);
    }
  }