/**
 * Buffered Table.Sort. Buffers the result to maintain the sort order in future
 * referencing steps
 * 
 * @categories table, sort
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (table as table, optional comparisonCriteria as any) =>
    Table.Buffer(Table.Sort(table, comparisonCriteria)),
  documentation = [
    Documentation.Name = " Table.SortB.pq#(cr,lf)",
    Documentation.Description = " Buffered Table.Sort#(cr,lf)",
    Documentation.LongDescription
      = " Buffered Table.Sort. Buffers the result to maintain the sort order in future referencing steps#(cr,lf)",
    Documentation.Category = " Table Transformation#(cr,lf)",
    Documentation.Source = " local#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
