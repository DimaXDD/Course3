const http = require("http");
const fs = require("fs");
const url = require('url');


function calculateFactorial(k) {
    if (k <= 1) {
        return 1;
    } else {
        return k * calculateFactorial(k - 1);
    }
}

http.createServer(function(request, response) {
    console.log(request.url);

    let path = url.parse(request.url, true);

    switch (path.pathname) {
        case '/fact':
        const k = +path.query.k;

        if (Number.isInteger(k) && k >= 0) {
            // let k = +path.query.k;
            response.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});

            setImmediate(() => {
                response.end(JSON.stringify({k: k, fact: calculateFactorial(k)}));
            });
        } else {
            response.writeHead(400, { 'Content-Type': 'text/plain; charset=utf-8' });
            response.end("Неверный параметр K");
        }
        break;
        case '/':
        fs.readFile('03-03.html', 'utf-8', function(err, data) {
            if (err) {
            response.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
            response.end("Ошибка сервера");
            } else {
            response.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
            response.end(data);
            }
        });
        break;
        default:
        response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
        response.end("Страница не найдена");
    }

}).listen(5000, "127.0.0.1", function() {
  console.log("Сервер начал прослушивание запросов на порту 5000");
});
