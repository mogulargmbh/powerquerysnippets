const fs = require("fs");
const path = require("path");

function hash(str) {
  var hash = 0;
  if (str.length == 0) {
      return hash;
  }
  for (let i = 0; i < str.length; i++) {
      var char = str.charCodeAt(i);
      hash = ((hash<<5)-hash)+char;
      hash = hash & hash; // Convert to 32bit integer
  }
  return hash;
}

let entries = fs.readdirSync("./snippets");
let list = [];
for(let e of entries)
{
  let src = path.join("./snippets", e);
  let content = fs.readFileSync(src).toString();
  let h = hash(content);
  list.push({
    name: e,
    hash: h
  });
}

fs.writeFileSync("./list.json", JSON.stringify(list));