const net = require('net');

let HOST = '0.0.0.0';
let PORTS = [40000, 50000];

function createServer(port) {
    let server = net.createServer();

    server.on('connection', (sock)=>{
        let sum = 0;
        console.log('Server CONNECTED:', sock.remoteAddress, sock.remotePort);
    
        sock.on('data', (data)=>{
            console.log('Server DATA:', data.readInt32LE(),'| Sum:', sum.toString(), '| Client', sock.remotePort);
            sum += Number(data.readInt32LE());
        });
    
        let buff = Buffer.alloc(4);
        setInterval(()=>{
            buff.writeInt32LE(sum, 0); 
            sock.write(buff)
        }, 5000);
    
        sock.on('close', (data)=>{console.log('Server CLOSED:', sock.remoteAddress, sock.remotePort)});
    
        sock.on('error', (e)=>{console.log('Server ERROR:', e, sock.remoteAddress, sock.remotePort)});
    })
    
    server.on('listening',()=>{console.log('TCP-server',HOST, port)});
    server.on('error',(e)=>{console.log('error', e)});
    server.listen(port, HOST);
}

for (let port of PORTS) {
    createServer(port);
}
