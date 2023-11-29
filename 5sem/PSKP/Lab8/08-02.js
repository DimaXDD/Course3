const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:4000/wsserver');

let sendingInterval = null;
let n = 0;

ws.onopen = () => {
    console.log('socket open');
    sendingInterval = setInterval(() => ws.send(`08-01-client: ${++n}`), 3000);
}

ws.onclose = (e) => console.log('socket close');

ws.onmessage = (message) => console.log(message.data);

ws.onerror = (e) => console.log('socket error', e);

setTimeout(() => {
    clearInterval(sendingInterval);
    ws.close(1000, 'Closing socket');
}, 25000);