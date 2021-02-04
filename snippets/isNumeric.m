
/**
* Check if the value is numeric.
* 
* @name isNumeric
* @categories datatype, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1
* @example isNumeric("Hallo") is false, isNumeric(23) is true
*/ 
(value2Check) => 
try Value.Is(Number.From(value2Check), type number) otherwise false
