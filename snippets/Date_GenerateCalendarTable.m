/**
* Creates a calendar table in power query.
* 
* @name Date_GenerateCalendarTable
* @categories date, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-3
* @example if you omit startDate/endDate the table starts 3 years before today until last day of current year
*/
(startDate as nullable date, endDate as nullable date) =>
   let
      
    // ISO 8601 Kalenderwoche bestimmen
    getISOCalendarWeekInfo = (myDate as nullable date) =>
      let
        internalFunc = () =>
          let
            weekdayNo = Date.DayOfWeek(myDate, Day.Monday) + 1,
            isoWeekYear = Date.Year(Date.AddDays(myDate, 4 - weekdayNo)),
            IsoWeekNrCol = (
              Duration.Days(
                Date.AddDays(myDate, 4 - weekdayNo)
                  - #date(isoWeekYear, 1, 7 - Date.DayOfWeek(#date(isoWeekYear, 1, 4), Day.Monday))
              )
                / 7
            )
              + 1,
            yearOfWeek = 
              if IsoWeekNrCol >= 52 and Date.Month(myDate) = 1 then
                Date.Year(myDate) - 1
              else if IsoWeekNrCol = 1 and Date.Month(myDate) = 12 then
                Date.Year(myDate) + 1
              else
                Date.Year(myDate),
            isoWeekInfo = [weekNoISO8601 = IsoWeekNrCol, yearOfWeekNoISO8601 = yearOfWeek]
          in
            isoWeekInfo,
        result = if myDate = null then null else internalFunc()
      in
        result,


    // KW Index erzeuen
    createWeekIndex = (t as table) =>
    let
        #"Andere entfernte Spalten" = Table.SelectColumns(t,{"YYYY/WW ISO8601"}),
        #"Entfernte Duplikate" = Table.Distinct(#"Andere entfernte Spalten"),
        #"Hinzugefügter Index" = Table.AddIndexColumn(#"Entfernte Duplikate", "KW Index", 0, 1, Int64.Type),
        join = Table.NestedJoin(t, {"YYYY/WW ISO8601"}, #"Hinzugefügter Index", {"YYYY/WW ISO8601"}, "joinColumns", JoinKind.LeftOuter),
        #"expanded" = Table.ExpandTableColumn(join, "joinColumns", {"KW Index"}, {"KW Index"})
    in
        #"expanded",

    currentYear = Date.Year(DateTime.Date(DateTime.FixedLocalNow())),
    sd = if startDate = null then #date(currentYear - 3, 1, 1) else startDate,
    ed = if endDate = null then #date(currentYear, 12, 31) else endDate,
    #"Anzahl Tage" = Duration.Days(ed - sd) + 1,
    Quelle = List.Dates(sd, #"Anzahl Tage", #duration(1, 0, 0, 0)),
    #"In Tabelle konvertiert" = Table.FromList(
      Quelle,
      Splitter.SplitByNothing(),
      null,
      null,
      ExtraValues.Error
    ),
    #"Umbenannte Spalten" = Table.RenameColumns(#"In Tabelle konvertiert", {{"Column1", "Datum"}}),
    #"Geänderter Typ" = Table.TransformColumnTypes(#"Umbenannte Spalten", {{"Datum", type date}}),
    #"Add Jahr" = Table.AddColumn(#"Geänderter Typ", "Jahr", each Date.Year([Datum])),
    #"Add Monat" = Table.AddColumn(#"Add Jahr", "Monat", each Date.Month([Datum])),
    #"Add Monatsname" = Table.AddColumn(
      #"Add Monat",
      "Monatsname",
      each Date.ToText([Datum], "MMMM")
    ),
    #"Add MonatsnameKurz" = Table.AddColumn(
      #"Add Monatsname",
      "Monatsname kurz",
      each Date.ToText([Datum], "MMM")
    ),
    #"Add YYYYMM" = Table.AddColumn(
      #"Add MonatsnameKurz",
      "YYYYMM",
      each Number.ToText([Jahr]) & Date.ToText([Datum], "MM")
    ),
    #"Add YYYY/MMMM" = Table.AddColumn(
      #"Add YYYYMM",
      "YYYY/MMMM",
      each Number.ToText([Jahr]) & "/" & [Monatsname]
    ),
    #"Add YYYY/MMM" = Table.AddColumn(
      #"Add YYYY/MMMM",
      "YYYY/MMM",
      each Number.ToText([Jahr]) & "/" & [Monatsname kurz]
    ),
    #"Add Quartal" = Table.AddColumn(#"Add YYYY/MMM", "Quartal", each Date.QuarterOfYear([Datum])),
    #"Add Quartalname" = Table.AddColumn(
      #"Add Quartal",
      "Quartalname",
      each "Q" & Number.ToText([Quartal])
    ),
    #"Add YYYYQ" = Table.AddColumn(
      #"Add Quartalname",
      "YYYYQ",
      each Number.ToText([Jahr]) & Number.ToText([Quartal])
    ),
    #"Add YYYY/Q" = Table.AddColumn(
      #"Add YYYYQ",
      "YYYY/Q",
      each Number.ToText([Jahr]) & "/" & [Quartalname]
    ),
    #"Add KW ISO 8601" = Table.AddColumn(
      #"Add YYYY/Q",
      "KW ISO8601",
      each getISOCalendarWeekInfo([Datum])[weekNoISO8601]
    ),
    #"Add Jahr KW ISO 8601" = Table.AddColumn(
      #"Add KW ISO 8601",
      "Jahr KW ISO8601",
      each getISOCalendarWeekInfo([Datum])[yearOfWeekNoISO8601]
    ),
    #"Add KWName" = Table.AddColumn(
      #"Add Jahr KW ISO 8601",
      "KW Name",
      each "KW" & Text.PadStart(Text.From([KW ISO8601]), 2, "0")
    ),
    #"Add YYYY/WW ISO 8601" = Table.AddColumn(
      #"Add KWName",
      "YYYY/WW ISO8601",
      each Text.From([Jahr KW ISO8601]) & "/" & Text.PadStart(Text.From([KW ISO8601]), 2, "0")
    ),

    #"AddKWIndex" = createWeekIndex(#"Add YYYY/WW ISO 8601"),

    #"Add Wochentag" = Table.AddColumn(
      #"AddKWIndex",
      "Wochentag",
      each Date.DayOfWeek([Datum], Day.Monday)
    ),
    #"Add WochentagName" = Table.AddColumn(
      #"Add Wochentag",
      "Wochentag Name",
      each Date.DayOfWeekName([Datum])
    ),
    #"Add WochentagNameKurz" = Table.AddColumn(
      #"Add WochentagName",
      "Wochentag Name kurz",
      each Date.ToText([Datum], "ddd")
    ),
    #"Add Day of Month" = Table.AddColumn(
      #"Add WochentagNameKurz",
      "Tag im Monat",
      each Date.Day([Datum])
    ),
    #"Add Day of Year" = Table.AddColumn(
      #"Add Day of Month",
      "Tag im Jahr",
      each Date.DayOfYear([Datum])
    ),
    #"Add Is Leap Year" = Table.AddColumn(
      #"Add Day of Year",
      "Ist Schaltjahr",
      each Date.IsLeapYear([Datum])
    ),
    #"Geänderter Typ1" = Table.TransformColumnTypes(
      #"Add Is Leap Year",
      {
        {"Jahr", Int64.Type},
        {"Monat", Int64.Type},
        {"Monatsname", type text},
        {"Monatsname kurz", type text},
        {"YYYYMM", Int64.Type},
        {"YYYY/MMMM", type text},
        {"YYYY/MMM", type text},
        {"Quartal", Int64.Type},
        {"Quartalname", type text},
        {"YYYYQ", Int64.Type},
        {"YYYY/Q", type text},
        {"KW ISO8601", Int64.Type},
        {"Jahr KW ISO8601", Int64.Type},
        {"Wochentag", Int64.Type},
        {"Wochentag Name", type text},
        {"Wochentag Name kurz", type text},
        {"Tag im Monat", Int64.Type},
        {"Tag im Jahr", Int64.Type},
        {"Ist Schaltjahr", type logical},
        {"KW Name", type text},
        {"YYYY/WW ISO8601", type text}
      }
    )
  in
    #"Geänderter Typ1"
