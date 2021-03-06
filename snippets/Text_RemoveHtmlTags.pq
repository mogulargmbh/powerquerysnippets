/**
 * Removes all Html tags from a text
 * 
 * @categories html, text
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (HTML) =>
    let
      Check         = if Value.Is(Value.FromText(HTML), type text) then HTML else "",
      Source        = Text.From(Check),
      SplitAny      = Text.SplitAny(Source, "<>"),
      ListAlternate = List.Alternate(SplitAny, 1, 1, 1),
      ListSelect    = List.Select(ListAlternate, each _ <> ""),
      TextCombine   = Text.Combine(ListSelect, "")
    in
      TextCombine,
  documentation = [
    Documentation.Name = " Text.RemoveHtmlTags",
    Documentation.Description = "Remove Html Tags",
    Documentation.LongDescription = " Removes all Html tags from a text",
    Documentation.Category = " Text.Modification",
    Documentation.Source = " Inspired by a solution from Bill Szysz",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com & Mike Carlo: PowerBI.Tips",
    Documentation.Examples = {
      [
        Description = "Function that enables one to pass in a column that has HTML tags.",
        Code        = "<div>my bit of text</div>",
        Result      = "my bit of text "
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
