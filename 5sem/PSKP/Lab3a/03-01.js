const http = require("http");

let state = "norm";

http.createServer(function(request, response){

    if (state != null) {
        response.writeHead("200", {"Content-type": "text/html; charset=utf-8"});
        response.end(`<h1>${state}<h1>`);
    } else {
        response.end(`<h1>Error<h1>`);    
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});

process.stdin.setEncoding('utf-8');
process.stdin.on('readable', () => {

    let input = null;
    const states = ['norm', 'stop', 'test', 'idle', 'exit'];

    while ((input = process.stdin.read()) !== null) {
        let trimmedInput = input.trim();

        if (states.includes(trimmedInput)) {

            console.log(`${state} -> ${trimmedInput}`);

            if (trimmedInput === 'exit') {
                process.exit(0);
            } else {
                state = trimmedInput;
            }

        } else {
            console.log(`Неизвестный стейт: ${trimmedInput}\n${state} -> ${state}`);
        }

    }
});
