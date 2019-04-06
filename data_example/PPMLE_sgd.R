

poisson.loglik = function( b, y, X ) {
  b = as.matrix( b )
  lambda =  exp( X %*% b )
  ell = -mean( -lambda + y *  log(lambda) )
  return(ell)
}


poisson.loglik.grad = function( b, y, X ) {
  b = as.matrix( b )
  lambda =  as.vector( exp( X %*% b ) )
  ell = -colMeans( -lambda * X + y * X )
  ell_eta = ell 
  return(ell_eta)
}

################################3

##### generate the artificial data
nn = 1e5; K = 100
X = cbind(1, matrix( runif( nn*(K-1) ), ncol = K-1 ) )
b0 = rep(1, K) / K
y = rpois(nn, exp( X %*% b0 ) )


b.init = runif(K); b.init  = 2 * b.init / sum(b.init)


#####################################################
# sgd depends on 
# * eta: the learning rate
# * epoch: the averaging small batch
# * the initial value

# and these tuning parameters are related to N and K

n = length(y)
test_ind = sample(1:n, round(0.2*n) )

y_test = y[test_ind]
X_test = X[test_ind, ]

y_train = y[-test_ind ]
X_train = X[-test_ind, ]

# optimization parameters
max_iter = 5000
min_iter = 20
eta=0.01
epoch = round( 100*sqrt(K) )

  
b_old = b.init

pts0 = Sys.time()
# the iteration of gradient
for (i in 1:max_iter ){
  
  loglik_old = poisson.loglik(b_old, y_train, X_train)
  i_sample = sample(1:length(y_train), epoch, replace = TRUE )
  b_new = b_old - eta * poisson.loglik.grad(b_old, y_train[i_sample], X_train[i_sample, ])
  loglik_new = poisson.loglik(b_new, y_test, X_test)
  b_old = b_new # update
  
  criterion =  loglik_old - loglik_new  
  cat( "the ", i, "-th criterion = ",   criterion, "\n")
  
  if (  criterion < 0.0001 & i >= min_iter ) break
}
cat("point estimate =", b_new, ", log_lik = ", loglik_new, "\n")
pts1 = Sys.time( ) - pts0
print(pts1)


# optimx is too slow for this dataset.
# Nelder-Mead method is too slow for this dataset

# thus we only sgd with NLoptr

opts = list("algorithm"="NLOPT_LD_SLSQP","xtol_rel"=1.0e-7, maxeval = 5000)


pts0 = Sys.time( )
res_NM = nloptr::nloptr( x0=b.init,
                 eval_f=poisson.loglik,
                 eval_grad_f = poisson.loglik.grad,
                 opts=opts,
                 y = y_train, X = X_train)
print( res_NM )
pts1 = Sys.time( ) - pts0
print(pts1)

b_hat_nlopt = res_NM$solution


#### evaluation in the test sample 
cat("\n\n\n\n\n\n\n")
cat("log lik in test data by sgd = ", poisson.loglik(b_new, y = y_test, X_test), "\n")
cat("log lik in test data by nlopt = ", poisson.loglik(b_hat_nlopt, y = y_test, X_test), "\n")
cat("log lik in test data by oracle = ", poisson.loglik(b0, y = y_test, X_test), "\n")
