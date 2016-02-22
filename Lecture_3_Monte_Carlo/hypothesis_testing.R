# Zhentao Shi. 4/5/2015

# an example to develop an experiment for the test size of b_hat in OLS
# the code should be developed from scratch
# each step must be tested, and then wrap into  "report"

# steps
# 1. given sample size, get OLS b_hat and its t_value
# 2. wrap the t_value so that we can replicate for many many times
# 3. give sample size, report the size under two distributions
# 4. wrap it over different sample sizes.
# 5. add comments and documentation

rm(list = ls( ) )
library(plyr)
# set.seed(999)


# set the parameters

Rep = 2000
b0 = matrix(1, nrow = 2 )
df = 1

# the workhorse functions

MonteCarlo = function(n, type = "Normal", df = df){
  # a function gives the t-value under the null
  if (type == "Normal"){
    e = rnorm(n)
  } else if (type == "T"){
    e = rt(n, df )
  }
  
  X = cbind( 1, rcauchy(n) )
  Y = X %*% b0 + e
  rm(e)
  
  bhat = solve( t(X) %*% X, t(X)%*% Y )
  bhat2 = bhat[2] # parameter we want to test
  
  e_hat = Y - X %*% bhat
  sigma_hat_square = sum(e_hat^2)/ (n-2)
  sig_B = solve( t(X) %*% X  ) * sigma_hat_square
  t_value_2 = ( bhat2 - b0[2]) / sqrt( sig_B[2,2] ) 
  
  return( c(bhat2, t_value_2) )
}



# report the empirical test size
report = function(n){
  # collect the test size from the two distributions
  # this function contains some repeated code, but is OK for such a smply one
  TEST_SIZE = rep(0,3)
  
  Res = ldply( .data = 1:Rep, .fun = function(i) MonteCarlo(n, "Normal")  )
  names(Res) = c("bhat2", "t_value")
  TEST_SIZE[1] = mean( abs(Res$t_value) > qt(.975, n-2) )  
  TEST_SIZE[2] = mean( abs(Res$t_value) > qnorm(.975) ) 
  
  Res = ldply( .data = 1:Rep, .fun = function(i) MonteCarlo(n, "T", df)  )
  names(Res) = c("bhat2", "t_value")
  TEST_SIZE[3] = mean( abs(Res$t_value) > qnorm(.975) )
  
  return(TEST_SIZE)
}





pts0 = Sys.time()
# run the calculation of the empirical sizes for different sample sizes
NN = c(5, 10, 200, 2000)
RES = ldply(.data = NN, .fun = report, .progress = "text" )
names(RES) = c("exact", "normal.asym", "t.asym")
RES$n = NN
RES = RES[, c(4,1:3)] # beautify the results
print(RES)
print( Sys.time() - pts0 )

# matplot( y = RES, x = NN, type = "l", ylim = c(0, 0.1) )
