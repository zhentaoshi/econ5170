# must executed in Rstudio wit an "admin" status
# need to copy the entire library to the "C:program files" location

install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools'))
devtools::install_github('IRkernel/IRkernel', force = TRUE)
IRkernel::installspec() 
