const http = require('http');
const fs = require('fs');
const nodemailer = require('nodemailer');
const smtpTransport = require('nodemailer-smtp-transport');

const pass = 'lcoevsvwfcqwzqst';

function send(sender, receiver, message) {
    let transporter = nodemailer.createTransport(smtpTransport({
        host: 'smtp.yandex.ru',
        port: 587,
        secure: false,
        auth: {
            user: sender,
            pass: pass
        }
    }));

    var mailOptions = {
        from: sender,
        to: receiver,
        subject: 'Lab5',
        text: message,
        html: `<i>${message}</i>`
    };

    transporter.sendMail(mailOptions, function (error, info) {
        if (error) {
            console.error(error);
        } else {
            console.log('Email sent: ' + info.response);
        }
    });
}

http.createServer((req, res) => {
    if (req.method === 'GET') {
        fs.readFile('index.html', (err, data) => {
            if (err) {
                res.writeHead(500);
                res.end('Internal Server Error');
            } else {
                res.writeHead(200, { 'Content-Type': 'text/html' });
                res.end(data);
            }
        });
    } else if (req.method === 'POST' && req.url === '/send') {
        let body = '';

        req.on('data', (chunk) => {
            body += chunk;
        });

        req.on('end', () => {
            const formData = new URLSearchParams(body.toString());
            const sender = formData.get('sender');
            const receiver = formData.get('receiver');
            const message = formData.get('message');

            //console.log(sender);
            //console.log(receiver);

            send(sender, receiver, message);

            res.writeHead(200, { 'Content-Type': 'text/plain' });
            res.end('Email sent!');
        });
    } else {
        res.writeHead(404);
        res.end('Not Found');
    }
}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});