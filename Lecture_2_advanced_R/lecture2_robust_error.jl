# using Distributions


tic()
option = 2
Rep = 10
for r in 1:Rep

n = 6000
e  = randn(n,1)

b0 = [1.;1.]
X = hcat(ones(n,1), randn(n,1))
Y = (X * b0 + e .> 0)

bhat = X \ Y

bhat2 = bhat[2]
e_hat = Y - X * bhat

# option 1
if option == 1
    k = size(X,2)
    XXe2 = zeros(k,k,n)
    for i in 1:n
      XXe2[:,:,i] = X[i,:]' * X[i,:] * e[i]^2
    end
    XXe2 = sum(XXe2,3)
    XXe2 = squeeze(XXe2,3)

    # option 2
    elseif option == 2
      Xe = X.*repmat(e, 1, k)
      XXe2 = Xe' * Xe
    end
end
toc()
