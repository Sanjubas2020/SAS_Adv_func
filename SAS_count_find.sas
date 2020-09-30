/*Functions accepts arguments, performs operations such as computations or text manipulations, and returns a numeric or character value*/
/*Function can be called within an expression.*/
/*Functions are divided into categories*/
/*Character, truncation, special, descriptive statistics*/

*Character:           LENGTH, SCAN, SUBSTR, TRANSWRD, STRIP, TRIM
                      FIND, ANYALPHA,ANYDIGIT, ANYPUNCT, COMPBL,COMPRESS
                      CAT, CATS, CATX, LOWCASE, PROPCASE, UPCASE
*Date and Time:       WEEKDAY, DAY, MONTH, QTR, YEAR,YRDIF, INTIC
                      INTNX,DATEPART, TIMEPART, MDY, TODAY
*TRUNCATION:          ROUND, CEIL, INT, FLOOR
SPECIAL:              INPUT, PUT
DESCRPTIVE STAT:      SUM,MEAN, MEDIAN,RANGE,MIN,MAX,LARGEST, N , NMISS;


/*Some advance Fucntons*/
             *LAG;
             *COUNT, COUNTC, COUNTTW;
             *FINDC, FINDW;
/*CALL routines functions accept arguments, perform a manipulation don't return a value*/
/*A CALL routine can't be called in an expression*/

/*lag fucntion: computing difference between rows and maving averages*/

data lag11;
set sashelp.class (keep= name weight);
preweight1=lag1(weight);
preweight2=lag2(weight);
increaseweight=weight-preweight1;
run;

proc sort data=sashelp.stocks out=stock11;
by stock Date;
run;

data stock12;
   set stock11 (keep=stock date adjclose);
   labstock=lag1(adjclose);
   monthlyinc=labstock-adjclose;
   run;



/*count functions*/
/*COUNT: no of times that a substring appears within a character string*/
/*COUNTC: No of characters in a string that appear (or don't appear) in a list of characters*/
/*COUNTW function counts the number of words in a character string*/

data Countfind;
infile cards;
input name $ 1-4 Des$ 6-150;
cards;
RAM   Grade 1 math Grade 2 sciene Grade 3 social Grade-4 Biostatistic Grade 1 health Grade A sas
Hari  Hari Grade 1 eng Grade 2 Math Grade 3 math Grade-4 science Grade 1 social Grade B sas
;;
run;


Data finddd;
set countfind;
ctword= countw(Des,' ');
ctspecgrad=count(Des,"Grade");
startpos=find(Des, "Grade"); /*first start position of the grade word*/
wordnum=findw(Des,'Grade');
wordnum1=findw(Des,'Grade', ' ');
wordnum2=findw(Des,'Grade', '012345- .,', 'e'); /*first start position of the grade word with delimitor*/
if wordnum2 > 0 then aftergrade= scan(Des, wordnum2 +1, '012345-., ');
run;



proc means data=finddd;
var ctword ctspecgrad;
run;

proc freq data=finddd;
tables wordnum2;
run;




/*What are Perl Regular Expressions?*/
/*PRXPARSE, PRXMATCH, and PRXCHANGE*/

/*Creating Picture Formats with the FORMAT Procedure*/