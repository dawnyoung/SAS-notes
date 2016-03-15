*
Usually, logistic regression is a way to model the relationship between a repsonse variable
with two or more categories of repsonses and explanatory variables of interest.
;




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





proc logistic data= addhealth;
  model H1GH1 = BMI H1FS11 H1WP9 H1WP13 H1GI20 / selection=forward
                                                 link=normit /*select link function.
                                                               logit by default*/
                                                 clodds=wald /*select confidence intervals*/
                                                 sequential /*forces the variables to be added 
                                                              to the model in the order given in
                                                              the model statement if forward or 
                                                              stepwise regression is requested*/
                                                 include=2; /*requests the first 2 variables in 
                                                             model statement be in every model*/
run;

