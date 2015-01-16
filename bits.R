




xx <- read.table("neus30_2014.bgm",header=FALSE,col.names=1:20,fill=TRUE,comment.char="")
xx <- read.table("neus30_2006.bgm",header=FALSE,col.names=1:20,fill=TRUE,comment.char="")
pick <- grep(".vert",xx[,1])
corners <- xx[pick,1:3]
corners[,2] <- as.numeric(as.character(corners[,2]))
corners[,3] <- as.numeric(as.character(corners[,3]))
corners <- na.omit(corners)

windows(record=TRUE)
cols <- gray(seq(0,1,length=30))
for (ibox in 0:29)
 {
  ipick <- grep("bnd_vert",corners[,1])
  plot(corners[ipick,3]~corners[ipick,2],type='l',main=ibox)
  string <- paste("box",ibox,sep="")
  ipick <- grep(string,corners[,1])
  polygon(corners[ipick,2],corners[ipick,3],col=cols[ibox+1])
 }




###############################
###########  25 June 2014
###############################
# check group structure etc.
root <- "J:/NEFSC/Atlantis/"
if (Sys.info()[['sysname']]=="Linux") 
  root <- "/media/My\ Passport/NEFSC/ATLANTIS/"
setwd(paste(root,"neus_sandbox/Test/test1/",sep=""))

groups <- read.csv("NeusGroups_v15.csv")
ngroups <- nrow(groups)
length(unique(groups[,1]))

### Sean's file

load("Species_groups_Sean.RData")
species_v15 <- species
split.groups <- NULL
groups <- read.csv("NeusGroups_v15_oldnames.csv")
parents <- unique(groups$Parent)
new.sp.codes <- rep(NA,nrow(species_v15))
for (code in parents)
{
  if(length(which(groups$Parent==code))==1)
    new.sp.codes[which(species_v15$Atcode==code)] <- as.character(groups$Child[which(groups$Parent==code)])
  if(length(which(groups$Parent==code))>1)
    {
    split.groups <- c(split.groups,code)
    new.sp.codes[which(species_v15$Atcode==code)] <- code
  }     
}
species_v15 <- cbind(species_v15,new.sp.codes)
for (i in 1:ncol(species_v15)) species_v15[,i] <- as.character(species_v15[,i])

neco.atl <- read.csv("pricecheck.csv")

svspp <- read.csv("SVSPP.csv",header=TRUE)
nespp <- read.csv("SPPNAME.csv",header=TRUE)
nespp$COMNAME <- nespp$SPPNM

print(split.groups)
###[1] "FVB" "FVT" "FBP" "FDE" "FDC" "SHD" "SHP" "SSK" "WHB" "WHT" "CEP" "BFF" "BMS" "PWN"
species.v15 <- species_v15
species.v15$new.sp.codes <- as.character(species.v15$new.sp.codes)



#####################################################
#FVB  (flatfish, now FLA)
species.v15$new.sp.codes[species.v15$new.sp.codes=="FVB"] <- "FLA"
species.v15$new.sp.codes[species.v15$COMNAME=="ATLANTIC HALIBUT"] <- "HAL"
species.v15$new.sp.codes[species.v15$COMNAME=="AMERICAN PLAICE"] <- "PLA"
species.v15$new.sp.codes[species.v15$COMNAME=="SUMMER FLOUNDER"] <- "SUF"
species.v15$new.sp.codes[species.v15$COMNAME=="FOURSPOT FLOUNDER"] <- "FOU"
species.v15$new.sp.codes[species.v15$COMNAME=="WINTER FLOUNDER"] <- "WIF"
species.v15$new.sp.codes[species.v15$COMNAME=="WITCH FLOUNDER"] <- "WTF"
species.v15$new.sp.codes[species.v15$COMNAME=="WINDOWPANE"] <- "WPF"
species.v15$new.sp.codes[grep("hogchoker",
    species.v15$COMNAME,ignore.case=TRUE,value=FALSE)] <- "FLA"

#####################################################
#FVT  (tunas and billfishes)
#
#tunas
species.v15[grep("tuna",species.v15$COMNAME,ignore.case=TRUE,value=FALSE),]
pick <- grep("tuna",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"TUN")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
pick <- grep("tuna",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"TUN")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
species.v15$new.sp.codes[grep("bluefin",
	species.v15$COMNAME,ignore.case=TRUE,value=FALSE)] <- "BFT"
#billfishes
pick <- grep("marlin",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
#   NESPP3        SPPNM Group      COMNAME
#95    216 MARLIN,WHITE Other MARLIN,WHITE
#96    217  MARLIN,BLUE Other  MARLIN,BLUE
#97    218   MARLIN,UNC Other   MARLIN,UNC
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"BIL")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
pick <- grep("swordfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"BIL")
newvec[1,4] <- nespp$NESPP3[grep("swordfish",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#####################################################
#FBP  (benthopelagic fish)
#
#
species.v15$new.sp.codes[species.v15$new.sp.codes=="FBP"] <- "BPF"
species.v15$new.sp.codes[species.v15$COMNAME=="ROUND HERRING"] <- "FDE"
species.v15$new.sp.codes[species.v15$COMNAME=="BUTTERFISH"] <- "BUT"
species.v15$new.sp.codes[species.v15$COMNAME=="BAY ANCHOVY"] <- "ANC"
species.v15$new.sp.codes[species.v15$COMNAME=="STRIPED ANCHOVY"] <- "ANC"

species.v15$new.sp.codes[grep("silverside",
     species.v15$COMNAME,ignore.case=TRUE,value=FALSE)] <- "BPF"
###Argentine 
pick <- grep("atlantic argentine",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"BPF")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
####harvestfish   #not in, need to add other Peprilus other than butterfish?
pick <- grep("harvestfish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"BPF")
newvec[3] <- svspp$SVSPP[grep("harvestfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#currently added to BPF but not in table:
17 Benthopelagics    FBP    38    361                 CAPELIN          BPF
24 Benthopelagics    FBP   205    319          ATLANTIC SAURY          BPF
25 Benthopelagics    FBP   208   <NA>           MACKEREL SCAD          BPF
26 Benthopelagics    FBP   209   <NA>             BIGEYE SCAD          BPF
27 Benthopelagics    FBP   211   <NA>              ROUND SCAD          BPF
28 Benthopelagics    FBP   212     76              ROUGH SCAD          BPF
29 Benthopelagics    FBP   212     77              ROUGH SCAD          BPF
30 Benthopelagics    FBP   212    331              ROUGH SCAD          BPF
31 Benthopelagics    FBP   213   <NA>              SILVER RAG          BPF
32 Benthopelagics    FBP   428   <NA> ATLANTIC THREAD HERRING          BPF
33 Benthopelagics    FBP   429   <NA>         SPANISH SARDINE          BPF
35 Benthopelagics    FBP   689    234          STRIPED MULLET          BPF
36 Benthopelagics    FBP   689    235          STRIPED MULLET          BPF
37 Benthopelagics    FBP   690   <NA>            WHITE MULLET          BPF



####################################################
#FDE
species.v15$new.sp.codes[species.v15$COMNAME=="ATLANTIC MENHADEN"] <- "MEN"
#
#gizzard shad
pick <- grep("gizzard",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"FDE")
newvec[1,4] <- nespp$NESPP3[grep("gizzard",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#hickory shad
#NESPP3      COMNAME
#69    173 SHAD,HICKORY
pick <- grep("hickory",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"FDE")
newvec[1,4] <- nespp$NESPP3[grep("hickory",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#smelt
#NESPP3       COMNAME
#68     171 HERRING SMELT
#132    371        SMELTS
pick <- grep("smelt",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDE")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#

###########################################################
#FMM mesopelagics (now MPF)
#
species.v15$new.sp.codes[species.v15$Atcode=="FMM"] <- "MPF"
species.v15$new.sp.codes[species.v15$Atcode=="FMN"] <- "MPF"
pick <- grep("lanternfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
pick <- pick[-(which(svspp$COMNAME[pick]=="LANTERNFISH UNCL"))]
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"MPF")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)


####################################################
# miscellaneous demersals
#FDC
species.v15$new.sp.codes[species.v15$new.sp.codes=="FDC"] <- "FDF"
species.v15$new.sp.codes[species.v15$COMNAME=="OFFSHORE HAKE"] <- "OHK"
species.v15$new.sp.codes[species.v15$COMNAME=="POLLOCK"] <- "POL"
species.v15$new.sp.codes[species.v15$COMNAME=="RED HAKE"] <- "RHK"
species.v15$new.sp.codes[species.v15$COMNAME=="BLACK SEA BASS"] <- "BSB"
species.v15$new.sp.codes[species.v15$COMNAME=="SCUP"] <- "SCU"
species.v15$new.sp.codes[species.v15$COMNAME=="TILEFISH"] <- "TYL"
species.v15$new.sp.codes[species.v15$COMNAME=="ACADIAN REDFISH"] <- "RED"
species.v15$new.sp.codes[species.v15$COMNAME=="OCEAN POUT"] <- "OPT"
species.v15$new.sp.codes[species.v15$COMNAME=="ATLANTIC SALMON"] <- "SAL"  ## DON'T SEE THIS IN SEAN's FILE. CHECK
species.v15$new.sp.codes[species.v15$COMNAME=="BLACK DRUM"] <- "DRM"  # MORE OF THESE
species.v15$new.sp.codes[species.v15$COMNAME=="STRIPED BASS"] <- "STB"  #DON'T SEE THIS EITHER
species.v15$new.sp.codes[species.v15$COMNAME=="TAUTOG"] <- "TAU" 
species.v15$new.sp.codes[species.v15$COMNAME=="ATLANTIC WOLFFISH"] <- "WOL"
# REMAINDER OF FDC ARE EITHER States Demersals, or Misc Demersals (FDF)
species.v15$new.sp.codes[species.v15$COMNAME=="ATLANTIC CROAKER"] <- "DRM"
species.v15$new.sp.codes[species.v15$COMNAME=="BLACK DRUM"] <- "DRM"
#red drum not in list. DO WE WANT OTHER DRUMS???
#species.v15$new.sp.codes[species.v15$COMNAME=="RED DRUM"] <- "DRM"
#pick <- grep("red drum",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
#newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"DRM")
#colnames(newvec) <- colnames(species.v15)
#species.v15 <- rbind(species.v15,newvec)
species.v15$new.sp.codes[species.v15$COMNAME=="SPOT"] <- "DRM"

#own groups
#Striped Bass  (STB)
#142    418 STRIPED BASS Other Demersal Fish 2.027354
pick <- grep("striped bass",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"STB")
newvec[1,3] <- svspp$SVSPP[grep("striped bass",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#Atlantic salmon (SAL)
#96    305 SALMON,ATLANTIC               2.499929
pick <- grep("salmon",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"SAL")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#####state demersals
#eels
#NESPP3      COMNAME       AtlantisGroup     Price
#37    115 EEL,AMERICAN Other Demersal Fish 2.4568239
#38    116   EEL,CONGER Other Demersal Fish 0.4849696
#39    117      EEL, NK Other Demersal Fish 0.4816598
#pick <- grep("eel",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
#newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"SDF")
#colnames(newvec) <- colnames(species.v15)
#species.v15 <- rbind(species.v15,newvec)
pick <- grep("cong",svspp$SCINAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"SDF")
newvec[1,4] <- nespp$NESPP3[grep("cong",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
pick <- grep("anguil",svspp$SCINAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"SDF")
pick <- grep("eel",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec[grep("american",newvec[,5],ignore.case=TRUE,value=FALSE),4] <- nespp$NESPP3[pick[grep("american",nespp$COMNAME[pick],ignore.case=TRUE,value=FALSE)]]
#newvec[grep("uncl",newvec[,5],ignore.case=TRUE,value=FALSE),4] <- nespp$NESPP3[pick[grep("NK",nespp$COMNAME[pick],ignore.case=TRUE,value=FALSE)]]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#sturgeons
svspp[grep("sturgeon",svspp$COMNAME,ignore.case=TRUE,value=FALSE),]
    SVSPP           COMNAME               SCINAME FISH   PD TL
278   380 ATLANTIC STURGEON ACIPENSER OXYRHYNCHUS    Y <NA> NA
pick <- grep("sturgeon",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"SDF")
newvec[grep("atlantic",newvec[,5],ignore.case=TRUE,value=FALSE),3] <- svspp$SVSPP[grep("sturgeon",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#spotted seatrout
#NESPP3           COMNAME       AtlantisGroup   Price
#112    345 SEA TROUT,SPOTTED Other Demersal Fish 1.39038
pick <- grep("sea trout,spotted",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"SDF")
newvec[1,3] <- svspp$SVSPP[grep("spotted seatrout",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#fed demersals missing
#northern puffer
#NESPP3              COMNAME       AtlantisGroup     Price
#144    429     PUFFER, NORTHERN Other Demersal Fish 0.7525483
#145    430 PUFFER (SEA CHICKEN) Other Demersal Fish 0.3164713
#146    431              PUFFERS                     2.3223792
#pick <- grep("puffer",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
pick <- grep("northern puffer",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"FDF")
newvec[1,4] <- nespp$NESPP3[grep("puffer, northern",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#garfish
#133 GARFISHES               0.1362264
pick <- grep("garfish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("garfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#hagfish
#150 HAGFISH
pick <- grep("hagfish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("hagfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#hogfish
#179 HOGFISH
pick <- grep("hogfish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("hogfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#oyster toadfish
#451 TOADFISHES
pick <- grep("toadfish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("toadfish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#sand perch
#311    PERCH,SAND
pick <- grep("perch,sand",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("sand perch",svspp$COMNAME,ignore.case=TRUE,value=FALSE)][2]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#Atlantic needlefish
#19 NEEDLEFISH,ATLANTIC
pick <- grep("needlefish",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("atlantic needlefish",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#sheepshead
#356 SHEEPSHEAD,ATLANTIC
pick <- grep("sheepshead",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"FDF")
newvec[1,3] <- svspp$SVSPP[grep("sheepshead",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#spot
#406 SPOT
#pick <- which(neco.atl$COMNAME=="SPOT")
#newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"DRM")
#newvec[1,3] <- svspp$SVSPP[which(svspp$COMNAME=="SPOT")]
#colnames(newvec) <- colnames(species.v15)
#species.v15 <- rbind(species.v15,newvec)

#tomcod  
#
pick <- grep("tomcod",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"FDF")
newvec[1,4] <- nespp$NESPP3[grep("tomcod",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

###
## following are fish that are
## currently in FDF but not in Tech Memo table
##
47  Miscellaneous demersals    FDC    91   <NA>              MARLIN-SPIKE          FDF
50  Miscellaneous demersals    FDC    98   <NA>             DEEPWATER DAB          FDF
51  Miscellaneous demersals    FDC    99    158         GREENLAND HALIBUT          FDF
56  Miscellaneous demersals    FDC   114   <NA>           BLACKMOUTH BASS          FDF
59  Miscellaneous demersals    FDC   117   <NA>       SMALLMOUTH FLOUNDER          FDF
62  Miscellaneous demersals    FDC   120   <NA>    BLUESPOTTED CORNETFISH          FDF
74  Miscellaneous demersals    FDC   150   <NA>   SHERBORN'S CARDINALFISH          FDF
76  Miscellaneous demersals    FDC   153   <NA>                      <NA>          FDF
86  Miscellaneous demersals    FDC   165   <NA>             ALLIGATORFISH          FDF
87  Miscellaneous demersals    FDC   166   <NA>                    GRUBBY          FDF
88  Miscellaneous demersals    FDC   167   <NA>       INQUILINE SNAILFISH          FDF
90  Miscellaneous demersals    FDC   169   <NA> ATLANTIC SPINY LUMPSUCKER          FDF
91  Miscellaneous demersals    FDC   170   <NA>         ATLANTIC SEASNAIL          FDF
96  Miscellaneous demersals    FDC   175   <NA>            FLYING GURNARD          FDF
99  Miscellaneous demersals    FDC   178   <NA>                      <NA>          FDF
100 Miscellaneous demersals    FDC   179     12        NORTHERN STARGAZER          FDF
101 Miscellaneous demersals    FDC   180   <NA>               ROCK GUNNEL          FDF
102 Miscellaneous demersals    FDC   187    236              RED GOATFISH          FDF
103 Miscellaneous demersals    FDC   188   <NA>          STRIPED CUSK-EEL          FDF
104 Miscellaneous demersals    FDC   189   <NA>            ARCTIC EELPOUT          FDF
105 Miscellaneous demersals    FDC   190   <NA>              WOLF EELPOUT          FDF
109 Miscellaneous demersals    FDC   194   <NA>             FAWN CUSK-EEL          FDF
110 Miscellaneous demersals    FDC   232   <NA>        SHORTNOSE GREENEYE          FDF
114 Miscellaneous demersals    FDC   436   <NA>                SAND DIVER          FDF
117 Miscellaneous demersals    FDC   439   <NA>                 SNAKEFISH          FDF
118 Miscellaneous demersals    FDC   440   <NA>       LONGNOSE LANCETFISH          FDF
'
#########################################################
####  Demersal sharks
#"SHD"  (now DSH)
species.v15$new.sp.codes[species.v15$new.sp.codes=="SHD"] <- "DSH"
species.v15$new.sp.codes[species.v15$COMNAME=="SMOOTH DOGFISH"] <- "SMO"
species.v15$new.sp.codes[species.v15$COMNAME=="SANDBAR SHARK"] <- "SSH"
#Dogfish 
#        sandbar
#        porbeagle
#171    481             SHARK,PORBEAGLE
pick <- which(neco.atl$COMNAME=="SHARK,PORBEAGLE")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"POR")
newvec[1,3] <- svspp$SVSPP[grep("porbeagle",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        nurse
pick <- grep("nurse",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"DSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        bull
pick <- grep("shark,bull",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"DSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#	lemon
pick <- grep("shark,lemon",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"DSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        sharpnose
#176    494    SHARK,ATLANTIC SHARPNOSE
pick <- which(neco.atl$COMNAME=="SHARK,ATLANTIC SHARPNOSE")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"DSH")
newvec[1,3] <- svspp$SVSPP[grep("sharpnose shark",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#sand tiger
pick <- grep("sand tiger",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"DSH")
newvec[1,4] <- nespp$NESPP3[grep("sand tiger",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)


#	scalloped hammerhead
pick <- grep("scalloped",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"DSH")
newvec[1,3] <- svspp$SVSPP[grep("scalloped",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        thresher
#117    353              SHARK,THRESHER
pick <- grep('thresher',nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"DSH")
newvec[1,3] <- svspp$SVSPP[grep("thresher shark",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)


########## Pelagic sharks

#blue shark
#175    493                  SHARK,BLUE
pick <- which(nespp$COMNAME=="SHARK,BLUE")
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"BLS")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

# pelagic shark group
#"SHP" 
# Not here. Need to add PSH (pelagic sharks), BLS (blue shark), and POR (porbeagle)
species.v15$new.sp.codes[species.v15$new.sp.codes=="SHP"] <- "PSH"

#       dusky	 
pick <- grep("dusky shark",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"PSH")
newvec[1,4] <- nespp$NESPP3[grep("dusky",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        great hammerhead
pick <- grep("great hammerhead",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        shortfin mako
#        118    355 SHARK,BONITO(SHORTFIN MAKO)
#        120    357              SHARK,MAKO UNC
#        121    358          SHARK,LONGFIN MAKO
pick <- grep("mako",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"PSH")
newvec[1,3] <- svspp$SVSPP[grep("mako",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec[1,])
	
#	white
#        170    480                 SHARK,WHITE
pick <- which(neco.atl$COMNAME=="SHARK,WHITE")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#	blacknose
pick <- grep("blacknose shark",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        silky
pick <- grep("silky",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"PSH")
newvec[1,4] <- nespp$NESPP3[grep("silky",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        blacktip
#        173    487              SHARK,BLACKTIP
pick <- which(neco.atl$COMNAME=="SHARK,BLACKTIP")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"PSH")
newvec[1,3] <- svspp$SVSPP[grep("blacktip",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#	tiger
pick <- which(nespp$COMNAME=="SHARK,TIGER")
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

#        finetooth
pick <- grep("finetooth",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
		
#	bignose  
pick <- grep("bignose",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"PSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)



####################################################
# Skates , remove rays and split out winter and little
#
#"SSK" 
species.v15$new.sp.codes[species.v15$new.sp.codes=="SSK"] <- "SK"
species.v15$new.sp.codes[grep("RAY",species_v15$COMNAME)] <- NA
species.v15$new.sp.codes[species.v15$COMNAME=="RAY AND SKATE UNCL"] <- "SK"
species.v15$new.sp.codes[species.v15$COMNAME=="LITTLE SKATE"] <- "LSK"
species.v15$new.sp.codes[species.v15$COMNAME=="WINTER SKATE"] <- "WSK"


######################################################
#  marine mammals
#  change over codes, need to add right whales and small tootheds, but unlikely to be in this database though!
#"WHB" 
species.v15$new.sp.codes[species.v15$new.sp.codes=="WHB"] <- "BWH"
#"WHT" 
species.v15$new.sp.codes[species.v15$new.sp.codes=="WHT"] <- "TWH"

#######################################################
# Turtles
#
pick <- grep('turtle',nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),"REP")
newvec[grep("loggerhead",newvec[,5],ignore.case=TRUE,value=FALSE),3] <- svspp$SVSPP[grep("loggerhead",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
newvec[grep("leatherback",newvec[,5],ignore.case=TRUE,value=FALSE),3] <- svspp$SVSPP[grep("leatherback",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#

######################################################
# Seabirds
# again, need to add from somewhere else


elevens <- which(species.v15$SVSPP==11)
newrow <- species.v15[elevens[1],]
newrow[1,4] <- NA
species.v15 <- species.v15[-elevens,]
species.v15 <- rbind(species.v15,newrow)



#duplicated nespp3 codes
code.freqs <- aggregate(species.v15$NESPP3,by=list(nespp=species.v15$NESPP3),length)
duplicate.nespp <- code.freqs[code.freqs$x>1,1]
tagrows <- NULL
for (i in 1:length(duplicate.nespp)) tagrows <- c(tagrows,as.numeric(which(species.v15$NESPP==duplicate.nespp[i])))



########################################################
#  INVERTEBRATES
#######################################################
# squid
#"CEP" 
# allocate unclassifieds to shallow macrozoobenthos? or to one of the two squids - which?
species.v15$new.sp.codes[species.v15$new.sp.codes=="CEP"] <- "BMS"
species.v15$new.sp.codes[species.v15$COMNAME=="LONGFIN SQUID"] <- "LSQ"
species.v15$new.sp.codes[species.v15$COMNAME=="NORTHERN SHORTFIN SQUID"] <- "ISQ"

#######################################################
# benthic inverts, lots to do here
#"BMS" 
# Want to separate out Red deep-sea crab.
#191    710        CRAB,RED AT
pick <- which(neco.atl$COMNAME=="CRAB,RED AT")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"RCB")
newvec[1,3] <- svspp$SVSPP[grep("red deepsea crab",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

pick <- grep("crab",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),
                "BMS")
pick <- grep("RED",newvec[,5],ignore.case=TRUE)
newvec <- newvec[-pick,]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

pick <- grep("crab",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,nespp$NESPP3[pick],as.character(nespp$COMNAME[pick]),
                "BMS")
pick <- grep("RED",newvec[,5],ignore.case=TRUE)
newvec <- newvec[-pick,]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#WHELKS
pick <- grep("knobbed",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],
                as.character(neco.atl$COMNAME[pick]),"BMS")
newvec[1,3] <- svspp$SVSPP[grep("knobbed",svspp$COMNAME,ignore.case=TRUE,value=FALSE)]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)





########################################################
# shrimp
#"PWN"
species.v15$new.sp.codes[species.v15$new.sp.codes=="PWN"] <- "OSH"
species.v15$new.sp.codes[species.v15$COMNAME=="NORTHERN SHRIMP"] <- "NSH"
#Northern shrimp
#(Pandalus borealis & other pandalids)
#sand shrimp
#pink shrimp
#brown shrimp (& other paneids)
#198    731                       SHRIMP,BROWN
#203    738      SHRIMP,ATLANTIC & GULF, BROWN
#202    737                     MANTIS SHRIMPS
pick1 <- grep("shrimp",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
pick <- pick1[grep("pandalus",svspp$SCINAME[pick1],ignore.case=TRUE,value=FALSE)]
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"NSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
pick <- pick1[grep("penaeus",svspp$SCINAME[pick1],ignore.case=TRUE,value=FALSE)]
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"OSH")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)


#
#########################################################
# benthic filter feeders
#"BFF" 
# Want to separate surfclam (CLA), quahog (QHG), and others (BFF)
# check svsp codes for these
#Bay scallop
#224    799 SCALLOP,BAY
pick <- which(neco.atl$COMNAME=="SCALLOP,BAY")
newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"BFF")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#ocean quahog
#206    754           CLAM,OCEAN QUAHOG
pick <- grep("ocean quahog",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"QHG")
newvec[,4] <- nespp$NESPP3[grep("ocean quahog",nespp$COMNAME,ignore.case=TRUE,value=FALSE)]
#pick <- grep("quahog",neco.atl$COMNAME,ignore.case=TRUE,value=FALSE)
#newvec <- cbind("","",NA,neco.atl$NESPP3[pick],as.character(neco.atl$COMNAME[pick]),"QHG")
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)
#surf clam
pick <- grep("surf",svspp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec <- cbind("","",svspp$SVSPP[pick],NA,as.character(svspp$COMNAME[pick]),"CLA")
pick1 <- grep("surf",nespp$COMNAME,ignore.case=TRUE,value=FALSE)
newvec[grep("arctic",newvec[,5],ignore.case=TRUE,value=FALSE),
       4] <- nespp$NESPP3[pick1[grep("arctic",nespp$COMNAME[pick1],ignore.case=TRUE,value=FALSE)]]
newvec[-grep("arctic",newvec[,5],ignore.case=TRUE,value=FALSE),
       4] <- nespp$NESPP3[pick1[-grep("arctic",nespp$COMNAME[pick1],ignore.case=TRUE,value=FALSE)]]
colnames(newvec) <- colnames(species.v15)
species.v15 <- rbind(species.v15,newvec)

colnames(species.v15)[6] <- "NewAtcode"

#also in BFF, to come
porifera
hydrozoa
anthozoa
selected annelids
other bivalves
cirripedia
bryozoa
brachiopoda
crinoidea
hemichordate
ascidians
204    743              CLAM,BLOOD ARC
205    748                  CLAMS,HARD
207    760         CLAM,RAZOR,ATLANTIC
208    763                   CLAM,SOFT
209    764                    CLAM,UNC



