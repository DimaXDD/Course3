const Router = require('express');
const router = new Router();
const controller = require('../controller/controller.js');
const passport = require('passport');

const isAuthenticated = (req, res, next) => {
    if (req.isAuthenticated()) {
      return next();
    }
    res.status(401).send('Unauthorized');
};
router.get('/login', controller.loginPage),
router.get('/resource',isAuthenticated, (req, res, next) => {
    if(req.user) next();
    else res.redirect('/login');
  }, (req,res) => {
    res.send(`Resource page.<br/> Username: ${req.user.login}`);
  });
router.get('/logout', (req, res) => {
    req.logout(() => {});
    res.redirect('/login');
  });
router.post('/login', passport.authenticate('local', {
    successRedirect: '/resource',
    failureRedirect: '/login'
}));

module.exports = router;
