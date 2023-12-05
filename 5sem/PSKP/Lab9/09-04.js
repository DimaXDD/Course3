const WebSocket = require('ws');

const wsserver = new WebSocket.Server({port: 4000, host: 'localhost'});

wsserver.on('connection', (ws) => {
    let counter= 0;
    ws.on('message', (data) => {
        console.log('on message: ', JSON.parse(data));
        ws.send(JSON.stringify({server: ++counter, 
                                client: JSON.parse(data).client, 
                                timestamp: new Date().toString()}))
    });
});
wsserver.on('error', error => {
    console.log('[ERROR] WebSocket: ', error.message);
});