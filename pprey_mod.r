#code to change the pPREY1XXX1 parameter vectors based on Rob's spreadsheet
#' @author Gavin Fay
#  24 June 2015
#'
#'
#newtable.out is the pPREY1XXX1 in the full v1.5 format
TheData <- read.table("newtable.out",header=FALSE,col.names=1:89,fill=TRUE)
ngroups <- nrow(TheData)/2
#grab the predators for the pPREY vectors
preds <- rep(NA,ngroups)
ivals <- seq(from=1,by=2,length.out=ngroups)
jvals <- seq(from=2,by=2,length.out=ngroups)
for (i in 1:ngroups) preds[i] <- strsplit(as.character(TheData[ivals[i],1]),
                                          split="1")[[1]][2]
#pprey matrix from old file
preymatrix <- TheData[jvals,]
for (icol in 1:ncol(preymatrix))
  preymatrix[,icol] <- as.numeric(as.character(preymatrix[,icol]))

#Rob's new pprey matrix
new.pprey <- read.csv("Atlantis_1_5_ppreys.csv",header=FALSE,skip=1)
#preys for the new matrix (columns)
prey.codes <- as.vector(t(read.csv("Atlantis_1_5_ppreys.csv",header=FALSE,skip=0,
                                 nrow=1)[1,-1]))
#predators for the new matrix (rows)
pred.codes <- as.vector(new.pprey[,1])
new.pprey <- new.pprey[,-1]

#match the new prey items to the right slots in the pPREY vectors
new.groups <- read.csv("NeusGroups_v15_unix.csv")
matches <- match(prey.codes,new.groups$Code)

#sub in the new values
preymatrix2 <- preymatrix
for (i in 1:length(pred.codes))
{
 irow <- which(preds==pred.codes[i])
 preymatrix2[irow,matches] <-as.numeric(new.pprey[i,])
}

#add the 3 extra columns for detritus in the sediment
newvals <- matrix(0,nrow=nrow(preymatrix2),ncol=3)
preymatrix2 <- cbind(preymatrix2,newvals)

#write it out, write out four versions for all the juv/adult combinations
outfile <- "new_pprey.out"
write(" ",outfile)
for (i in 1:ngroups)
{
  write(paste(paste("pPREY1",preds[i],"1",sep=""),92,sep=" "),file=outfile,append=TRUE)
  write.table(preymatrix2[i,],file=outfile,col.names=FALSE,row.names=FALSE,quote=F,append=TRUE)
  write(" ",file=outfile,append=TRUE)
}
for (i in 1:ngroups)
{
  write(paste(paste("pPREY2",preds[i],"1",sep=""),92,sep=" "),file=outfile,append=TRUE)
  write.table(preymatrix2[i,],file=outfile,col.names=FALSE,row.names=FALSE,quote=F,append=TRUE)
  write(" ",file=outfile,append=TRUE)  
}
for (i in 1:ngroups)
{
  write(paste(paste("pPREY1",preds[i],"2",sep=""),92,sep=" "),file=outfile,append=TRUE)
  write.table(preymatrix2[i,],file=outfile,col.names=FALSE,row.names=FALSE,quote=F,append=TRUE)
  write(" ",file=outfile,append=TRUE)
}
for (i in 1:ngroups)
{
  write(paste(paste("pPREY2",preds[i],"2",sep=""),92,sep=" "),file=outfile,append=TRUE)
  write.table(preymatrix2[i,],file=outfile,col.names=FALSE,row.names=FALSE,quote=F,append=TRUE)
  write(" ",file=outfile,append=TRUE)
}



