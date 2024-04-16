const { UsersCASL } = require('../models');
const jwt = require('jsonwebtoken');

const refreshKey = 'dimas';
const accessKey = 'dimas';

let oldrefreshKeyCount = 0;

class AbilityController {
    getLoginPage(req, res) {
        res.sendFile( __dirname.replace(__dirname.split('\\').pop(), '') + 'static/log.html');
    }

    getRegisterPage(req, res) {
        res.sendFile(__dirname.replace(__dirname.split('\\').pop(), '') + 'static/reg.html');
    }

    getResoursePage(req, res) {
        if (req.payload && req.payload.id !== 0) {
            res
                .status(200)
                .send(
                    `<h2>Welcome to the resource, ${req.payload.username}!</h2>` + 
                    `<h3>Your id: ${req.payload.id}</h3>` + 
                    `<h3>Your role: ${req.payload.role}</h3>` + 
                    `<a href="http://localhost:3000/logout">Log Out</a>`
                );
        } else {
            res.status(401).send('Unauthorized');
        }
    }

    refreshToken(req, res) {
        if (req.cookies.refreshToken) {
            jwt.verify(
                req.cookies.refreshToken,
                refreshKey,
                async (err, payload) => {
                    if (err) {
                        console.log(err.message);
                    } else if (payload) {
                        client.on('ready', () => console.log('ready'));
                        client.on('error', (err) => console.log(`error: ${err}`));
                        client.on('connect', () => console.log('connect'));
                        client.on('end', () => console.log('end'));
                        client.set(oldrefreshKeyCount, req.cookies.refreshToken, () =>
                            console.log('set old refresh token')
                        );
                        client.get(oldrefreshKeyCount, (err, result) =>
                            console.log('added old refresh token:', result)
                        );
                        oldrefreshKeyCount++;
                        client.quit();
                        const candidate = await UsersCASL.findOne({
                            where: {
                                id: payload.id,
                            },
                        });
                        const newAccessToken = jwt.sign(
                            {
                                id: candidate.id,
                                username: candidate.username,
                                role: candidate.role,
                            },
                            accessKey,
                            { expiresIn: 200 * 60 }
                        );
                        const newRefreshToken = jwt.sign(
                            {
                                id: candidate.id,
                                username: candidate.username,
                                role: candidate.role,
                            },
                            refreshKey,
                            { expiresIn: 24 * 60 * 60 }
                        );
                        res.cookie('accessToken', newAccessToken, {
                            httpOnly: true,
                            sameSite: 'strict',
                        });
                        res.cookie('refreshToken', newRefreshToken, {
                            path: '/refresh-token',
                        });
                        res.redirect('/resource');
                    }
                }
            );
        } else {
            res.status(401).send('Unauthorized');
        }
    }

    logout(req, res) {
        res.clearCookie('accessToken');
        res.clearCookie('refreshToken');
        res.redirect('/login');
    }

    async login(req, res) {
        const candidate = await UsersCASL.findOne({
            where: {
                username: req.body.username,
                password: req.body.password,
            },
        });
        if (candidate) {
            const accessToken = jwt.sign(
                {
                    id: candidate.id,
                    username: candidate.username,
                    role: candidate.role,
                },
                accessKey,
                { expiresIn: 10 * 60 }
            );

            const refreshToken = jwt.sign(
                {
                    id: candidate.id,
                    username: candidate.username,
                    role: candidate.role,
                },
                refreshKey,
                { expiresIn: 24 * 60 * 60 }
            );
            res.cookie('accessToken', accessToken, {
                httpOnly: true,
                sameSite: 'strict',
            });
            res.cookie('refreshToken', refreshToken, {
                httpOnly: true,
                sameSite: 'strict',
            });
            res.redirect('/resource');
        } else {
            res.redirect('/login');
        }
    }

    async register(req, res) {
        const candidate = await UsersCASL.findOne({
            where: {
                username: req.body.username,
            },
        });
        if (candidate) {
            res.redirect('/register');
        } else {
            console.log('ROLE: ', req.body.role);
            await UsersCASL.create({
                username: req.body.username,
                email: req.body.email,
                password: req.body.password,
                role: req.body.role,
            });
            res.redirect('/login');
        }
    }
}

module.exports = new AbilityController();