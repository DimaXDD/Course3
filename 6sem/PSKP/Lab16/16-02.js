const express = require('express');
const passport = require('passport');
const DigestStrategy = require('passport-http').DigestStrategy;
const Users = require('./users.json');

const getCredential = (user) => {
    let u = Users.find((e) => {return e.user.toUpperCase() == user.toUpperCase();});
    return u;
};

const verPassword = (pass1, pass2) => {return pass1 == pass2};

const app = express();
app.use(passport.initialize());

passport.use(new DigestStrategy({qop: 'auth'}, (user, done) => {
    let rc = null;
    let cr = getCredential(user);
    if (!cr) {
        rc = done(null, false);
    } else {
        rc = done(null, cr.user, cr.password);
    }
    return rc;
}, (params, done) => {
    console.log('params = ', params);
    done(null, true);
}));

app.get('/login',
    function(req, res, next) {
        console.log('preAuth');
        if (req.session && req.session.logout) {
            req.session.logout = false;
            delete req.headers['authorization'];
        }
        next();
    }, 
    passport.authenticate('digest', { session: false }),
    function(req, res, next) {
        res.send('Аутентификация прошла успешно, вы можете получить доступ к ресурсу.');
        next();
    }
);

app.get('/logout', (req, res) => {
    console.log('Logout');
    if (req.session) {
        req.session.logout = true;
    }
    res.redirect('/login');
});

app.get('/resource', 
    passport.authenticate('digest', { session: false }),
    (req, res) => {
        res.send('RESOURCE');
});

app.use((req, res) => {
    console.log('Error 404');
    res.status(404).send('Сообщение со статусом 404');
});

app.listen(3000, () => console.log('Сервер слушает порт 3000'));