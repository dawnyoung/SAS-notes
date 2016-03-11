* Used when we cannot assume the data is from a noraml distribution;

*
- one sample: sign test, Wilcoxon singed ranks test
- two samples: Wilcoxon rank sum test
- more than two samples: Kruskal-Wallis test;




*Load data;
proc import
  datafile= "/home/dongyangli0/my notes/myowncodebook.csv"
  out = work.addhealth
  dbms =csv
  replace;
run;
      
data addhealth; set addhealth;
*set aside missing value;
if H1GI20=97 then delete; if H1GI20=99 then delete; if H1GI20=96 then delete;
if H1GI20=98 then delete;
if H1GH1=6 then H1GH1=.; if H1GH1=8 then H1GH1=.;
if H1GH59A=96 then H1GH59A=.; if H1GH59A=98 then H1GH59A=.; if H1GH59A=99 then H1GH59A=.;
if H1GH59B=96 then H1GH59B=.; if H1GH59B=98 then H1GH59B=.; if H1GH59B=99 then H1GH59B=.;
if H1GH60=996 then H1GH60=.; if H1GH60=998 then H1GH60=.; if H1GH60=999 then H1GH60=.;
if H1FS11=6 then H1FS11=.; if H1FS11=8 then H1FS11=.;
if H1WP9=6 then H1WP9=.; if H1WP9=7 then H1WP9=.; 
if H1WP9=8 then H1WP9=.; if H1WP9=9 then H1WP9=.;
if H1WP13=6 then H1WP13=.; if H1WP13=7 then H1WP13=.;
if H1WP13=8 then H1WP13=.; if H1WP13=9 then H1WP13=.;
*Calculate height;
H1GH59=H1GH59A * 12 + H1GH59B;
*add labels;
label AID="respondent ID"
      BIO_SEX="gender"
      H1GI20="grade"
      H1GH1="general health"
      H1GH2="frequency of headache"
      H1GH6="frequnecy of feeling weak"
      H1GH59A="height in feet"
      H1GH59B="height in inch"
      H1GH60="weigt (pound)"
      H1FS11="feeling happy"
      H1WP9="how close with mother"
      H1WP13="how close with father"
      H1GH59="height (inch)";
run;






*#####################one sample
Both Sign test and Wilcoxon signed ranks test can be processed by PROC UNIVARIATE;

*Null hypothesis: mean=60;
proc univariate data=addhealth normal location=60 loccount;
  var H1GH59;
run;





*#######################Two samples;

* PROC NPAR1WAY compares the centers of two or more distributions.
Used when data is not normal but continous.

Wilcoxon rank sum test is equivalent of t-test and pooled t-test.
Wilcoson signed ranks test is alternative to the paired t-test. 
Kruskal-Wallis test is alternative to One-way ANOVA.

;




*Null hypothesis: H1GH1 for male is the same with H1GH1 for female;
proc npar1way data=addhealth wilcoxon;
  var H1GH1;
  class BIO_SEX;
run;



*Null hypothesis: for each level of H1GH1, H1GH2 is equal;
proc npar1way data=addhealth wilcoxon;
  var H1GH2;
  class H1GH1;
run;



*Null hypothesis: for BIO_SEX=1, at each level of H1GH1, H1GH2 is equal;
proc npar1way data=addhealth wilcoxon;
  where BIO_SEX = 1;
  var H1GH2;
  class H1GH1;
run;
