### Logical variables

logi_1 = [True,True,False]
logi_2 = [False,True,True]

logi_12 = logi_1 and logi_2
print(logi_12)

### OLS simulation

import numpy as np
from numpy.linalg import inv

np.random.seed(1)
# set the parameters

n = 100
b0 = np.ones ( ( 2, 1) )

# generate the data
e = np.random.randn(n,1) 
X = np.hstack( (np.ones ( ( n, 1) ),  np.random.randn(n,1)  ) )
Y = np.dot(X, b0) + e

# OLS estimator
bhat = np.dot( inv( np.dot(np.transpose(X), X ) ),   
              np.dot( np.transpose(X), Y ) ) 
print(bhat)