/**
 * fetches the first N rows in all tables (and views) from a database at once and
 * presents them in a compact form
 * 
 * @categories table, sql
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  // fetches the first N rows in all tables from a database at once and presents them in a compact form
  func = (Server as text, Database as text, NumberOfRows as number) as table =>
    let
      Source = Sql.Database(Server, Database, [CreateNavigationProperties = false]),
      #"Filtered Rows" = Table.SelectRows(Source, each Value.Is([Data], type table)),
      #"Added Custom" = Table.AddColumn(
        #"Filtered Rows",
        "Custom",
        each Table.Transpose(Table.DemoteHeaders(Table.Buffer(Table.FirstN([Data], NumberOfRows))))
      ),
      #"Expanded Custom" = Table.ExpandTableColumn(
        #"Added Custom",
        "Custom",
        Table.ColumnNames(#"Added Custom"[Custom]{0})
      )
    in
      #"Expanded Custom",
  documentation = [
    Documentation.Name = " Sql.Database_FirstNRowsFromAllTables#(cr,lf)",
    Documentation.Description
      = " fetches the first N rows in all tables (and views) from a database at once and presents them in a compact form#(cr,lf)",
    Documentation.LongDescription
      = " fetches the first N rows in all tables (and views) from a database at once and presents them in a compact form#(cr,lf)",
    Documentation.Category = " Accessing data#(cr,lf)",
    Documentation.Source = " local#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com#(cr,lf)",
    Documentation.Examples = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
