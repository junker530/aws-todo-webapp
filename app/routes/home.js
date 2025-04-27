const route = require('express').Router();

route.get('/index', (req, res) => {
  res.render('home/index');
});

route.get('/privacy', (req, res) => {
  res.render('home/privacy');
});

module.exports = route;