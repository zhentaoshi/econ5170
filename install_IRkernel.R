# must executed in Rstudio with an "admin" status
# need to copy the entire library to the "C:program files" location

# last successful installation: Microsoft Open R 3.5.0, Aug 16, 2018

install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools', 'sringi'))
devtools::install_github('IRkernel/IRkernel', force = TRUE)
IRkernel::installspec() 
