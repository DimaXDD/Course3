const fs = require('fs');
const WebSocket = require('ws');
const path = './download/09-02_ToClient.txt';

const wsserver = new WebSocket.Server({port: 4000, host: 'localhost'});

wsserver.on('connection', (ws)=>{
    const duplex = WebSocket.createWebSocketStream(ws, { encoding: 'utf8' });
    let rfile = fs.createReadStream(path);
    rfile.pipe(duplex);
});
wsserver.on('error', error => {
    console.log('[ERROR] WebSocket: ', error.message);
});