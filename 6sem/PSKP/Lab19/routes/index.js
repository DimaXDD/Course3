const Router = require('express');
const router = new Router();
const abilityRouter = require('./abilityRouter');
const userRouter = require('./userRouter');
const reposRouter = require('./reposRouter');
const commitsRouter = require('./commitsRouter');

router
    .use('/user', userRouter)
    .use('/ability', abilityRouter)
    .use('/repos', reposRouter)
    .use('/repos', commitsRouter);

module.exports = router;