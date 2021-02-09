/**
 * Extract M-code from Excel- or Power BI files, see:
 * http://www.thebiccountant.com/2017/10/15/bulk-extracting-power-query-m-code-from-multiple-pbix-files-in-power-bi/
 * 
 * @categories mcode
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  func = (Filename as text) =>
    let
      // Unz-function from: https://querypower.com/2017/03/22/extracting-power-queries-in-m/
      Unz = (binaryZip, fileName) =>
        let
          //shorthand
          UInt32 = BinaryFormat.ByteOrder(BinaryFormat.UnsignedInteger32, ByteOrder.LittleEndian),
          UInt16 = BinaryFormat.ByteOrder(BinaryFormat.UnsignedInteger16, ByteOrder.LittleEndian),
          //ZIP file header fixed size structure
          Header = BinaryFormat.Record(
            [
              MiscHeader       = BinaryFormat.Binary(14),
              CompressedSize   = UInt32,
              UncompressedSize = UInt32,
              FileNameLen      = UInt16,
              ExtraFieldLen    = UInt16
            ]
          ),
          //ZIP file header dynamic size structure
          FileData = (h) =>
            BinaryFormat.Record(
              [
                FileName = BinaryFormat.Text(h[FileNameLen]),
                ExtraField = BinaryFormat.Text(h[ExtraFieldLen]),
                UncompressedData = BinaryFormat.Transform(
                  BinaryFormat.Binary(h[CompressedSize]),
                  (x) => try Binary.Buffer(Binary.Decompress(x, Compression.Deflate)) otherwise null
                )
              ]
            ),
          //Parsing the binary in search for PKZIP header signature
          ZipIterator = BinaryFormat.Choice(
            UInt32,
            (signature) =>
              if signature <> 0x04034B50 then
                BinaryFormat.Record([FileName = null])
              else
                BinaryFormat.Choice(Header, (z) => FileData(z))
          ),
          ZipFormat = BinaryFormat.List(ZipIterator),
          out = List.Select(ZipFormat(binaryZip), each _[FileName] = fileName)
        in
          out{0}[UncompressedData],
      Source = Unz(Unz(File.Contents(Filename), "DataMashup"), "Formulas/Section1.m"),
      Custom1 = Lines.FromBinary(Source),
      #"Converted to Table" = Table.FromList(
        Custom1,
        Splitter.SplitByNothing(),
        null,
        null,
        ExtraValues.Error
      )
    in
      #"Converted to Table",
  documentation = [
    Documentation.Name = " AccessingData.MCodeFromFiles#(cr,lf)",
    Documentation.Description = " Extract M-code from Excel- or Power BI files#(cr,lf)",
    Documentation.LongDescription
      = " Extract M-code from Excel- or Power BI files, see: http://www.thebiccountant.com/2017/10/15/bulk-extracting-power-query-m-code-from-multiple-pbix-files-in-power-bi/ .#(cr,lf)",
    Documentation.Category = " Accessing Data#(cr,lf)",
    Documentation.Source
      = " http://www.thebiccountant.com/2017/10/15/bulk-extracting-power-query-m-code-from-multiple-pbix-files-in-power-bi/ .#(cr,lf)",
    Documentation.Author = " Imke Feldmann: www.TheBIccountant.com .#(cr,lf)",
    Documentation.Examples = {
      [
        Description
          = " http://www.thebiccountant.com/2017/10/15/bulk-extracting-power-query-m-code-from-multiple-pbix-files-in-power-bi/ .#(cr,lf)",
        Code = " #(cr,lf) ",
        Result = " #(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(func, Value.ReplaceMetadata(Value.Type(func), documentation))
