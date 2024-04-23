const express = require('express');
const session = require('express-session');
const cookieParser = require('cookie-parser');
const routes = require('./routes/authJWT.routes');

const port = 3000;

const app = express();
app.use(session({ secret: 'salt', resave: false, saveUninitialized: false }));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(cookieParser());
app.use(routes);

app.listen(port, () => {console.log(`Server started on Port: ${port}`)});
