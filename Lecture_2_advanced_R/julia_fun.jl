module julia_fun

export capture

function CI(x::Array)
  # x is a vector of random variables

  n = length(x)
  mu = mean(x)
  sig = std(x)
  upper = mu + 1.96/sqrt(n) * sig
  lower = mu - 1.96/sqrt(n) * sig
  return lower, upper = (lower, upper)
end


function capture(Rep::Int64)

const sample_size = 5000000
const mu = 2
const dist = Poisson(mu)

  out = zeros(Rep,1)
  for i in 1:Rep
    x = rand(dist,  sample_size)
    bounds = CI(x)
    out[i]= (  bounds[1] <= mu  ) & ( mu <= bounds[2] )
  end
  return out
end

end
