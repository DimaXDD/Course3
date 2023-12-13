const dgram = require('dgram');
const server = dgram.createSocket('udp4');

server.on('message', (msg, rinfo) => {
    console.log(`Server received: ${msg} from ${rinfo.address}:${rinfo.port}`);
    const message = Buffer.from(`ECHO: ${msg}`);
    server.send(message, 0, message.length, rinfo.port, rinfo.address);
});

server.bind(40000);