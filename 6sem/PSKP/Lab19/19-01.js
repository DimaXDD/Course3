const express = require('express');
const jwt = require('jsonwebtoken');
const bodyParser = require('body-parser');
const cookieParser = require('cookie-parser');
const { Ability, AbilityBuilder } = require('casl');
const authRouter = require('./routes/authRouter');
const apiRouter = require('./routes/index');
const sequelize = require('./db');

const accessKey = 'dimas';

const app = express();
const port = 3000;

app.use(express.static(__dirname + '/static'));
app.use(cookieParser('dimaxdd'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use((req, res, next) => {
    const { rules, can } = AbilityBuilder.extract();
    console.log('accessToken:', req.cookies.accessToken);

    if (req.cookies.accessToken) {
        jwt.verify(req.cookies.accessToken, accessKey, (err, payload) => {
            if (err) {
                console.log('err', err);
                next();
            } else if (payload) {
                req.payload = payload;
                console.log('payload:', req.payload, '\n');

                switch (req.payload.role) {
                    case 'admin':
                        can(['read', 'update', 'delete'], ['Repos', 'Commits']);
                        can('read', ['Repos', 'Commits', 'UsersCASL', 'ability', 'all']);
                        can('manage', 'all');
                        break;

                    case 'user':
                        can(['read', 'create', 'update'], ['Repos', 'Commits'], {
                            authorId: req.payload.id,
                        });
                        //can('read', 'UsersCASL', { id: req.payload.id }); -- для просмотра всех ползователей
                        break;

                    case 'guest':
                        can(['read'], ['Repos', 'Commits'], {
                            authorId: req.payload.id,
                        });
                        can('read', 'UsersCASL', { id: req.payload.id });
                        break;
                }
            }
        });
    } else {
        req.payload = { id: 0 };
        can('read', ['Repos', 'Commits'], 'all');
    }
    req.ability = new Ability(rules);
    next();
});

app.use('/', authRouter);
app.use('/api', apiRouter);
app.use((req, res, next) => { res.status(404).send('<h2>Incorrect URI or method</h2>'); });

sequelize
    .sync({ force: false })
    .then(() => {
        app.listen(port, ()=>{console.log("Server Starter on PORT: ", port)});
    })
    .catch(err => console.log(err));