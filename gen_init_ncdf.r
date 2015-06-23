setwd("~/Atlantis/neus_sandbox")
library(ncdf)

old.init.nc <- open.ncdf("inneus_2012.nc")

var.names <- rep(NA,length=old.init.nc$nvar)
for (i in 1:old.init.nc$nvar) var.names[i] <- old.init.nc$var[[i]]$name

myvar <- get.var.ncdf(old.init.nc,"Demersal_S_Fish1_StructN")
myatt <- att.get.ncdf(old.init.nc,"Demersal_S_Fish1_StructN")

old.init.nc$var[["Demersal_S_Fish1_StructN"]]


olddat <- read.table("gav.junk",header=FALSE,col.names=1:20,fill=TRUE,sep="\t")
for (icol in 1:3) olddat[,icol] <- as.character(olddat[,icol])


myname <- "Demersal_S_Fish1_StructN"

pick <- grep(myname,olddat[,1])
pick2 <- grep(myname,olddat[,2])
pick3 <- grep(myname,olddat[,3])


pick <- grep("// global attributes:",olddat[,1])

newdat <- olddat[1:(pick-1),1:3]
newdat2 <- olddat[pick:nrow(olddat),1:3]

#read old groups
old.groups <- read.csv("NeusGroups.csv")
new.groups <- read.csv("NeusGroups_v15.csv")

nold <- which(old.groups$Name=="Prawn")

mapfile <- "coderelations.csv"
CodeRelations <- read.csv(mapfile)


for (iold in 1:nold)
{
   var2find <- old.groups$Name[iold]
   pick2 <- grep(var2find,newdat[,2])
   pick3 <- grep(var2find,newdat[,3])
   newg <- which(as.character(CodeRelations$Parent)==old.groups$Code[iold])
   reuse <- newdat[c(pick2,pick3),]
   var2put <- new.groups$Name[which(as.character(new.groups$Code)==
                           CodeRelations$Child[newg[1]])]
   newdat[pick2,2] <- gsub(var2find,var2put,newdat[pick2,2])
   newdat[pick3,3] <- gsub(var2find,var2put,newdat[pick3,3])
   if (length(newg)>1)
   {
     for (igroup in 2:length(newg))
     {
       var2put <- new.groups$Name[which(as.character(new.groups$Code)==
                              CodeRelations$Child[newg[igroup]])]
       newbit <- reuse
       newbit[,2] <- gsub(var2find,var2put,newbit[,2])
       newbit[,3] <- gsub(var2find,var2put,newbit[,3])
       newdat <- rbind(newdat,newbit)
     }          
   }
}



for (iold in 1:nold)
{
  var2find <- old.groups$Name[iold]
  pick2 <- grep(var2find,newdat2[,2])
  pick3 <- grep(var2find,newdat[,3])
  newg <- which(as.character(CodeRelations$Parent)==old.groups$Code[iold])
  reuse <- newdat[c(pick2,pick3),]
  var2put <- new.groups$Name[which(as.character(new.groups$Code)==
                                     CodeRelations$Child[newg[1]])]
  newdat[pick2,2] <- gsub(var2find,var2put,newdat[pick2,2])
  newdat[pick3,3] <- gsub(var2find,var2put,newdat[pick3,3])
  if (length(newg)>1)
  {
    for (igroup in 2:length(newg))
    {
      var2put <- new.groups$Name[which(as.character(new.groups$Code)==
                                         CodeRelations$Child[newg[igroup]])]
      newbit <- reuse
      newbit[,2] <- gsub(var2find,var2put,newbit[,2])
      newbit[,3] <- gsub(var2find,var2put,newbit[,3])
      newdat <- rbind(newdat,newbit)
    }          
  }
}

