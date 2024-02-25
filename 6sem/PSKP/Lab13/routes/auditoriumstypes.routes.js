const Router = require('express');
const router = new Router();
const auditoriumstypes = require('../controllers/auditoriumsTypes.controller');

router.get('/auditoriumstypes', auditoriumstypes.select);
router.get('/auditoriumtypes/:id/auditoriums', auditoriumstypes.selectWithParam);
router.post('/auditoriumstypes', auditoriumstypes.insert);
router.put('/auditoriumstypes', auditoriumstypes.update);
router.delete('/auditoriumtypes/:id', auditoriumstypes.delete);

module.exports = router;
