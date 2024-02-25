const Router = require('express');
const router = new Router();
const pulpit = require('../controllers/pulpit.controller');

router.get('/pulpits', pulpit.select);
router.post('/pulpits', pulpit.insert);
router.put('/pulpits', pulpit.update);
router.delete('/pulpits/:id', pulpit.delete);

module.exports = router;