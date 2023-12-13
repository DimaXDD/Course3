var net = require('net');

let HOST = '127.0.0.1';

//node 10-02a.js 40000 10
//node 10-02a.js 50000 12
//node 10-02a.js 50000 4

// Каждые 5 секунд на клиенте и 1 секунда на сервере

let PORT = process.argv[2];
let X = process.argv[3];

var client = new net.Socket();
var buf = Buffer.alloc(4);

client.connect(PORT, HOST, ()=>{
    console.log('Client connected:', client.remoteAddress, client.remotePort);

    setInterval(()=>{
        buf.writeInt32LE(X, 0);
        client.write(buf);
    }, 1000);
})

client.on('data',(data)=>{console.log('Client data:', data.readInt32LE())});
client.on('close', ()=>{console.log('Client close')});
client.on('error', (e)=>{console.log('Client error', e)});
