const Router = require('express');
const router = new Router();
const pulpit = require('../controller/pulpit.controller');

router.get('/pulpits', pulpit.select);
router.get('/pulpitspg', pulpit.selectPulpit);
router.get('/puplitsWithoutTeachers', pulpit.puplitsWithoutTeachers);
router.get('/pulpitsWithVladimir', pulpit.pulpitsWithVladimir);
router.post('/pulpits', pulpit.insert);
router.put('/pulpits', pulpit.update);
router.delete('/pulpits/:id', pulpit.delete);

module.exports = router;