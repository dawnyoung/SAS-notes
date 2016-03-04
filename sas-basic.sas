*SAS notes - basic information


#  Two types of steps in SAS
Each SAS step or paragraph must start with *DATA* or *PROC* to let SAS know whta kind of step it is. 
- DATA steps: put data in a form that the SAS program can use
- PROC steps: use procedures to do something to the data

#  Character variables are case sensitive;


* Create data set;
data dataname; *The *data* statement names the data set;
input id y z $ status; *input* is the keyword that defines the names of the variables in the data set.;
* $ indicates that z is a character variable;
datalines; 
1 0.3 male 1
2 0.5 female 3
3 0.4 unknown 2
; *datalines statements signals the beginning of the lines of data;
run;*optional last statement in data steps and proc steps when using batch processing. ;

* Batch processing means that you write the entire program and then submit it to the SAS processor,
which performs the actions requested by each statement. 
RUN statement makes the log file easier to read.;


* IF, THEN, ELSE;
data dataname; set dataname;
if z = "male" then gender = 1;
else if z = "female" then gender = 2;
else gender = 0;
run;

*  Logical operators
-----------------------------------------
Symbol | Mnemonic Equivalent | Definition	
-----------------------------------------
  =    |        EQ           | equal
  ^=   |        NE           | not equal
  ~=   |        NE           | not equal
  >    |        GT           | greater than
  <    |        LT           | less than
  >=   |        GE           | greater than or equal to
  <=   |        LE           | less than or equal to
       |        IN           | equal to one of a list
-----------------------------------------
Example:  num in (3, 4, 5): equal to 3 or 4 or 5;


*  FORMAT;
data dataname; set dataname;
proc format;
value sfmt 1 = "good" 2 = "okay" 3 = "bad";
proc print data = dataname;
format status sfmt.; *write numeric values with characters;


*  IMPORT csv files by proc step;
proc import datafile="/home/dongyangli0/my notes/myowncodebook.csv"
out= addhealth
dbms=csv
replace;getnames=yes;
run;

*  Import csv file by data step;
data addhealth;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX H1GH1; *Select variables of interest;
run;


*  Merge data sets;
*  similar to cbind in R;
data addhlth1;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX;
run;

data addhlth2;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID H1GH1;
run;

data addhlth3; merge addhlth1 addhlth2; 
* Merge by the same variable AID by default;
run;

data addhlth4; merge addhlth1 addhlth4; by AID;
run;

*  Concatenate data sets
*  Similar to rbind in R;
data addhlth5;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX H1GH1;
if BIO_SEX=1 then delete;
run;

data addhlth6;
infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX H1GH1;
if BIO_SEX=2 then delete;
run;

data addhlth7; set addhlth5 addhlth6;
proc sort; by AID;
run;


*  Save the data sets into library;
data addhlth; infile "/home/dongyangli0/my notes/myowncodebook.csv" dlm=",";
input AID BIO_SEX H1GH1;
run;
*create a new library;
libname newlib "/home/dongyangli0/my notes/";
data newlib.addhealth; *use two part data name: libname.datasetname;
set addhealth;
run;
*the name of the library should not have more than 8 characters.;


*  Accessing the data sets saved in library;
libname newlib "/home/dongyangli0/my notes/";
proc contents data=newlib.addhealth;
run;






*    Basic Funtions;
*
#numeric
abs(argument): returns the absolute value of argument
exp(): returns the number e to the power of argument
int(): returns the integer portion
log(): natural log
log10(): base 10 log
round(argument, round off unit): rounds argument to the nearest value of the round-off-unit.
                                 for example: round(3.12, 0.1);*return the value 3.1
sqrt(): square root

arcos(): arccos
arsin(): arcsin
atan(): arctan
cosh()； hyperbolic cosine
sinh(): hyperbolic sine
tanh(): hyperbolic tan



#character
left(): left aligns
right(): right aligns
substr(argument, position, n): extracts a substring of argument beginning with the 
                               character at specified position and having length n.
trim(): romoves trailing blanks from argument




#probability function
poisson(m, n): p(x <= n), where x is a poisson variable with mean m
probbnml(p, n, m): p(x <= m), where x is binomial, p is the prob of each trial. n is the 
                   number of trials
probchi(x, df): p(x <= x), x is chi-square with df as degrees of freedom
cinv(p, df): return pth quantile from the chi-square distribution
probf(x, ndf, ddf): p(x <= x), f distribution
finv(p, ndf, ddf): pth quantile from f distribution
probhyper(N, K, n, x): p(x <= x), hypergeometric random variable. N is population size.
                       K is the number in the population with a special characteristic.
                       n is sample size.
probnorm(x): p(x <= x), normal distribution, miu=0, sigma=1
probit(p): p th quantile of the standard normal distribution
probt(x, df): p(x <= x), random variable with df as degrees of freedom
tinv(p, df): p th quantile of the t distribution



#descriptive statistics
mean(): mean
std(): standard deviation
sum(): sum
min(): minimum value
max(): maximum value
median(): median
iqr(): interquartile range
range(): range