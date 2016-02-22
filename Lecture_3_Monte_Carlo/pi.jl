n = 1000000
Z1 = 2 * (rand(n)-0.5)
Z2 = 2 * (rand(n)-0.5)

inside = mean( Z1.^2 + Z2.^2  .<=  1 )
pi_hat = 4 * inside # the total area of the square base is 4.
println(pi_hat)
