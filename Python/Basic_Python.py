var1 = 11 #The data type of var is number
var1 = 'python' #The 'var' variable is now of string type.


var1 = 'hello world'
var2 = "I'm good."
var3 = """This is a string that will
span across multiple lines."""

A = [] #This is a blank list variable
B = [1, 23, 'bye'] #Lists can contain different variable types.
C = [[1, 2], ['SEE'], []]
s1 = [1, 2, 3]
s2 = [4, 5]
s1.extend(s2) # extend is to add the elements in the list at the end of s1
s1.append(s2) # append is to add the list s2 at the end of s1

# originally it was s3 = s1.extend(s2) 
# it was wrong. 
# The method was applied to an object. Cannot assign it to a new object.
# #s3 is now [1, 2, 3, 4, 5]



kk = zip([1,2,3], [4,5] ); list( kk )
kk = range(10); list(kk) # the start index is 0, not 1!



#######
logi_1 = [True, True, False]
logi_2 = [False, True, True]
logi_12 =  logi_1 and logi_2

import numpy as np
logi_comb = np.concatenate([logi_1, logi_2])
# this is equivalent to logi_1+logi_2

logi_34 = all( [logi_1, logi_2] )

####

x = [1,5,2]
y = [7,4,1]

x + y # surprusingly, this is c(x,y) as in R

# to do numerical work, we must haved defined it as numpy arrary
x = np.array([1, 5, 2])
y = np.array([7, 4, 1])
x + y #[8, 9, 3]

x // y #Integer division: [0, 1, 2]

x % y #[1, 1, 0]

X = np.array([[2, 3], [3, 5]])
Y = np.array([[1, 2], [5, -1]])
X * Y #element-wise multiplication: array([ [2, 6], [15, -5]])

np.dot(X, Y) #matrix multiplication: matrix([ [17, 1], [28, 1]])
np.mat(X) * np.mat(Y) #matrix multiplication: matrix([ [17, 1], [28, 1]])

X = np.mat([[2, 3], [3, 5]])
Y = np.mat([[1, 2], [5, -1]])
X * Y #matrix multiplication: matrix([ [17, 1], [28, 1]])


########################
import random
import numpy as np

np.random.seed(111)
n = 100
b0 = np.mat( [[1], [1]] )
e = np.random.normal(size = (n, 1))
X = np.column_stack((np.full((n, 1), 1), np.random.normal(size = (n, 1))))
Y = np.dot(X, b0) + e

bhat = np.linalg.solve( X.T @ X, X.T @ Y) # estimation


#### plot 
import matplotlib.pyplot as plt

plt.plot(X[:, 1], Y, 'o') # this is because the index starts from 0
# so X[:,1] is the second column
plt.plot(X[:, 1], np.dot(X, b0), color='red', linestyle='-') # true conditional mean
plt.plot(X[:, 1], np.dot(X, bhat), color='black', linestyle='-') # y_hat
plt.title('regression')
plt.xlabel('X')
plt.ylabel('Y')
plt.axhline(0, color = 'black', linestyle = 'dashed')
plt.axvline(0, color = 'black', linestyle = 'dashed')

plt.show()


### t statistic
import math

bhat2 = bhat[1, 0] # the row index is 1 and the column index is 0 
# in R, this shoulbe hat bhat[ 2,1 ]
e_hat = Y - X @ bhat
sigma_hat_square = e_hat.T @ e_hat / (n - 2) # .T is the method of transpose
Sigma_B = np.linalg.inv( X.T @ X ) * np.array( sigma_hat_square )
t_value_2 = (bhat2 - b0[1, 0]) / math.sqrt(Sigma_B[1, 1])

print(t_value_2)


#################
import seaborn as sns
from scipy import stats
import numpy as np
import matplotlib.pyplot as plt

x = np.linspace(0.01, 16, num = 1600)
y = stats.chi2.pdf(x, 3)

z = stats.chi2.rvs(3, size = 1000)
plt.plot(x, y, linestyle = '-', color = 'black')
sns.distplot(z, hist = False, color = 'red')
plt.xlim(-0.5, 16)
plt.ylim(-0.01, 0.25)
plt.xlabel('X')
plt.ylabel('density')
plt.show()

crit = stats.chi2.ppf(q = 0.95, df = 3)

print(len([i for i in z if i > crit]) / len(z)) # don't quite understand this line

####### self defined function

import math
import statistics

def CI(x:int):

  #x is a vector of random variables
  n = len(x)  
  
  x = np.array( x, dtype = float) # THIS LINE IS CRUCIAL; otherwise the result is wrong
  mu = statistics.mean(x)
  sig = statistics.stdev(x)
  upper = mu + 1.96 * sig / math.sqrt(n) 
  lower = mu - 1.96 * sig / math.sqrt(n)
  return {'lower': lower, 'upper': upper}


## the CI simulation exercise

import statistics
from scipy import stats
import numpy as np

Rep = 100
sample_size = 50
capture = [0] * Rep

# random.seed(3)
# start the iteration
for i in range(Rep):
  mu = 5
  # x = stats.norm.rvs(mu, size = sample_size, random_state = None ) # generate random variables 
  x = stats.poisson.rvs(mu = mu, size = sample_size, random_state = None ) # generate random variables 
  print(i)
  print(x)
    
  bounds = CI(x)

  if (bounds['lower'] <= mu and mu <= bounds['upper']):
    capture[i] = 1

print(statistics.mean(capture))

###########################################
####### OLS estimation 

import numpy as np
from scipy import stats
import statsmodels.api as sm
import matplotlib.pyplot as plt

T = 100
p = 2
b0 = np.mat( [[1], [2]] )

#generate data

x = stats.norm.rvs(size = (T, p) ) 
y = x @ b0 + stats.norm.rvs(size = (T , 1) )
# this y is a matrix

# or y = np.(x, b0) + stats.norm.rvs(size = T ) 
# this y is an array


#Linear model

model = sm.OLS(y, x)
results = model.fit()
print(results.summary())


plt.plot(results.fittedvalues, color = 'red', label = 'Fitted Value')
plt.plot(y, color = 'blue', linestyle = 'dashed', label = 'True Value')
plt.title('Fitted Value')
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.show()
  



plt.scatter(x[:,0], np.array(y), color = 'black', marker = 'o')
# Python is quite restrict on the consistency of array and matrix
plt.title('Fitted Value')
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.show()  