const http = require("http");
const fs = require("fs");

http.createServer(function(request, response){
    console.log(request.url);

    if (request.url === "/png") {
        fs.readFile("pic.png", (err, data) => {
            if (err) {
                response.writeHead(500, { "Content-Type": "text/plain" });
                response.end("Internal Server Error");
            } else {
                response.writeHead(200, { "Content-Type": "image/png" });
                response.end(data);
            }
        });
    } else {
        response.end(`
        <html>
            <body>
                <h1>Error! Visit localhost:5000/png</h1>
            </body>
        </html>
    `);    
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});