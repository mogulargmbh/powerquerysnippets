
/**
 * Returns the second argument for Table.RenameColumns to 
 * rename a table with a given list of standard column names.
 * @author https://github.com/acanepas
 * @source https://github.com/acanepas/ColumnStandardizer
 * @license MIT (c) 2022 Angelo Canepa
 * @version 2022-09-06-1
 */
let
  Source = (
    column_names as list, 
    standard_column_names as list, 
    optional score as nullable number, 
    optional symbol_list as nullable list
  ) as list =>
    ////////////////////////////////////////////////////////////
    //                Functions Defitinions
    ///////////////////////////////////////////////////////////
    let
      /* 
    Function: GetTextSimilarity
    Description:Define a text similarity function between two strings. 
    Arguments:
        1. col_one: Original column name to be compared. Example: "date.month"
        2. col_two: New Target column name. Example: "date month"
        3. symbol_list: List of symbols to consider to exclude from column names. Example: {".","-"}
     */
      GetTextSimilarity = (col_one as text, col_two as text, optional symbol_list as list) as number =>
        let
        default_symbols = {".","/","_","-"," ","\"},
          col_one_clean = 
            if symbol_list <> null then
              Text.Remove(col_one, symbol_list)
            else
              Text.Remove(col_one, default_symbols), 
          col_two_clean = 
            if symbol_list <> null then
              Text.Remove(col_two, symbol_list)
            else
              Text.Remove(col_two, default_symbols), 
          Records = [
            ColumnNameOne = Text.Lower(col_one_clean), 
            ColumnNameTwo = Text.Lower(col_two_clean)
          ], 
          ToTable = Record.ToTable(Records), 
          Pivoted = Table.Pivot(ToTable, List.Distinct(ToTable[Name]), "Name", "Value"), 
          LengthColOne = Text.Length(Text.Remove(Pivoted[ColumnNameOne]{0}, " ")), 
          LengthColTwo = Text.Length(Text.Remove(Pivoted[ColumnNameTwo]{0}, " ")), 
          ListCol = Table.AddColumn(
            Pivoted, 
            "ListFirstCol", 
            each Text.ToList(Text.Remove([ColumnNameOne], " "))
          ), 
          ExpandList = Table.ExpandListColumn(ListCol, "ListFirstCol"), 
          AddIndex = Table.AddIndexColumn(ExpandList, "Index", 0, 1, Int64.Type), 
          IndexedCol = Table.AddColumn(
            AddIndex, 
            "IndexCol", 
            each 
              if ([Index] + 1) > LengthColTwo then
                null
              else
                Text.ToList(Text.Remove(Text.Lower([ColumnNameTwo]), " ")){[Index]}
          ), 
          IndexedColLag = Table.AddColumn(
            IndexedCol, 
            "IndexedColLag", 
            each 
              if ([Index]) > LengthColTwo or ([Index] - 1) < 0 then
                null
              else
                Text.ToList(Text.Remove(Text.Lower([ColumnNameTwo]), " ")){[Index] - 1}
          ), 
          IndexedColLead = Table.AddColumn(
            IndexedColLag, 
            "IndexedColLead", 
            each 
              if ([Index] + 2) > LengthColTwo then
                null
              else
                Text.ToList(Text.Remove(Text.Lower([ColumnNameTwo]), " ")){[Index] + 1}
          ), 
          GetScore = Table.AddColumn(
            IndexedColLead, 
            "Score", 
            each 
              if [ListFirstCol] = [IndexCol] then
                1
              else if [ListFirstCol] = [IndexedColLag] then
                1
              else if [ListFirstCol] = [IndexedColLead] then
                1
              else
                0
          ), 
          TotalScoreAmount = List.Sum(GetScore[Score]), 
          ScorePercentage = Value.Divide(TotalScoreAmount, LengthColOne)
        in
          ScorePercentage, 
      /*
    Function: GetColumnScore
    Description: From a given column index, compares the original column names against a standard.
    Arguments:
      1. column_index: The column position.
      2. Column_names: List of column names to be replaced.
      3. Standard Column Names: List of columns set as standard.
    */
      GetColumnScore = (
        column_index as number, 
        column_names as list, 
        standard_column_names as list, 
        optional symbol_list as list
      ) =>
        let
          Source = List.Generate(
            () => 0, 
            each _ <= (List.Count(standard_column_names) - 1), 
            each _ + 1, 
            each GetTextSimilarity(
              standard_column_names{_}, 
              column_names{column_index}, 
              symbol_list
            )
          ), 
          #"Converted to Table" = Table.FromList(
            Source, 
            Splitter.SplitByNothing(), 
            {"Score"}, 
            null, 
            ExtraValues.Error
          ), 
          #"Added Index" = Table.AddIndexColumn(#"Converted to Table", "Index", 0, 1, Int64.Type), 
          MaxVal = List.Max(#"Converted to Table"[Score]), 
          Step2 = Table.SelectRows(#"Added Index", each [Score] = MaxVal), 
          #"Added Custom" = Table.AddColumn(
            Step2, 
            "StandardColName", 
            each standard_column_names{[Index]}
          ), 
          #"Removed Columns" = Table.RemoveColumns(#"Added Custom", {"Index"}){0}
        in
          #"Removed Columns", 
      ////////////////////////////////////////////////////////////
      //                Main Function Operation
      ///////////////////////////////////////////////////////////
      score = if score = null then 0.85 else score, 
      ColumnList = List.Generate(
        () => 0, 
        each _ <= (List.Count(column_names) - 1), 
        each _ + 1, 
        each GetColumnScore(_, column_names, standard_column_names, symbol_list)
      ), 
      #"Converted to Table" = Table.FromList(
        ColumnList, 
        Splitter.SplitByNothing(), 
        null, 
        null, 
        ExtraValues.Error
      ), 
      #"Expanded Column1" = Table.ExpandRecordColumn(
        #"Converted to Table", 
        "Column1", 
        {"Score", "StandardColName"}, 
        {"Column1.Score", "Column1.StandardColName"}
      ), 
      #"Added Index" = Table.AddIndexColumn(#"Expanded Column1", "Index", 0, 1, Int64.Type), 
      #"Added Custom" = Table.AddColumn(#"Added Index", "OriginalCol", each column_names{[Index]}), 
      #"Filtered Rows" = Table.SelectRows(#"Added Custom", each [Column1.Score] >= score), 
      #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows", {"Column1.Score", "Index"}), 
      #"Reordered Columns" = Table.ReorderColumns(
        #"Removed Columns", 
        {"OriginalCol", "Column1.StandardColName"}
      ), 
      Rename_list = Table.ToColumns(Table.Transpose(#"Reordered Columns"))
    in
      Rename_list, 
  documentation = [
    Documentation.Name = "Column Standardizer", 
    Documentation.Description
      = "Power Query function that helps standardize column names from a given table and a given list of standard column names.", 
    Documentation.Author = "Angelo Canepa (www.simplebi.uk)", 
    Documentation.Examples = {
      [
        Description = "Example Code", 
        Code
          = "RetrieveCanonicalNames({""Date.Month"",""SalesAmount"",""Profit""},{""Sales Amount"", ""Date Month""})", 
        Result = "{{""Date.Month"",""Date Month""},{""SalesAmount"",""Sales Amount""}}"
      ]
    }
  ]
in
  Value.ReplaceType(Source, Value.ReplaceMetadata(Value.Type(Source), documentation))
