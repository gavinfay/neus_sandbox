#Mapping spatial distribution from bil.prm (hdistrib) 
setwd("~/Atlantis/neus_sandbox")

#get the coords of the boxes
bgm.file <- read.table("neus30_v15.bgm",col.names=1:100,comment.char="",
                       fill=TRUE,header=FALSE)
boxes <- NULL
for (box in 0:29)
{
  label <- paste("box",box,".vert",sep="")
  pick <- grep(label,bgm.file[,1])
  boxes <- rbind(boxes,cbind(box,bgm.file[pick[-1],2:3]))
}
colnames(boxes) <- c("box","X","Y")
boxes[,2] <- as.numeric(as.character(boxes[,2]))
boxes[,3] <- as.numeric(as.character(boxes[,3]))
plot(0,0,xlim=c(450000,1600000),ylim=c(2300000,3600000))
for (box in 0:29)
{
  pick <- which(boxes[,1]==box)
  #polygon(360+coords[pick,3],coords[pick,4])
  polygon(boxes[pick,2],boxes[pick,3])
  labloc <- colMeans(boxes[pick,2:3])
  if (box>0 & box <23) text(labloc[1],labloc[2],box,cex=0.55)
}
  
 polygon  
  

hdistrib <- read.table("hdistrib.out",header=FALSE)
coords <- boxes
pick <- grep("SSK",hdistrib[,1])
pick2 <- pick[-grep("juv",hdistrib[pick,1])]
c2 <- NULL
for (irow in pick2)
{
  coords$fillpts <- as.numeric(t(hdistrib[irow,as.numeric(coords$box)+2]))
  #coords$fillpts <- as.numeric(t(hdistrib[irow,as.numeric(coords$id)+2])) 
  coords$season <- rep(which(pick==irow),nrow(coords))
  c2 <- rbind(c2,coords)
}
c2$season <- factor(c2$season)

# Map <- ggplot(c2, aes(long,lat, group = id, fill=fillpts)) + 
#  geom_polygon() + coord_equal() + labs(x = "Longitude", y = "Latitude") + 
#  scale_fill_gradient() + facet_wrap(~season) + #,nrow=1,ncol=4) + 
#  ggtitle(strsplit(as.character(hdistrib[pick2[1],1]),split="_",
#                   fixed=TRUE)[[1]][1])
# Map

Map <- ggplot(c2, aes(X,Y, group = box, fill=fillpts)) + 
  geom_polygon() + coord_equal() + labs(x = "Longitude", y = "Latitude") + 
  scale_fill_gradient() + facet_wrap(~season) + #,nrow=1,ncol=4) + 
  ggtitle(strsplit(as.character(hdistrib[pick2[1],1]),split="_",
                   fixed=TRUE)[[1]][1])
Map


