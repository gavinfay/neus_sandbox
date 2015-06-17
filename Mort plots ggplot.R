#####1.14.15
#Set working directory and load packages
setwd('/Users/mwinton/Desktop/for Gavin')
setwd('~/Atlantis/neus_sandbox')
library(ggplot2)
library(grid)

#read in file from WD
dat = read.table("rjg_output/neusDynEffort_Test1_SpecificMort.txt", sep=" ",header=T)
  str(dat)
  summary(dat)

#Choose species and age class (make sure to keep quotations around species code)
species="FPS"
ageclass=7

M1 = paste(species,ageclass,"S0","M1", sep = ".")
M2 = paste(species,ageclass,"S0","M2", sep = ".")
Fish = paste(species,ageclass,"S0","F", sep = ".")

#Select these columns for plotting
pdat=dat[,c("Time",M1,M2,Fish)]
  summary(pdat)

#Plot 
dev.off()
g<-ggplot(pdat, aes(Time, y = value, color = variable)) + 
  geom_line(aes(y = pdat[,2], col = "y1")) + 
  geom_line(aes(y = pdat[,3], col = "y2")) +
  geom_line(aes(y = pdat[,4], col = "y3")) +
  xlab("Days since Jan 1 1964") +
  ylab("Mortality") +
  ggtitle(paste(species,"Age",ageclass)) +
  scale_color_discrete(labels = c("M1","M2","F"))
g

###################Multipanel plot of all age classes of a given species
#Choose species (make sure to keep quotations around species code)
species="FPS"

p <- list()
for (i in 1:10) {
  ageclass=i-1
  M1 = paste(species,ageclass,"S0","M1", sep = ".")
  M2 = paste(species,ageclass,"S0","M2", sep = ".")
  Fish = paste(species,ageclass,"S0","F", sep = ".")
  
  #Select these columns for plotting
  pdat=dat[,c("Time",M1,M2,Fish)]
  pdat$C1=c("#1b9e77")
  pdat$C2=c("#7570b3")
  pdat$C3=c("#d95f02")
  names(pdat)=c("Time","M1","M2","F","C1","C2","C3")
  
  a0 <- ggplot(pdat,color=variable)+geom_line(aes_string(x="Time",y="M1",col="C1")) +
        geom_line(aes_string(x="Time",y="M2",col="C2")) +
        geom_line(aes_string(x="Time",y="F",col="C3")) +
        xlab("Days since Jan 1 1964") +
        ylab("Mortality") +
        ggtitle(paste(species,"Age",ageclass)) +
        theme(legend.position="none")
  
  p[[i]]=a0                          
}                                   

dev.off()              
pushViewport(viewport(layout = grid.layout(5, 2)))
print(p[[1]], vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(p[[2]], vp = viewport(layout.pos.row = 1, layout.pos.col = 2))
print(p[[3]], vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
print(p[[4]], vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
print(p[[5]], vp = viewport(layout.pos.row = 3, layout.pos.col = 1))  
print(p[[6]], vp = viewport(layout.pos.row = 3, layout.pos.col = 2))
print(p[[7]], vp = viewport(layout.pos.row = 4, layout.pos.col = 1))
print(p[[8]], vp = viewport(layout.pos.row = 4, layout.pos.col = 2))
print(p[[9]], vp = viewport(layout.pos.row = 5, layout.pos.col = 1))
print(p[[10]], vp = viewport(layout.pos.row = 5, layout.pos.col = 2))

