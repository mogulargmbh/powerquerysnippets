/**
 * Blends table data like in Tableau. See:
 * http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/
 * 
 * @categories table
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (
    PrimaryTable as table,
    SecondaryTable as table,
    KeyColumnsPrimaryTable as list,
    KeyColumnsSecondaryTable as list,
    ValueColumns as list
  ) =>
    let
      // Rename key columns from secondary table to names from primary table
      RenamedSec = Table.RenameColumns(
        SecondaryTable,
        List.Zip({KeyColumnsSecondaryTable, KeyColumnsPrimaryTable})
      ),
      // Fetch row who don't have a match in primary table and need to be appended
      JoinForRowsOnlyInSec = Table.NestedJoin(
        PrimaryTable,
        KeyColumnsPrimaryTable,
        RenamedSec,
        KeyColumnsPrimaryTable,
        "NewColumn",
        JoinKind.RightAnti
      ),
      // Select relevant columns from rows to be appended
      OnlySec = Table.SelectColumns(
        JoinForRowsOnlyInSec[NewColumn]{0},
        List.Union({KeyColumnsPrimaryTable, ValueColumns})
      ),
      // Add rows to primary table
      AppendToPrim = Table.Combine(
        {PrimaryTable, Table.SelectColumns(OnlySec, KeyColumnsPrimaryTable)}
      ),
      // Merge new primary table with secondary table
      MergeWithSec = Table.NestedJoin(
        AppendToPrim,
        KeyColumnsPrimaryTable,
        RenamedSec,
        KeyColumnsPrimaryTable,
        "NewColumn",
        JoinKind.LeftOuter
      ),
      // Expand the additional columns
      #"Expanded NewColumn" = Table.ExpandTableColumn(MergeWithSec, "NewColumn", ValueColumns)
    in
      #"Expanded NewColumn",
  documentation = [
    Documentation.Name = " Table.BlendDataTableau#(cr,lf)",
    Documentation.Description = " Blends table data like in Tableau.#(cr,lf)",
    Documentation.LongDescription
      = " Blends table data like in Tableau. See: http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/#(cr,lf)",
    Documentation.Category = " Table#(cr,lf)",
    Documentation.Source
      = " http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {
      [
        Description
          = " http://www.thebiccountant.com/2017/02/23/blending-data-in-powerbi-like-in-tableau/#(cr,lf)",
        Code = " #(cr,lf) ",
        Result = " #(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
