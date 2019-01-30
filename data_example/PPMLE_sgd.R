library(AER)
library(numDeriv)
library(optimx)



poisson.loglik = function( b, y, X ) {
  b = as.matrix( b )
  lambda =  exp( X %*% b )
  ell = -mean( -lambda + y *  log(lambda) )
  return(ell)
}


poisson.loglik.grad = function( b, y, X, eta=1 ) {
  b = as.matrix( b )
  lambda =  as.vector( exp( X %*% b ) )
  ell = -colMeans( -lambda * X + y *  X )
  return(eta*ell)
}


poisson.loglik.grad.nlopt = function( b, y, X) {
  b = as.matrix( b )
  lambda =  as.vector( exp( X %*% b ) )
  ell = -colMeans( -lambda * X + y *  X )
  return(ell)
}

## prepare the data
# data("RecreationDemand")
# y =  RecreationDemand$trips
# X =  with(RecreationDemand, cbind(1, income) )

nn = 1e5 # start from 1000 to 1e4 to 1e6
K = 100
X = cbind(1, matrix( runif( nn*(K-1) ), ncol = K-1 ) )
b0 = rep(1, K) / K
y = rpois(nn, exp( X %*% b0 ) )

## estimation
# b.init = runif( K) # runif(K) # c(1,0)
# b.init = .01 * rep(1, K)
# b.init = c( rep(1,5), rep(0, K-5) ) 
# b.init = rnorm(2)

b.init = runif(K); b.init  = 2 * b.init / sum(b.init)



#####################################################

n = length(y)


test_ind = sample(1:n, round(0.2*n) )

y_test = y[test_ind]
X_test = X[test_ind, ]

y_train = y[-test_ind ]
X_train = X[-test_ind, ]

b_old = b.init

pts0 = Sys.time()
max_iter = 5000
min_iter = 20

for (i in 1:max_iter ){
  
  
  loglik_old = poisson.loglik(b_old, y_train, X_train)
  i_sample = sample(1:length(y_train), round( 100*sqrt(K) ), replace = TRUE )
  b_new = b_old - poisson.loglik.grad(b_old, y_train[i_sample], X_train[i_sample, ], eta=0.01)
  loglik_new = poisson.loglik(b_new, y_test, X_test)
  b_old = b_new # update
  
  criterion =  loglik_old - loglik_new  
  cat( "the ", i, "-th criterion = ",   criterion, "\n")
  
  if (  criterion < 0.00001 & i >= min_iter ) break
  
  
}
cat("point estimate =", b_new, ", log_lik = ", loglik_new, "\n")
pts1 = Sys.time( ) - pts0
print(pts1)

# ##########################
# pts0 = Sys.time( )
# b.hat = optimx( b.init, poisson.loglik, y=y_train, X=X_train,
#                 method = c("BFGS", "Nelder-Mead"),
#                 control = list(reltol = 1e-7,
#                                abstol = 1e-7)  )
# print( b.hat )
# pts1 = Sys.time( ) - pts0
# print(pts1)
# 
# 
# pts0 = Sys.time( )
# b.hat = optimx( b.init, poisson.loglik, y=y_train, X=X_train,
#                 gr = poisson.loglik.grad.nlopt,
#                 method = c("BFGS", "Nelder-Mead"),
#                 control = list(reltol = 1e-7,
#                                abstol = 1e-7)  )
# print( b.hat )
# pts1 = Sys.time( ) - pts0
# print(pts1)

###############################################


library(nloptr)
## optimization with NLoptr




# opts = list("algorithm"="NLOPT_LN_NELDERMEAD",
#             "xtol_rel"=1.0e-7,
#             maxeval = 5000
# )
# pts0 = Sys.time( )
# res_NM = nloptr( x0=b.init,
#                  eval_f=poisson.loglik,
#                  opts=opts,
#                  y = y_train, X = X_train)
# print( res_NM )
# 
# pts1 = Sys.time( ) - pts0
# print(pts1)

# "SLSQP" is indeed the BFGS algorithm in NLopt,
# though "BFGS" doesn't appear in the name
opts = list("algorithm"="NLOPT_LD_SLSQP","xtol_rel"=1.0e-7, maxeval = 5000)




pts0 = Sys.time( )
res_NM = nloptr( x0=b.init,
                 eval_f=poisson.loglik,
                 eval_grad_f = poisson.loglik.grad.nlopt,
                 opts=opts,
                 y = y_train, X = X_train)
print( res_NM )
pts1 = Sys.time( ) - pts0
print(pts1)

b_hat_nlopt = res_NM$solution

cat("\n\n\n\n\n\n\n")
cat("log lik in test data by sgd = ", poisson.loglik(b_new, y = y_test, X_test), "\n")
cat("log lik in test data by nlopt = ", poisson.loglik(b_hat_nlopt, y = y_test, X_test), "\n")
cat("log lik in test data by oracle = ", poisson.loglik(b0, y = y_test, X_test), "\n")
