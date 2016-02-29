require(Rmosek)

lo1 <- list()
lo1$sense <- "max"
lo1$c <- c(3,1,5,1)
lo1$A <- Matrix(c(3,1,2,0,
                  2,1,3,1,
                  0,2,0,3), nrow=3, byrow=TRUE, sparse=TRUE)
lo1$bc <- rbind(blc = c(30,15,-Inf),
                buc = c(30,Inf,25))
lo1$bx <- rbind(blx = c(0,0,0,0),
                bux = c(Inf,10,Inf,Inf))
r <- mosek(lo1)