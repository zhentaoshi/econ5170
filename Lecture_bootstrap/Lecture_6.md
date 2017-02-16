# Lecture 6: Bootstrap

Zhentao Shi

6/15/2015

#### Introduction

Bootstrap, originated from Efron (1979), is an extremely powerful and influential idea for statistical estimation and inference. Properties of a statistic mostly depend on an underlying true distribution, which is impossible to know in reality. Bootstrap replaces the unknown distribution by a consistent estimator of the true distribution, for example, the empirical distribution function. 

Implementation of bootstrap is almost always a Monte Carlo simulation. In i.i.d. environment we sample over each observation with equal weight, while in dependent dataset such as time series, clustering data or networks, we must adjust the sampling schedule to keep the dependence structure.

In many regular cases, it is possible to show in theory the *consistency* of bootstrap: the statistic of interest and its bootstrap version converge to the same asymptotic distribution. However, bootstrap consistency can fail when the distribution of the statistic is discontinuous in the limit. Bootstrap is invalid in such cases. For instance, bootstrap fails to replicate the asymptotic distribution of the two-stage least squares estimator under weak instruments. 

#### Execution in R

Bootstrap is simple enough to be done by a "ply"-family function for repeated simulations. Alternatively, R package [boot](http://cran.r-project.org/web/packages/boot/index.html) provides a general function *boot()*.  

#### Bootstrap Estimation

Bootstrap is useful when the analytical formula of the variance of an econometric estimator is too complex to derive or code up.

**Example**: One of the most popular estimators for a sample selection model is Heckman(1979)'s two-step method. To obtain a point estimator, we simply run a Probit in the selection model, predict the probability of participation, and then run an OLS in the outcome model. However, as we can see from Heckman's original paper, the asymptotic variance expression of the two-step estimator is very complicated. Instead of following the analytical formula, we bootstrap the variance. 

```
library(plyr)
library(sampleSelection)

# the dataset comes from
# Greene( 2003 ): example 22.8, page 786
data( Mroz87 )

# equations
selection_eq = lfp ~ age + faminc + exper + educ
outcome_eq   = wage ~ exper + educ 

# Heckman two-step estimation
heck = heckit( selection_eq, outcome_eq, data = Mroz87 )
print(coeftest(heck))

########## bootstrap Heckit #################

# function for a single bootstrap
n = nrow(Mroz87)
boot_heck = function(){
  indices = sample(1:n, n, replace = T)
  Mroz87_b = Mroz87[ indices, ]
  heck_b = heckit( selection_eq, outcome_eq, data = Mroz87_b )
  return( coef(heck_b) )
}

# repeat the bootstrap
boot_Rep = 499
Heck_B = ldply( .data = 1:boot_Rep, .fun = function(i) boot_heck(), 
                .progress = "text")

# collect the bootstrap outcomes 
Heck_b_coef = data.frame(mean = colMeans(Heck_B), sd = apply(Heck_B, 2, sd))
Heck_b_coef$z = with(Heck_b_coef, mean/sd)
print(Heck_b_coef)

# print(head(Heck_B))
```


#### Bootstrap Test

Bootstrap is particularly helpful in statistical inference. Indeed, it is possible to show in theory the higher-order improvement of bootstrap. Loosely speaking, if the test statistic is asymptotically pivotal, a bootstrap hypothesis testing can be more accurate than its analytical asymptotic counterpart.  

**Example**: a bootstrap test for the population mean. The true test is carried out via a t-statistic. The distribution of the sample is either *normal* or *zero-centered chi-square*. It shows that the bootstrap test size is more precise than that of the asymptotic approximation. 

```
rm(list = ls( ) )
library(plyr)

############ prepare the workhorse functions ##############

# the t-statistic for a null hypothesis mu
T_stat = function(Y, mu ) (mean(Y) - mu ) / sqrt( var(Y)/n )

# the bootstrap function
boot_test = function(Y, boot_Rep){ 
  # INPUT
  #   Y: the sample
  #   boot_Rep: number of bootstrap replications
  
  n = length(Y)
  boot_T = rep(0, boot_Rep)  
  
  # bootstrap in action
  for (r in 1:boot_Rep){
    indices = sample.int(n, n, replace = T) # resampling the index
    resampled_Y = Y[indices] # construct a bootstrap artificial sample
    boot_T[r] = abs( T_stat( resampled_Y, mean(Y) ) ) 
    # the bootstrapped t-statistic
    # mu is replaced by "mean(Y)" to mimic the situation under the null
  }
  
  boot_critical_value = quantile(boot_T, 1-alpha) # bootstrapped critical value
  return( abs( T_stat(Y, mu) ) > boot_critical_value  ) 
  # bootstrap test decision
}

################# start the experiment ######################
# set the parameters
n = 20
distribution = "normal"
boot_Rep = 199
MC_rep = 1000
alpha = 0.05
mu = 0

compare = function(){
  # this function generates a sample of n observations
  # and it returns the testing results from three decision rules
  
  if (distribution == "normal") {  X = rnorm(n) }
  else if (distribution == "chisq") {  X = rchisq(n, df = 3) - 3 }
  
  t_value_X = T_stat(X, mu ) # T-statistic
  
  # compare it to the 9.75% of t-distribution
  exact = abs( t_value_X ) > qt(0.975, df = n-1) 
  # compare it to the 9.75% of normal distribution
  asym  = abs( t_value_X ) > 1.96 
  # decision from bootstrap
  boot_decision = boot_test(X, boot_Rep) 

  return( c( exact, asym, boot_decision  ))
}

# Monte Carlo simulation and report the rejection probability
res = ldply( .data = 1:MC_rep, 
    .fun = function(i) compare(), .progress = "text")
colnames(res) = c("exact", "asym", "bootstrap")
print( colMeans(res))
```

A key point for bootstrap test is that the null hypothesis must be imposed no matter the hypothesized parameter is true value or not.

### Extended Readings
* Hansen (2015): [Econometrics](http://www.ssc.wisc.edu/~bhansen/econometrics/). Chapter 10.
* Politis, Romano and Wolf (1999): [Subsampling](http://www.amazon.com/Subsampling-Springer-Statistics-Dimitris-Politis/dp/0387988548)