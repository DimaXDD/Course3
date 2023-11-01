const url = require("url");
const fs = require("fs");
const xml2js = require('xml2js');
const path = require('path');

let keepAliveTimeout = "";

const getReq = (request, response) =>
{
    const {pathname, query} = url.parse(request.url, true);

    if (pathname.startsWith('/files')) {
        const [, , file] = pathname.split('/');

        if (file !== undefined) {
            const filePath = path.join(__dirname, 'static', file);

            try {
                const fileContent = fs.readFileSync(filePath);

                response.writeHead(200, { 'Content-Type': 'text/plain' }); // Здесь устанавливаем правильный Content-Type
                response.end(fileContent);
            } catch (err) {
                response.writeHead(404, { 'Content-Type': 'text/plain' });
                response.end('Error 404: File Not Found');
            }
        }
    }

    
   switch (pathname)
    {
        case '/connection': {
            const {set} = query;

            if (!set) {
                response.writeHead(200, { "Content-Type": "text/plain" });
                response.end('Value: ' + keepAliveTimeout);
            } else {
                keepAliveTimeout = set;
                response.writeHead(200, { "Content-Type": "text/plain" });
                response.end("Update keepAliveTimeout! New value: " + keepAliveTimeout);
            }
            break;
        }
        case '/headers': {
            let h = (r) => {
                let rc='';
                for (key in r.headers) {
                    rc += '<h3>' + key + ':'+ r.headers[key]+'</h3>';
                }
                return rc;
            }

            response.writeHead(200, {'Content-Type' : 'text/html; charset=utf-8'});
            response.end(
                '<!DOCTYPE html> <html>' +
                '<head></head>' +
                '<body>' +
                '<h1>'+'Headers: '+'</h1>' + h(request) +
                '</body>'+
                '</html>'
            )
            break;
        }
        case '/parameter': {
            const {x, y} = query;
            if (isFinite(x) && isFinite(y)) {
                const xNum = Number.parseInt(x);
                const yNum = Number.parseInt(y);

                const sum = xNum + yNum;
                const mul = xNum * yNum;
                const dif = xNum - yNum;
                const dif2 = yNum - xNum;
                const div = yNum/xNum;
                const div2 = xNum/yNum;

                response.writeHead(200, {'Content-Type' : 'text/html; charset=utf-8'});
                response.end(
                    `<!DOCTYPE html>
                     <html>
                       <head></head>
                       <body>
                         <h2>x и y = ${xNum}, ${yNum}</h2>
                         <h2>Сумма x + y = ${sum}</h2>
                         <h2>Произведение x * y = ${mul}</h2>
                         <h2>Разность x - y = ${dif}</h2>
                         <h2>Разность y - x = ${dif2}</h2>
                         <h2>Частное x / y = ${div2}</h2>
                         <h2>Частное y / x = ${div}</h2>
                       </body>
                     </html>`
                );                  
            } else {
                response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8'});
                response.end("Ошибка: введенные данные не являются числами!");
            }
            break;
        }
        case '/socket':{    
            response.writeHead(200, { 'Content-Type': 'text/plain' });
            response.end(`
                Server IP:      ${server.address().address}\n
                Server PORT:    ${server.address().port}\n
                Client IP:      ${req.connection.remoteAddress}\n
                Client PORT:    ${req.connection.remotePort}\n
            `);
            break;
        }
        case '/resp-status': {
            const { code, mess} = query;
            if(!code || !mess || !Number.parseInt(code))
            {
                response.writeHead(500, { "Content-Type": "text/plain" });
                response.end('Error: one of parameter is not undefined');
            }
            response.writeHead(Number.parseInt(code), mess, { "Content-Type": "text/plain" });
            response.end('Status: ' + code + ' Comments: ' + mess);
            break;
        }
        case '/formparameter': {
            fs.readFile('file1.html', (err, data) => {
                if (err) {
                    response.writeHead(500, {'Content-Type': 'text/plain'});
                    response.end('Internal Server Error');
                    return;
                }

                response.writeHead(200, {'Content-Type': 'text/html'});
                response.end(data);
            });
            break;
        }
        case '/files': {
            fs.readdir('./static', (err, files) => {
                if (err) {
                    response.writeHead(500, { 'Content-Type': 'text/plain' });
                    response.end('Internal Server Error');
                    return;
                }

                const fileCount = files.length;
                response.writeHead(200, { 'Content-Type': 'text/plain', 'X-static-files-count': fileCount.toString() });
                response.end(`Number of files in static directory: ${fileCount}`);
            });
            break;
        }
        case '/upload': {
            fs.readFile('file2.html', (err, data) => {
                if (err) {
                    response.writeHead(500, {'Content-Type': 'text/plain'});
                    response.end('Internal Server Error');
                    return;
                }

                response.writeHead(200, {'Content-Type': 'text/html'});
                response.end(data);
            });
            break;
        }
        default: {
            if (pathname.startsWith('/parameter')) {
                response.end(request.url);
            } else {
                response.end();
            }
        }
    }
}

const postReq = (request, response) =>
{
    const {pathname, query} = url.parse(request.url, true);

    switch (pathname)
    {
        case '/formparameter': {
                let body = '';
                request.on('data', chunk => {
                    body += chunk.toString();
                });

                request.on('end', () => {
                    const formData = new URLSearchParams(body);
                    const values = {};
                    formData.forEach((value, key) => {
                        values[key] = value;
                    });

                    response.writeHead(200, { 'Content-Type': 'text/plain' });
                    response.end(JSON.stringify(values));
                });
            break;
        }
        case '/json': {
            let data = '';

            request.on('data', chunk => {
                data += chunk;
            });

            request.on('end', () => {
                try {
                    const requestData = JSON.parse(data);
                    const comment = requestData._comment;
                    const x = requestData.x;
                    const y = requestData.y;
                    const s = requestData.s;
                    const o = requestData.o;
                    const m = requestData.m;

                    const responseBody = {
                        "__comment": "Ответ: " + comment,
                        "x: ": x,
                        "y:": y,
                        "x_plus_y": x + y,
                        "Concatination_s_o": s +": "+ o.name,
                        "Length_m": m.length
                    };

                    response.writeHead(200, { 'Content-Type': 'application/json' });
                    response.end(JSON.stringify(responseBody));
                } catch (error) {
                    response.writeHead(400, { 'Content-Type': 'text/plain' });
                    response.end('Bad Request');
                }

                // POSTMAN:
                // {
                //     "_comment": "Lab 6",
                //     "x": 1,
                //     "y": 2,
                //     "s": "message",
                //     "m": ["a", "b", "c"],
                //     "o": {"surname": "Trubach", "name": "Dmitry"}
                // }
            });
            break;
        }
        case '/xml': {
            let data = '';

            request.on('data', chunk => {
                data += chunk;
            });

            request.on('end', () => {
                xml2js.parseString(data, (err, result) => {
                    if (err) {
                        response.writeHead(400, { 'Content-Type': 'text/plain' });
                        response.end('Bad Request');
                        return;
                    }

                    const request = result.request;
                    const id = request.$.id;
                    const xs = request.x.map(x => +x.$.value || 0);
                    const ms = request.m.map(m => m.$.value);

                    const sumX = xs.reduce((acc, curr) => acc + curr, 0);
                    const concatM = ms.join('');

                    const responseBody = {
                        response: {
                            $: { id: id, request: id },
                            sum: { $: { element: 'x', result: sumX.toString() } },
                            concat: { $: { element: 'm', result: concatM } }
                        }
                    };

                    const builder = new xml2js.Builder();
                    const xml = builder.buildObject(responseBody);

                    response.writeHead(200, { 'Content-Type': 'application/xml' });
                    response.end(xml);
                });
            });

            /*
            * this is for postman:
            *  <request id="28">
                 <x value = "1"/>
                 <x value = "2"/>
                 <m value = "na"/>
                 <m value = "me"/>
               </request>
            * */
            break;
        }
        case '/upload': {
            let data = [];
            request.on('data', chunk => {
                data.push(chunk);
            });

            request.on('end', () => {
                const boundary = request.headers['content-type'].split('=')[1];
                const fileData = Buffer.concat(data).toString();
                const fileStart = fileData.indexOf('filename="') + 10;
                const fileEnd = fileData.indexOf('"', fileStart);
                const fileName = fileData.slice(fileStart, fileEnd);

                const filePath = path.join(__dirname, 'static', fileName);

                const fileContentStart = fileData.indexOf('\r\n\r\n') + 4;

                fs.writeFile(filePath, fileData.slice(fileContentStart), (err) => {
                    if (err) {
                        response.writeHead(500, {'Content-Type': 'text/plain'});
                        response.end('Internal Server Error');
                    } else {
                        response.writeHead(200, {'Content-Type': 'text/plain'});
                        response.end('File uploaded successfully!');
                    }
                });
            });
            break;
        }
        default: {
            res.end();
        }
    }
}


module.exports = {getReq, postReq}