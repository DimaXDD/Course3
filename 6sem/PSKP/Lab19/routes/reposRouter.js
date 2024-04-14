const Router = require('express');
const repoRouter = new Router();
const reposController = require('../controllers/reposController');

repoRouter
    .get('/', reposController.getAllRepos)
    .get('/:id', reposController.getOneRepo)
    .post('/', reposController.createRepo)
    .put('/:id', reposController.updateRepo)
    .delete('/:id', reposController.deleteRepo);
   
module.exports = repoRouter;