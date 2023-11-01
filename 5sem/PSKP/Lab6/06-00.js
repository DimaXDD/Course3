const http = require("http");
const controller = require('./controller')

http.createServer(function(request, response){
     if (request.method === 'GET') {
        controller.getReq(request, response);
     } else if (request.method === 'POST') {
        controller.postReq(request, response);
     }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});

//  Ex1
//console.log('Сервер запушен на http://localhost:5000/connection?set=4');
//  Ex2
//console.log('Сервер запушен на http://localhost:5000/headers');
//  Ex3
//console.log('Сервер запушен на http://localhost:5000/parameter?x=15&y=3');
//  Ex4
//console.log('Сервер запушен на http://localhost:5000/parameter/15/6');
//  Ex5
//console.log('Сервер запушен на http://localhost:5000/socket');
//  Ex6
//console.log('Сервер запушен на http://localhost:5000/resp-status?code=222&mess=dfgfdglf');
//  Ex7
//console.log('Сервер запушен на http://localhost:5000/formparameter');
//  Ex8
//console.log('Сервер запушен на http://localhost:5000/json');
//  Ex9
//console.log('Сервер запушен на http://localhost:5000/xml');
//  Ex10
//console.log('Сервер запушен на http://localhost:5000/files');
//  Ex11
//console.log('Сервер запушен на http://localhost:5000/files/file12.txt');
//  Ex12
//console.log('Сервер запушен на http://localhost:5000/upload');