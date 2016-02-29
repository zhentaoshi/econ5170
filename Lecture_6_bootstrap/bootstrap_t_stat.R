# 6/14/2015
# Zhentao Shi

# this script illustrates a bootstrap test for the population mean
# the test is carried out via a t-statistic

# the distribution of the sample is either "normal" 
# or "zero-centered chi-square"

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
  
  # boostrap in action
  for (r in 1:boot_Rep){
    indices = sample.int(n, n, replace = T) # resampling the index
    resampled_Y = Y[indices] # construct a boostrap artificial sample
    boot_T[r] = abs( T_stat( resampled_Y, mean(Y) ) ) # the boostrapped t-statistic
    # mu is replaced by "mean(Y)" to mimic the situation under the null
  }
  
  boot_critical_value = quantile(boot_T, 1-alpha) # bootstrapped critical value
  return( abs( T_stat(Y, mu) ) > boot_critical_value  ) # bootstrap test decision
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
  boot_decision = boot_test(X, boot_Rep) # decision from bootstrap
  
  return( c( exact, asym, boot_decision  ))
}

# Monte Carlo simulation and report the rejection probability
res = ldply( .data = 1:MC_rep, .fun = function(i) compare(), .progress = "text")
colnames(res) = c("exact", "asym", "bootstrap")
print( colMeans(res))
