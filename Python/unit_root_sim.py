# -*- coding: utf-8 -*-
"""
Created on Thu Nov 29 22:40:02 2018

@author: Zhentao
"""

# unit root


#%%
import numpy as np


def AR(a,T):
    y = np.zeros((T,1))
    for t in range(1,T):
        y[t] = a * y[t-1] + np.random.randn(1)
    return y


#%%
    
# without drift in the regression
T = 100
a = 1.0

Rep = 1000
Bhat0 = np.zeros(Rep)

for r in range(Rep):
    Y = AR(a,T)
    y = Y[1:(T+1)]
    x = Y[range(T-1)]
    bhat = np.linalg.lstsq(x , y, rcond=None)[0]
    Bhat0[r] = bhat

#%%

# using PyPlot

import matplotlib.pyplot as plt
import seaborn as sns

sns.distplot(Bhat0)


#%%

# with a drift in the regression

Bhat = np.zeros(Rep)

for r in range(Rep):
    Y = AR(a,T)
    y = Y[1:(T+1)]
    x = np.column_stack( (np.ones((T-1,1)), Y[range(T-1)] ) )
    bhat = np.linalg.lstsq(x , y, rcond=None)[0]
    Bhat[r] = bhat[1]

#%%

# using PyPlot

import matplotlib.pyplot as plt
import seaborn as sns

sns.distplot(Bhat)
