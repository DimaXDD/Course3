const Router = require('express');
const abilityRouter = new Router();
const abilityController = require('../controllers/abilityController');

abilityRouter.get('/', abilityController.getAllRules);

module.exports = abilityRouter;