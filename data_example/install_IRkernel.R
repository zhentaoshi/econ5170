# must executed in Rstudio with an "admin" status
# need to copy the entire library to the "C:program files" location

# last successful installation: Microsoft Open R 3.5.0, Aug 16, 2018

install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools', 'stringi', 'uuid', 'digest'))
devtools::install_github('IRkernel/IRkernel', force = TRUE)
IRkernel::installspec() 

# In case that Ipython reports "there is no package called 'IRkernel'", check in R 
# `libPaths()` and syncronize the libraries if necessary.

# As Nov 5, 2919 (and also Mar 7, 2020), 
# installation problem is encountered in the last line "IRkernel::installspec()"
# It is because "jupyter" is not in the path

# Solution:
# In 'anaconda prompt', cd to the location of R.exe and run ".\R" to enter R command line interface
# Run "IRkernel::installspec()" inside and then quit. It solves the problem
