# using Distributions

# this script can be run successfully


option = 1
Rep = 10

n = 6000
b0 = [1.;1.]



for r in 1:Rep
    e  = randn(n,1)
    X = hcat(ones(n,1), randn(n,1))
    k = size(X,2)

    Y = (X * b0 + e .> 0)

    bhat = X \ Y

    bhat2 = bhat[2]
    e_hat = Y - X * bhat

    # option 1
    if option == 1
        XXe2 = zeros(k,k,n)

        for i in 1:n
            XXe2[:,:,i] = X[i,:] * X[i,:]' * e[i]^2
        end
        XXe2 = sum(XXe2, dims = 3)
        XXe2 = XXe2[:,:,1]

        elseif option == 2
            Xe = X.*repmat(e, 1, k)
            XXe2 = Xe' * Xe
    end
end
