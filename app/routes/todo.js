const USER_ID = 1;
const route = require('express').Router();
const { Tasks } = require('../repository/tasks');

route.get(['/', '/index'], async (req, res, next) => {
  try {
    const tasks = new Tasks();
    const data = await tasks.getTasks(USER_ID);
    res.render('todo/index', { tasks: data });
  } catch (err) {
    next(err);
  }
});

route.get('/create', (req, res) => {
  res.render('todo/create');
});

route.post('/create', async (req, res, next) => {
  try {
    const tasks = new Tasks();
    await tasks.createTask(USER_ID, req.body);
    res.redirect('/todo');
  } catch (err) {
    next(err);
  }
});

route.post('/delete/:taskId', async (req, res, next) => {
  try {
    const tasks = new Tasks();
    await tasks.deleteTask(req.params.taskId);
    res.redirect('/todo');
  } catch (err) {
    next(err);
  }
});

route.get('/edit/:taskId', async (req, res, next) => {
  try {
    const tasks = new Tasks();
    const data = await tasks.getTask(req.params.taskId);
    res.render('todo/edit', { item: data });
  } catch (err) {
    next(err);
  }
});

route.post('/edit/:taskId', async (req, res, next) => {
  try {
    const tasks = new Tasks();
    await tasks.updateTask(req.params.taskId, req.body);
    res.redirect('/todo');
  } catch (err) {
    next(err);
  }
});

module.exports = route;