/**
* Combine path infos with selectable separator.
* 
* @name File_CombinedPathInfos
* @categories file, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1
* @example If you use a parameter for your root directory use it like this: Folder.Files(getCombinedPathInfo({dataPath,"CSV"}))
*/ 
(parts as list, optional separator as text) =>
  let
      sep = if separator = null then "\" else separator,
      uncSeparator = sep & sep,
      isUNC = Text.StartsWith(parts{0}, uncSeparator),
      cleanedList = List.ReplaceValue(parts, sep, "", Replacer.ReplaceText),
      combinedPath = List.Accumulate(
          cleanedList,
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