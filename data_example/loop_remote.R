library(plyr)
library(foreach)
library(doParallel)

# prepare the functions
mu <- 2
CI <- function(x) {
  # x is a vector of random variables

  n <- length(x)
  mu <- mean(x)
  sig <- sd(x)
  upper <- mu + 1.96 / sqrt(n) * sig
  lower <- mu - 1.96 / sqrt(n) * sig
  return(list(lower = lower, upper = upper))
}

capture <- function() {
  x <- rpois(sample_size, mu)
  bounds <- CI(x)
  return((bounds$lower <= mu) & (mu <= bounds$upper))
}

############ implementation ###############
Rep <- 400
sample_size <- 5000000

# compare to the parallel version
registerDoParallel(16) # opens other CPUs

pts0 <- Sys.time() # check time
out <- foreach(icount(Rep), .combine = c) %dopar% {
  capture()
}

cat("empirical coverage probability = ", mean(out), "\n") # empirical size
pts1 <- Sys.time() - pts0 # check time elapse
print(pts1)

pts0 <- Sys.time()
out <- foreach(icount(Rep), .combine = c) %do% {
  capture()
}
cat("empirical coverage probability = ", mean(out), "\n") # empirical size
pts1 <- Sys.time() - pts0 # check time elapse
print(pts1)
