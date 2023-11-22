let http = require('http');
let xmlbuilder = require('xmlbuilder');
let xmldoc = xmlbuilder.create('request').att('id', 33);

xmldoc.ele('x').att('value', 3);
xmldoc.ele('x').att('value', 1);
xmldoc.ele('x').att('value', 2);
xmldoc.ele('m').att('value', 'a');
xmldoc.ele('m').att('value', 'b');
xmldoc.ele('m').att('value', 'c');

let options = {
    host: 'localhost',
    path: `/5`,
    port: 5000,
    method: 'POST',
    headers: {'content-type': 'application/xml', 'accept': 'application/xml'}
}

const req = http.request(options, (res) => {
    console.log('http.request: statusCode: ', res.statusCode, res.statusMessage);
    let data = '';
    res.on('data', (chunk) => {
        data += chunk.toString('utf-8');
    });
    res.on('end', () => {
        console.log('end: body=', data);
    });
});

req.write(xmldoc.toString({pretty: true}));
req.end();