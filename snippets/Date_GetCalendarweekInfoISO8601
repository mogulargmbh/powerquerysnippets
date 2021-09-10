/**
* Returns the weeknumber and year as defined in ISO 8601
* 
* @name Date_GetCalendarweekInfoISO8601
* @categories Date, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210910-1

*/ 

(myDate as nullable date) =>
         let
            internalFunc = () =>
               let
                  weekdayNo = Date.DayOfWeek(myDate, Day.Monday) + 1, 
                  isoWeekYear = Date.Year(Date.AddDays(myDate, 4 - weekdayNo)), 
                  IsoWeekNrCol = (
                     Duration.Days(
                        Date.AddDays(myDate, 4 - weekdayNo)
                           - #date(isoWeekYear, 1, 7 - Date.DayOfWeek(#date(isoWeekYear, 1, 4), Day.Monday))
                     )
                        / 7
                  )
                     + 1, 
                  yearOfWeek = 
                     if IsoWeekNrCol >= 52 and Date.Month(myDate) = 1 then
                        Date.Year(myDate) - 1
                     else if IsoWeekNrCol = 1 and Date.Month(myDate)=12 then
                        Date.Year(myDate) + 1
                     else
                        Date.Year(myDate), 
                  isoWeekInfo = [weekNoISO8601 = IsoWeekNrCol, yearOfWeekNoISO8601 = yearOfWeek]
               in
                  isoWeekInfo, 
            result = if myDate = null then null else internalFunc()
         in
            result
