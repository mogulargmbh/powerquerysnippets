const fs = require("fs");
const path = require("path");
const md5 = require("md5")

let entries = fs.readdirSync("./snippets");
let list = [];
for(let e of entries)
{
  let src = path.join("./snippets", e);
  let content = fs.readFileSync(src).toString();
  list.push({
    path: e,
    hash: md5(content)
  });
}

fs.writeFileSync("./list.json", JSON.stringify(list));