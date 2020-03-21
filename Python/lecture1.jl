# this Julia script basically repeats the R script for lecture 1.
using Distributions

n = 100
b0 = [ 0.5; 1.0 ]

X = 2 * rand(Normal(), n,1)
X = hcat(ones(n,1), X )
e = rand(Normal(), n)
Y = X * b0 + e

bhat = inv( X' * X) * (X' * Y )
println(bhat)

e_hat = Y - X * bhat
bhat2 = bhat[2]

sigma_hat_square = sum(e_hat.^2)/(n-2)
sig_B = inv( X' * X ) * sigma_hat_square
t_value = (bhat2 - b0[2])  /sqrt( sig_B[2,2] )
# println(t_value)

y = rand(Chisq(3), 1000)

# plot can only be done in IJulia notebook
# using KernelDensity
# using PyPlot
# kd = kde(y)
# plot(kd)
