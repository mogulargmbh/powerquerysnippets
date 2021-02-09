/**
 * Replaces multiple values at a time in a table column without recursion:
 * http://www.thebiccountant.com/2016/05/22/multiple-replacements-in-power-bi-and-power-query/
 * The <code>ReplacementsTable </code> must have the values to be replaced in the
 * 1st column and the new value in the 2nd.
 * 
 * @categories table
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2.0
 */
let
  func = (
    TableWithTextColumn as table,
    ColumnNameTextToReplace as text,
    ReplacementsTable as table,
    ColumnNameWordToReplace as text,
    ColumnNameReplaceWith as text
  ) =>
    let
      Source = ReplacementsTable,
      CreateListOfLists = Table.AddColumn(
        Source,
        "Liste",
        each ({Record.Field(_, ColumnNameWordToReplace), Record.Field(_, ColumnNameReplaceWith)})
      ),
      Text = TableWithTextColumn,
      TurnTextToList = Table.AddColumn(
        Text,
        "Custom",
        each Text.Split(Record.Field(_, ColumnNameTextToReplace), " ")
      ),
      Replacements = Table.AddColumn(
        TurnTextToList,
        "Changed Text Expected",
        each Text.Combine(List.ReplaceMatchingItems([Custom], CreateListOfLists[Liste]), " ")
      ),
      Cleanup = Table.RemoveColumns(Replacements, {"Custom", "Text"})
    in
      Cleanup,
  documentation = [
    Documentation.Name = " Table.ReplaceMultiple.pq ",
    Documentation.Description
      = " Replaces multiple values at a time in a table column without recursion. ",
    Documentation.LongDescription
      = "  Replaces multiple values at a time in a table column without recursion: http://www.thebiccountant.com/2016/05/22/multiple-replacements-in-power-bi-and-power-query/ The <code>ReplacementsTable </code> must have the values to be replaced in the 1st column and the new value in the 2nd. ",
    Documentation.Category = " Table.ColumnOperations ",
    Documentation.Source
      = " http://www.thebiccountant.com/2016/05/22/multiple-replacements-in-power-bi-and-power-query/ . ",
    Documentation.Version = " 2.0 ",
    Documentation.Author = " Imke Feldmann ",
    Documentation.Examples = {
      [
        Description = "  ",
        Code
          = " let #(cr,lf)    TableWithText = #table( {""Text""}, List.Zip( { {""the cat sat on the mat"" ,""the cat sat next to the dog"" ,""the dog chased the cat"" ,""the dog sat on the mat"" ,""the catamaran sails through the air""} } ) ), #(cr,lf)    ReplacementsTable = #table( {""Word To Replace"", ""Replace With""}, List.Zip( { {""cat"" ,""mat"" ,""dog"" ,""the"" ,""air""}, {""bear"" ,""chair"" ,""dragon"" ,""THE"" ,""water""} } ) ),#(cr,lf)// The query containing the function has to be called ""fnTable_ReplaceMultiple_pq""#(cr,lf)    Result = fnTable_ReplaceMultiple_pq ( TableWithText , ""Text"", ReplacementsTable, ""Word To Replace"", ""Replace With"" ) #(cr,lf)in #(cr,lf)    Result ",
        Result
          = " Changed Text Expected#(cr,lf)---------------------#(cr,lf)THE bear sat on THE chair#(cr,lf)THE bear sat next to THE dragon#(cr,lf)THE dragon chased THE bear#(cr,lf)THE dragon sat on THE chair#(cr,lf)THE catamaran sails through THE water "
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
