library(plyr)
library(sampleSelection)
library(AER)

# the dataset comes from
# Greene( 2003 ): example 22.8, page 786
data( Mroz87 )

# equations
selection_eq = lfp ~ age + faminc + exper + educ
outcome_eq   = wage ~ exper + educ 

# Heckman two-step estimation
heck = heckit( selection_eq, outcome_eq, data = Mroz87 )
print(coeftest(heck))

########## bootstrap Heckit #################

# function for a single bootstrap
n = nrow(Mroz87)
boot_heck = function(){
  indices = sample(1:n, n, replace = T)
  Mroz87_b = Mroz87[ indices, ]
  heck_b = heckit( selection_eq, outcome_eq, data = Mroz87_b )
  return( coef(heck_b) )
}

# repeat the bootstrap
boot_Rep = 499
Heck_B = ldply( .data = 1:boot_Rep, .fun = function(i) boot_heck(), 
                .progress = "text")


# collect the bootstrap outcomes 
Heck_b_coef = data.frame(mean = colMeans(Heck_B), sd = apply(Heck_B, 2, sd))
Heck_b_coef$z = with(Heck_b_coef, mean/sd)
print(Heck_b_coef)

# print(head(Heck_B))