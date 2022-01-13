rm(list = ls())
library(Matrix) # for sparse matrix
library(tidyverse)

T = 601
T.eff = T - 1 # effective T, due to one lag

N = 15

time.marker = rep(1:T, N) # to hand the diff between y and its lag


# dependent variable and regressors

Y.raw <-  rnorm(N*T)

Y <- matrix( Y.raw[time.marker != 1], ncol = 1 ) # remove the start of each state. (T.eff*N)-vector 

X <- matrix( Y.raw[time.marker != T], ncol = N ) # lagged variables in matrix. T.eff-by-N matrix

XX <- kronecker( diag(N), X ) %>% Matrix() # regressors into a big matrix 


## dummy variables
state.index = rep(1:N, each = T.eff)
state.D <-  fastDummies::dummy_cols(state.index, remove_first_dummy = TRUE) %>%
        data.matrix( ) %>% Matrix( )

hour.index <- rep( c( rep(1:24, length.out = T) ), N)
hour.index <- hour.index[time.marker != 1 ] # similar to (Y.raw -> Y)
hour.D <-  fastDummies::dummy_cols(hour.index, remove_first_dummy = TRUE) %>%
        data.matrix( ) %>% Matrix( )



# dummies and regressors together

DX <- cbind(state.D, hour.D, XX)

## OLS

bhat <- solve( t(DX)%*% DX, t(DX)%*% Y )
