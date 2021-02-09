/**
* returns the date of N days ago from Today
*
* @categories date 
* @license MIT (c) 2014 tycho01
* @author https://github.com/KiaraGrouwstra/pquery
* @version 20210121-1
*/ 
(N as number) => 
	Date.AddDays(DateTime.FixedLocalNow(), -N)