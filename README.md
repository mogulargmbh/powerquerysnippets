# Power Query Snippets

This is the repository for all Power Query code snippets shown on
[PowerQueryFormatter](https://powerqueryformatter.com)

## Contribute your code
Pull requests are welcome.

Please add only your own code or code where the license is clear and permissive.

One snippet per file.

Please prefix all snippets with a comment in [JSDoc](https://en.wikipedia.org/wiki/JSDoc) format with a short description and at least the following tags:

* *@categories* A comma-separated list of categories

* *@license* License under which you grant a license to the snippet code. Must be a short identifier of an open source license from the [SPDX List](https://spdx.org/licenses/), followed by the copyright holder.

We also parse the following **optional** tags:

* *@name* If not available the snippet name is taken from the filename (without extension)

* *@example* Provide an optional uage example

* *@author* optional information about the author (e.g. link to website) 

* *@version* optional version of the snippet. Just for information.

* *@source* optional url where the code is from

* *@result* optional description of the result of the snippet (if any)

Here is a nonsene example. Browse the code to find real snippets.
```
/**
* an example to generate a table with square numbers with bases from -10 to 10
* this is the second line of the description
* 
* @categories table, math 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1
* @example just past the snippet in your query
* @source https://github.com/mogulargmbh/powerquerysnippets
* @result a table
*/ 
let
  data = List.Generate(
    () => [x = - 10, y = 100],
    each [x] <= 10,
    each [x = [x] + 1, y = x * x]
  ),
  output = Table.FromRecords(data)
in
  output
```
