# Zhentao Shi. 4/5/2015

# this script can run successfully

using Distributions
# using Debug

# set the parameters

Rep = 200
b0 = [1.;1.]

# the workhorse functions

function MonteCarlo( X::Array, n::Int64, Dist::Int64 )
  if Dist == 1
  	e = rand(TDist(1),n)
  elseif Dist == 2
  	e = randn(n,1)
  end

  Y = X * b0 + e

  bhat = (X' * X )\ (X' * Y)
  bhat2 = bhat[2]

  e_hat = Y - X * bhat
  sigma_hat_square = sum(e_hat.^2)/ (n-2)
  sig_B = inv( X' * X  ) * sigma_hat_square
  t_value_2 = ( bhat2 - b0[2]) / sqrt( sig_B[2,2] )

  return  t_value_2
end



# report the empirical test size
function report(n)
  # collect the test size from the two distributions
  # this function contains some repeated code, but is OK for such a smply one

  TEST_SIZE = zeros(1,2)

  X = hcat( ones(n,1), randn(n,1) ) # generate the regressors
  Res = zeros(Rep)
  for i in 1:Rep
    Res[i] =  MonteCarlo(X, n, 1)
  end

  crit_value = quantile(TDist(n-2),  .975)
  TEST_SIZE[1] = mean( abs(Res) .> crit_value )

  for i in 1:Rep
    Res[i] =  MonteCarlo(X, n, 2)
  end
  TEST_SIZE[2] = mean( abs(Res) .> crit_value )

  return TEST_SIZE
end


NN = [5,10,20, 40]
@time RES = [ report(n) for n in NN ]
println(RES)
