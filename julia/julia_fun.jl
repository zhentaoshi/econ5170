
# this script can run successfully

function CI(x) # ::Array{Float64})
  # x is a vector of random variables

  n = length(x)
  mu = mean(x)
  sig = std(x)
  upper = mu + 1.96/sqrt(n) * sig
  lower = mu - 1.96/sqrt(n) * sig
  return lower, upper = (lower, upper)
end


using Distributions
# run the procedure
Rep = 100
sample_size = 1000


Rep = 200
sample_size = 500

mu = 2
dist = Poisson(mu)

# a standard loop
out = zeros(Rep,1)
# tic() # check time

# out = SharedArray(Int64,Rep)
for i in 1:Rep
  x = rand(dist,  sample_size)
  bounds = CI(x)
  out[i] = (  bounds[1] <= mu  ) & ( mu <= bounds[2] )
end
println( mean(out) )
# toc()
