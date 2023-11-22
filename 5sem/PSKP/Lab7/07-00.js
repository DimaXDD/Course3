const http = require('http');
const url = require("url");
let parseString = require('xml2js').parseString;
let mp = require('multiparty');
const fs = require("fs");

http.createServer((req, res) => {
    let parsedUrl = url.parse(req.url, true);

    switch (parsedUrl.pathname) {
        case '/':
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end("");
            break;
        case "/2": {
            res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            let x = parsedUrl.query.x;
            let y = parsedUrl.query.y;
            res.end(`Second task. x = ${x}, y = ${y}`);
            break;
        }
        case "/3": {
            let data = '';

            req.on('data', (chunk) => {
                data += chunk;
            });
            req.on('end', () => {
                const postData = JSON.parse(data);
                let x = postData.x;
                let y = postData.y;
                let s = postData.s;
                res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
                res.end(`Third task. x = ${x}, y = ${y}, s = ${s}`);
            });

            break;
        }
        case "/4":
            let data = '';
            req.on('data', (chunk) => {
                data += chunk;
            });
            req.on('end', () => {
                data = JSON.parse(data);
                res.writeHead(200, { 'Content-type': 'application/json; charset=utf-8' });
                let comment = 'Ответ. Лабораторная работа 7';
                let resp = {};
                resp.__comment = comment;
                resp.x_plus_y = data.x + data.y;
                resp.Concatenation_s_o = data.s + ': ' + data.o.surname + ', ' + data.o.name;
                resp.Length_m = data.m.length;
                res.end(JSON.stringify(resp));
            });
            break;
        case "/5": {
            let data = '';
            req.on('data', (chunk) => {
                data += chunk;
            });
            req.on('end', () => {
                parseString(data, (err, result) => {
                    res.writeHead(200, { 'Content-type': 'application/xml' });
                    let id = result.request.$.id;
                    let sum = 0;
                    let concat = '';
                    result.request.x.forEach((p) => {
                        sum += parseInt(p.$.value);
                    });
                    result.request.m.forEach((p) => {
                        concat += p.$.value;
                    });

                    let responseText = `<response id="33" request="${id}"><sum element="x" result="${sum}"/><concat element="m" result="${concat}"/></response>`;
                    res.end(responseText);
                });
            });
            break;
        }
        case "/6":
            let result = '';
            let form = new mp.Form({ uploadDir: './static' });
          
            form.on('field', (name, field) => {
              console.log(field);
              result += `'${name}' = ${field}`;
            });
          
            form.on('file', (name, file) => {
              console.log(name, file);
              const filePath = './static/server.png'; // Путь для сохранения файла
              const readStream = fs.createReadStream(file.path);
              const writeStream = fs.createWriteStream(filePath);
          
              readStream.pipe(writeStream); // Копирование файла
          
              result += `'${name}': Original filename – ${file.originalFilename}, Filepath – ${filePath}`;
            });
          
            form.on('error', (err) => {
              res.writeHead(500, { 'Content-Type': 'text/html' });
              console.log('error', err.message);
              res.end('Form error.');
            });
          
            form.on('close', () => {
              res.writeHead(200, { 'Content-Type': 'text/html' });
              res.write('Form data:');
              res.end(result);
            });
          
            form.parse(req);
            break;
        case "/7":
            res.writeHead(200, { 'Content-Type': 'text/html' });
            let file = fs.readFileSync("./static/server.png");
            console.log("Done!");
            res.end(file);
            break;
    }
}).listen(5000, () => console.log('Сервер начал прослушивание запросов на порту 5000'));