
param.name <- "C_"
name2 <- NULL
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
clearance <- output[,5:14]
param.name <- "mum_"
name2 <- NULL
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
growth.rate <- output[,5:14]

param.name <- "KMIGa_"
name2 <- "sn"
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
sn <- output[,5:14]
param.name <- "KMIGa_"
name2 <- "rn"
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
rn <- output[,5:14]

size <- rn+sn

c_frac <- clearance/size
g_rate <- growth.rate/size
