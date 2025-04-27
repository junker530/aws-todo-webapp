const mysql = require('mysql2/promise');
const path = require('path');
const fs = require('fs');

var getCert = function (target = '') {
  var key = target.toLocaleLowerCase();

  switch (key) {
    case 'azure':
      return {
        rejectUnauthorized: false,
        ca: fs.readFileSync(path.join(__dirname, './certs/azure-ca.pem'), 'utf8'),
      };
    case 'aws':
      return {
        rejectUnauthorized: false,
        ca: fs.readFileSync(path.join(__dirname, './certs/aws-ca.pem'), 'utf8'),
      };
    case 'true':
      return {
        rejectUnauthorized: false
      };
    default:
      return undefined;
  }
}

class MySqlClient {
  _config = null;
  _pool = null;

  constructor() {
    this._config = {
      host: process.env.MYSQL_HOST || 'localhost',
      user: process.env.MYSQL_USER || 'root',
      password: process.env.MYSQL_PASSWORD || 'root',
      database: process.env.MYSQL_DATABASE || 'todo',
      connectionLimit: 10,
      namedPlaceholders: true,
      ssl: getCert(process.env.MYSQL_SSL) || undefined
    };

    this._pool = mysql.createPool(this._config);
  }

  async executeQuery(query, parameters) {
    const [rows] = await this._pool.query(query, parameters);
    return rows;
  }
}

module.exports = { MySqlClient };