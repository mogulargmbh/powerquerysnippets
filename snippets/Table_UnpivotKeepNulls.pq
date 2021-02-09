/**
 * Unpivots columns (or optional other columns) while keeping empty fields (with
 * null). Any entry to the 3rd parameter will set to 'Unpivot Other Columns'
 * instead.
 * 
 * @categories table, pivot
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (Table_ as table, Columns as list, optional Others as any) =>
    let
      NonSelectedColumns = List.Difference(Table.ColumnNames(Table_), Columns),
      Unpivot = if Others <> null then NonSelectedColumns else Columns,
      AddColumn = Table.AddColumn(
        Table_,
        "Custom",
        each Record.ToTable(Record.SelectFields(_, Unpivot))
      ),
      Cleanup = Table.RemoveColumns(AddColumn, Unpivot),
      Expand = Table.ExpandTableColumn(Cleanup, "Custom", {"Name", "Value"}, {"Name", "Value"})
    in
      Expand,
  documentation = [
    Documentation.Name = " Table.UnpivotKeepNulls#(cr,lf)",
    Documentation.Description
      = " Unpivots columns (or optional other columns) while keeping empty fields (with null). #(cr,lf)",
    Documentation.LongDescription
      = " Unpivots columns (or optional other columns) while keeping empty fields (with null). Any entry to the 3rd parameter will set to ""Unpivot Other Columns"" instead. #(cr,lf)",
    Documentation.Category = " Table Transformation#(cr,lf)",
    Documentation.Source = " local#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
