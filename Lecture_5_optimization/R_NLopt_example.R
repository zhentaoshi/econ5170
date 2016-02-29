library(nloptr)

###############################
N = 1000
b0 = rep(1,3)
X = cbind(1, rnorm(N), rnorm(N) )
y = X %*% b0 + rnorm(N)

eval_f <- function(b) 0.5 * sum( ( y - X %*% b)^2 ) 



 eval_grad_f <- function(b)  return(  -t(X) %*% ( y - X%*%b )  )
 

b_init = rep(5,3)

opts <- list("algorithm"="NLOPT_LN_NELDERMEAD",
             "xtol_rel"=1.0e-8)

res <- nloptr( x0=b_init, 
               eval_f=eval_f, 
               eval_grad_f=eval_grad_f,
               opts=opts)

print( res )


