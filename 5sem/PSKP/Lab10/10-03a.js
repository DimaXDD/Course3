const dgram = require('dgram');
const client = dgram.createSocket('udp4');

client.send('Hello, Server!', 40000, 'localhost', (err) => {
    if (err) throw err;
    console.log('Message sent');
});

client.on('message', (msg, rinfo) => {
    console.log(`Client received: ${msg} from ${rinfo.address}:${rinfo.port}`);
});
