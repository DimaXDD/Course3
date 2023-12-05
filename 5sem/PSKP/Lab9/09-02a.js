const fs = require('fs');
const WebSocket = require('ws');
const path = `./09-02_FromServer.txt`;

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', ()=>{
    const duplex = WebSocket.createWebSocketStream(ws);
    let wfile = fs.createWriteStream(path);
    duplex.pipe(wfile);
});