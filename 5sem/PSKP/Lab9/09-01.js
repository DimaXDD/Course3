const fs = require('fs');
const WebSocket = require('ws');
const path = './upload/09-01_FromClient.txt';

const wsserver = new WebSocket.Server({port: 4000, host: 'localhost'});

wsserver.on('connection', (ws) => {
    const duplex = WebSocket.createWebSocketStream(ws, { encoding: 'utf8' });
    let wfile = fs.createWriteStream(path);
    duplex.pipe(wfile);
});
wsserver.on('error', error => {
    console.log('[ERROR] WebSocket: ', error.message);
});