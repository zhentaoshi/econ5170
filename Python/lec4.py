import numpy as np


n = 10000
Z =  np.random.rand(n,2)-0.5
# uniform distribution ranging (0,1)
hit =  np.sum( np.square(Z), axis = 1)    <=  0.5**2 
inside = np.mean( hit ) 
# the center of the cirle is (0.5,0.5)
pi_hat = 4 * inside # the area of a circle = pi * r ** 2
print(pi_hat)