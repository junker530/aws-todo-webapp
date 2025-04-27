const { MySqlClient } = require('../lib/mysqlclient');

class Tasks {

  getTasks = async (userId) => {
    const client = new MySqlClient();

    const data = await client.executeQuery(
      `SELECT * FROM Tasks WHERE UserId = :userId`,
      { userId }
    );

    return data;
  }

  getTask = async (taskId) => {
    const client = new MySqlClient();

    const data = await client.executeQuery(
      `SELECT * FROM Tasks WHERE TaskId = :taskId`,
      { taskId }
    );

    return data[0];
  }

  createTask = async (userId, task) => {
    const client = new MySqlClient();

    task.deadline = task.deadline ? task.deadline : null;

    await client.executeQuery(
      `INSERT INTO Tasks (UserId, Title, Description, Deadline, Priority, Status) VALUES (:userId, :title, :description, :deadline, :priority, :status)`,
      { userId, ...task }
    );
  }

  deleteTask = async (taskId) => {
    const client = new MySqlClient();

    await client.executeQuery(
      `DELETE FROM Tasks WHERE TaskId = :taskId`,
      { taskId }
    );
  }

  updateTask = async (taskId, task) => {
    const client = new MySqlClient();

    task.deadline = task.deadline ? task.deadline : null;

    await client.executeQuery(
      `UPDATE Tasks SET Title = :title, Description = :description, Deadline = :deadline, Priority = :priority, Status = :status WHERE TaskId = :taskId`,
      { taskId, ...task }
    );
  }
}

module.exports = { Tasks };