library(Matrix)

# data source: https://archive.ics.uci.edu/ml/datasets/Bank+Marketing

bank_0 = read.csv("bank-full.csv", header = TRUE, sep = ";" )
bank_0$y01 = (bank_0$y == "yes")



X = as.matrix( cbind(1, bank_0[, c("age", "balance")] ) )
reg0 = lm(y01 ~ X - 1, data = bank_0)
e_hat = residuals(reg0)



n = nrow(bank_0)
K = ncol(X)





for (opt in c(1,3,4,2)){
  
  pts0 = Sys.time()

    
    XXe2 = matrix(0, nrow = K, ncol = K)
    
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
      Xe = X * e_hat
      XXe2 = t(Xe) %*% Xe
    }

  cat("n = ", n, ", opt = ", opt, ", time = ", Sys.time() - pts0, "\n")
}