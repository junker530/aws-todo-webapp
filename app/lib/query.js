const fs = require('fs');
const path = require('path');

class SqlFileLoader {
  _root = null;

  constructor(root) {
    this._root = root;
  }

  load = (root, options) => {
    var filelist = {};

    // Read all items
    const items = fs.readdirSync(root, {withFileTypes: true});

    // Process each item
    for (const item of items) {
      var fullpath = path.join(root, item.name);
      if (item.isDirectory()) {
        // Recursively load files
        var obj = this.load(fullpath, options);
        filelist = Object.assign(filelist, obj);
      } else {
        // Load only SQL files
        const ext = (path.extname(item.name) || '').toLowerCase();
        if (ext === '.sql') {
          const key = path.join(root, path.basename(item.name, ext));
          const value = fs.readFileSync(fullpath, 'utf-8');
          filelist[key] = this.format(value);
        }
      }
    }

    return filelist;
  }

  format = (text = "") => {
    // Remove comment line.
    text = text.replace(/\-\- .*/g, "");
    text = text.replace(/\/\*[\s\S]*?\*\//mg, "");
    // Remove spaces.
    text = text.replace(/\s+/g, " ").trim()
    return text;
  }
}

const loader = new SqlFileLoader();
const sql = loader.load(path.join(__dirname, 'sql'));

module.exports = { sql };
