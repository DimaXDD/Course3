const http = require('http');

const jsonObject = JSON.stringify({
    "__comment": "Запрос. Лабораторная работа 7",
    "x": 1,
    "y": 2,
    "s": "Сообщение",
    "m": ["a", "b", "c", "d"],
    "o": {
        "surname": "Иванов",
        "name": "Иван"
    }
});


const options = {
    host: 'localhost',
    path: `/4`,
    port: 5000,
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
}

setTimeout(() => {
    const req = http.request(options, res => {
        let data = '';
        console.log(`Response status:  ${res.statusCode} ${res.statusMessage}`);
        res.on('data', chunk => {
            data += chunk.toString('utf8');
        })
        res.on('end', () => {
            console.log(`Response body (end):\n${data}\n\n`);
        });
    });

    req.on('error', e => {
        console.log(`${e.message}\n\n`);
    })
    req.end(jsonObject);
}, 500);