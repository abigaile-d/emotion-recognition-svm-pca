#NOTE: SHOULD RUN pca_train.r BEFORE RUNNING THIS SCRIPT

if(CURR == "emo"){
	N = 4178/2	#total number of observations per set
	P = 48*48	#number of pixels
	IN	<- "emotion_testset"
	OUT	<- "emotion_prediction.csv"
}else if(CURR == "ide"){
	N = 3537/2	#total number of observations per set
	P = 48*48	#number of pixels
	IN	<- "identity_testset"
	OUT	<- "identity_prediction.csv"
}

Neigen	<- 300				#number of principal components to be considered, same as training
Eigen	<- PCA$rotation[,1:Neigen]

dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
ytest	<- dataset[,1]
xtest	<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
xtest	<- matrix(as.numeric(xtest), N, P, byrow=FALSE)

Wtest		<- sweep(xtest,2,PCA$center,"-") %*% Eigen	#project into face space: W = (x-mean)*E
cat(file=OUT, append=FALSE, fill=TRUE, "ACTUAL, EUCLIDEAN PREDICTION, MAHALANOBIS PREDICTION")
acc_euc			<- 0
acc_mah			<- 0
prediction_euc	<- c()
prediction_mah	<- c()

sigma		<- cov(Wtrain)

for(i in 1:N){
	eucdist		<- sqrt(rowSums(sweep(Wclass,2,Wtest[i,],"-")^2))	#get the distance of each new image from each classes
	mahdist		<- mahalanobis(Wclass,Wtest[i,],sigma)
	
	prediction_euc[i]	<- classes[which.min(eucdist)]
	prediction_mah[i]	<- classes[which.min(mahdist)]

	cat(file=OUT, append=TRUE, fill=TRUE, paste(ytest[i], prediction_euc[i], prediction_mah[i], sep=","))
	if(ytest[i] == prediction_euc[i])
		acc_euc	<- acc_euc+1
	if(ytest[i] == prediction_mah[i])
		acc_mah	<- acc_mah+1
}

print(acc_euc/N)
print(acc_mah/N)
cat(file=OUT, append=TRUE, fill=TRUE, paste("Euclidean Accuracy", acc_euc/N, sep="="))
cat(file=OUT, append=TRUE, fill=TRUE, paste("Mahalanobis Accuracy", acc_mah/N, sep="="))