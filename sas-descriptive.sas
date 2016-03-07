data addhealth;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX H1GH1 H1GH2 H1GH59A H1GH59B H1GH60; *Select variables of interest;
run;

libname newlib "/home/dongyangli0/my notes/";
data newlib.addhealth; *use two part data name: libname.datasetname;
set addhealth;
run;


data addhlth; set addhealth;
*add label;
label BIO_SEX = "gender"
      H1GH1 = "general health"
      H1GH2 = "frequency of headache"
      H1GH59A = "height in feet"
      H1GH59B = "height in inch"
      H1GH60 = "weight";




proc sort data=addhlth; by BIO_SEX;

proc univariate /*generate descriptive statistics*/
data=addhlth plot/*plot: produces caracter-quality stem and leaf plot, or horizontal bar
                     chart if n is large, box plot, and normal probability plot*/
alpha = 0.01; *set confidence level. 0.05 by default;
   var H1GH1;*statement specifies the analysis variables and their order in the 
                      results. if omit, analyze the numeric variables by defualt;
   probplot H1GH1 / normal; 
   histogram H1GH1 / normal; *test if it is normally distributed;
   id AID; *specifies a variable whose value is printed next to the smallest and largest 
            observations;
   by BIO_SEX; *first sorted by BIO_SEX. when the analysis is performed, values are grouped
                by BIO_SEX;
run;



proc boxplot data=addhlth;
plot H1GH1 * BIO_SEX/boxstyle=schematicid cboxes=bgr;*set style and color;
title1 "distribution of general health";*first order title;
title2 "grouped by gender"; *second order title;
run;




* global statement;
goptions cpattern=bibg /*set color*/
         htext=2;/*Specifies the default size of the text in the graphics output.*/

proc gchart data=addhlth;
vbar H1GH1 / /*vbar: vertical bars*/
             space=1 /*specify the space between two bars*/
             width=4 /*specify the width of bars*/
             discrete /*if no discrete, the variable would be treated as contineous var*/
             subgroup=BIO_SEX /*grouped by BIO_SEX*/
             type=cpercent; /*set the bar type*/
title move=(50, -10) "barchat";*set the location of title;
run;




proc means data=addhlth alpha=0.01;
by BIO_SEX;
class H1GH1; /*Specifies the variables whose values define the subgroup combinations for 
              the analysis*/
freq H1GH1; /*treat values of this variable as frequency, as integer*/
id AID;
run;



* generates tables for data that are in categories;
proc freq data=addhlth; 
tables BIO_SEX BIO_SEX * H1GH1 BIO_SEX*H1GH2 H1GH1 * H1GH2/ alpha=0.01;
title "tables";
run;

proc freq data=addhlth; 
tables BIO_SEX * H1GH1 BIO_SEX*H1GH2 H1GH1 * H1GH2/ alpha=0.01;
title "tables";
weight H1GH60;
run;
* provides a weight for each observation in the input data set.
assumes each observation represents n observations, where n is the value of this weight
variable;

