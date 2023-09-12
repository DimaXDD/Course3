const http = require("http");
const fs = require("fs");

http.createServer(function(request, response){
    console.log(request.url);

    if (request.url === "/xmlhttprequest") {
        fs.readFile("xmlhttprequest.html", (err, data) => {
            if (err) {
                response.writeHead(500, { "Content-Type": "text/plain" });
                response.end("Internal Server Error");
            } else {
                response.writeHead(200, {
                    "Content-Type": "text/html; charset=utf-8",
                });
                response.end(data);
            }
        });
    }  else if (request.url === "/api/name") {
        response.writeHead(200, {'Content-Type': 'text/plain; charset=utf-8'});
        response.end('Трубач Дмитрий Сергеевич')
    } else {
        response.end(`
        <html>
            <body>
                <h1>Error! Visit localhost:5000/xmlhttprequest</h1>
            </body>
        </html>
    `);    
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});