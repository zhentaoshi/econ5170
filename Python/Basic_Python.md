## Help System:

The help system is the first thing we must learn for a new language. In Python, if we know the exact name of a
function and want to check its usage, we can call help(function_name).

can call help(function_name). This function returns the help related to python module, object or method if it is called with respective argument; but without any argument it will return the help related to currently running programming module.

Example: help(), help(str)

= assigns the value on its right-hand side to a self-defined variable name on its left-hand side.

Binary arithmetic operators +, -, \*, / are only performed to numbers. To do these operations element-wisely, use the zip() function or modules like 'numpy'.

Logical operators: not, and, or. Logical values: True, False.

Python, especially Pandas, Numpy, and Scikit-Learn, mark missing values as NaN.


## Data types in Python

There are five standard data types in Python:

Numbers

String

List

Tuple

Dictionary

Unlike C, Python does not require explicit type declaration. It sets the variable type based on the value that is assigned to it. The variable type will change along with the change of the variable value.

Example:

var = 11 \#The data type of var is number

var = 'python' \#The 'var' variable is now of string type.

To find the type of a certain variable, use the function "type()".


### Numbers

int: a = 10 \#Signed integer

long: a = 123L \#(L) stands for long integers; they can also be represented in octal and hexadecimal

float: a = 45.67 \#(.) marks floating point real values

complex: a = 1 + 1J \#(J) is the imaginary part


### String

String variables are enclosed by quotes. Python use single quotes ' double quotes " and triple quotes """ to denote literal strings. The triple quoted string """ will automatically continue across the end of the line statement.

Example:

var1 = 'hello world'

var2 = "I'm good."

var3 = """This is a string that will

span across multiple lines."""


### List

Declare list variables using brackets []. It can contain a series of values of different types.

All lists in Python are zero-based indexed. To combine two or more lists into a long one, use the method 'extend()'.

Example:

A = [] \#This is a blank list variable

B = [1, 23, 'bye'] \#Lists can contain different variable types.

C = [[1, 2], ['SEE'], []]

s1 = [1, 2, 3]

s2 = [4, 5]

s3 = s1.extend(s2) \#s3 is now [1, 2, 3, 4, 5]


Logical list operation:

\#Use the zip() function

\#logical lists:

logi_1 = [True, True, False]

logi_2 = [False, True, True]

logi_12 = [logi_1 and logi_2 for i in range(len(logi_1))]

print(logi_12)

\#Use the numpy module:

import numpy as np

logi_1 = np.array([True, True, False])

logi_2 = np.array([False, True, True])

logi_12 = logi_1 & logi_2

print(logi_12)


### Tuple

Define tuples using parenthesis (). Tuples are a group of values like a list but they are fixed in size once they are assigned. Elements cannot be added to or removed from a tuple, therefore tuples have no append or remove method.

Example:

myTuple = (1, 23, 'bye')


### Dictionary

Dictionaries in Python are lists of Key:Value pairs. It allows the use of a key to access its members. In dictionary the key must be unique. Dictionaries are created by using curly braces {} with pairs separated by comma , and the key values associated with a colon :.

Example:

employerAge = {'Smith':35, 'Clinton':50}

employerAge['Smith'] = 66 \#set the value associated with the 'smith' key to 66


## Array and Matrix

Python does not have built-in support for Arrays, but Python lists can be used instead. Matrix can be implemented as 2-dimensional array.

Another way to implement array and matrix arithmetic is to use the module numpy. This more convenient.

array/matrix arithmetic for numpy arrays/matrix:

+, -, \*, /, //, \*\*,  %

element-by-element (except that * for numpy matrix is matrix multiplication). Caution must be exercised in binary operations involving two objects of different length. This is not allowed in Python. If X and Y are two matrices(np.matrix()) than X * Y denotes the matrix multiplication. While if X and Y are just normal arrays(np.array()), X * Y is element-by-element multiplication.

Example:

import numpy as np

x = np.array([1, 5, 2])

y = np.array([7, 4, 1])

x + y \#[8, 9, 3]

x - y \#[-6, 1, 1]

x * y \#[7, 20, 2]

x // y \#Integer division: [0, 1, 2]

x % y \#[1, 1, 0]

X = np.array([[2, 3], [3, 5]])

Y = np.array([[1, 2], [5, -1]])

X * Y \#element-wise multiplication: array([ [2, 6],
                                             [15, -5]
])

np.dot(X, Y) \#matrix multiplication: matrix([ [17, 1],
                                               [28, 1]
])

np.mat(X) * np.mat(Y) \#matrix multiplication: matrix([ [17, 1],
                                                        [28, 1]
])

X = np.matrix([[2, 3], [3, 5]])

Y = np.matrix([[1, 2], [5, -1]])

X * Y \#matrix multiplication: matrix([ [17, 1],
                                        [28, 1]
])

Example:

Step 1: We need data Y and X to run OLS. We simulate an artificial dataset.

\\#simulate data

import random

import numpy as np

np.random.seed(111)

n = 100

b0 = np.full((2, 1), 1)

e = np.random.normal(size = (n, 1))

X = np.column_stack((np.full((n, 1), 1), np.random.normal(size = (n, 1))))

Y = np.dot(X, b0) + e

Step 2: translate the formula to code

\#OLS estimation

bhat = np.dot(np.linalg.inv(np.dot(X.T, X)), np.dot(X.T, Y))

Step 3 (additional): plot the regression graph with the scatter points and the regression line. Further compare

the regression line (black) with the true coefficient line (red).

\#plot

import matplotlib.pyplot as plt

plt.plot(X[:, 1], Y, 'o')

plt.plot(X[:, 1], np.dot(X, b0), color='red', linestyle='-')

plt.plot(X[:, 1], np.dot(X, bhat), color='black', linestyle='-')

plt.title('regression')

plt.xlabel('X')

plt.ylabel('Y')

plt.axhline(0, color = 'black', linestyle = 'dashed')

plt.axvline(0, color = 'black', linestyle = 'dashed')

plt.show()
![](https://github.com/Jingyi-W/Pics/blob/master/Python01_01.png?raw=true)

Step 4:

\#calculate the t-value

import math

bhat2 = bhat[1, 0]

e_hat = Y - np.dot(X, bhat)

sigma_hat_square = np.dot(e_hat.T, e_hat) / (n - 2)

Sigma_B = np.linalg.inv(np.dot(X.T, X)) * sigma_hat_square

t_value_2 = (bhat2 - b0[1, 0]) / math.sqrt(Sigma_B[1, 1])

print(t_value_2)

\# -0.7771772903170108


##Package/Module/Library

Similar to the packages in R, Python has numerous useful packages/modules/libraries. You have first install the targeted package into the environment (different IDEs have different installing procedures). Then to invoke a module in a certain scripts, use the function import(module_name) as abbr; every time the function of the module is called, use abbr.func_name().


##Input and Output

To read and write csv files in Python, use the pandas library.

Example:

import pandas as pd

sample_data = pd.read_csv('source.csv')

sample_data = sample_data.dropna()

pd.to_csv(sample_data, file = 'out.csv')


##Statistics

To implement most of the statistical tasks, use the package SciPy. Commonly used probability distributions can be found in the 
subpackage SciPy.stats. If you hope to draw the kernel density plot for a given set of data, use the seaborn package.

Example:

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

![](https://github.com/Jingyi-W/Pics/blob/master/Python01_02.png?raw=true)
crit = stats.chi2.ppf(q = 0.95, df = 3)

print(len([i for i in z if i > crit]) / len(z))

\#0.055

## User-defined function

The format of a user-defined function in Python is

def function_name(input):

  expressions
 
  return output

The beginning of the main function is written as follows:

if \__name__ == '\__main__':

  expressions
 
  function_name

Example:

\#construct confidence interval

import math

import statistics

def CI(x):

  \#x is a vector of random variables
  
  n = len(x)
  
  mu = statistics.mean(x)
  
  sig = statistics.stdev(x)
  
  upper = mu + 1.96 / math.sqrt(n) * sig
  
  lower = mu - 1.96 / math.sqrt(n) * sig
  
  return {'lower': lower, 'upper': upper}

## Flow Control

Example

import datetime

import statistics

from scipy import stats

Rep = 1000

sample_size = 100

capture = [0] * Rep

\#check time

pts0 = datetime.datetime.now()

for i in range(0, Rep):

  mu = 2
  
  x = stats.poisson.rvs(mu, size = sample_size)
  
  bounds = CI(x)
  
  if (bounds['lower'] <= mu and mu <= bounds['upper']):
  
    capture[i] = 1

print(statistics.mean(capture))

\#0.523

pts1 = datetime.datetime.now() - pts0

print(pts1)

\# 0:00:00.939326

## Statistical model

import numpy as np

from scipy import stats

import statsmodels.api as sm

import matplotlib.pyplot as plt

T = 100

p = 1

b0 = 1

\#generate data

x = np.full(T, stats.norm.rvs(size = T * p))

y = np.dot(x, b0) + stats.norm.rvs(size = T)

\#Linear model

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

![](https://github.com/Jingyi-W/Pics/blob/master/Python01_03.png?raw=true)

plt.plot(x, results.fittedvalues, color = 'black', label = 'Fitted Line')

plt.plot(x, np.dot(x, b0), color = 'red', label = 'True Coef')

plt.scatter(x, y, color = 'black', marker = 'o')

plt.title('Fitted Value')

plt.xlabel('x')

plt.ylabel('y')

plt.legend()

plt.show()

![](https://github.com/Jingyi-W/Pics/blob/master/Python01_04.png?raw=true)
