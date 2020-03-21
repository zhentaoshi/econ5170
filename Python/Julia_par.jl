# so far the parallel computing on Julia does not work
# it seems quite trick that a piece of code was working yesterday, but
# now problem is reported.


using Distributions


push!(LOAD_PATH, pwd())

using julia_fun
# on a single processor
tic()
# include("julia_fun.jl")
b1 = 200
# combine_single = capture(b1)
# println(mean(combine_single))
toc()


# on two processors
tic()
b = 100


# require( "julia_fun.jl" )
# combine = pmap(capture,[b,b])
# combine = vcat(combine[1],combine[2])
# println( mean(combine) )
# using julia_fun


c1 =  remotecall(1, capture, b)
c2 =  remotecall(2, capture, b)

c1 = fetch(c1)
c2 = fetch(c2)

println(mean(c12))

toc()
