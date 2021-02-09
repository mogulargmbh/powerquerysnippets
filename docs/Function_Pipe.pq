/**
 * Allows to use piping-syntax:
 * http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/
 * 
 * @categories function
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (x, operations) =>
    List.Accumulate(
      operations,
      x,
      (state, current) => Function.Invoke(current{0}, {state} & List.Skip(current))
    ),
  documentation = [
    Documentation.Name = " Syntax.Pipe#(cr,lf)",
    Documentation.Description = " Allows to use piping-syntax. #(cr,lf)",
    Documentation.LongDescription
      = " Allows to use piping-syntax: http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/#(cr,lf)",
    Documentation.Category = " Documentation#(cr,lf)",
    Documentation.Source = "  http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/ .#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
