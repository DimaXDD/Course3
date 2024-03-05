const Router = require('express');
const router = new Router();
const subjects = require('../controller/teachers.controller');

router.get('/teachers', subjects.select);
router.post('/teachers', subjects.insert);
router.put('/teachers', subjects.update);
router.delete('/teachers/:id', subjects.delete);

module.exports = router;
