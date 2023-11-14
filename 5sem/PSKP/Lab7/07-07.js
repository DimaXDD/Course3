const http = require('http');
const fs = require('fs');

let options = {
    host: 'localhost',
    path: '/7',
    port: 5000,
    method: 'GET'
}
const req = http.request(options, (res) => {
    res.pipe(fs.createWriteStream('file_from_server.png'));
});

req.on('error', e => {
    console.log(`${e.message}\n\n`);
})

req.end();