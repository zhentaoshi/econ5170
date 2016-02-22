library(mcmc)
h = function(x){ y = -x^2 / 2 } # the log, unnormalized function
out = metrop( obj = h, initial = 0, nbatch = 100, nspac = 1  )
plot(out$batch, type = "l") # a time series with flat steps

out = metrop( obj = h, initial = 0, nbatch = 100, nspac = 10  )
plot(out$batch, type = "l") # a time series looks like a white noise


summary(out)
plot(density(out$batch))