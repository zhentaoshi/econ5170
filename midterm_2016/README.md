Econ 5170 Computational Methods in Economics

The Chinese University of Hong Kong

# Midterm Exercises


## Stata Question

Download a data set of the OECD countries from [https://data.oecd.org/](https://data.oecd.org/). Collect the information on GDP (in current PPP), population, net capital stock (year 2010 = 100), and exchange rates (US = 1) from 2001 to 2010 for all the OECD countries. Conduct the following analysis in Stata. Hand in your do file, log file and all the outputs.

1. Calculate the mean and median of exchange rates across years for each country.
2. Generate a variable called pop1001, which equals to the country-specific difference in population between 2010 and 2001.
3. Draw a figure that shows the time trend of per capita GDP (in current PPP) for U.S., U.K., Germany, and the mean of these three countries. Nicely label the graph (including x-axis, y-axis, legend, etc).
4. Run a regression of GDP on population and net capital stock, using country fixed effects.
5. Run a regression of GDP on population and net capital stock, using lag population (population in t-1 period) as the instrument of population.


## R Question


A dataset is provided to evaluate the  log-likelihood function on a $20 \times 20$ grid system.

* `data.csv` contains a data set of 100 observations.
* `midterm.R` is an R-script to be completed.

#### Task 1

In the R-script,

* `loglike` is an empty shell to develop a log-likelihood function of the normal distribution with mean $\mu$ and standard deviation $\sigma$.
* `mu_grid` or `sigma_grid` each is a grid system of 20 points on which we evaluate the log-likelihood.


1. Write the log-likelihod function given the data.
2. After evaluating the log-likelihood function on each combination of $\mu$ and $\sigma$, store the results into a $20 \times 20$ matrix.
2. Draw the contour graph using `contour()`, and save it as a png file.
3. Add comments in the R-script for readability.

#### Task 2

Instead of using $\mu$ and $\sigma$ as the parameters, we reparameterize the log-likelihood function with two new parameters, $\theta_1 = \mu/\sigma$ and $\theta_2 = 1/\sigma$.

In the R-script,

* `loglike2` is an empty shell to develop a log-likelihood function of the normal distribution under the new parameterization.
* `theta1_grid` or `theta2_grid` each is a grid system of 20 points on which we evaluate the new log-likelihood.


1. Write the new log-likelihod function given the data.
2. After evaluating the new log-likelihood function on each combination of $\theta_1$ and $\theta_2$, store the results into a $20 \times 20$ matrix.
2. Draw the contour graph using `contour()`, and save it as a png file.
3. Add comments in the R-script for readability.
