setwd <- "H:/NEFSC/ATLANTIS/Scenarios/Levels of Tuning/Base Effort/"
xx <- read.csv("H:/NEFSC/ATLANTIS/Scenarios/Levels of Tuning/Base Effort/FuncGroupNamesInPlotOrderNEUS_GF20130416.csv",header=TRUE)

setwd <- "H:/NEFSC/ATLANTIS/neus_sandbox/Test/test1/"

yy <- read.csv("H:/NEFSC/ATLANTIS/neus_sandbox/Test/test1/coderelations.csv",header=TRUE)

matches <- match(yy[,3],xx[,2])
yy[,"Old.Name"] <- xx[matches,3]
write.table(yy,file="H:/NEFSC/ATLANTIS/neus_sandbox/Test/test1/NEUSgroups_v15_oldnames.csv",row.names=FALSE,quote=FALSE,sep=",")

