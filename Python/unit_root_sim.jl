# unit root


using Distributions

function AR(a::Float64,T::Int)
    y = zeros(T,1)
    for t in 2:T
        y[t] = a * y[t-1] + randn(1)[1]
    end
    return y
end


T = 100
a = 1.0


Rep = 1000
Bhat = zeros(Float64,Rep)

for r in 1:Rep
    Y = AR(a,T)
    y = Y[2:T]
    x = Y[1:(T-1)]
    bhat = x \ y
    Bhat[r] = bhat
end


# using PyPlot

using PyPlot
using Gadfly
using KernelDensity

Gadfly.plot(Bhat, x = 0.0:0.01:1.5, Geom.density)
