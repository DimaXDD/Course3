const WebSocket = require('ws');

let param2 = process.argv[2];

let prfx = typeof param2 == 'undefined' ? 'A' : param2;

console.log('client name = ', prfx);

const ws = new WebSocket('ws://localhost:4000/broadcast');

ws.on('open', () => {
    console.log('Connected to WebSocket server');
    let k = 0;
    let sendingInterval = setInterval(() => {
        ws.send(`client: ${prfx}-${++k}`);
    }, 1000);

    ws.on('message', message => {
        console.log(`${message}`)
    })

    setTimeout(() => {
        clearInterval(sendingInterval);
        ws.close();
    }, 25000);
});