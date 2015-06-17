
print.prm <- function(path,origfile,param.name,outfile,mapfile,param.type,
                        name2=NULL)
{
#set working directory
setwd(path)

#Lookup table with new codes for functional groups along with 'parent' groups from Atlantis-neus v1.
CodeRelations <- read.csv(mapfile)

#read in orig param file
TheData <- read.table(origfile,col.names=1:100,comment.char="",fill=TRUE,header=FALSE)

#find the length-weight parameters from the old prm file, store them
if (param.name!= "") 
  pick <- grep(param.name,TheData[,1])
if (length(name2)>0) pick <-pick[grep(name2,TheData[pick,1])]
if (param.name== "") pick <- grep(name2,TheData[,1])
xx <- TheData[pick,]
pick2 <- grep('#',xx[,1])
if(length(pick2)>0) xx <- xx[-pick2,]
yy <- TheData[pick+1,]
if(length(pick2)>0) yy <- yy[-pick2,]

tempmat <- matrix(NA,nrow=nrow(xx),ncol=2)
if (param.name!="")
{
  for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
    strsplit(as.character(xx[igroup,1]),param.name)[[1]][2]
  if (length(name2)>0)
  {
    for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
      strsplit(as.character(tempmat[igroup,1]),name2)[[1]][1]
  }
}
if (param.name=="")
{
  for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
    strsplit(as.character(xx[igroup,1]),name2)[[1]][1]
}     
###if (length(name2)>0) for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- strsplit(tempmat[igroup,1],name2)[[1]][1]
tempmat[,2] <- as.numeric(as.character(xx[,2]))
##pick <- grep("li_b_",TheData[,1])
##tempmat[,3] <- as.numeric(as.character(TheData[pick,2]))

#assign the old vals to the new codes, write a csv for data entry with columns to change highlighted and 'parent' group parameter values inserted.
output <- CodeRelations #list(Code=CodeRelations$Child,Parent=CodeRelations$Parent,Change=CodeRelations$Change)
output$x <- rep(NA,nrow(output))
#output$x <- tempmat[match(CodeRelations$Parent,tempmat[,1]),2]
output$x <- tempmat[match(CodeRelations$Child,tempmat[,1]),2]
#output$li_b <- rep(NA,nrow(output))
#output$li_b <- tempmat[match(CodeRelations$Parent,tempmat[,1]),3]
#output$source <- ""
#output$source[output$Change==0] <- "Atlantis-Neus v1"
#head(output)
names(output)[9] <- paste(param.name,"XXX",name2,sep="")
cols.to.write <- c(1,3,4,6,9)
write.table(output[,cols.to.write],file=outfile,col.names=TRUE,
            row.names=FALSE,quote=FALSE,sep=",")
return(output[,cols.to.write])
}



print.prm2 <- function(path,origfile,param.name,outfile,mapfile,param.type,
                      name2=NULL)
{
  #set working directory
  setwd(path)
  
  #Lookup table with new codes for functional groups along with 'parent' groups from Atlantis-neus v1.
  CodeRelations <- read.csv(mapfile)
  
  #read in orig param file
  TheData <- read.table(origfile,col.names=1:100,comment.char="",fill=TRUE,header=FALSE)
  
  #find the length-weight parameters from the old prm file, store them
  if (param.name!= "") 
    pick <- grep(param.name,TheData[,1])
  if (length(name2)>0) pick <-pick[grep(name2,TheData[pick,1])]
  if (param.name== "") pick <- grep(name2,TheData[,1])
  xx <- TheData[pick,]
  pick2 <- grep('#',xx[,1])
  if(length(pick2)>0) xx <- xx[-pick2,]
  yy <- TheData[pick+1,]
  if(length(pick2)>0) yy <- yy[-pick2,]
  pick3 <- unique(c(grep("_",yy[,1]),grep("#",yy[,1])))
  if (length(pick3)>0) 
    {
     xx <- xx[-pick3,]
     yy <- yy[-pick3,]
    }
  tempmat <- matrix(NA,nrow=nrow(xx),ncol=2)
  if (param.name!="")
  {
    for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
      strsplit(as.character(xx[igroup,1]),param.name)[[1]][2]
    if (length(name2)>0)
    {
      for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
        strsplit(as.character(tempmat[igroup,1]),name2)[[1]][1]
    }
  }
  if (param.name=="")
  {
    for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
      strsplit(as.character(xx[igroup,1]),name2)[[1]][1]
  }     
  ###if (length(name2)>0) for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- strsplit(tempmat[igroup,1],name2)[[1]][1]
  tempmat[,2] <- as.numeric(as.character(xx[,2]))
  ##pick <- grep("li_b_",TheData[,1])
  ##tempmat[,3] <- as.numeric(as.character(TheData[pick,2]))
  
  #assign the old vals to the new codes, write a csv for data entry with columns to change highlighted and 'parent' group parameter values inserted.
  output <- CodeRelations #list(Code=CodeRelations$Child,Parent=CodeRelations$Parent,Change=CodeRelations$Change)
  output$x <- rep(NA,nrow(output))
  #output$x <- tempmat[match(CodeRelations$Parent,tempmat[,1]),2]
  output$x <- tempmat[match(CodeRelations$Child,tempmat[,1]),2]
  #output$li_b <- rep(NA,nrow(output))
  #output$li_b <- tempmat[match(CodeRelations$Parent,tempmat[,1]),3]
  #output$source <- ""
  #output$source[output$Change==0] <- "Atlantis-Neus v1"
  #head(output)
  
  
  matches <- match(CodeRelations$Child,tempmat[,1])
  #numcols <- unique(as.numeric(output$x[which(is.na(output$x)==FALSE)]))
  numcols <- as.numeric(unique(output$x[which(is.na(output$x)==FALSE)]))
  output2 <- matrix(NA,ncol=numcols,nrow=nrow(output))
  for (irow in 1:nrow(output2)) 
  {
    output2[irow,] <-  
      as.numeric(as.character(t(yy[matches[irow],1:ncol(output2)])))
  }
  
  
  
  names(output)[9] <- paste(param.name,"XXX",name2,sep="")
  #names(output2)[1:ncol(output2)] <- paste(param.name,"XXX",name2,sep="")
  cols.to.write <- c(1,3,4,6)
  out.write <- cbind(output[,cols.to.write],output2)
  names(out.write)[5:ncol(out.write)] <- paste(param.name,"XXX",name2,sep="")
  #write.table(output[,cols.to.write],file=outfile,col.names=TRUE,
  #            row.names=FALSE,quote=FALSE,sep=",")
  #return(cbind(output[,cols.to.write],output2))
  return(out.write)
}





library(stringr)
outfile <- "newtable.out"
setwd("~/Atlantis/neus_sandbox")
path <- getwd()
mapfile <- "coderelations.csv"
#origfile <- "at_biol_neus_v15_DE.prm"
origfile <- "at_biol_neus_v15_working.prm"
param.name <- "li_a_"
name2 <- NULL
param.type=3
#change.prm(path,origfile,param.name,outfile,mapfile,param.type)
param.name <- "li_a_"
output <- print.prm(path,origfile,param.name,outfile,mapfile,param.type,name2)
out.table <- output
param.name <- "li_b_"
output <- print.prm(path,origfile,param.name,outfile,mapfile,param.type,name2)
out.table <- cbind(out.table,output[,5])
names(out.table)[ncol(out.table)] <- names(output)[5]
param.name <- "C_"
name2 <- "_T15"
output <- print.prm(path,origfile,param.name,outfile,mapfile,param.type,name2)
out.table <- cbind(out.table,output[,5])
names(out.table)[ncol(out.table)] <- names(output)[5]
param.name <- "C_"
name2 <- NULL
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
fcol <- ncol(out.table)+1
out.table <- cbind(out.table,output[,-(1:4)])
names(out.table)[fcol:ncol(out.table)] <- names(output)[5]
param.name <- "mum_"
name2 <- "_T15"
output <- print.prm(path,origfile,param.name,outfile,mapfile,param.type,name2)
out.table <- cbind(out.table,output[,5])
names(out.table)[ncol(out.table)] <- names(output)[5]
param.name <- "mum_"
name2 <- NULL
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
fcol <- ncol(out.table)+1
out.table <- cbind(out.table,output[,-(1:4)])
names(out.table)[fcol:ncol(out.table)] <- names(output)[5]
param.name <- NULL
name2 <- "_AgeClassSize"
output <- print.prm2(path,origfile,param.name,outfile,mapfile,param.type,name2)
fcol <- ncol(out.table)+1
out.table <- cbind(out.table,output[,-(1:4)])
names(out.table)[fcol:ncol(out.table)] <- names(output)[5]




write.table(out.table,file="newtable.csv",quote=FALSE,sep=",",row.names=FALSE)

