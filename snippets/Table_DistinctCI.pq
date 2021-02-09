/**
 * Case insensitive Table.Distinct
 * 
 * @categories table
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (table as table, optional equationCriteria as any) =>
    let
      equationCriteriaNew = 
        if equationCriteria = null then
          Comparer.OrdinalIgnoreCase
        else
          List.Transform(equationCriteria, each {_, Comparer.OrdinalIgnoreCase}),
      TableDistinctCaseInsensitive = Table.Distinct(table, equationCriteriaNew)
    in
      TableDistinctCaseInsensitive,
  documentation = [
    Documentation.Name            = " Table.DistinctCI.pq#(cr,lf)",
    Documentation.Description     = " Case insensitive Table.Distinct#(cr,lf)",
    Documentation.LongDescription = " Case insensitive Table.Distinct#(cr,lf)",
    Documentation.Category        = " Table Transformation#(cr,lf)",
    Documentation.Source          = " local#(cr,lf)",
    Documentation.Author          = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples        = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
