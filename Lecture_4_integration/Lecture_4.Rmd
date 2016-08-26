# Lecture 4: Numerical and Statistical Integrations

Zhentao Shi

3/14/2016

## Computational Alternative to Analytical Methods

Integration and differentiation involve limits in their mathematical definitions. However, a modern computer is a finite-precision machine that can handle neither arbitrarily small nor arbitrarily big numbers. We attempt to bridge the gap by approximation.

### Numerical Derivatives

Numerical derivative is particularly convenient when the analytical alternative is
too complex. We do not want to program up those analytical expressions in the
trial-and-error stage.

Package `numDeriv`

* `grad` for a scalar-valued function
* `jacobian` for a real-vector-valued function
* `hessian` for a scalar-valued function
* `genD` for a real-vector-valued function


### Numerical Integration

* one-dimensional quadrature: `integrate`
* multi-dimensional quadrature: `adaptIntegrate` in the package `cubature`

## Simulated Methods

**Motivation example: a structural model with latent variables**

In the classical Roy model, a man can assume one of the two occupations: a farmer or a fisher. The utility of being a farmer is $U_1^{*} = x' \beta_1 + e_1$ and that of being a fisher is $U_2^{*} = x' \beta_2 + e_2$, where $U_1^{*}$ and $U_2^{*}$ are latent (unobservable). In reality, we observe the binary outcome $y=\mathbf{1}\{U_1^{*}> U_2^{*}\}$. If
$$
\begin{bmatrix}
e_1\\e_2
\end{bmatrix}
\sim N \left(
\begin{bmatrix}
0 \\ 0
\end{bmatrix},
  \begin{bmatrix}
  \sigma_1^2 & \sigma_{12} \\ \sigma_{12} & 1
  \end{bmatrix}\right)$$
where $\sigma_2^2$ is normalized to be 1, we can write down the log-likelihood of an observable sample as
$$L(\theta) = \sum_{i = 1}^n  \left\{ y_i \log P( U_{i1}^* > U_{i2}^* )
+ (1-y_i)\log P( U_{i1}^* \leq  U_{i2}^* ) \right\}.$$
The analytical form is complicated because of the presence of correlation in the joint distribution of $(e_1, e_2)$. What is worse, analytical form may not be obtainable if $(e_1, e_2)$ follows some other distribution.

The key difficulty of the analytical approach lies in the explicit form of
$$p(\theta|x_i) = P\left( U^*_{i1}(\theta) > U^*_{i2}(\theta) \right)
= P\left( x_i'(\beta_1 - \beta_2) + e_{i1} - e_{i2} > 0 \right), $$
which is complicated because of the correlation between $e_1$ and $e_2$.
However, given a trial value $\theta$, it is easy to simulate the probability by drawing artificial $(e^s_1, e^s_2)$ from a proposed distribution. In such a simulation approach, we estimate
$$
\hat{p}(\theta|x_i) = \frac{1}{S} \sum_{i=1}^S \mathbf{1}\left( U^{s*}_{i1}(\theta) > U^{s*}_{i2}(\theta) \right),
$$
where $s=1,\ldots,S$ is the index of simulation, and $S$ is the total number of simulation replications.

#### Generate Random Variables

If the CDF $F(X)$ is known and $U\sim \mathrm{Uniform}(0,1)$, then $F^{-1}(U)$ follows the distribution $F(X)$.

If the pdf $f(X)$ is known, we can generate a sample with such a distribution by the importance sampling.
Metropolis-Hastings algorithm is such a method.
R package `mcmc` implements Metropolis-Hastings algorithm.

**Example**: use [Metropolis-Hastings algorithm](https://en.wikipedia.org/wiki/Metropolis%E2%80%93Hastings_algorithm) to generate a sample of normally distributed observations.
```{r}
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


#### Optimization

[Expectation-Maximization algorithm](http://en.wikipedia.org/wiki/Expectation%E2%80%93maximization_algorithm) is an iterative estimation method for statistical models in which likelihood is difficult to express in explicit forms.

It is better to categorize the EM algorithm as a numerical optimization method assisted by simulation.

### Indirect Inference

* Economic structural model
* Reduced-form: (auxiliary model)
* Binding function: a mapping from the parameter space of the reduced-form to that
of the structural form.

**Example**: In the Roy model example, the structural parameter is $\theta = (\beta, \sigma_1^2, \sigma_{12} )$. The choice of the reduced-form model is not unique.
A sensible reduced-form model is the linear regression between $y_i$ and $x_i$.
A set of reduced-form parameters can be chosen as
$$
\begin{eqnarray*}
b_1 & = & (X'X)^{-1}X'y \\
b_2 & = & n^{-1}\sum_{y_i=1} (y_i - x_i' b_1)^2 = n^{-1}\sum_{y_i=1} (1 - x_i' b_1)^2  \\
b_2 & = & n^{-1}\sum_{y_i=0} (y_i - x_i' b_1)^2 = n^{-1}\sum_{y_i=0} (x_i' b_1)^2 \\
\end{eqnarray*}
$$
where in the binding function $b_1$ is associated with $\beta$, and $(b_2,b_3)$ are associated with $(\sigma_1^2,\sigma_{12})$.

**Example**: linear IV model.


### Simulated Method of Moments

Pakes and Pollard (1989): Simulation and the asymptotics of optimization estimators

Match moments generated the theoretical model with their empirical counterparts. The choice of the moments to be matched is not unique either. A set of valid choice is
$$
\begin{eqnarray*}
n^{-1} \sum_{i=1}^n x_i (y_i - \hat{p}(\theta | x_i)) &\approx & 0\\
n^{-1} \sum_{i=1}^n (y_i - \bar{y})^2 - \bar{\hat{p}}(\theta) (1- \bar{\hat{p}}(\theta)) &\approx & 0\\
n^{-1} \sum_{i=1}^n (x_i - \bar{x} ) (y_i - \hat{p}(\theta | x_i))^2 &\approx & 0\\
\end{eqnarray*}
$$
where $\bar{y} = n^{-1} \sum_{i=1}^n y_i$ and
$\bar{\hat{p}}(\theta) = n^{-1} \sum_{i=1}^n p(\theta|x_i)$.
The first set of moments is justified by the independence of $(e_{i1}, e_{i2})$ and $x_i$ so that $E[x_i y_i] = x_i E[y_i | x_i] = x_i p(\theta|x_i)$, and the second set matches the variance of $y_i$.
Moreover, we need to choose a weighting matrix $W$ to form a quadratic criterion for GMM.




### Markov Chain Monte Carlo

#### Laplace-type estimator

Chernozhukov and Hong (2003): An MCMC approach to classical estimation


If we know the distribution of an extremum estimator, then *asymptotically* the point estimator equals its mean under the quadratic loss function, and equals its median under the absolute-value loss function.

The *Laplace-type estimator* (LTE) transforms the value of the criterion function of an extremum estimator into a probability weight. In a minimization problem, the smaller is the value of the criterion function, the larger it weighs.

**Example**: LTE estimation for linear regression
```
library(mcmc)

# DGP
n = 100
b0 = c(1,2)
X = cbind(1, rnorm(n))
Y = X %*% b0 + rnorm(n)

# Laplace-type estimator
L = function(b) -sum( (Y - X %*% b )^2 )  # criterion function

out = metrop( obj = L, initial = c(0,0), nbatch = 10000, nspac = 10  )

# summarize the estimation
bhat2 = out$batch[,2]
bhat2_point = mean(bhat2)
bhat2_var   = var(bhat2)
bhat2_CI = quantile(bhat2, c(.025, .975) )

# compare with OLS
b_OLS = summary( lm(Y~-1+X) )
```





## Extended Readings

* Arcidiacono and Jones (2003): [Finite Mixture Distributions, Sequential Likelihood and the EM Algorithm](http://www.jstor.org/stable/1555527?seq=1#page_scan_tab_contents)
* Gourieroux, Monfort and Renault (1993): [Infirect Inference](http://onlinelibrary.wiley.com/doi/10.1002/jae.3950080507/abstract)
