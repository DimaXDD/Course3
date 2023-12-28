const Router = require('express');
const router = new Router();
const auditoriums = require('../controller/auditoriums.controller');

router.get('/auditoriums', auditoriums.select);
router.post('/auditoriums', auditoriums.insert);
router.put('/auditoriums', auditoriums.update);
router.delete('/auditoriums/:id', auditoriums.delete);

module.exports = router;

