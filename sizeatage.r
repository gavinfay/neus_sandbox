#' Code to get size at age and plot
#' @author Gavin Fay
#' Jan 13 2015
#' 
#set working directory
setwd("~/Desktop/Volumes/MyPassport/NEFSC/ATLANTIS/neus_sandbox")
setwd("~/Atlantis/neus_sandbox/")

#Lookup table with new codes for functional groups along with 'parent' groups from Atlantis-neus v1.
CodeRelations <- read.csv("coderelations.csv")

#read in biology file
TheData <- read.table("at_biol_neus_v15_DE.prm",col.names=1:100,comment.char="",fill=TRUE,header=FALSE)

#find the length-weight parameters from the old prm file, store them
pick <- grep("li_a_",TheData[,1])
xx <- TheData[pick,1:20]
tempmat <- matrix(NA,nrow=nrow(xx),ncol=3)
for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- strsplit(as.character(xx[igroup,1]),"li_a_")[[1]][2]
tempmat[,2] <- as.numeric(as.character(xx[,2]))
pick <- grep("li_b_",TheData[,1])
tempmat[,3] <- as.numeric(as.character(TheData[pick,2]))

#find the ages per cohort parameters from the old prm file, store them
pick <- grep("_AgeClassSize",TheData[,1])
xx <- TheData[pick,1:20]
ages.per.cohort <- matrix(NA,nrow=nrow(xx),ncol=2)
for (igroup in 1:nrow(ages.per.cohort)) ages.per.cohort[igroup,1] <- 
  strsplit(as.character(xx[igroup,1]),"_AgeClassSize")[[1]][1]
ages.per.cohort[,2] <- as.numeric(as.character(xx[,2]))

#find the ages at maturity parameters from the old prm file, store them
pick <- grep("_age_mat",TheData[,1])
xx <- TheData[pick,1:20]
age.of.maturity <- matrix(NA,nrow=nrow(xx),ncol=2)
for (igroup in 1:nrow(ages.per.cohort)) age.of.maturity[igroup,1] <- 
  strsplit(as.character(xx[igroup,1]),"_age_mat")[[1]][1]
age.of.maturity[,2] <- as.numeric(as.character(xx[,2]))


#For each time step
# For each Atlantis age class, calculate length associated with weight
# Generate length distribution assuming a fixed CV of length at age
# calculate distribution by 1cm
# max length 150cm
upper.bins <- 1:150
#mulen = 20
CVlenage = 0.15
#CVlenage = sqrt(exp(sigma^2) - 1)

require(ncdf)
setwd("~/Desktop/Volumes/MyPassport/NEFSC/ATLANTIS/Scenarios/Levels\ of\ Tuning/Base\ Effort/")

group.names <- read.csv("FuncGroupNamesInPlotOrderNEUS_GF20130416.csv")
gb.groups <- c("FPS","FPL","FDS","FDO","FDF","FDD","SHB","SSK","FVB","FDB")
groups <- group.names$NetCDFName[match(gb.groups,group.names$CODE)]
groups <- group.names$NetCDFName
groups <- as.character(t(strsplit(as.character(groups),"_N",fixed=TRUE)))

setwd("~/Desktop/Volumes/MyPassport/NEFSC/ATLANTIS/Scenarios/Test/BASE_ANNUAL/")

xx2 <- open.ncdf("neusDynEffort_Base_Effort_.nc")
names2 <- rep(NA,xx2$nvar)
for (i in 1:xx2$nvar) names2[i] <- xx2$var[[i]]$name

group = "Demersal_D_Fish"
#get total N
ivar <- grep(paste(group,"_N",sep=""),names2)
groupN <- get.var.ncdf(xx2,ivar)
vol <- get.var.ncdf(xx2,"volume")
TotN <- sum(groupN*vol,na.rm=TRUE)

for (age in 1:10)
{
  ivar <- grep(paste(group,age,"_ResN",sep=""),names2)
  SRN <- get.var.ncdf(xx2,ivar)
  ivar <- grep(paste(group,age,"_StructN",sep=""),names2)
  SRN <- SRN + get.var.ncdf(xx2,ivar)
  ivar <- grep(paste(group,age,"_Nums",sep=""),names2)
  Nums <- get.var.ncdf(xx2,ivar)
  if (age==1) TheN <- SRN*Nums
  if (age>1) TheN <- TheN + SRN*Nums
}




Lenfreq = array(0,dim=c(length(groups),150,dim(SRN)),
                dimnames=list(groups=group.names$EMOCCName[match(gb.groups,group.names$CODE)],
                              length=upper.bins,depth=1:5,box=0:29,time=1:dim(SRN)[3]))
Fracperbin = array(0,dim=c(150,dim(SRN)))
li_a_use = 0.0107
li_b_use = 2.91
Kwet = 20.0
Redfield_CN = 5.7
ages = 1:10

groups <- CodeRelations$Child[CodeRelations$IsVertebrate==1]

mulenage <- array(0,dim=c(length(groups),10,dim(SRN)[3]))
muweight <- array(0,dim=c(length(groups),10,dim(SRN)[3]))


for (group in groups)
{
  print(group)
  igroup <- which(groups==group)
  
  ncgroup <- 
    group.names$NetCDFName[which(
    group.names$CODE==as.character(CodeRelations$Parent[igroup]))]
  ncgroup <- as.character(t(strsplit(as.character(ncgroup),"_N",fixed=TRUE)))
  
  #total biomasa by area
  #
  # END GOAL
  # size structure of the catch/pop by area and fleet  (can be in numbers)
  #
  # catches, total catch by fleet and area, apply size structure of pop to get catch at age
  #
  #
  
  
  #biology parameter file
  #weight-at-length parameters
  li_a_use <- 
    as.numeric(tempmat[which(tempmat[,1]==CodeRelations$Parent[igroup]),2])
  li_b_use <- 
    as.numeric(tempmat[which(tempmat[,1]==CodeRelations$Parent[igroup]),3])
  
  #calculate length
  #length-weight determined by equation #95 in TechMemo 218

  for (age in ages)
  {
    print(age)
    #ivar <- grep(paste(group,age,"_ResN",sep=""),names2)
    SRN <- get.var.ncdf(xx2,paste(ncgroup,age,"_ResN",sep=""))
    #ivar <- grep(paste(group,age,"_StructN",sep=""),names2)
    SRN <- SRN + get.var.ncdf(xx2,paste(ncgroup,age,"_StructN",sep=""))
    #ivar <- grep(paste(group,age,"_Nums",sep=""),names2)
    Nums <- get.var.ncdf(xx2,paste(ncgroup,age,"_Nums",sep=""))
    #if (age==1) TheN <- SRN*Nums
    # if (age>1) TheN <- TheN + SRN*Nums
    
    Nperage <- SRN*Nums
    
    #Nperage2 <- array(dim=dim(Nperage)[-1])
    #for (irow in 1:nrow(Nperage2))
    # Nperage2[irow,] <- colSums(Nperage[,irow,],na.rm=TRUE)
    
    #GET LENGTH FOR THIS AGE CLASS
    Length <- ((Kwet*Redfield_CN*SRN)/(1000*li_a_use))^(1/li_b_use)
    mulen <- rep(0,length(Length[1,1,]))
    for (t in 1:length(mulen))
     {
      numfreq <- Nums[,,t]/sum(Nums[,,t]) 
      mulen[t] <- sum(Length[,,t]*numfreq)      
     }
    
    mulenage[igroup,age,] <- mulen
    muweight[igroup,age,] <- li_a_use*mulen^li_b_use
  #close ages  
  }  
 #close groups
 } 

setwd("~/Atlantis/neus_sandbox/")
pdf(file='sizeatage.pdf')
par(mfrow=c(3,3),mar=c(2,3,3,1),oma=c(3,3,0,0))
for (igroup in 1:dim(mulenage)[1])
{
 ages.use <- ages*as.numeric(ages.per.cohort[
   which(ages.per.cohort[,1]==CodeRelations$Parent[igroup]),2])
 ages.use2 <- c(0,ages.use[-length(ages.use)]) 
 a2 <- (ages.use-ages.use2)/2
 ages.use3 <- ages.use2 + a2
 agemat <- ages.use3[as.numeric(age.of.maturity[
   which(age.of.maturity[,1]==CodeRelations$Parent[igroup]),2])]
 plot(ages.use3,mulenage[igroup,,1],type='l',lwd=2,
      main=CodeRelations$Long.Name[which(CodeRelations$Child==groups[igroup])],
      xlab="Age",ylab="Length (cm)",ylim=c(0,1.1*max(mulenage[igroup,,])))
 abline(v=agemat,lty=2)
 for(t in 2:52) lines(ages.use3,mulenage[igroup,,t],lwd=0.5,col=gray(0.9))
 lines(ages.use3,mulenage[igroup,,1],lwd=2) 
 mtext("Age",side=1,outer=TRUE)
 mtext("Length",side=2,outer=TRUE) 
}
dev.off()

    
    sigma = sqrt(log((CVlenage^2)+1))
    #muuse <- log(Len2/10) - 0.5*(sigma^2)
    muuse <- log(Len2) - 0.5*(sigma^2)
    #hist(exp(muuse),main=age)
    #CumFracperbin <- plnorm(upper.bins,muuse,sigma)
    for (i in 1:dim(SRN)[1])
      for (j in 1:dim(SRN)[2])
        for (k in 1:dim(SRN)[3])
        {
          CumFracperbin <- plnorm(upper.bins,muuse[i,j,k],sigma)
          Fracperbin[,i,j,k] <- c(CumFracperbin[1],diff(CumFracperbin))
        }
    for (i in 1:dim(SRN)[1])
      for (j in 1:dim(SRN)[2])
        for (k in 1:dim(SRN)[3])
        {
          Lenfreq[igroup,,i,j,k] = Lenfreq[igroup,,i,j,k] + Fracperbin[,i,j,k]*Nums[i,j,k]
        }
    
    if (age==1)
      plot(apply(Lenfreq[igroup,,depths,boxes,time],1,sum,na.rm=TRUE),type='l',ylab="N",
           xlab="length (cm)",main=dimnames(Lenfreq)$groups[igroup])
    if (age>1)
      lines(apply(Lenfreq[igroup,,depths,boxes,time],1,sum,na.rm=TRUE),lty=age)
    
    #print(age)
    #print(Lenfreq[igroup,,14,52])
  }
  
  #multiple species.
}

setwd("/media/My\ Passport/NEFSC/ATLANTIS/Hydra/")
save(Lenfreq,file="Lenfreq_Numbers.RData")

# Think about getting catch frequencies

#plot length freq for some of Georges Bank for last time step
boxes = c(13:16,21:22) #12  #c(13,14,16)
depths = 1:5
time = 52
par(mfrow=c(4,3),oma=c(0,0,0,0),mar=c(2,2,3,1))
for (igroup in 1:10)
{
  plot(apply(Lenfreq[igroup,,depths,boxes,time],1,sum,na.rm=TRUE),type='l',ylab="N",
       xlab="length (cm)",main=dimnames(Lenfreq)$groups[igroup])
}

