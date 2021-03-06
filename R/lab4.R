smpcovmatr <- matrix(0,5,5)
diag(smpcovmatr) <- c( 1106,2382,2136,.016,70.56)
diag2 <- c(396.7,1143,2.189,.216)
for(i in 1:4){
smpcovmatr[i,i+1] <- diag2[i]
}
diag3 <- c(108.4,-.214,-20.84)
for(i in 1:3){
  smpcovmatr[i,i+2] <- diag3[i]
}
diag4 <-c(.787,-23.96)
for(i in 1:2){
  smpcovmatr[i,i+3] <- diag4[i]
}
smpcovmatr[1,5] <- c(26.23)
smpcovmatr[lower.tri(smpcovmatr)] = t(smpcovmatr)[lower.tri(smpcovmatr)]

cormatr <- cov2cor(smpcovmatr)
s11 <- smpcovmatr[1:3,1:3]
s12 <- smpcovmatr[1:3,4:5]
s22 <- smpcovmatr[4:5,4:5]

matrsqrtinv <- function(A){
  eig <- eigen(A)
  vects <- eig$vectors
  vals <- eig$values
  result <- matrix(0,nrow=ncol(vects),ncol=ncol(vects))
  for(i in 1:length(vals)){
    result <- result + 1/sqrt(vals[i]) * crossprod(t(vects[,i]),t(vects[,i]))
  }
  return(result)
}

thatmatr <- matrsqrtinv(s22) %*% t(s12) %*% solve(s11) %*% s12 %*% matrsqrtinv(s22)
ees <- eigen(thatmatr)
paste("First canonical correlation:",signif(sqrt(ees$values[1]),3))
paste("Second canonical correlation:",signif(sqrt(ees$values[2]),3))

ffs <- eigen(matrsqrtinv(s11) %*% (s12) %*% solve(s22) %*% t(s12) %*% matrsqrtinv(s11))
thosevects <- ffs$vectors
vcoefs <- t(thosevects) %*% matrsqrtinv(s11)
ucoefs <- t(ees$vectors) %*% matrsqrtinv(s22)

dmat <- diag(x=sqrt(c( 1106,2382,2136,.016,70.56)))

# Self-correlations
selfcorrs1 <- vcoefs %*% s11 %*% solve(dmat[1:3,1:3])
selfcorrs2 <- ucoefs %*% s22 %*% solve(dmat[4:5,4:5])

#Let us say obsvs are standardized
vcoefs <- vcoefs %*% dmat[1:3,1:3]
ucoefs <- ucoefs %*% dmat[4:5,4:5]
colnames(vcoefs) <- c("X1","X2","X3")
rownames(vcoefs) <- c("First","Second","Irrelevant")
colnames(ucoefs) <- c("X4","X5")
rownames(ucoefs) <- c("First","Second")
paste("Coefficients for canonical variable U for standardized X:")
vcoefs
paste("Coefficients for canonical variable V for standardized X:")
ucoefs
#reject criterion -(n-1 - 1/2 (p + q + 1))ln PI(1- rho^2) > chisq_pq(alpha)
p <- 2
q <- 3
n <- 46
const <- -(n - 1 - 1/2 * (p + q + 1))
logfactor <- log((1 - ees$values[1] ) * (1- ees$values[2]))
tryingtobeat <- const * logfactor
beatthis <- qchisq(0.95,6)
logfactor2 <- log((1- ees$values[2]))
tryingtobeat2 <- const * logfactor2
nextobeat <- qchisq(0.95,2)
