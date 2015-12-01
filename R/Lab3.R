
www = "http://www.ida.liu.se/~732A37/T1-9.dat"
data <- read.delim(www, header = FALSE, sep="\t")
colnames(data) <- c("NAT","100m(s)","200m(s)","400m(s)",
                    "800m(min)","1500m(min)","3000m(min)","Mara(min)")
head(data)
nations <- as.character(data[,1])
data <- data[,-1]
col_mu <- colMeans(data)
col_sigmasquared<-apply(data,2,var)

prcomp()