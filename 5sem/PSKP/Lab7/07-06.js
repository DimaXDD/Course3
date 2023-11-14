const http = require('http');
const fs = require('fs');

let bound = '---bound--';
let body = `--${bound}\r\n`;
body += 'Content-Disposition: form-data; name="pngUpload"; filename="file.png"\r\n';
body += 'Content-Type: application/octet-stream\r\n\r\n';



let options = {
    host: 'localhost',
    path: '/6',
    port: 5000,
    method: 'POST',
    headers: { 'Content-Type': `multipart/form-data; boundary=${bound}` }
}



setTimeout(() => {
    const req = http.request(options, (res) => {
        let data = '';

        console.log(`\nResponse status: ${res.statusCode} ${res.statusMessage}\n`);
        res.on('data', chunk => { console.log(`Response body (data): ${data += chunk.toString('utf8')}`); });

        res.on('end', () => {
            console.log(`Response body (end): ${data}\n`);
            console.log(`Response body length: ${Buffer.byteLength(data)}\n`);
        });
    });


    req.write(body);
    let stream = new fs.ReadStream('file.jpg');
    stream.on('data', chunk => {
        req.write(chunk);
        console.log('chunk length = ', Buffer.byteLength(chunk));
    })
    stream.on('end', () => { req.end(`\r\n--${bound}--`); })

    req.on('error', e => { console.log(`${e.message}\n\n`); })
}, 500);