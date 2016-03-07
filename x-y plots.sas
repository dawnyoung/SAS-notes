* PROC GPLOT;

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



proc sort; by BIO_SEX;

proc gplot data=addhealth;
  plot H1GH59 * AID = "+";
  by BIO_SEX;
run;




proc gplot data=addhealth;
  plot H1GH1 * (H1GH59 H1GH60); *two plots on separate pages;
run;





* two plots overlayed in one page;
goptions csymbol=bgr;
symbol11 value=dot;
symbol12 value=plus;
proc gplot data=addhealth;
  plot H1GH1 * AID = 1 H1GH2 * AID = 2 / overlay;
run;






data std1;
  do i = 1  to 10;
    x1 = rannor(123);
    x2 = x1 * 1 + 2;
    output;
  end;
run;
goptions csymbol=bgr;
symbol11 value=dot;
symbol12 value=plus; *define the symbol for each variable;
proc gplot data=std1;
  plot x1 * i = 1 X2 * i = 2 /overlay; *set symbol 1 for x1, symbol 2 for x2;
run;

