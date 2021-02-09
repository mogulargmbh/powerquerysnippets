/**
 * Exports a table to a csv file using R-script in PowerBI Desktop. You can pass
 * the path in with backward-slashes, that will be reversed automatically.
 * 
 * @categories table, csv, export, conversion
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = // Exports the current table to csv. Pass full PathFile specification as parameter
  (path as text, dataset as table) =>
    let
      TransformToText = Table.TransformColumnTypes(
        dataset,
        List.Transform(Table.ColumnNames(dataset), each {_, type text})
      ),
      ConvertedPath = Text.Replace(path, "\", "/"),
      RScript = R.Execute(
        "write.csv(dataset,"""
          & ConvertedPath
          & """) #(cr,lf)#(cr,lf)                         output <- TransformToText#(cr,lf)#(cr,lf)                         ",
        [dataset = dataset]
      ),
      output = RScript{[Name = "output"]}[Value]
    in
      output,
  documentation = [
    Documentation.Name = " Table.ExportToCsv#(cr,lf)",
    Documentation.Description = " Exports a table to a csv file using R-script in PowerBI Desktop#(cr,lf)",
    Documentation.LongDescription
      = " Exports a table to a csv file using R-script in PowerBI Desktop. You can pass the path in with backward-slashes, that will be reversed automatically.#(cr,lf)",
    Documentation.Category = " Table.Other#(cr,lf)",
    Documentation.Source
      = " http://www.thebiccountant.com/2015/12/28/how-to-export-data-from-power-bi-and-power-query/ .#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com#(cr,lf)",
    Documentation.Examples = {
      [
        Description
          = " Details see: http://www.thebiccountant.com/2015/12/28/how-to-export-data-from-power-bi-and-power-query/ #(cr,lf)",
        Code = " #(cr,lf) ",
        Result = " #(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
