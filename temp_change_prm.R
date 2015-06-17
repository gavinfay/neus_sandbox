
#' this function finds a parameter in a prm file, 
#' maps the old values to new group structure,
#' and then writes out the new parameters in a text file,
#' for insertion into a new .prm file
#'  this version is for parameters with dimension and then values on the 2nd line
#'  
change.prm5 <- function(path,origfile,param.name,outfile,mapfile,param.type,
                        name2=NULL)
{
  #this function finds a parameter in a prm file, 
  #maps the old values to new group structure,
  #and then writes out the new parameters in a text file,
  #for insertion into a new .prm file
  # this version is for parameters with dimension and then values on the 2nd line
  
  #set working directory
  setwd(path)
  
  #write first line of outfile so all future calls are append=TRUE
  write(" ",file=outfile)
  
  #Lookup table with new codes for functional groups along with 'parent' groups from Atlantis-neus v1.
  CodeRelations <- read.csv(mapfile)
  #read in orig param file
  TheData <- read.table(origfile,col.names=1:100,comment.char="",fill=TRUE,header=FALSE)
  
  pick <- which(CodeRelations$IsVertebrate==1)
  parents <- unique(CodeRelations$Parent[pick])
  
  #loop over the parent vertebrate groups
  for (name2 in as.character(parents))
   {
    
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
  
  if (nrow(xx)>0)
   {
  tempmat <- matrix(NA,nrow=nrow(xx),ncol=2)
  if (param.name!="")
  {
    for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
      substr(xx[igroup,1],start=1+str_length(param.name),
             stop=str_length(xx[igroup,1]))
    #strsplit(as.character(xx[igroup,1]),param.name)[[1]][2]
    if (length(name2)>0)
    {
      for (igroup in 1:nrow(tempmat)) tempmat[igroup,1] <- 
        #strsplit(as.character(tempmat[igroup,1]),name2)[[1]][1]
        substr(tempmat[igroup,1],stop=str_length(tempmat[igroup,1])-
                 str_length(name2),start=1)
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
  
  
  #as.numeric(t(yy[1,1:10]))
  
  #assign the old vals to the new codes, write a csv for data entry with columns to change highlighted and 'parent' group parameter values inserted.
  output <- CodeRelations #list(Code=CodeRelations$Child,Parent=CodeRelations$Parent,Change=CodeRelations$Change)
  output$x <- rep(NA,nrow(output))
  output$x <- tempmat[match(CodeRelations$Parent,tempmat[,1]),2]
  #output$x[] <- 11
  #output$li_b <- rep(NA,nrow(output))
  #output$li_b <- tempmat[match(CodeRelations$Parent,tempmat[,1]),3]
  #output$source <- ""
  #output$source[output$Change==0] <- "Atlantis-Neus v1"
  #head(output)
  #write.table(output,file="weightlength.csv",col.names=TRUE,row.names=FALSE,quote=FALSE,sep=",")
  
  matches <- match(CodeRelations$Parent,tempmat[,1])
  numcols <- unique(as.numeric(output$x[which(is.na(output$x)==FALSE)]))
  output2 <- matrix(NA,ncol=numcols,nrow=nrow(output))
  for (irow in 1:nrow(output2))
  {
    output2[irow,] <-  
      as.numeric(as.character(t(yy[matches[irow],1:ncol(output2)])))
  }
  
  
  ## assuming that the new values have been filled in, put back into format for the .prm file
  if (param.type==1)  #just vertebrates
  {
    Nverts <- length(CodeRelations$IsVertebrate[CodeRelations$IsVertebrate==1])
    temptab <- matrix(NA,nrow=Nverts,ncol=2)
    temptab[,1] <- paste(param.name,output$Child[output$IsVertebrate==1],sep="")
    if (length(name2)>0) temptab[,1] <- paste(param.name,output$Child[output$IsVertebrate==1],name2,sep="")
    temptab[,2] <- output$x[output$IsVertebrate==1]
    #temptab[,3] <- paste("weight at length a parameter for ",output[output$IsVertebrate==1,"Long.Name"],sep="")
    #write.table(temptab,file=outfile,col.names=FALSE,row.names=FALSE,quote=FALSE,sep=" ")
    #write(" ",file=outfile,append=TRUE)
    rows.use <- which(output$IsVertebrate==1)
    write(" ",file=outfile)
    for (row in rows.use)
      #for (irow in 1:nrow(temptab))
    {
      irow = which(rows.use==row)
      if (is.na(temptab[irow,2])==FALSE)
      {
        write.table(t(temptab[irow,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write.table(t(output2[row,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write(" ",file=outfile,append=TRUE)
      }  
    }  
    
  }
  if (param.type==2)  #all groups
  {
    write(" ",file=outfile,append=TRUE)
    cpick <- which(CodeRelations$Parent==name2)
    for (name3 in CodeRelations$Child[cpick])
    {
    Ngroups <- nrow(CodeRelations)
    temptab <- matrix(NA,nrow=Ngroups,ncol=2)
    temptab[,1] <- paste(param.name,output$Child,sep="")
    if (length(name2)>0) temptab[,1] <- paste(param.name,output$Child,name3,sep="")
    temptab[,2] <- output$x
    #temptab[,3] <- paste("weight at length a parameter for ",output[output$IsVertebrate==1,"Long.Name"],sep="")
    
    for (irow in 1:nrow(temptab))
    {
      if (is.na(temptab[irow,2])==FALSE)
      {
        write.table(t(temptab[irow,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write.table(t(output2[irow,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write(" ",file=outfile,append=TRUE)
      }
    }
   }
  }
  if (param.type==3)  #just invertebrates
  {
    Nverts <- length(CodeRelations$IsVertebrate[CodeRelations$IsVertebrate!=1])
    temptab <- matrix(NA,nrow=Nverts,ncol=2)
    temptab[,1] <- paste(param.name,output$Child[output$IsVertebrate!=1],sep="")
    if (length(name2)>0) temptab[,1] <- paste(param.name,output$Child[output$IsVertebrate!=1],name2,sep="")
    temptab[,2] <- output$x[output$IsVertebrate!=1]
    rows.use <- which(output$IsVertebrate!=1)
    write(" ",file=outfile)
    for (row in rows.use)
      #for (irow in 1:nrow(temptab))
    {
      if (is.na(temptab[row,2])==FALSE)
      {
        irow = which(rows.use==row)
        write.table(t(temptab[irow,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write.table(t(output2[row,]),file=outfile,col.names=FALSE,row.names=FALSE,
                    quote=FALSE,sep=" ",append=TRUE)
        write(" ",file=outfile,append=TRUE)
      }
    }
    #write.table(temptab,file=outfile,col.names=FALSE,row.names=FALSE,quote=FALSE,sep=" ")
    #write(" ",file=outfile,append=TRUE)
  }
  }
  }
  
}


