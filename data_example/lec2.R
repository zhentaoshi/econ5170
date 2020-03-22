# this script stores functions used
# in Lec 2: advanced R

lpm <- function(n) {
  # estimation in a linear probability model

  # set the parameters
  b0 <- matrix(c(-1, 1), nrow = 2)

  # generate the data
  e <- rnorm(n)
  X <- cbind(1, rnorm(n)) # you can try this line. See what is the difference.
  Y <- (X %*% b0 + e >= 0)
  # note that in this regression b0 is not converge to b0 because the model is changed.

  # OLS estimation
  bhat <- solve(t(X) %*% X, t(X) %*% Y)

  # calculate the t-value
  bhat2 <- bhat[2] # parameter we want to test
  e_hat <- Y - X %*% bhat
  return(list(X = X, e_hat = as.vector(e_hat)))
}


CI <- function(x) { # construct confidence interval
  # x is a vector of random variables

  n <- length(x)
  mu <- mean(x)
  sig <- sd(x)
  upper <- mu + 1.96 / sqrt(n) * sig
  lower <- mu - 1.96 / sqrt(n) * sig
  return(list(lower = lower, upper = upper))
}
