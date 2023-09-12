const http = require("http");
const fs = require("fs");

http.createServer(function(request, response){
    console.log(request.url);

    if (request.url === "/html") {
        fs.readFile("index.html", "utf8", function (err, data) {
            if (err) {
                response.writeHead("500", { "Content-type": "text-plain" });
                response.end("Internal Server Error");
            } else {
                response.writeHead("200", { "Content-type": "text/html" });
                response.end(data);
            }
        });
    } else {
        response.end(`
        <html>
            <body>
                <h1>Error! Visit localhost:5000/html</h1>
            </body>
        </html>
    `);    
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});