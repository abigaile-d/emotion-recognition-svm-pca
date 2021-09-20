BASEDIR <- "C:/Users/Abigaile Dionisio/Documents/Masters/CS280/MP"
setwd(BASEDIR)

N = 4178	#total number of observations
P = 48*48	#number of pixels (squared)

# EMOTION
IN		<- "train.csv"
OUT 	<- "emotion_dataset"

dataset	<- scan(IN, what=list(y=0, x=""), skip=1, sep=",")				#load dataset (emotion: pixels)
x		<- matrix(unlist(strsplit(dataset$x, " ")), N, P, byrow=TRUE)	#parse space separated pixels
xsvm	<- matrix(paste(seq(1:P), t(x), sep=":"), N, P, byrow=TRUE)		#convert to libsvm format <index>:<pixel>
svm		<- cbind(dataset$y, xsvm)										#1st col should be label = emotion
colnames(svm)	<- NULL

library(MASS)
write.matrix(svm, file=OUT, sep=" ")									#write file in libsvm format

#IDENTITY
IN		<- "train_identity.csv"
OUT 	<- "identity_dataset_pre"

y		<- scan(IN, 0, skip=1, sep=",")									#load auxiliary file (identities)
svm		<- cbind(y, xsvm)												#1st col should be label = emotion
colnames(svm)	<- NULL

occurence	<- table(y)													#remove observations that occurred only once and type=unknown(-1)
occurence	<- as.numeric(unlist(labels(occurence[occurence>6])))
occurence	<- occurence[occurence>-1]
final		<- which(y %in% occurence)

library(MASS)
write.matrix(svm[final,], file=OUT, sep=" ")							#write file in libsvm format