/**
* Normalizes a datetime value to the specified part.
* 
* @name geDateTimeNumeric
* @categories DateTime, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1
* @example getDateTimeNormalized(#date(2021,1,1,8,21,34),"minutes", 15) = 01.01.2021 08:15:00
*/ 

let
  func = (dtValue as datetime, partToNormalize as text, normalizeTo as number)=>
  let
    Map = #table(
      {"PartType", "func"}, 
      {
        {
          "seconds", 
          ()=> let
            sec = Time.Second(dtValue),
            newPart = Number.IntegerDivide(sec,normalizeTo) * normalizeTo,
            res = if normalizeTo > 59 then error "if using seconds state a value between 0 and 59 as normalizeTo" else dtValue + #duration(0,0,0, newPart - sec)
          in
            res
        }, 
        {
          "minutes",  
          ()=> let
            sec = Time.Second(dtValue),
            min = Time.Minute(dtValue),
            newPart = Number.IntegerDivide(min,normalizeTo)  * normalizeTo,
            res = if normalizeTo > 59 then error "if using minutes state a value between 0 and 59 as normalizeTo" else dtValue + #duration(0,0, newPart - min,-sec)
          in
            res
        }, 
        {
          "hours", 
          ()=> let
            sec = Time.Second(dtValue),
            min = Time.Minute(dtValue),
            h = Time.Hour(dtValue),
            newPart = Number.IntegerDivide(h,normalizeTo) * normalizeTo,
            res = if normalizeTo > 23 then error "if using hours state a value beteween 0 and 23 as normalizeTo" else dtValue + #duration(0, newPart - h,-min,-sec)
          in
            res
        } 
      }),
      f = Table.SelectRows(Map, (row) => Text.Upper(row[PartType]) = Text.Upper(partToNormalize)),
      return = if Table.RowCount(f) = 0 then error "Use (seconds, minutes, hours) only for partToNormalize!" else f{0}[func]()
  in
    return,

  fnMetaInfo = type function(
    dtValue as datetime, 
    partToNormalize as (type text meta [Documentation.AllowedValues={"hours","minutes","seconds"}]), 
    normalizeTo as number
  )
  as list meta
    [
      Documentation.Name = "getDateTimeNormalized",
      Documentation.LongDescription="Normalizes a datetime value to the specified part using parts in (seconds,minutes,hours)",
      Documentation.Examples = {
        [
          Description = "Normalize to 30 seconds",
          Code = "getDateTimeNormalized(#date(2021,1,1,8,21,34),""seconds"", 30)",
          Result="01.01.2021 08:21:30"
        ],
        [
          Description = "Normalize to 15 minutes",
          Code = "getDateTimeNormalized(#date(2021,1,1,8,21,34),""minutes"", 15)",
          Result="01.01.2021 08:15:00"
        ]
      }
    ]

in
  Value.ReplaceType(func, fnMetaInfo)
