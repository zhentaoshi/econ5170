# Zhentao Shi. 4/6/2015

# an example of robust matrix, sparse matrix. Vecteroization.
rm(list = ls( ) )
library(Matrix)

set.seed(111)

n = 6000; Rep = 10; # Matrix is quick, matrix is slow, adding is OK
# n = 50; Rep = 1000;  # Matrix is slow,  matrix is quick, adding is OK

for (opt in 1:4){
  
  pts0 = Sys.time()
  
  for (iter in 1:Rep){
    # set the parameters
    b0 = matrix( c(-1,1), nrow = 2 )
    
    # generate the data
    e = rnorm(n)
    X = cbind( 1, rnorm(n) ) # you can try this line. See what is the difference.
    Y = (X %*% b0 + e >=0 ) # note that in this regression b0 is not converge to b0 because the model is changed.
    
    
    # OLS estimation
    bhat = solve( t(X) %*% X, t(X)%*% Y ) 
    
    
    # calculate the t-value
    bhat2 = bhat[2] # parameter we want to test
    e_hat = Y - X %*% bhat
    
    XXe2 = matrix(0, nrow = 2, ncol = 2)
    
    if (opt == 1){
      for ( i in 1:n){
        XXe2 = XXe2 + e_hat[i]^2 * X[i,] %*% t(X[i,])
      }
    } else if (opt == 2) {# the vectorized version
      e_hat2_M = matrix(0, nrow = n, ncol = n)
      diag(e_hat2_M) = e_hat^2
      XXe2 = t(X) %*% e_hat2_M %*% X
    } else if (opt == 3)  {# the vectorized version
      e_hat2_M = Matrix( 0, ncol = n, nrow = n)
      diag(e_hat2_M) = e_hat^2
      XXe2 = t(X) %*% e_hat2_M %*% X
    } else if (opt == 4)  {# the best vectorization method. No waste
      Xe = X * e
      XXe2 = t(Xe) %*% Xe
    } 
    
    
    XX_inv = solve( t(X) %*% X  )
    sig_B =  XX_inv %*% XXe2 %*% XX_inv 
  }
  cat("n = ", n, ", Rep = ", Rep, ", opt = ", opt, ", time = ", Sys.time() - pts0, "\n")
}

