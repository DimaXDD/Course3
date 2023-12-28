const Router = require('express');
const router = new Router();
const faculties = require('../controller/faculties.controller');

router.get('/faculties', faculties.select);
router.get('/faculty/:id/pulpits', faculties.selectWithParam);
router.put('/faculties', faculties.update);
router.delete('/faculties/:id', faculties.delete);

module.exports = router;