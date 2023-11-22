const nodemailer = require('nodemailer');
const smtpTransport = require('nodemailer-smtp-transport');

//const sender = 'dimatruba2004@yandex.ru';
//const receiver = 'dimatruba2004@yandex.ru';
//const pass = ''; // тут вписывайте пароль от smtp на почте


function send(from, to, pass, message) {
    let transporter = nodemailer.createTransport(smtpTransport({
        host: 'smtp.yandex.ru',
        port: 587,
        secure: false,
        auth: {
            user: from,
            pass: pass
        }

    }));

    var mailOptions = {
        from: from,
        to: to,
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
    })
};

module.exports = { send };
