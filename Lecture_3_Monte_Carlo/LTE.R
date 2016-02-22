library(mcmc)

n = 100
b0 = c(1,2)
X = cbind(1, rnorm(n))
Y = X %*% b0 + rnorm(n)
b_OLS = summary( lm(Y~-1+X) )


L = function(b) -sum( (Y - X %*% b )^2 ) 

out = metrop( obj = L, initial = c(0,0), nbatch = 10000, nspac = 10  )
bhat2 = out$batch[,2]
bhat2_point = mean(bhat2)
bhat2_var   = var(bhat2)
bhat2_CI = quantile(bhat2, c(.025, .975) )

