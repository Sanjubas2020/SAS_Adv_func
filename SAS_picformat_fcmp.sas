
/*Formats*/
   *formats determine how a column's values are displayed;
    *returns a value unlike call routine;

/*picture format*/*
PROC FORMAT's PICTURE statement to create a custom template to display large numbers, dates, and times;
proc print data= sashelp.class;
run;

proc format;  
     value $ fsex  'M'= 'Male'
	               'F' ='Female'
				   other = 'Miscoded';
     value fage  low -< 13 = 'Pre-Teen'
	             13-<15    = 'Teen'
				 15-high   =  'Adult';
	 run;

proc print data= sashelp.class;
format Sex $fsex. age fage.;   
run;


/*Creating Custom Formats*/
/*Date formating in other ways outside SAS system defined date format*/
/*for example wed -2-jan-2019*/




/*PICTURE statement syntax is similar to the VALUE statement 
You specify a format name and values or ranges to be formatted,
but then you specify a template and options instead of an exact character string. 
The template uses special characters to describe how to display the numeric value.*/



/*Creating Date and Datetime Formats
  custome data and datetime formats
  Format   Display     
  %A       Wednesday
  %a       Wed
  %d       2 or 22 (day of month)
  %0d      02      (two digist)
  %B       January (full month name)
  %3B      Jan      (first three letters)
  %m       1        (month in digit)
  %0m      01        (month in 2 digist with leading zero)
  &y      2020      (four digit year)
  %0y     20        (two last digist of year)
*/

data yes1; 
dob=today(); 
format dob mmddyy.;
run;

proc format;
picture dateh (default=30)
        low-high= '%a.%3B.%0d.%y' (datatype=date); 
		run;

proc print data=yes1;
  format dob dateh.;
  run;

/*Custom Numeric Formats*/


data new1;
input Jobid country $ salary ;
cards;
1001 USA          14000
1002 UK           12000
1003 India        150000000
1004 Japan        500000000
1005 Netherlands  1100000
1006 Poland       12000000
1007 Kenya        900
;
run;

/*digit selectors*/
 *Digit selectors are numeric characters, 0 through 9, that define the positions in the template.
  Nonzero digit selectors display leading zeros, 
  whereas a digit selector of 0 does not print leading zeros.
  The digit 9 is commonly used as the nonzero digit selector;

proc format;
       picture currency (round default=10)
             low -<1000 = '009' (prefix = '$' mult=1)
             10000-<1000000= '009.9k' (prefix = '$' mult=0.01)
			 1000000-high = '009.9m'  (prefix = '$' mult=0.000001);
			 run;


proc print data=new1;
format salary currency.;
run;

/*Use pciture format to put %*/


data statecount;
input state $ count percent;
datalines;
AL 6 1.8987
AR 22 6.9620
CA 1  0.3165
;;
run;


proc format;
    picture mypct (round default=7)
               low-high='009.99%' (mult=100);
	run;

proc print data=statecount;
format percent mypct.;
run;







data new1;
input Jobid salary county$;
cards;
1001 1473.33 USA
1002 1560.00 UK
1003 1646.67 india
1004 1733.33 japan
1005 1820.00 netherlands
1006 1906.67 poland
1007 1933.33 zimbabwe
;
run;

proc format;
       picture  sanj (default=20)
             low -<1500 = '0009' (prefix = '$')
             1500-<1600= '0009' (prefix = '@')
			 1600-<1700= '9999'  (prefix = '#')
			 1700-<1800= '9999'  (prefix = '!')
		     1800-<1900= '9999'  (prefix = 'a')
			 1900-high = '9999'  (prefix = 'b');
			 run;


proc print data=new1;
format salary sanj.;
run;



/*Creating Functions with the FCMP Procedure*/
*cusotm functions simplify programs that use redundant syntax;
*function vs the call routine*returns a value unlike call routine;

data Citytemp;
input Cityname $ Statecode $ TempF;
datalines;
Richmond      VA         85
Rochester     NY         70
Raleigh       NC         80
Myrtle        SC         88
Savanah       GA         90
;
run;

/*lets create a function and save it in our computer*/

libname libref "C:\folder_nmae";

proc fmcp outlib=liberef.table.package;
/*Outlib shoukd be defined and have three level, cert library, table and package*/
function AAXX (arguments $) $ ; /*$ if the argument is character*/
return (expression);/*we return this value*/
endsub;
run;


/*Demo with numerical custom functions*/

libname aaa "C:\SASfcmp";
proc fcmp outlib=aaa.tempfuc.temp;/*fuc table in temp package*/
function FtoC (TempF);
tempc=round((tempf-32)*5/9, 0.1);
return (TempC);
endsub;
run;

/*lets use fucntion*/

options cmplib=aaa.tempfuc;/*request sas to access the fucntion table*/
data citytemp1;
set citytemp;
newTemp=Ftoc(tempF);
run;


data name1;
input name $ 1-19 age;
datalines;
Sanjay Basnet      37
Manira Gautam      72
Anup Bhandari      34  
Ranju Poudel       33
Bijaya Upadhay     37
Susma Dhungana     32
run;

proc fcmp outlib=aaa.functions.temp;
function RevName(name $) $ 40;      /*donot forget the charater $ value in two places*/
return (catx(', ', scan(name,2,' '),scan(name,1,' ')));
endsub;
run;

options cmplib=aaa.functions;
data workact01;
set name1;;
newname=RevName(name);
run;

*Function accepts than one argument
include the arguments in a comma-separated list within the parentheses in the FUNCTION statement. 
For a character argument, place a dollar sign after the argument name;
data Citytemp11;
input Cityname $  Temp Unit$;
datalines;
Richmond     85   F
Rocheste     70   C
Raleigh      80   C
Myrtle       88   F
Savanah      90   c
;
run;


libname aaa "C:\SASfcmp";

proc fcmp outlib=aaa.twoarg.temp;
  function CFtemp (Temp, Unit $);
  if upcase (Unit)= 'F' then NewTemp =round ((temp-32)*5/9, 0.01);
  else if upcase (Unit)= 'C' then NewTemp =round (temp*9/5 + 32, 0.01);
  return (NewTemp);
  endsub;
 run;

options cmplib=aaa.twoarg;
data citytemp22;
set citytemp11;
newTemp=CFtemp(Temp, Unit);
run;

/*It can also accept three arguments give a try later*/