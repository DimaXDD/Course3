const Router = require('express');
const controller = require('../controller/controller.js');
const jwt = require('jsonwebtoken');
const router = new Router();
const fs = require('fs');

const { DBredis, DBsequelize } = require('../db/DB.js');

const redisClient = new DBredis();
const sequelizeClient = new DBsequelize();

redisClient.client_connect();
sequelizeClient.client_connect();

const secret = "SECRET_KEY";

const generateAccesToken = (username, fio, _expiresIn = '24m', _secret = secret) => {
  const payload = {
    username,
    fio
  };
  return jwt.sign(payload, _secret, { expiresIn: _expiresIn });
}

function decodeToken(token) {
  try {
    const decoded = jwt.decode(token);
    return decoded;
  } catch (error) {
    console.error('Error decoding token:', error.message);
    return null;
  }
}

router.get('/login', controller.loginPage);
router.get('/register', controller.registerPage);
router.get('/logout', (req, res) => {
  req.session.destroy((err) => {
    if (err) {
      console.error('Error destroying session:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.clearCookie('access_token');
      res.clearCookie('refresh_token');
      res.redirect('/api/login');
    }
  });
});
router.get('/resource', async (req, res) => {
  if (req.session && req.session.user) {
    const { username } = req.session.user;
    const { refreshToken } = req.cookies;

    jwt.verify(refreshToken, 'refresh_secret', async (err, user) => {
      if (err) {
        return res.status(401).send('Unauthorized');
      }
    });

    try {
      console.log("GET | /resource | refreshToken", refreshToken);

      const result2 = await redisClient.RC.get(`key${refreshToken}`);

      if (`${username}` === result2) {
        return res.status(401).send('Refresh token is in the BLACKLIST :)');
      }
    } catch (error) {
      console.error('Error accessing Redis:', error);
      return res.status(500).send('Internal Server Error');
    }

    res.send(`Resource page. You're authorized. <br/> Username: ${req.session.user.username} Info: ${req.session.user.FIO}`);
  } else {
    res.status(401).send('Unauthorized');
  }
});

router.get('/refresh-token', async (req, res) => {
  const existRefreshToken = req.cookies.refreshToken;
  console.log("/refresh-token | existRefreshToken", existRefreshToken);
  const decodedToken = decodeToken(existRefreshToken);

  if (decodedToken) 
    console.log('Decoded token:', decodedToken);
  else              
    console.log('Token decoding failed.');
  
  if (existRefreshToken) {
    jwt.verify(existRefreshToken, 'refresh_secret', async (err, user) => {
      if (err) {
        return res.status(401).send('Unauthorized');
      } else if (user) {
        const usrname = user.username;
        console.log(user);
        console.log("Check key: ", `key${existRefreshToken}`);

        const Banned = await redisClient.RC.get(`key${existRefreshToken}`);
        if (`value ${usrname}` === Banned) {
          return res.status(401).send('Refresh token in black list');
        }

        const newAccessToken = generateAccesToken(decodedToken.username, decodedToken.fio, '10m', 'access_secret');
        const newRefreshToken = generateAccesToken(decodedToken.username, decodedToken.fio, '24h', 'refresh_secret');

        res.clearCookie('accessToken');
        res.clearCookie('refreshToken');

        res.cookie('accessToken', newAccessToken, { httpOnly: true, sameSite: 'strict' });
        res.cookie('refreshToken', newRefreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

        await redisClient.RC.set(`key${existRefreshToken}`, `${usrname}`);
        const bannedToken = await redisClient.RC.get(`key${existRefreshToken}`);

        console.log('ADD refresh token in black list', bannedToken);
        console.log('NEW refreshToken ' + newRefreshToken);

        res.redirect('/api/resource');
      }
    });
  } else {
    res.status(400).send('No refresh token provided');
  }
});

router.post('/login', (req, res) => {
  const { username, password } = req.body;

  sequelizeClient.users.findOne({ where: { username: username } })
    .then(user => {
      if (user) {
        if (user.password === password) {
          req.session.user = user;
          try {
            const accessToken = generateAccesToken(user.username, user.FIO, '10m', 'access_secret');
            const refreshToken = generateAccesToken(user.username, user.FIO, '24h', 'refresh_secret');

            res.cookie('accessToken', accessToken, { httpOnly: true, sameSite: 'strict' });
            res.cookie('refreshToken', refreshToken, { httpOnly: true, sameSite: 'strict', path: '/' });

            res.redirect('/api/resource');
          } catch (error) {
            console.error('Error:', error);
            res.status(500).send('Internal Server Error');
          }
        } else {
          res.status(401).send('Incorrect password');
        }
      } else {
        res.redirect('/login');
      }
    })
    .catch(err => {
      console.error('Error:', err);
      res.status(500).send('Internal Server Error');
    });
});

router.post('/register', (req, res) => {
  console.log('register');
  const { username, password, fio } = req.body;
  sequelizeClient.users.create({ username: username, password: password, FIO: fio })
    .then(user => {
      res.status(200).send('User registered successfully');
    })
    .catch(err => {
      res.status(500).send('Error registering user');
    });
});

router.use(function (err, req, res, next) {
  res.send(err.message);
});

module.exports = router;