# construct confidence interval

CI = function(x){
  # x is a vector of random variables

  n = length(x)
  mu = mean(x)
  sig = sd(x)
  upper = mu + 1.96/sqrt(n) * sig
  lower = mu - 1.96/sqrt(n) * sig
  return( list( lower = lower, upper = upper) )
}


##########################
Rep = 100000
sample_size = 100

cat("Rep = ", Rep, "; sample size = ", sample_size, "\n")

# a standard loop
out = rep(0, Rep)
pts0 = Sys.time() # check time
mu = 2
for (i in 1:Rep){
  x = rpois(sample_size, mu)
  bounds = CI(x)
  out[i] = ( ( bounds$lower <= mu  ) & (mu <= bounds$upper) )
}

pts1 = Sys.time() - pts0 # check time elapse
cat( "standard loop:", pts1, "\n") # empirical size



# efficient loop
library(plyr)

capture = function(i){
  x = rpois(sample_size, mu)
  bounds = CI(x)
  return( ( bounds$lower <= mu  ) & (mu <= bounds$upper) )
}

pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture)
pts1 = Sys.time() - pts0 # check time elapse
cat( "plyr loop:", pts1, "\n") # empirical size


########### parallel
library(plyr)
library(foreach)
library(doParallel)

registerDoParallel(2) # opens other CPUs

pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = TRUE,
            .paropts = list(.export = ls(envir=globalenv() )) )
pts1 = Sys.time() - pts0 # check time elapse
cat( "parallel loop with 2 cores:", pts1, "\n") # empirical size

# this parallel indeed takes more time

########### non-trivial problem of large sample size



Rep = 200
sample_size = 5000000


cat("\n\n Rep = ", Rep, "; sample size = ", sample_size, "\n")


pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = FALSE)
pts1 = Sys.time() - pts0 # check time elapse
cat( "plyr loop:", pts1, "\n") # empirical size
# about 1 minute


# compare to the parallel version

pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = TRUE,
            .paropts = list(.export = ls(envir=globalenv() )) )
pts1 = Sys.time() - pts0 # check time elapse
cat( "parallel loop with 8 cores:", pts1, "\n") # empirical size


