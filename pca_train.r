CURR	<- "ide"	#set to "emo" when doing emotion recognition, or "ide" when identity recognition
BASEDIR <- "C:/Users/Abigaile Dionisio/Documents/Masters/CS280/MP"
setwd(BASEDIR)

P 		<- 48*48	#number of pixels
if(CURR == "emo"){
	N 	<- 4178/2	#total number of observations per set
	IN	<- "emotion_trainset"
}else if(CURR == "ide"){
	N 	<- 3537/2+1	#total number of observations per set
	IN	<- "identity_trainset"
}

#load training set
dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
y		<- as.numeric(dataset[,1])
x		<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
x		<- matrix(as.numeric(x), N, P, byrow=FALSE)

PCA	<- prcomp(x)
#plot(PCA$sdev^2)
#plot(PCA, type="lines")
#biplot(PCA)

Neigen	<- 300	#number of principal components to be considered
Eigen	<- PCA$rotation[,1:Neigen]	#principal eigenfaces

Nclass	<- length(unique(y))
Wclass 	<- c()
classes	<- sort(unique(y))

for(i in 1:Nclass){
	thisclass	<- which(y==classes[i])
	if(length(thisclass)>1)
		Wtmp	<- sweep(x[thisclass,],2,PCA$center,"-") %*% Eigen	#project into face space: W = (x-mean)*E
	else
		Wtmp	<- t(as.matrix(x[thisclass,]-PCA$center)) %*% Eigen	#project into face space: W = (x-mean)*E
		
	Wclass		<- rbind(Wclass, array(colMeans(Wtmp)))				#get average per class: emotion or person's identity
}

Wtrain		<- sweep(x,2,PCA$center,"-") %*% Eigen	#project into face space: W = (x-mean)*E