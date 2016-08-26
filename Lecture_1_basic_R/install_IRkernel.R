# must executed in Rstudio wit a "admin" status
# need to copy the entire library to the "C:program files" location

install.packages(c('repr', 'IRdisplay', 'crayon', 'pbdZMQ', 'devtools'), lib = "C:/Program Files/R/R-3.3.0/library")
devtools::install_github('IRkernel/IRkernel', force = TRUE)
IRkernel::installspec() 
