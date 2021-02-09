const fs = require("fs");
const path = require("path");
let entries = fs.readdirSync("./snippets");

let list = [];
for(let e of entries)
{
  fs.copyFileSync(path.join("./snippets", e), path.join("./docs", e));
  list.push(e);
}

fs.writeFileSync("./docs/list.json", JSON.stringify(list));