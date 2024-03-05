const Router = require('express');
const router = new Router();
const faculties = require('../controller/faculties.controller');

router.get('/faculties', faculties.select);
router.get('/faculties/:id/subjects', faculties.selectWithParam);
router.post('/faculties', faculties.insert);
router.put('/faculties', faculties.update);
router.delete('/faculties/:id', faculties.delete);

module.exports = router;