const https = require('https');
const fs = require('fs');

const options = {
    key:fs.readFileSync('cert/key.pem'),
    cert:fs.readFileSync('cert/cert.pem')
}

https.createServer(options, (req,res)=>{
    res.end("SSL :)")
}).listen(4444);