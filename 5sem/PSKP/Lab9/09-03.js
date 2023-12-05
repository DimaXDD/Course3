const WebSocket = require('ws');
const fs = require('fs');

let counter = 0;

const wsserver = new WebSocket.Server({port: 4000, host: 'localhost'});

wsserver.on('connection', (ws)=>{
    setInterval(() => {
        wsserver.clients.forEach((client)=>{
            if (client.readyState === ws.OPEN){
                client.send(`09-03-server: ${++counter}`);
            }
        })
    }, 15000);

    ws.on('pong', (data)=>{
        console.log(`On pong: ${data.toString()}`);
    });
    ws.on('message', (data)=>{
        console.log(`On message: ${data.toString()}`);
        ws.send(data);
    });

    setInterval(() => {
        console.log(`Count of connections: ${wsserver.clients.size} clients`);
        ws.ping(`Server ping: ${wsserver.clients.size} clients`);
    }, 5000);
});