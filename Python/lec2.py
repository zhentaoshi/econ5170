# -*- coding: utf-8 -*-
"""
Created on Tue Nov 27 00:31:19 2018

@author: Zhentao
"""

#%%
import numpy as np
import statistics as st
from scipy import stats
import math
# construct confidence interval

def CI(x:int):

  #x is a vector of random variables
  n = len(x)  
  
  x = np.array( x, dtype = float) # THIS LINE IS CRUCIAL; otherwise the result is wrong
  mu = st.mean(x)
  sig = st.stdev(x)
  upper = mu + 1.96 * sig / math.sqrt(n) 
  lower = mu - 1.96 * sig / math.sqrt(n)
  return {'lower': lower, 'upper': upper}

#%%
Rep = 1000
sample_size = 20

capture = np.zeros(Rep, int)

for i in range(Rep):
  mu = 5
  # x = stats.norm.rvs(mu, size = sample_size, random_state = None ) # generate random variables 
  x = stats.poisson.rvs(mu = mu, size = sample_size, random_state = None ) # generate random variables 
  print(i)
    
  bounds = CI(x)

  if (bounds['lower'] <= mu and mu <= bounds['upper']):
    capture[i] = 1

print("empirical coverage probability = %f", np.mean(capture), "\n")

#%%





########### parallel 
library(plyr)
library(foreach)
library(doParallel)

registerDoParallel(2) # opens other CPUs

pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = TRUE,
            .paropts = list(.export = ls(envir=globalenv() )) )
cat( "empirical coverage probability = ", mean(out$V1), "\n") # empirical size
pts1 = Sys.time() - pts0 # check time elapse
print(pts1)
# this parallel indeed takes more time 




###########################
Rep = 200
sample_size = 5000000
pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = FALSE) 
cat( "empirical coverage probability = ", mean(out$V1), "\n") # empirical size
pts1 = Sys.time() - pts0 # check time elapse
print(pts1)
# about 1 minute


# compare to the parallel version
registerDoParallel(2) # opens other CPUs

pts0 = Sys.time() # check time
out = ldply(.data = 1:Rep, .fun = capture, .parallel = TRUE,
            .paropts = list(.export = ls(envir=globalenv() )) ) 
cat( "empirical coverage probability = ", mean(out$V1), "\n") # empirical size
pts1 = Sys.time() - pts0 # check time elapse
print(pts1)

