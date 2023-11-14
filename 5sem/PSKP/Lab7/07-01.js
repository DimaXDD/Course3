const http = require('http');

const options = {
    host: '127.0.0.1',
    path: '/',
    port: 5000,
    method: 'GET'
}

setTimeout(() => {
    const req = http.request(options, res => {
        console.log(`Status code:     ${res.statusCode}`);
        console.log(`Status message:  ${res.statusMessage}`);
        console.log(`Server IP:       ${res.socket.remoteAddress}`);
        console.log(`Server port:     ${res.socket.remotePort}`);
    });

    req.on('error', e => { console.log(`${e.message}\n\n`); })
    req.end();
}, 500);