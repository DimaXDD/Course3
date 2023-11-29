const http = require('http');
const fs = require('fs');
const WebSocket = require('ws');

const httpServer = http.createServer((req, res) => {
    if (req.method === 'GET' && req.url === "/start") {
        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
        res.end(fs.readFileSync('./start.html', 'utf8'));
    } else {
        res.writeHead(400, {'Content-Type': 'text/html; charset=utf-8'});
        res.end('<h1>Error 400: bad request</h1>');
    }
});
httpServer.listen(3000, () => console.log('Server is running at http://localhost:3000/start'));


const wsserver = new WebSocket.Server({port: 4000, host: 'localhost', path: '/wsserver'});
wsserver.on('connection', ws => {
    let k = 0;
    let n = 0;
    ws.on('message', message => {
        console.log(`Received message: ${message}`);
        n = +message.toString().slice(-1);
    }); 

    setInterval(() => ws.send(`08-01-server: ${n}->${++k}`), 5000);
});

wsserver.on('error', err => console.error('ws server error', err));
console.log(`ws server: host: ${wsserver.options.host}, port: ${wsserver.options.port}, path: ${wsserver.options.path}`);