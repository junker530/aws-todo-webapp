const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Set up express
app.set('view engine', 'ejs');

// Static files
app.use('/public', express.static(path.join(__dirname, 'public')));

// Set up middlewares
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use((req, res, next) => {
  res.locals.DateTime = require('luxon').DateTime;
  next();
});

// Routes
app.get('/', (req, res) => {
  res.render('home/index');
});
app.use('/home', require('./routes/home'));
app.use('/todo', require('./routes/todo'));

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).render('error/500', err);
});

// Start the server
app.listen(PORT, () => {
  console.log(`Now listening on: http://localhost:${PORT}`);
  console.log(`Application started. Press Ctrl+C to shut down.`);
});