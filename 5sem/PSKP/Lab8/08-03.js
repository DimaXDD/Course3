const WebSocket = require('ws');

const wss = new WebSocket.Server({port: 4000, host: 'localhost', path: '/broadcast'});

wss.on('connection', ws => {
    console.log('Connected to WebSocket server');
    ws.on('message', message => {
        wss.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send('server: ' + message);
            }
        })
    });

    ws.on('close', () => {
        console.log('Socket closed');
    })
});

wss.on('error', (e) => {
    console.log('ws server error', e)
});

console.log(`ws server: host: ${wss.options.host}, port: ${wss.options.port}, path: ${wss.options.path}`);