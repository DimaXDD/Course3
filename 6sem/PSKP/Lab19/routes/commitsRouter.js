const Router = require('express');
const commitsRouter = new Router();
const commitsController = require('../controllers/commitsController');

commitsRouter
    .get('/:id/commits', commitsController.getAllCommitsByRepo)
    .get('/:id/commits/:commitId', commitsController.getOneCommitByRepo)
    .post('/:id/commits', commitsController.createCommitByRepo)
    .put('/:id/commits/:commitId', commitsController.updateCommitByRepo)
    .delete('/:id/commits/:commitId', commitsController.deleteCommitByRepo);

module.exports = commitsRouter;