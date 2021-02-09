/**
 * simple Number.Mod that returns the same like Excel or DAX when negative
 * figures are involved
 * 
 * @categories number, excel
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (number, divisor) =>
    if number > 0 then
      number - Number.RoundDown(number / divisor, 0)
    else
      Number.Abs(divisor) + number,
  documentation = [
    Documentation.Name = " fnNumber.ModXls.pq#(cr,lf)",
    Documentation.Description
      = " simple Number.Mod that returns the same like Excel or DAX when negative figures are involved#(cr,lf)",
    Documentation.LongDescription
      = " simple Number.Mod that returns the same like Excel or DAX when negative figures are involved#(cr,lf)",
    Documentation.Category = " Number.Operations#(cr,lf)",
    Documentation.Source = " local#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com#(cr,lf)",
    Documentation.Examples = {
      [Description = " (number, divisor) #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
