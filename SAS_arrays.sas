
/*In SAS, an array is defined as a group of variables or columns that are arranged in a particular order and identified by a name.*/
/*Arrays processigng code in groups for the varaibles in horizontal rows*/
/*A SAS array is not a data structure, but a way to temporarily group together variables in the program data vector*/
/*three ways of usign arrays*/

*processing repetitive code, rotating data, and performing table lookups;

/*processing repetitive code*/

data array1;
input city $ temp1-temp12;
datalines;
raleigh   42 43 45 67 89 87 65 34 56 55 67 87
DC        54 56 67 78 87 89 99 99 56 24 56 45
rocheter  23 34 56 67 89 65 67 78 88 89 34 12
blacksburg 45 56 78 79 79 78 89 89 90 54 44 45
portland    45 46 47 48 67 56 77 89 89 90 76 77
;;
run;

/*We want to change the degree celsious into fahreanheight*/
 data array2;
     set array1;
     array temperature[12] temp1-temp12;/*one dimensionla array with 12 elements)*/
     do month=1 to 12;
        Temperature[month]=(Temperature[month]-32)*5/9;
     end;
	 format temp1-temp12 5.1;
run;

/*if you want to donot know the number of columns */
 data array3;
     set array1;
     array temperature[*] temp:;   /* use * to define the elements and Temp:*/
     do month=1 to dim(temperature); /*call DIM function as the stop value for DO loop*/
        Temperature[month]=(Temperature[month]-32)*5/9;
     end;
	 format temp: 5.1;
run;


/*Prcoessing one dimensional array on numeric data*/

data arrayclass;
    set sashelp.class;
    array C [2] height weight;
    array B [2] heightbmi weightbmi;
    do i =1 to 2;
       B [i]= C[i]/age;
    end;
    drop i;
	format heightbmi weightbmi 7.2;
run;

/*Prcoessing one dimensional array on character*/
data array111;
input name $ A1 $ A2 $ A3 $ A4 $ A5$;
datalines;
Sanjay   A C D E F
Manira   C C C D E
Ranju    A B C D E
Anup     E E A B E
Biajay   A B B C D
;
run;

/*Lets check how many answers are correct using array*/

data array222;    
    set array111;
    Score=0; 
    array EmpAnswer[5] A1-A5;   
    array CorAnswer[5] $ 1 _temporary_  ('A','C','C','B','E');
    do i=1 to 5;
       if EmpAnswer[i]=CorAnswer[i] then Score+1;
    end;
    drop i;
run;


/*Differences between Array Elements*/
data array1;
input name $ sub1-sub10;
datalines;
Sanjay   78 67 85 78 93 45 82 67 89 99
Manira   84 96 78 89 86 95 98 69 74 84 
Ranju    94 85 88 78 98 73 63 67 78 90
Anup     94 67 89 83 89 75 86 77 84 76
Biajay   94 96 89 75 98 98 73 77 86 78
;
run;


 data array2;
     set array1;
     array subj[10] sub1-sub10;
    array Diff[3] Diff1 Diff2 diff3; /*coln 1- col2, col2-col3*/
    do i=1 to 3;
       Diff[i]=subj[i]-subj[i+1];
    end;
run;


/*if clause with array*/

*if the accepted score for sub1 to sub10 is 65 70 70 80 87 87 89 90 23 45;
*use the loop to compare the value and keep the value if thea actual score is greater than the accepted score;

data array3;
   set array1;
    array S (10) sub1- sub10;
	array A (10) _temporary_ (80 80 80 80 80 80 80 80 80 80);
	do i= 1 to 10;
	if s(i) < A (i) then s (i)= A (i);
    end;
	drop i;
   run;

proc means data=array3;
run;



/*Two-Dimensional Arrays*/

*take data from a table and load it into the array;
*You can think of the two-dimensional array as a table with rows and columns
but in the PDV, the values are just consecutive columns;
*often used for look up table;

/*array  [2,3] (4 5 6 3 6 5 */
 *2 rows and three columns;



