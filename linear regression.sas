*
Both PROC REG and PROC GLM can do regression analysis. But RPOC REG has more options.

-  Create scatter plot of response variable and explannatory variable
-  Compute the least-squares regression line
-  Output predicted values
-  Plot the predicted values on the same plot as the original scatterplot
-  Calculate confidenc intervals for Y and prediction intervals for future values of Y


_______________________________________________________________________________________;





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



*________________________________________________________________________________________;

*Simple linear regression;
proc reg data=addhealth simple;
  model H1GH60 = H1GH59 / cli /*prints confidence intervals of prediction values*/
                          clm /*prints confidence intervals for the mean of each observation*/
                          p /*prints observed value, predicted value, residual*/
                          r /*prints all the values from P and standard errors of predicted and 
                              residuals, teh studentized residuals and Cook's D-statistic. also
                              a small residual plot*/
                          alpha=0.01;
  plot H1GH60 * H1GH59;
run;



*________________________________________________________________________________________;

*Model checking
Assumption: errors are independent and normally distributed with mean 0 and constant variacne.;

*Some plots that can be used to verify the model assumption:
-  y ~ yhat: y should be close to yhat. the plot should be a 45 degree straight line
-  residual e (standardized residual) ~ yhat: a random scatter about 0. the width of the scatter
                                              should be the same if constant variance is true.
-  residual e ~ x: same with the e ~ yhat
-  normal probability plot of errors: check the normality assumption
;

*Regreesion and output data;
proc reg data=addhealth simple;
  model H1GH60 = H1GH59;
  output out=modelcheckingdata /*name the output data as modelcheckingdata*/
         p = yhat /*name the predicted values as yhat*/
         r = residualvalue /*name the residuals as residualvalue*/
         student=sresid; /* name the standardzied residuals*/
  plot H1GH60 * p.; /*plot of y ~ yhat*/
  plot student. * p.; /*plot of standardized residual ~ predicted values*/
  plot student. * H1GH59;
run;

*Make plots;
proc gplot data=modelcheckingdata;
  plot H1GH60 * H1GH59;
  title "regression line";
  run;
  plot H1GH60 * yhat
       yhat * yhat / overlay; /*make it easy to see if the y ~ yhat is a 45 degree straight line*/
  title "y ~ yhat";
  run;
  plot residualvalue * yhat / vref = 0;
  title "residuals ~ yhat";
  run;
  plot residualvalue * H1GH59 / vref = 0;
  title "residuals ~ x";
run;
* Normal test;
proc univariate normal data=modelcheckingdata;
  var sresid;
  probplot sresid / normal;
  title "normal test";
run;



*________________________________________________________________________________________;

* Multiple linear regression;
proc reg data=addhealth;
  model H1GH1 = H1FS11 BMI;
  plot H1GH1 * H1FS11 H1GH1 * BMI / overlay;
  plot student. * p.;
run;




* Polynomial;
data newdata; set addhealth;
  BMI2 = BMI ** 2;
  BMI3 = BMI ** 3;
run;

proc reg data=newdata;
  model H1GH1 = BMI BMI2 BMI3;
  plot H1GH1 * BMI H1GH1 * BMI2 H1GH1 * BMI3 / overlay;
  plot student. * p.;
run;




*________________________________________________________________________________________;

* Aids for selecting and assessing models;

* Collinearity occurs when low tolerance values, or large condition index;

proc reg data=addhealth;
  model H1GH1 = BMI H1FS11 H1WP9 H1WP13 H1GI20 / collin /*collinearity analysis*/
                                                 tol /*tolerance values*/
                                                 vif /*variance inflation factors*/
                                                 influence /*residual and studentized residual*/
run;







proc reg data=addhealth;
  model H1GH1 = BMI H1FS11 H1WP9 H1WP13 H1GI20 / selection = stepwise;
run;

proc reg data=addhealth;
  model H1GH1 = BMI H1FS11 H1WP9 H1WP13 H1GI20 / selection = forward;
run;
