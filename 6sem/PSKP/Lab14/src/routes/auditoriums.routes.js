const Router = require('express');
const router = new Router();
const auditoriums = require('../controller/auditoriums.controller');

router.get('/auditoriums', auditoriums.select);
//router.get('/auditoriums-scope', auditoriums.selectScope);
router.get('/auditoriums-transaction', auditoriums.transaction);
router.get('/auditoriumsWithComp1', auditoriums.selectWithComp1);
router.get('/auditoriumsSameCount', auditoriums.auditoriumsSameCount);
router.post('/auditoriums', auditoriums.insert);
router.put('/auditoriums', auditoriums.update);
router.delete('/auditoriums/:id', auditoriums.delete);

module.exports = router;