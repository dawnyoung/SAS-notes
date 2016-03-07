******************************* One sample test ****************************

- T test: PROC MEANS
- Chi-square test: PROC FREQ: test for true proportion of a distribution
;

*Load data;
proc import
  datafile= "/home/dongyangli0/my notes/myowncodebook.csv"
  out = work.addhealth
  dbms =csv
  replace;
run;
data addhealth; set addhealth;
centeredweight = H1GH60 - 200;
if BIO_SEX = 6 then BIO_SEX = .;
run;



* t test
Null hypothesis: miu of weight (H1GH60) is equal to 200;
proc means data=addhealth n mean std 
           t /*generate t-statistic*/
           probt; /*generate p-value*/
var centeredweight;
run;


* t test through PROC;
proc ttest data=addhealth 
           alpha=0.01 /*confidence level*/
           dist=normal /*assume it is normally distributed*/
           side=l /*alternative hypothesis: mean is less than miu*/
           h0=200; /*null hypothesis: mean is equal to 200*/
var centeredweight;
run;


* Chi-square test
test for p;
* null hypothesis: 70% of respondents have weight (H1GH60) greater than 200;
data new1; set addhealth;
if H1GH60 > 200 then weightgroup = 0;
if H1GH60 <= 200 then weightgroup = 1;
run;
proc freq data=new1;
table weightgroup / chisq testp=(0.3, 0.7);
run;







******************* Two sample *********************************

*  Whether two means are equal;

*unpaired;
*null hypothesis: mean of male = mean of female;
proc ttest data=addhealth;
  class BIO_SEX; /*indentifies the variable that devide the data set into two groups*/
                 /*can only have two values*/
  var H1GH60;
run;


*paired;
* null hypothesis: there is no difference between the mean of H1GH1 and H1GH2;
proc sort data=addhealth; by BIO_SEX;
proc ttest data=addhealth alpha=0.01;
  paired H1GH1 * H1GH2;
  by BIO_SEX;
run;


*test by proc means procedure;
*paired;
*null hypothesis: no difference;
data new2; set addhealth;
difference = H1GH1 - H1GH2;
run;
proc means data=new2 n mean std t probt;
var difference;
run;
