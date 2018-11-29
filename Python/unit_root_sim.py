# -*- coding: utf-8 -*-
"""
Created on Thu Nov 29 22:40:02 2018

@author: Zhentao
"""

# unit root


#%%
import numpy as np


def AR(a,T):
    y = np.zeros(T)
    for t in range(1,T):
        y[t] = a * y[t-1] + np.random.randn(1)
    return y


#%%
T = 100
a = 1.0

Rep = 1000
Bhat = np.zeros(Rep)

for r in range(Rep):
    Y = AR(a,T)
    y = Y[1:(T+1)]; y = np.reshape(y,(-1,1))
    x = Y[range(T-1)]; x = np.reshape(x,(-1,1))
    bhat = np.linalg.lstsq(x , y, rcond=None)[0]
    Bhat[r] = bhat

#%%

# using PyPlot

import matplotlib.pyplot as plt
import seaborn as sns

sns.distplot(Bhat)