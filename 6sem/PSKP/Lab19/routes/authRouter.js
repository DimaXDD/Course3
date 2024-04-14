const Router = require('express');
const authRouter = new Router();
const authController = require('../controllers/authController');

authRouter
    .get('/', authController.getLoginPage)
    .get('/login', authController.getLoginPage)
    .get('/register', authController.getRegisterPage)
    .post('/login', authController.login)
    .post('/register', authController.register)
    .get('/resource', authController.getResoursePage)
    .get('/refresh-token', authController.refreshToken)
    .get('/logout', authController.logout);

module.exports = authRouter;