/**
 * no description available
 * 
 * @categories table, markdown, conversion
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
// Transforms a table into markdown syntax
(Table as table) =>
  let
    Source = Table,
    TableValues = Table.AddColumn(Source, "Custom", each Text.Combine(Record.FieldValues(_), " | ")),
    HyphenLine = Text.Combine(
      List.Transform(Table.ColumnNames(Source), each Text.Repeat("-", Text.Length(_))),
      " | "
    ),
    CombineList = List.Combine(
      {{Text.Combine(Table.ColumnNames(Source), " | ")}, {HyphenLine}, TableValues[Custom]}
    ),
    TransferToMarkdown = Text.Combine(CombineList, "#(lf)")
  in
    TransferToMarkdown
