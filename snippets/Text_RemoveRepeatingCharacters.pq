/**
 * Removes repeating characters of the delimiter from a string
 * 
 * @categories text
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 1_2 : Fixed bug for delimiter at the last position
 */
let
  func = (Text as text, Delimiter as text) as text =>
    let
      TextToList = List.Buffer(Text.Split(Text, Delimiter)),
      FilterList = List.Select(TextToList, each _ <> ""),
      Result = 
        if Text.End(Text, 1) = Delimiter then
          Text.Combine(FilterList, Delimiter) & Delimiter
        else
          Text.Combine(FilterList, Delimiter)
    in
      Result,
  documentation = [
    Documentation.Name = " Text.RemoveRepeatingCharacters#(cr,lf)",
    Documentation.Description = " Removes repeating characters of the delimiter from a string#(cr,lf)",
    Documentation.LongDescription = " Removes repeating characters of the delimiter from a string#(cr,lf)",
    Documentation.Category = " Text Modification#(cr,lf)",
    Documentation.Source = " http://wp.me/p6lgsG-M9  .#(cr,lf)",
    Documentation.Version = "1.2: Fixed bug for delimiter at the last position#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {
      [
        Description = " Removes repeating characters of the delimiter from a string#(cr,lf)",
        Code        = " RemoveRepeatingCharacters(""Imke      Feldmann"", "" "")#(cr,lf) ",
        Result      = " ""Imke Feldmann""#(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
