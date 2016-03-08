******************************************One way ANOVA**************************************

- proc anova
- proc glm

When the number of observations for each level of a factor are the same, they can be used 
interchangeably. 

When the levels of the independent variables have unequal sample sizes, PROC GLM is better.





Load data;
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


proc sort data=addhealth; by BIO_SEX;
run;



*****************PROC GLM;
proc glm data=addhealth;
  class H1WP9; *if no class statement, the proc glm will compute statistics for a
                regression model rather than an ANOVA model;
  model H1GH1 = H1WP9 / alpha=0.01; 
  means H1WP9 / lines; *means options
                        only class variables are allowed here
                        it has to appear in the model;
  by BIO_SEX;
run;


* means options
---------------------------------------------------------------------------------------------
option       |  description
---------------------------------------------------------------------------------------------
alpha = p    |  significance level
cldiff       |  requests confidence intervals for all pairwise differences between means
bon          |  Bonferroni t-test
duncan       |  Duncan's multiple comparisons
lines        |  lists the means in descending order
scheffe      |  Scheffe's multiple comparisons
snk          |  Student-Newman-Keuls multiple range test
lsd          |  pairwise t-test, which is equivalent to Fisher's lest significant difference 
                test when cell sizes are equal
tukey        |  Tukey's studentized range test
---------------------------------------------------------------------------------------------



*************PROC ANOVA;
proc anova data=addhealth;
  class H1WP9;
  model H1GH1 = H1WP9;
  means H1WP9 / alpha=0.01 bon;
  by BIO_SEX;
run;






**************************************Two way ANOVA*****************************************

Null hypothesis: the main effect or interaction does not have an effect on the response
                 variable. The means for the different levels of teh effect are the same.
;




proc glm data=addhealth;
  class H1WP9 H1FS11;
  model H1GH1 = H1WP9 | H1FS11;* this can also be written as
                                 H1WP9 H1FS11 H1WP9 * H1FS11;
  means H1WP9 H1FS11 / alpha=0.01;
run;



proc anova data=addhealth;
  class H1WP9 H1FS11;
  model H1GH1 = H1WP9 | H1FS11;* this can also be written as
                                 H1WP9 H1FS11 H1WP9 * H1FS11;
  means H1WP9 H1FS11 / alpha=0.01;
run;







**************************General ANOVA analysis*******************************************

N-way ANOVA, handled by PROC GLM procedure;



proc glm data=addhealth;
  class H1WP9 H1WP13 H1FS11;
  model H1GH1 = H1WP9 | H1WP13 | H1FS11;
  means H1WP9 H1WP13 H1FS11 / alpha=0.01;
  random H1WP9 H1WP9 * H1WP13 H1WP9 * H1WP13 * H1FS11 / test;* indicates that H1WP9 and all 
                                                               interactions including H1WP9
                                                               are random. TEST asks SAS to 
                                                               compute F-tests using the 
                                                               RANDOM information;
run;







***************************************Model checking in ANOVA*******************************
Assumption for ANOVA: error terms are independent and normally distributed with mean 0 and constant
                      variance.


Plots for model checking:

- residual e VS y-hat: random scatter about 0. The width of the scatter should be the same if 
                       the assumption of constant variance is true.
- residual e VS main effects: random scatter about 0. The width of the scatter should be the
                              same if the assumption of constant variance is true.
- normal probability plot of errors: check the normality assumption.
;



proc glm data=addhealth;
  class H1WP9 H1WP13;
  model H1GH1 = H1WP9 | H1WP13;
  output out = anovaout /*creates a new dataset*/
         p = yhat /*predicted value*/
         student = resid; /*standardized residuals*/
run;

proc gplot data=anovaout;
  plot resid * yhat / vref=0;
  title2 "srandardized residuals vs. yhat";
  
  plot resid * H1WP9 / vref=0;
  title2 "standardized residuals vs. H1WP9";
  
  plot resid * H1WP13 / vref=0;
  title2 "standardized residuals vs. H1WP13";
run;

proc univariate data=anovaout normal;
 var resid;
 probplot resid / normal (mu = est sigma = est) square;
 title2 "normal test and plot";
run;

