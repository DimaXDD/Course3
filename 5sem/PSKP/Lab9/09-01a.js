const fs = require('fs');
const WebSocket = require('ws');
const path = `./09-01_ToServer.txt`;

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', ()=>{
    const duplex = WebSocket.createWebSocketStream(ws);
    let rfile = fs.createReadStream(path);
    rfile.pipe(duplex);
})