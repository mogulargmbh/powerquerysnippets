/**
* Combine path infos with selectable separator.
* 
* @name File_CombinePathInfos
* @categories file, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1
* @example If you use a parameter for your root directory use it like this: Folder.Files(getCombinedPathInfo({dataPath,"CSV"}))
*/ 
(parts as list, optional separator as text) =>
  let
      sep = if (separator = null or separator ="") then "\" else separator,
      uncSeparator = sep & sep,
      isUNC = Text.StartsWith(parts{0}, uncSeparator),
      partsTable = Table.FromList(parts),
      partsTableSplitted = Table.ExpandListColumn(
        Table.TransformColumns(
            partsTable, 
                {{"Column1", Splitter.SplitTextByDelimiter(sep, QuoteStyle.None), 
                let itemType = (type nullable text) meta [Serialized.Text = true] in type {itemType}}}
            ), "Column1"
        ),
      combinedPath = List.Accumulate(
          partsTableSplitted[Column1],
          "",
          (state, current) => 
          let
              result = if state = "" then current else state & sep & current
          in
              result
      ),
      combinedPathUNC = if isUNC then uncSeparator & combinedPath else combinedPath
  in
      combinedPathUNC
