######
#root <- "J:/NEFSC/ATLANTIS/"
#setwd(paste(root,"Scenarios/Levels\ of\ Tuning/Oct23_08d/",sep=""))

# OLD FIXED EFFORT
setwd('/Volumes/MyPassport/NEFSC/Atlantis/Scenarios/Levels\ of\ Tuning/Oct23_08d/')
setwd('/Volumes/MyPassport/NEFSC/Atlantis/Scenarios/Test/FIXEFF_ANNUAL/')
setwd('/Volumes/MyPassport/Atlantis/Scenarios/Levels\ of\ Tuning/Oct23_08d/')
run.name <- "neusDynEffort_Oct23_08d_"

### OLD BASE EFFORT
setwd("/Volumes/MyPassport/NEFSC/Atlantis/Scenarios/Levels\ of\ Tuning/Base\ Effort")
setwd("/Volumes/MyPassport/Atlantis/Scenarios/Levels\ of\ Tuning/Base\ Effort")
run.name <- "neusDynEffort_Base_Effort_"

# DYNAMICS EFFORT
setwd('~/Atlantis/atneus/test20150812')
run.name <- "neusDynEffort_Test1_"



biomass <- read.table(paste(run.name,"BiomIndx.txt",sep=""),header=TRUE)
biomass <- biomass[-nrow(biomass),]
catch <- read.table(paste(run.name,"Catch.txt",sep=""),header=TRUE)
catch <- catch[-nrow(catch),]
asp <- biomass[-1,2:36]-biomass[-nrow(biomass),2:36]+catch[-1,2:36]
#FOX
biomass2 <- biomass*log(biomass)
lm.coef <- NULL
for (isp in 1:ncol(asp))
{
  lm1 <- lm(asp[-1,isp]~biomass[-(c(1,nrow(biomass))),isp+1]+biomass2[-(c(1,nrow(biomass2))),isp+1])
  #print(isp)
  #print(summary(lm1))
  lm.coef <- rbind(lm.coef,as.numeric(coef(lm1)))
}
bzero <- exp(-1*lm.coef[,2]/lm.coef[,3])
names(bzero) <- colnames(asp)
#FLETCHER
lm.coef <- NULL
a.use <- asp[-1,isp]
b.use <- biomass[-(c(1,nrow(biomass))),isp+1]
nlm1 <- nls(a.use~-(0.5*(1+h*b.use)/g)+0.5*sqrt(1+b.use*(2*h+4*b*g))/g,start=list(b=1,g=1,h=1))
nlm1 <- nls(asp[-1,isp]~biomass[-(c(1,nrow(biomass))),isp+1]+biomass2[-(c(1,nrow(biomass2))),isp+1])


get.foxbio <- function(bio,cat)
{
asp <- diff(bio)+cat[-1]
bio2 <- bio*log(bio)
lm.coef <- NULL
  lm1 <- lm(asp[-1]~bio[-(c(1,length(bio)))]+bio2[-(c(1,length(bio2)))])
  #print(isp)
  #print(summary(lm1))
  lm.coef <- rbind(lm.coef,as.numeric(coef(lm1)))
bzero <- exp(-1*lm.coef[,2]/lm.coef[,3])
return(bzero)
}



depletion <- as.numeric(biomass[50,2:36])/bzero
length(depletion[depletion<0.368/2])


WriteFoxDatFile(getwd(),bio=bio.use,cat=cat.use,nyrs=29,skip=1)


results <- NULL
setwd('~/Atlantis/neus_sandbox/foxmodel')
#setwd(paste(root,"neus_sandbox/foxmodel/",sep=""))
#if (Sys.info()[1]=="Linux") setwd('/home/jlink/gfay/sandbox/foxmodel/')
for (isp in 2:36)
{
  bio.use <- biomass[,isp]
  #bio.use <- as.numeric(0.5*(biomass[-1,isp]+biomass[-nrow(biomass),isp]))
  cat.use <- catch[-1,isp]
  #cat.use <- cat.use[-length(cat.use)]
  WriteFoxDatFile(getwd(),bio=bio.use,cat=cat.use,nyrs=40,skip=10)
  #print(getwd())
  RunFoxModel(getwd())
  results <- rbind(results,ReadFoxResults(getwd()))
}
rownames(results) = colnames(biomass)[2:36]

for (i in 1:14)
{
  if (i==1) pick <- 3:21 #is.fish <- 3:21
  if (i==2) pick <- 22:26  #is.teps
  if (i==3) pick <- c(27:33,35:36) #is.invert 
  if (i==4) pick <- c(34,37:42) # is.plank
  if (i==5) pick <- c(3,4,10,12) # is.small.pelagic
  if (i==6) pick <- c(5,7,11,13:19,21) # is.demersal.fish
  if (i==7) pick <- 18:21 #is.shark 
  #is.scallop <- 28
  #is.bird <- 22
  #is.mammal <- c(23,25:26)
  #is.seal <- 23
  if (i==8) pick <- c(3:29,31:33) #is.bio 
  if (i==9) pick <- c(3:21,27:29,31:33) #is.target.bio
  if (i==10) pick <- c(3:4,10,12,23) #is forage
  if (i==11) pick <- c(5,11,13,14,16) #is ground  
  if (i==12) pick <- c(6,8,9,15,7,17) #is other  
  if (i==13) pick <- c(18:21) #is other  
  if (i==14) pick <- c(28:29,31:32,29) #is benthic invert
  
  bio.use <- as.numeric(t(rowSums(biomass[,pick-1])))
  cat.use <- as.numeric(t(rowSums(catch[,pick-1])))[-1]
  #cat.use <- cat.use[-length(cat.use)]
  WriteFoxDatFile(getwd(),bio=bio.use,cat=cat.use,nyrs=50,skip=0)
  #print(getwd())
  RunFoxModel(getwd())
  results <- rbind(results,ReadFoxResults(getwd()))
}




FleetCat <- read.table(paste(run.name,"CatchPerFishery.txt",sep=""),header=TRUE) 
times <- unique(FleetCat[,"Time"])[47:51]
SumCat <- matrix(0,nrow=33,ncol=ncol(FleetCat)-2)
for (ifleet in 1:33)
{
  FleetCat.use <- FleetCat[FleetCat$Fishery==unique(FleetCat$Fishery)[ifleet],]
  matches <- match(times,FleetCat.use[,"Time"])
  SumCat[ifleet,] <- colSums(FleetCat.use[matches,-(1:2)],na.rm=TRUE) 
}
PropCat <- SumCat
PropCat[,] <- 0
for (i in 1:ncol(PropCat))
  if (sum(SumCat[,i])>0) PropCat[,i] <- SumCat[,i]/sum(SumCat[,i])
AvgCat <- SumCat/5
CurrCat <- colSums(AvgCat)

WhichFleet <-apply(AvgCat,2,which.max)

groups <- colnames(FleetCat)[-(1:2)]


outfile = "out.out"
write("#Input for fixed F runs",file=outfile)

for (group in groups)
{
  write(paste("flagF_",group," 33",sep=""),file=outfile,append=TRUE)
  vec <- rep(0,33)
  igroup <- which(groups==group)
  if (WhichFleet[igroup]>1) vec[WhichFleet[igroup]] = 1
  #if (WhichFleet[igroup]>1) vec[1] = 1
  #if (igroup<20)  vec[1] = 1
  #if (igroup>24)  vec[1] = 1
  write.table(t(vec),file=outfile,quote=FALSE,col.names=FALSE,row.names=FALSE,append=TRUE)
  write("",file=outfile,append=TRUE)
}


#load("H:/NEFSC/ATLANTIS/r4atlantis/surplus_results.rdata")
#umsy <- results[,"msy"]/(0.368*results[,"bzero"])
umsy <- results[,"fmsy"]
umsy[umsy>=1] <- 0.99
fmsy <- -1.*log(1.-umsy)/365

write("",file=outfile,append=TRUE)
for (group in groups)
{
  igroup <- which(groups==group)
  flag=0
  if (igroup<20)  flag = 1
  if (igroup>24)  flag = 1
  if (WhichFleet[igroup]>1)
  #if (flag==1)  
    {
    write(paste("mFC_",group,"  33",sep=""),file=outfile,append=TRUE)
    vec <- rep(0,33)
    jgroup <- which(rownames(results)==group)
    vec[WhichFleet[igroup]] = fmsy[jgroup]
    vec[WhichFleet[igroup]] = fmsy[44]    
    #vec[1] = fmsy[jgroup]
    write.table(t(format(vec,scientific=FALSE)),file=outfile,quote=FALSE,col.names=FALSE,row.names=FALSE,append=TRUE)
    write("",file=outfile,append=TRUE)
  }
}


temp <- read.csv('NeusGroups.csv')
group.index <- temp[temp$IsTurnedOn==1,]
is.bio <- c(3:29,31:33)
group.index$Code[is.bio-2]

0  2  3  5  6  7  9 11 12 13 14 17 18 19 20 21 22 24 26 35 36 37 41 42 43



r2 <- NULL
for (i in 8:14) {
if (i==8) pick <- c(3:29,31:33) #is.bio 
if (i==9) pick <- c(3:21,27:29,31:33) #is.target.bio
if (i==10) pick <- c(3:4,10,12,23) #is forage
if (i==11) pick <- c(5,11,13,14,16) #is ground  
if (i==12) pick <- c(6,8,9,15,7,17) #is other  
if (i==13) pick <- c(18:21) #is other  
if (i==14) pick <- c(28:29,31:32,29) #is benthic invert
r2 <- c(r2,get.foxbio(rowSums(biomass[,pick-1]),rowSums(catch[,pick-1])))
}



aa <- NULL
bb <- NULL
cc <- NULL
mults <- c(1,2,4,5)
#mults <- 1:8
for (eff.mult in mults)
{
  run.name <- "neusDynEffort_Test1_"
  
  if (eff.mult==1) setwd('~/Atlantis/atneus/test20150812')
  if (eff.mult==2) setwd('~/Atlantis/atneus/test20150816')
  if (eff.mult==3) setwd('~/Atlantis/atneus/test20150817_fmsy')
  if (eff.mult==4) 
    {
     setwd('~/Atlantis/atneus/spatial_mpa_all20/')
   #  run.name <- ""
    }
  if (eff.mult==5) setwd('~/Atlantis/atneus/test20150817_fmmsy/')
  
  #Bio <- read.table("neusDynEffort_Oct23_08d_BiomIndx.txt",header=TRUE)
  #Cat <- read.table("neusDynEffort_Oct23_08d_Catch.txt",header=TRUE) 
  if (eff.mult!=4) Bio <- read.table(paste(run.name,"BiomIndx.txt",sep=""),header=TRUE)
  if (eff.mult==4) Bio <- read.table("neusDynEffort_spatial_BoxBiomass_all20.txt",header=TRUE)
  #biomass <- biomass[-nrow(biomass),]
  if (eff.mult!=4) Cat <- read.table(paste(run.name,"Catch.txt",sep=""),header=TRUE)
  if (eff.mult==4) Cat <- read.table("neusDynEffort_spatial_Catch_ALL20.txt",header=TRUE)
  #catch <- catch[-nrow(catch),]
  
  numrow <- nrow(Bio)
  row.use <- numrow-1
  BioUse <- Bio[row.use,1:48]
  CatUse <- Cat[row.use,1:48]
  #print(cbind(eff.mult,CatUse))
  setwd('~/Atlantis/neus_sandbox')
  aa <- rbind(aa,c(eff.mult,get.Ind(BioUse,CatUse,bzero,path=getwd())))
  bb <- rbind(bb,c(eff.mult,BioUse))
  cc <- rbind(cc,c(eff.mult,CatUse))
}

bb2 <- bb
for (i in 1:nrow(bb2)) bb2[i,] <- as.numeric(bb[i,])/as.numeric(bb[1,])
cc2 <- cc
for (i in 1:nrow(cc2)) cc2[i,] <- as.numeric(cc[i,])/as.numeric(cc[1,])




#aa <- get.Ind(RefBioUse,RefCatUse)
#bb <- get.Ind(OABioUse,OACatUse)
#aa <- rbind(aa,bb)
for (i in 2:ncol(aa)) aa[,i] <- aa[,i]/max(aa[,i])
aa1 <- rep(1,ncol(aa))
aa0 <- rep(0,ncol(aa))
new <- as.data.frame(rbind(aa1,aa0,aa))

require(fmsb)
#linecols <- c("black","orange")
pick <- 1+c(1:3,5,7,8,9,10,11,12,13,14,15)
#no fishing: 
#pick <- 1+c(1,5,7,8,9,12,14,15)
litype <- 1:7
#radarchart(new[,pick],plty=rep(1,ncol(new[,pick])),pty=32,plwd=3,cglcol=gray(0.1),xlim=c(-1.4,1.4),pcol=c("black",gray(seq(0.1,0.9,length=nrow(aa)-1))),cex.lab=1.2)
radarchart(new[,pick],pty=32,plwd=2,cglcol=gray(0.1),xlim=c(-1.4,1.4),pcol=1:7,plty=1,cex.lab=1.2)
s1 <- rep("M",7)
#s1 <- rep("G",7)
s1 <- rep("NF",7)
#s2 <- c(1,8:13)
s2 <- 1:7
ss <- paste(s1,s2,sep="")
legend(1.2,1.4,legend=ss,lwd=2,col=1:7,cex=0.8,bty='n')
