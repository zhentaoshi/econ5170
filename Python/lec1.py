# %reset

### Logical variables

logi_1 = [True,True,False]
logi_2 = [False,True,True]

logi_12 = logi_1 and logi_2
print(logi_12)

### OLS simulation
from pylab import *
import numpy as np

np.random.seed(1)
# set the parameters

n = 100
b0 = ones ( ( 2, 1) )

# generate the data
e = np.random.randn(n,1) 
X = hstack( (ones ( ( n, 1) ),  np.random.randn(n,1)  ) )
Y = dot(X, b0) + e

# OLS estimator
bhat = dot( inv( dot( X.T, X ) ), dot( X.T, Y ) ) 
print(bhat)