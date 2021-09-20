CURRSET <- "train"

if(CURR == "emo"){
	N	<- 4178/2	#total number of observations per set
	OUT	<- paste0("emotion_",CURRSET,"set.dim")
}else if(CURR == "ide"){
	N 	<- 3537/2	#total number of observations per set
	OUT	<- paste0("identity_",CURRSET,"set.dim")
}

if(CURRSET == "train"){
	xdim	<- x
	ydim	<- y
}else if(CURRSET == "test"){
	xdim	<- xtest
	ydim	<- ytest
}

for(Neigen in 1:10){					#test 100 to 1000 principant components
	Neigen	<- Neigen*100				#number of principal components to be considered
	Eigen	<- PCA$rotation[,1:Neigen]
	
	xhat	<- c()
	xhat	<- sweep(xdim,2,PCA$center,"-") %*% Eigen	#transform data into the lower dimension
	
	xsvm	<- matrix(paste(seq(1:Neigen), t(xhat), sep=":"), N, Neigen, byrow=TRUE)
	xsvm	<- cbind(ydim, xsvm)
	colnames(xsvm)	<- NULL

	library(MASS)
	OUTN	<- paste0(OUT, Neigen)
	write.matrix(xsvm, file=OUTN, sep=" ")				#write files with new feature set into libsvm format
}