# data source: https://archive.ics.uci.edu/ml/datasets/IPUMS+Census+Database

# this is a demonstration of the time efficiency in the computation of
# the heteroskedastic-robust variance


library(magrittr)


d99 = readr::read_csv( file = "ipums.la.99.csv", col_names = FALSE)
d98 = readr::read_csv( file = "ipums.la.98.csv", col_names = FALSE)
d97 = readr::read_csv( file = "ipums.la.97.csv", col_names = FALSE)
d0 = rbind(d97, d98, d99)

X =  cbind(1, d0[, c("X20", "X22")])  %>% as.matrix
y = d0$X11

e_hat = lm(y ~ X - 1) %>% residuals()

n = nrow(d0)
K = ncol(X)



for (opt in c(1,3,4)){ # option 2 takes too much time. We omit it.

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
    e_hat2_M = Matrix::Matrix( 0, ncol = n, nrow = n)
    diag(e_hat2_M) = e_hat^2
    XXe2 = t(X) %*% e_hat2_M %*% X
  } else if (opt == 4)  {# the best vectorization method. No waste
    Xe = X * e_hat
    XXe2 = t(Xe) %*% Xe
  }

  cat("outcome = ", as.vector(XXe2), ", opt = ", opt, ", time = ", Sys.time() - pts0, "\n")
}
