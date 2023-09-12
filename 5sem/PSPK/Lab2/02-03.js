const http = require("http");

http.createServer(function(request, response){
    console.log(request.url);

    if (request.url === "/api/name") {
        response.writeHead("200", {"Content-type": "text/plain; charset=utf-8"});
        response.end("Трубач Дмитрий Сергеевич");
    } else {
        response.end(`
        <html>
            <body>
                <h1>Error! Visit localhost:5000/api/name</h1>
            </body>
        </html>
    `);    
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});