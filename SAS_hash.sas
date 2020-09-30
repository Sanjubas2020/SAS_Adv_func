
/*HASH Objects Hash objects Hash objects*/

  *Hash object (hash tables) is in-memory table that contains key and data components;
   *must have at least one key component, but multiple key components are supported;
    * each key must be a column in the program data vector;
    *Unlike an array, which is defined during compilation, a hash object is defined at execution;
      * Instead of using a subscript, you use lookup keys to access data values;
       *hash object is available only to the DATA step that creates it, and when the DATA step ends, the hash object is deleted;


*declare hash states ('datasets:hashtab1 (where citypop > 4000000)');
      *three ways to define hash objects
          *DEFINEKEY;
               * DEFINEDATA;
                  * DEFINEDONE;
/*Asignmens 1*, we have two data sets wihtout any common varaibles but need to creat a table from these two*/

data Pop_usstates;
input Statename $ Capital $  Statepop2017;
datalines;
Virginia        Richmond   4000000
Colorado        Denver     7000000
Florida         Miami    8000000
Texas           Austin     7850000
Georgia         Atlanta    5000000
;
run;

data Pop_uscities;
input CityName $ StateCode $  Citypop2017;
datalines;
Richmond      VA        1250000
Denver        CO       1400000
Miami         FL        1800000
Austin        TX        1850000
Atlanta       GA        200000
;
run;


/*We have two complete tables with different columns and we want to calculate the city population percent*/
/*Hash objects: we have to declare the key components and data components*/


/* Declaring and Defining a Hash Object*/
data statecitypop;
length Statename $ 20 Capital $ 14 Statepop2017 8;
if _N_=1 then do;
declare hash A (dataset: 'Pop_usstates'); /*where, drop, keep, rename, obs can be use after table name inside parenthesis*/
 A.definekey ('StateName'); 
 A.definedata ('Capital', 'Statepop2017'); 
 A.definedone();
call missing (StateName, Capital, Statepop2017);
end;
run;

/*FIND method to search for key values in a hash object.*/


data statecitypop;
length Statename $ 20 Capital $ 14 Statepop2017 8;
if _N_=1 then do;
declare hash A (dataset: 'Pop_usstates');
 A.definekey ('Statename'); 
 A.definedata ('Capital', 'Statepop2017'); 
 A.definedone();
call missing (StateName, Capital, Statepop2017);
end;
set Pop_uscities;
Statename=stnamel(StateCode);
RC = A.find(Key:Statename); /*FIND method to search for key values in a hash object.*/
pctpop=Citypop2017/Statepop2017;
format statepop2017 comma14. pctpop percent8.1;
run;



/*if the key varaible is same, life is a lot easier*/

data Pop_usstates;
input Statename $ Capital $  Statepop2017;
datalines;
Virginia        Richmond   4000000
Colorado        Denver     7000000
Florida         Miami    8000000
Texas           Austin     7850000
Georgia         Atlanta    5000000
;
run;

data Pop_uscities;
input StateName $ StateCode $  Citypop2017;
datalines;
Virginia      VA         1250000
Colorado      CO       1400000
Florida       FL         1800000
Texas        TX        1850000
Georgia       GA         200000
;
run;


data statecitypop;
length Statename $ 20 Capital $ 14 Statepop2017 8;
if _N_=1 then do;
declare hash hstates (dataset: 'Pop_usstates');
 hstates.definekey ('Statename'); 
 hstates.definedata ('Capital', 'Statepop2017'); 
 hstates.definedone();
call missing (StateName, Capital, Statepop2017);
end;
set Pop_uscities;
RC = hstates.find(Key:StateName); 
pctpop=Citypop2017/Statepop2017;
format statepop2017 comma14. pctpop percent8.1;
run;

+






/*Formats*/
   *formats determine how a column's values are displayed;


/*picture format*/*
PROC FORMAT's PICTURE statement to create a custom template to display large numbers, dates, and times;


data yes1; 
dob=today(); 
format dob mmddyy.;
run;

proc format;
picture dateh (default=20)
        low-high= '%a.%B.%0d.%0y' (datatype=date);/*day month 
		run;

proc print data=yes1;
  format dob dateh.;
  run;


/*Custom Numeric Formats*/

data new1;
input Jobid country $ salary ;
cards;
1001 USA          1400
1002 UK           1200
1003 India        1500000
1004 Japan        50000000
1005 Netherlands  100000
1006 Poland       110000
1007 Kenya        90000
;
run;

proc format;
       picture currency (round default=10)
             low -<1000 = '09' (prefix = '$' mult=1)
             1000-<100000= '009.9k' (prefix = '$' mult=0.01)
			 100000-high = '009.9M'  (prefix = '$' mult=0.00001);
			 run;


proc print data=new1;
format salary currency.;
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
/*function vs the call routine*/

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

/*lets create a function*/

libname ctfunc "C:\Sanjaysas";

proc fcmp outlib=ctfunc.funcs.temp;
function FtoC (TempF);
tempc=round((tempf-32)*5/9, 0.1);
return (TempC);
endsub;
run;

/*lets use fucntion*/

options cmplib=ctfunc.funcs;
data citytemp1;
set citytemp;
newTemp=Ftoc(tempF);
run;


data name;
input name $ 1-19 age;
datalines;
Sanjay Basnet      37
Manira Gautam      72
Anup Bhandari      34  
Ranju Poudel       33
Bijaya Upadhay     37
Susma Dhungana     32
run;

proc fcmp outlib=work.functions.dev;
function ReverseName(Wei, Zhang );
reversename=catx(" ", scan(name,2,","),scan(name,1,","));
return (reversename);
endsub;
run;



data workact01;
set cert.names01;;
newname=reversename (name);
run;