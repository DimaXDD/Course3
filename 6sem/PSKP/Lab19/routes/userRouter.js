const Router = require('express');
const userRouter = new Router();
const userController = require('../controllers/userController');

userRouter
    .get('/', userController.getAllUsers)
    .get('/:id', userController.getOneUser);

module.exports = userRouter;