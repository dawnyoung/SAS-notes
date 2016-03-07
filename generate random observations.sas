* Generate random observations from specific distributions;
* DO loops: repeat a command or statement over and over again within a data step;


* FUNCTIONS
------------------------------------------------------------------------
SAS Function          |   Description
------------------------------------------------------------------------
ranbin(seed, n, p)    |   binomial, n trials, probability p of success
ranexp(seed)          |   exponential distribution with lamda=1
rannor(seed)          |   standard normal distribution
ranpoi(seed, m)       |   poisson distribution with mean m>=0
ranuni(seed)          |   uniform distribution on the interval (0, 1)
------------------------------------------------------------------------



* generate 1000 observations from a standard normal distribution;
data std1; *name the data;
do i = 1 to 1000; * DO loop begins with DO.
                    i = beginning number to ending number;
x = rannor(123); * statement tells SAS what to do. set seed;
output; *output the observations to the data set. Without the output statement, there is
         no observations in the data set;
end; *DO loop ends with END;
run;

proc gchart; vbar x / space=0 midpoints=-3 to 3 by 0.5 width= 4;
title "Random observations from standard normal distribution";
run;



* Generate 1000 observations from a normal distribution with miu=2, sigma = 1;
data std2;
  do i = 1  to 1000;
    x1 = rannor(123);
    x2 = x1 * 1 + 2;
    output;
  end;
run;
proc gchart; vbar x1 / space=0 midpoints=-3 to 3 by 0.5;
run;
proc gchart; vbar x2 / space=0 midpoints=-1 to 5 by 0.5;
title "Random observations from normal distribution with miu=2, sigma=1";
run;





* Distribution of sample mean;
data bin1;
  do i = 1 to 100;
     x1 = ranbin(2, 50, 0.2);
     x2 = ranbin(2, 50, 0.2);
     x3 = ranbin(2, 50, 0.2);
     x4 = ranbin(2, 50, 0.2);
     x5 = ranbin(2, 50, 0.2);
     x6 = ranbin(2, 50, 0.2);
     x7 = ranbin(2, 50, 0.2);
     x8 = ranbin(2, 50, 0.2);
     x9 = ranbin(2, 50, 0.2);
     x10 = ranbin(2, 50, 0.2);
     avex = (x1 + x2 + x3 + x4 + x5 + x6 + x7 + x8 + x9 + x10)/10;
     output;
  end;
run;
proc univariate;
var avex;
histogram avex / normal endpoints=5 to 15 by 1;
title "distribution of sample means";
run;



