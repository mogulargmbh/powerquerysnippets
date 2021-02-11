/**
* Converts an epoch date to date. 
* 
* @name Date_fromEpoch
* @categories file, 
* @license MIT (c) 2021 mogular
* @author https://github.com/mogulargmbh
* @version 20210121-1

*/ 

(epochTS as number) as datetime=>
let
    res = #datetime(1970,1,1,0,0,0) + #duration(0,0,0,epochTS)
in
    res
