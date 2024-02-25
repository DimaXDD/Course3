const Router = require('express');
const router = new Router();
const subjects = require('../controllers/subjects.controller');

router.get('/subjects', subjects.select);
router.post('/subjects', subjects.insert);
router.put('/subjects', subjects.update);
router.delete('/subjects/:id', subjects.delete);

module.exports = router;
