const Router = require('express');
const router = new Router();
const auditoriums = require('../controllers/auditoriums.controller');

router.get('/auditoriums', auditoriums.select);
router.get('/auditoriums-scope', auditoriums.selectScope);
router.get('/auditoriums-transaction', auditoriums.transaction);
router.post('/auditoriums', auditoriums.insert);
router.put('/auditoriums', auditoriums.update);
router.delete('/auditoriums/:id', auditoriums.delete);

module.exports = router;

