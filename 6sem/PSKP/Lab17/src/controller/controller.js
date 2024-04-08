//не исп
module.exports.resourcePage = function(req, res) {
    if(req.isAuthenticated()){
      res.send('RESOURCE')
    }
    else{
        res.redirect('/api/login')
    }
  }
module.exports.loginPage = function(req, res) {
  res.sendFile(__dirname + '/loginPage.html');
}
module.exports.registerPage = function(req, res) {
  res.sendFile(__dirname + '/registerPage.html');
}
//не исп 
module.exports.logout = function(req, res) {
    req.logout((err) => {
      if (err) {
        console.log('Error destroying session:', err);
      } else {
          req.session.logout = true;
          res.redirect('/api/login');
      }
    })
  };  
  