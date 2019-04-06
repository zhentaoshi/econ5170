# -*- coding: utf-8 -*-

"""
Created on Sat Dec  8 00:01:06 2018

@author: Zhentao
"""


import numpy as np

def poissonLoglik( b ):
  lamb = np.exp( X @ b )
  ell = -np.sum( lamb + np.multiply(y,   np.log(lamb) ) )
  return ell
    
# data
n = 10
X = np.hstack( [ np.ones((n,1)),  np.random.randn(n, 2) ] )
b0 = np.mat([[1],[-1],[0]])
y = np.random.poisson( lam = np.exp( X @ b0 ) ).reshape((n,1))



poissonLoglik(b0)