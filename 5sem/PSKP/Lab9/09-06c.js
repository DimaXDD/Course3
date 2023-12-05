const rpcws = require('rpc-websockets').Client;

let ws = new rpcws('ws://localhost:4000');

ws.on('open', () => {
    ws.subscribe('C');

    ws.on('C', data => {console.log('on C event: ', data.toString())});
});