const http = require('http');
const data = require('./DB.js')
const fs = require('fs');
const url = require('url');

let db = new data.DB();

db.on('GET', (req, res) => {
    console.log('DB.Get');
    
    res.setHeader('Content-Type', 'application/json');
    db.select()
    .then(elem =>{
        res.end(JSON.stringify(elem));
    })
})

db.on('POST', (req, res) =>{
    console.log('DB.POST'); 
    //обычный insert
    req.on('data', data => {
        let r = JSON.parse(data);
        if(r.BDay == -1){
            //подгрузка
            res.setHeader('Content-Type', 'application/json');
            db.select(r)
            .then(elem =>{
                res.end(JSON.stringify(elem));
            })
        }
        else{
            //обычный insert
            db.insert(r);
            res.setHeader('Content-Type', 'application/json');
            res.end(JSON.stringify(r));
        }
    })
})

db.on('PUT', (req, res)=>{
    console.log('DB.PUT');

    req.on('data', data => {
        let r = JSON.parse(data);
        db.update(r);
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(r));
    })
})

db.on('DELETE', (req, res)=>{
    console.log('DB.DELETE');
    
    req.on('data', data => {
        let r = JSON.parse(data);
        db.delete(r);
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(r));
    })
})

http.createServer(function(req, res) {
    if(url.parse(req.url).pathname === '/'){
        let html = fs.readFile('index.html', (err, html) => {
            res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
            res.end(html);
        })
    }
    else if (url.parse(req.url).pathname ==='/api/db') {
        db.emit(req.method, req, res);
    }
     
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});