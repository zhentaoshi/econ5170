# Lecture 4: Numerical and Statistical Integrations

Zhentao Shi

3/14/2016



### Markov Chain Monte Carlo

Chernozhukov and Hong (2003): An MCMC approach to classical estimation

#### Metropolis-Hastings algorithm

Metropolis-Hastings algorithm is a simulation method that generates a random sample of desirable density $f(x)$ over its sample space.

To implement Metropolis-Hastings algorithm in R, I recommend `install.packages("mcmc")`.

Example: use Metropolis-Hastings algorithm to generate a sample of normally distributed observations.
```{r,eval=F}
library(mcmc)
h = function(x){ y = -x^2 / 2 } # the log, unnormalized function

out = metrop( obj = h, initial = 0, nbatch = 100, nspac = 1  )
plot(out$batch, type = "l") # a time series with flat steps

out = metrop( obj = h, initial = 0, nbatch = 100, nspac = 10  )
plot(out$batch, type = "l") # a time series looks like a white noise

out = metrop( obj = h, initial = 0, nbatch = 10000, nspac = 10  )
summary(out)
plot(density(out$batch))
```



#### Laplace-type estimator

If we know the distribution of an extremum estimator, then *asymptotically* the point estimator equals its mean under the quadratic loss function, and equals its median under the absolute-value loss function.

The *Laplace-type estimator* transforms the value of the criterion function of an extremum estimator into a probability weight. In a minimization problem, the smaller is the value of the criterion function, the larger it weighs.

Example: LTE estimation for linear regression
```{r,eval=F}
library(mcmc)

# DGP
n = 100
b0 = c(1,2)
X = cbind(1, rnorm(n))
Y = X %*% b0 + rnorm(n)

# Laplace-type estimator
L = function(b) -sum( (Y - X %*% b )^2 )  % criterion function

out = metrop( obj = L, initial = c(0,0), nbatch = 10000, nspac = 10  )

# summarize the estimation
bhat2 = out$batch[,2]
bhat2_point = mean(bhat2)
bhat2_var   = var(bhat2)
bhat2_CI = quantile(bhat2, c(.025, .975) )

# compare with OLS
b_OLS = summary( lm(Y~-1+X) )
```


### Bayes Estimation

Example: linear regression with normal error.

#### Gibbs sampling

Gibbs sampling is an MCMC method that is used to generate a multivariate distribution when its marginal distribution of each component is easy to calculate.

Application: the linear regression model with many coefficients.



### Simulated Method of Moments

Pakes and Pollard (1989): Simulation and the asymptotics of optimization estimators


Integration and differentiation involve limits in their mathematical definitions. However, a modern computer is a finite-precision machine that can handle neither arbitrarily small nor arbitrarily big numbers. Approximation must be invoked to bridge the gap.

### Numerical Integration

* one-dimensional quadrature: `integrate`
* multi-dimensional quadrature: `adaptIntegrate` in the package `cubature`

### Numerical Derivatives

Package `numDeriv`

* `grad` for a scalar-valued function
* `jacobian` for a real-vector-valued function
* `hessian` for a scalar-valued function
* `genD` for a real-vector-valued function


## Statistical Integration

### Importance Sampling

### EM algorithm

[Expectation-Maximization algorithm](http://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) is an iterative etimation method for statistical models in which likelihood is difficult to express in explicit forms.

Example: parametric Roy model

### Indirect Inference

* Economic structural model
* Auxiliary model
* Binding function

Example

* simultaneous equations system
* parametric Roy model


## Extended Readings

* Arcidiacono and Jones (2003): [Finite Mixture Distributions, Sequential Likelihood and the EM Algorithm](http://www.jstor.org/stable/1555527?seq=1#page_scan_tab_contents)
* Gourieroux, Monfort and Renault (1993): [Infirect Inference](http://onlinelibrary.wiley.com/doi/10.1002/jae.3950080507/abstract)
