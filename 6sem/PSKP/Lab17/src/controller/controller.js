module.exports.loginPage = function(req, res) {
  res.sendFile(__dirname + '/loginPage.html');
}
module.exports.registerPage = function(req, res) {
  res.sendFile(__dirname + '/registerPage.html');
}
  