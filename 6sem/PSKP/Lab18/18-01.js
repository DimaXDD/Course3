const express = require('express');
const passport = require('passport');
const GitHubStrategy = require('passport-github').Strategy;
const cookieParser = require('cookie-parser');
const session = require('express-session');

const port = 3000;
const app = express();

app.use(cookieParser());
app.use(session({ secret: 'dimasss', resave: false, saveUninitialized: false }));
app.use(passport.initialize());
app.use(passport.session());

passport.use(new GitHubStrategy({
    clientID: '',
    clientSecret: '',
    callbackURL: 'http://localhost:3000/auth/github/callback'
}, (accessToken, refreshToken, profile, done) => {
    return done(null, profile);
}));

passport.serializeUser((user, done) => {
    done(null, user);
});

passport.deserializeUser((user, done) => {
    done(null, user);
});

// Routes
app.get('/login', (req, res) => {
    res.send('<a href="/auth/github">Login with GitHub</a>');
});

app.get('/auth/github', passport.authenticate('github'));

app.get('/auth/github/callback', passport.authenticate('github', { failureRedirect: '/login' }), (req, res) => {
    res.redirect('/resource');
});
app.get('/logout', (req, res) => {
    req.logout();
    req.session.destroy((err) => {
        if (err) {
            console.error('Error destroying session:', err);
            return next(err);
        }
        res.clearCookie('connect.sid', { path: '/' });
        res.redirect('/login');
    });
});

app.get('/resource', isAuthenticated, (req, res) => {
    res.send(`RESOURCE - User ID: ${req.user.id}, Username: ${req.user.username}`);
});

app.get('/', (req, res) => {
    res.status(404).send('Not Found');
});

function isAuthenticated(req, res, next) {
    if (req.isAuthenticated()) {
        return next();
    }
    res.redirect('/login');
}

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));