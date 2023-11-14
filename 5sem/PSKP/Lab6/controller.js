const url = require("url");
const fs = require("fs");
const xml2js = require('xml2js');
const path = require('path');

let KeepAliveTimeout = 60; // Значение по умолчанию (в секундах)

const getReq = (req, res) =>
{
    const {pathname, query} = url.parse(req.url, true);

    if (pathname.startsWith('/files')) {
        const [, , file] = pathname.split('/');

        if (file !== undefined) {
            const filePath = path.join(__dirname, 'static', file);

            try {
                const fileContent = fs.readFileSync(filePath);
                res.writeHead(200, { 'Content-Type': 'text/plain' });
                res.end(fileContent);
            } catch (err) {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end('Error 404: File Not Found');
            }
        }
    }

    if(pathname.startsWith('/parameter'))
    {
        const [,_, xStr, yStr] = pathname.split('/'); // Разбираем x и y из пути

        if (!isNaN(xStr) && !isNaN(yStr)) { // Проверяем, являются ли x и y числами
            const x = Number.parseInt(xStr);
            const y = Number.parseInt(yStr);

            const sum = x + y;
            const diff = x - y;
            const prod = x * y;
            const quot = x / y;

            res.writeHead(200, { "Content-Type": "text/plain" });
            res.end(`Sum: ${sum}, Dif: ${diff}, Mult: ${prod}, Quot: ${quot}`);
        } else {
            res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8'});
            res.end("Ошибка: введенные данные не являются числами!");
        }
    }

    
   switch (pathname)
    {
        case '/connection': {
            const parsedUrl = url.parse(req.url, true);

            if (parsedUrl.query.set) {
                const newKeepAliveTimeout = parseInt(parsedUrl.query.set);
                if (!isNaN(newKeepAliveTimeout)) {
                    KeepAliveTimeout = newKeepAliveTimeout;
                    res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
                    res.end(`Установлено новое значение параметра KeepAliveTimeout=${newKeepAliveTimeout}`);
                } else {
                    res.writeHead(400, { 'Content-Type': 'text/plain; charset=utf-8' });
                    res.end('Ошибка: Укажите корректное значение для параметра set');
                }
            } else {
                res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
                res.end(`Текущее значение параметра KeepAliveTimeout: ${KeepAliveTimeout}`);
            }

            break;
        }
        case '/headers': {
            let h = (r) => {
                let rc = '';
                for (key in r.headers) {
                    rc += '<h3>' + key + ':'+ r.headers[key]+'</h3>';
                }
                return rc;
            }

            res.writeHead(200, {'Content-Type' : 'text/html; charset=utf-8'});
            res.end(
                '<!DOCTYPE html> <html>' +
                '<head></head>' +
                '<body>' +
                '<h1>'+'Headers: '+'</h1>' + h(req) +
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

                res.writeHead(200, {'Content-Type' : 'text/html; charset=utf-8'});
                res.end(
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
                res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8'});
                res.end("Ошибка: введенные данные не являются числами!");
            }
            break;
        }
        case '/socket':{    
            const {headers} = req;
            const ip = req.connection.remoteAddress;
            const port = req.connection.remotePort;

            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end(`
                Client IP: ${ip}, 
                Client Port: ${port},
                Server IP: ${headers.host.split(':')[0]},
                Server Port: ${headers.host.split(':')[1]}`);
            break;
        }
        case '/resp-status': {
            const {code, mess} = query;
            if(!code || !mess || !Number.parseInt(code))
            {
                res.writeHead(500, { "Content-Type": "text/plain" });
                res.end('Error: one of parameter is not undefined');
            }
            res.writeHead(Number.parseInt(code), mess, { "Content-Type": "text/plain" });
            res.end('Status: ' + code + ' Comments: ' + mess);
            break;
        }
        case '/formparameter': {
            fs.readFile('file1.html', (err, data) => {
                if (err) {
                    res.writeHead(500, {'Content-Type': 'text/plain'});
                    res.end('Internal Server Error');
                    return;
                }

                res.writeHead(200, {'Content-Type': 'text/html'});
                res.end(data);
            });
            break;
        }
        case '/files': {
            fs.readdir('./static', (err, files) => {
                if (err) {
                    res.writeHead(500, { 'Content-Type': 'text/plain' });
                    res.end('Internal Server Error');
                    return;
                }

                const fileCount = files.length;
                res.writeHead(200, { 'Content-Type': 'text/plain', 'X-static-files-count': fileCount.toString() });
                res.end(`Number of files in static directory: ${fileCount}`);
            });
            break;
        }
        case '/upload': {
            fs.readFile('file2.html', (err, data) => {
                if (err) {
                    res.writeHead(500, {'Content-Type': 'text/plain'});
                    res.end('Internal Server Error');
                    return;
                }

                res.writeHead(200, {'Content-Type': 'text/html'});
                res.end(data);
            });
            break;
        }
        default: {
            if (pathname.startsWith('/parameter')) {
                res.end(req.url);
            } else {
                res.end();
            }
        }
    }
}

const postReq = (req, res) =>
{
    const {pathname, query} = url.parse(req.url, true);

    switch (pathname)
    {
        case '/formparameter': {
                let body = '';
                req.on('data', chunk => {
                    body += chunk.toString();
                });

                req.on('end', () => {
                    const formData = new URLSearchParams(body);
                    const values = {};
                    formData.forEach((value, key) => {
                        values[key] = value;
                    });

                    res.writeHead(200, { 'Content-Type': 'text/plain' });
                    res.end(JSON.stringify(values));
                });
            break;
        }
        case '/json': {
            let data = '';

            req.on('data', chunk => {
                data += chunk;
            });

            req.on('end', () => {
                try {
                    const reqData = JSON.parse(data);
                    const comment = reqData._comment;
                    const x = reqData.x;
                    const y = reqData.y;
                    const s = reqData.s;
                    const o = reqData.o;
                    const m = reqData.m;

                    const resBody = {
                        "__comment": "Ответ: " + comment,
                        "x: ": x,
                        "y:": y,
                        "x_plus_y": x + y,
                        "Concatination_s_o": s +": "+ o.name,
                        "Length_m": m.length
                    };

                    res.writeHead(200, { 'Content-Type': 'application/json' });
                    res.end(JSON.stringify(resBody));
                } catch (error) {
                    res.writeHead(400, { 'Content-Type': 'text/plain' });
                    res.end('Bad req');
                }

                // POSTMAN:
                // {
                //     "_comment": "Lab6",
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

            req.on('data', chunk => {
                data += chunk;
            });

            req.on('end', () => {
                xml2js.parseString(data, (err, result) => {
                    if (err) {
                        res.writeHead(400, { 'Content-Type': 'text/plain' });
                        res.end('Bad req');
                        return;
                    }

                    const req = result.req;
                    const id = req.$.id;
                    const xs = req.x.map(x => +x.$.value || 0);
                    const ms = req.m.map(m => m.$.value);

                    const sumX = xs.reduce((acc, curr) => acc + curr, 0);
                    const concatM = ms.join('');

                    const resBody = {
                        res: {
                            $: { id: id, req: id },
                            sum: { $: { element: 'x', result: sumX.toString() } },
                            concat: { $: { element: 'm', result: concatM } }
                        }
                    };

                    const builder = new xml2js.Builder();
                    const xml = builder.buildObject(resBody);

                    res.writeHead(200, { 'Content-Type': 'application/xml' });
                    res.end(xml);
                });
            });

            /*
            * POSTMAN:
            *  <req id="28">
                 <x value = "1"/>
                 <x value = "2"/>
                 <m value = "na"/>
                 <m value = "me"/>
               </req>
            * */
            break;
        }
        case '/upload': {
            let data = [];
            req.on('data', chunk => {
                data.push(chunk);
            });

            req.on('end', () => {
                const boundary = req.headers['content-type'].split('=')[1];
                const fileData = Buffer.concat(data).toString();
                const fileStart = fileData.indexOf('filename="') + 10;
                const fileEnd = fileData.indexOf('"', fileStart);
                const fileName = fileData.slice(fileStart, fileEnd);

                const filePath = path.join(__dirname, 'static', fileName);

                const fileContentStart = fileData.indexOf('\r\n\r\n') + 4;

                fs.writeFile(filePath, fileData.slice(fileContentStart), (err) => {
                    if (err) {
                        res.writeHead(500, {'Content-Type': 'text/plain'});
                        res.end('Internal Server Error');
                    } else {
                        res.writeHead(200, {'Content-Type': 'text/plain'});
                        res.end('File uploaded successfully!');
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