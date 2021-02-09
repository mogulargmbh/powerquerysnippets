/**
 * Unpivots a table according to the number of columns and header rows passed on
 * in the parameters
 * 
 * @categories table, pivot, number
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  /* The header rows to be unpivoted must sit in the first rows of your table and NOT in the header itself. The header will be ignored, so if it shall be unpivoted as well, demote it first.*/
  func = (Table as table, FirstNColumnsToKeep as number, FirstNRowsToKeep as number) =>
    let
      Source = Table,
      // Determine column names to keep
      FirstColumnsToKeep = List.FirstN(Table.ColumnNames(Source), FirstNColumnsToKeep),
      // Those columns who are not to keep shall be unpivoted
      UnpivotColumns = List.Difference(Table.ColumnNames(Source), FirstColumnsToKeep),
      // Create list of lists with one row per header row
      Headers = 
        if FirstNRowsToKeep = 0 then
          {UnpivotColumns}
        else
          List.Buffer(
            Table.ToRows(
              Table.FirstN(Table.SelectColumns(Source, UnpivotColumns), FirstNRowsToKeep)
            )
          ),
      // This step effectively unpivots the values of every row of the table and creates one table per row with an index column indicating the values relative positions.
      ValuesRecord = Table.AddColumn(
        Source,
        "Custom",
        each Table.AddIndexColumn(
          Table.FromColumns(
            List.Union({Headers, {Record.FieldValues(Record.SelectFields(_, UnpivotColumns))}})
          ),
          "IndexUnpivot",
          1,
          1
        )
      ),
      Cleanup = Table.RemoveColumns(ValuesRecord, UnpivotColumns),
      // Remove the first rows who hold the "to-be-unpivoted" headers.
      RemoveTopNRows = Table.Skip(Cleanup, FirstNRowsToKeep),
      // Retrieve the column names of the unpivoted columns-table 
      ColsToExpand = List.Union(List.Transform(RemoveTopNRows[Custom], each Table.ColumnNames(_))),
      // Expand the columns and add ".1" to now columns to avoid duplicate column names
      fnUnpivotByNumbers = Table.ExpandTableColumn(
        RemoveTopNRows,
        "Custom",
        ColsToExpand,
        List.Transform(ColsToExpand, each _ & ".1")
      )
    in
      fnUnpivotByNumbers,
  documentation = [
    Documentation.Name = " fnTable.UnpivotByNumbers#(cr,lf)",
    Documentation.Description
      = " Unpivots a table according to the number of columns and header rows passed on in the parameters#(cr,lf)",
    Documentation.LongDescription
      = " Unpivots a table according to the number of columns and header rows passed on in the parameters#(cr,lf)",
    Documentation.Category = " Table functions#(cr,lf)",
    Documentation.Source
      = " Check this blogpost explaining how it works: http://wp.me/p6lgsG-zW .#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com#(cr,lf)",
    Documentation.Examples = {
      [
        Description = " #(cr,lf)",
        Code        = " Check this blogpost explaining how it works: http://wp.me/p6lgsG-zW#(cr,lf) ",
        Result      = " #(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
