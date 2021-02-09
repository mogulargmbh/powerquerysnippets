/**
 * R script to import text from a pdf file. Returns a table with one row per page
 * by default. Using 1 in the second optional parameter will return one row per
 * line of text instead with matching indices.
 * 
 * @categories pdf
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (pdfSource as text, optional ByPage as number) as table =>
    let
      RunRScript = R.Execute(
        "# 'dataset' holds the input data for this script#(lf)output <- data.frame(pdftools::pdf_text("""
          & pdfSource
          & """))"
      ),
      output = RunRScript{[Name = "output"]}[Value],
      DemoteHeaders = Table.DemoteHeaders(output),
      RemoveOldHeader = Table.Skip(DemoteHeaders, 1),
      AddPageIndex = Table.AddIndexColumn(RemoveOldHeader, "PageIndex", 1, 1),
      TransformTextToRows = Table.TransformColumns(
        AddPageIndex,
        {{"Column1", each List.Transform(Text.Split(_, "#(lf)"), Text.Clean)}}
      ),
      ExpandRows = Table.ExpandListColumn(TransformTextToRows, "Column1"),
      AddRowIndex = Table.AddIndexColumn(ExpandRows, "RowIndex", 1, 1),
      Result = if ByPage = 1 then AddRowIndex else AddPageIndex
    in
      Result,
  documentation = [
    Documentation.Name = " ImportPdfText_R#(cr,lf)",
    Documentation.Description
      = " R script to import text from a pdf file. Returns a table with one row per page.#(cr,lf)",
    Documentation.LongDescription
      = " R script to import text from a pdf file. Returns a table with one row per page by default. Using 1 in the second optional parameter will return one row per line of text instead with matching indices.#(cr,lf)",
    Documentation.Category = " Accessing data functions#(cr,lf)",
    Documentation.Source = " http://wp.me/p6lgsG-M3  .#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {[Description = " #(cr,lf)", Code = " #(cr,lf) ", Result = " #(cr,lf)"]}
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
