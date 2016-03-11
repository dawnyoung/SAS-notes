*
PROC CORR
- computes the Pearson correlation coefficient
- produces simple descriptive statistics
- computes p-value for testing whether the true correlation rho = 0
;




*Loda data;
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
*Calculate body mass index;
BMI=H1GH60 * 0.454/(H1GH59 * 0.0254)**2;
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






proc corr data=addhealth;
  var H1GH1 H1GH2 H1GH6;
  with BMI;*Compare the variables in var statement with BMI respectively;
run;


proc corr data=addhealth;
  var H1GH1 H1GH2 H1GH6; *Compare each two of variables in this statement respectively, which means
                          H1GH1 ~ H1GH2, H1GH1 ~ H1GH6, H1GH2 ~ H1GH6;
run;


proc corr data=addhealth;
  var H1GH1 H1GH2 H1GH6;
  with BMI;
  partial BIO_SEX;*Produces partial correlation coefficients, controlling for the effect of BIO_SEX;
run;


proc corr data=addhealth cov/*prints the covariance matrix*/
                         nosimple /*suppresses the printing of simple descriptive statistics*/
                         noprob /*suppresses the printing of p-value*/
                         pearson /*request Pearson correlatiosn. Default. Only needed when SPEARMAN
                                   is specified*/
                         spearman;
  var H1GH1 H1GH2 H1GH6;
run;
