const express = require("express");
const express_session = require('express-session');
const bodyParser = require('body-parser');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;
const routes = require('./routes/auth.routes');
const users = require('./db/users.json');

const port = 3000;
const app = express();

const Strategy = new LocalStrategy(
  (username, password, done) => {
    for (let user of users){
      if(username === user.login && password === user.password)
        return done(null, user);
    }
    return done(null, false, {message:'Что-то не то('});
  }
)

passport.use(Strategy);

passport.serializeUser((user, next) => {
  next(null, user);
});

passport.deserializeUser((user, next) => {
  next(null, user);
});
const session = new express_session({
    resave:false,
    saveUninitialized: false,
    secret: "salt"
})
app.use(session);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());

app.use(passport.initialize());
app.use(passport.session());

app.use(routes);

app.use((req, res) => {
  res.status(404).send('404');
});

app.listen(port, ()=>{console.log("Server Starter on PORT: ", port)})