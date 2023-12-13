const net = require('net');

let HOST = '0.0.0.0';
let PORT = 40000;

net.createServer((sock)=>{
    console.log('Server CONNECTED: ', sock.remoteAddress, " : ", sock.remotePort);

    sock.on('data', (data)=>{
        console.log('Server DATA: ', sock.remoteAddress, " : ", data.toString());
        sock.write('ECHO: ' + data.toString());
    })

    sock.on('close', ()=>{console.log('Server CLOSED: ', sock.remoteAddress, " : ", sock.remotePort)})
}).listen(PORT, HOST);

console.log('TCP-сервер ', HOST, ":", PORT);
