library(AER)

# Poisson likelihood
poisson.loglik = function( b ) {
  b = as.matrix( b )
  lambda =  exp( X %*% b )
  ell = -sum( -lambda + y *  log(lambda) )
  return(ell)
}

## prepare the data
data("RecreationDemand")
y =  RecreationDemand$trips
X =  with(RecreationDemand, cbind(1, income) )

## estimation
library(optimx)
b.init =  c(0,1)  # initial value
b.hat = optimx( b.init, poisson.loglik, method = c("BFGS", "Nelder-Mead"), 
                 control = list(reltol = 1e-7, abstol = 1e-7)  )
print( b.hat )



## contour plot
x.grid = seq(0, 2, 0.05)
x.length = length(x.grid)
y.grid = seq(-.5, .2, 0.01)
y.length = length(y.grid)

z.contour = matrix(0, nrow = x.length, ncol = y.length)

for (i in 1:x.length){
  for (j in 1:y.length){
    z.contour[i,j] = poisson.loglik( c( x.grid[i], y.grid[j] )  )
  }
}

filled.contour( x.grid,  y.grid, z.contour)



## alternative package
library(nloptr)
opts = list("algorithm"="NLOPT_LN_NELDERMEAD",
            "xtol_rel"=1.0e-7)
# check the solver status

res_NM = nloptr(x0=b.init, 
               eval_f=poisson.loglik, 
               opts=opts)
print( res_NM )


opts = list("algorithm"="NLOPT_LN_NELDERMEAD",
            "xtol_rel"=1.0e-7,
            "maxeval" = 500
)

res_NM = nloptr( x0=b.init, 
                 eval_f=poisson.loglik, 
                 opts=opts)
print( res_NM )

## 
opts = list("algorithm"="NLOPT_LD_SLSQP","xtol_rel"=1.0e-7)
res_BFGS = nloptr( x0=b.init, 
               eval_f=poisson.loglik, 
               opts=opts)
print( res_BFGS )
# the above code will report error. must provide a gradient

poisson.loglik.grad = function( b ) {
  b = as.matrix( b )
  lambda =  exp( X %*% b )
  ell = -colSums( -as.vector(lambda) * X + y *  X )
  return(ell)
}

# check the numerical gradient and the analytical gradient
library(numDeriv)

b = c(0,.5)
grad(poisson.loglik, b)
poisson.loglik.grad(b)


res_BFGS = nloptr( x0=b.init, 
                   eval_f=poisson.loglik, 
                   eval_grad_f = poisson.loglik.grad,
                   opts=opts)
print( res_BFGS )


