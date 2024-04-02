const express = require('express');
const path = require('path');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const users = require('./Users.json');
const bodyParser = require('body-parser');

const session = require('express-session')({
    resave: false,
    saveUninitialized: false,
    secret: 'longsecretcode'
});

const port = 3000;

const app = express();

app.use(session);
app.use(passport.initialize());
app.use(passport.session());
app.use(bodyParser.urlencoded({ extended: false }));

passport.use(new LocalStrategy(
    (username, password, done) => {
        const user = users.find(u => u.username === username && u.password === password);
        if (user) {
            return done(null, user);
        } else {
            return done(null, false, {message: 'Ошибка в логине или пароле'});
        }
    }
));

passport.serializeUser((user, done) => {
    done(null, user.username);
});

passport.deserializeUser((username, done) => {
    const user = users.find(u => u.username === username);
    done(null, user);
});

app.get('/', (req, res) => res.redirect('/login'));

app.get('/login', (req, res) => {
    if (req.session.logout) {
        req.session.logout = false;
        delete req.headers['authorization'];
    }
    res.sendFile(path.join(__dirname, '17-01.html'));
});

app.post('/login', passport.authenticate('local', {
    successRedirect: '/resource',
    failureRedirect: '/login'
}));

app.get('/logout', (req, res) => {
    req.logout(function(err) {
        if (err) { return next(err); }
        req.session.destroy(() => {
            res.redirect('/login');
        });
    });
});


app.get('/resource', (req, res) => {
    if (req.isAuthenticated()) {
        res.send('RESOURCE: '+'Username: '+ req.user.username + ', Info: ' + req.user.info + '😊😊😊😊😊');
    } else {
        res.status(401).send('Куда лезем? 🤔🤔🤔🤔🤔');
    }
});


app.use((req, res) => {
    res.status(404).send('Сообщение со статусом 404');
});

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));