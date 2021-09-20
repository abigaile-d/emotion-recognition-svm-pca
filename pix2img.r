BASEDIR <- "C:/Users/Abigaile Dionisio/Documents/Masters/CS280/MP"
setwd(BASEDIR)

# create dirs if missing
dir.create(file.path(BASEDIR, "images"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "emo_train"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "emo_test"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_train"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_test"), showWarnings = FALSE)


# EMOTION
P = 48*48	#number of pixels
N = 4178/2	#total number of observations per set

IN		<- "emotion_trainset"	
dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
y		<- dataset[,1]
x		<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
x		<- matrix(as.numeric(x), N, P, byrow=FALSE)

for(i in 1:N){
	m	<- matrix(rev(x[i,]), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/emo_train/img", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar=rep(0, 4))
	image(m, axes=FALSE, col=grey(seq(0,1,length=256)))	#recreate pixels as image
	dev.off()
}

IN		<- "emotion_testset"
dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
y		<- dataset[,1]
x		<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
x		<- matrix(as.numeric(x), N, P, byrow=FALSE)

for(i in 1:N){
	m	<- matrix(rev(x[i,]), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/emo_test/img", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar=rep(0, 4))
	image(m, axes=FALSE, col=grey(seq(0,1,length=256)))	#recreate pixels as image
	dev.off()
}


# IDENTITY
P = 48*48	#number of pixels
N = 3537/2+1#total number of observations per set

IN		<- "identity_trainset"
dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
y		<- dataset[,1]
x		<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
x		<- matrix(as.numeric(x), N, P, byrow=FALSE)

for(i in 1:N){
	m	<- matrix(rev(x[i,]), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/ide_train/img", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar=rep(0, 4))
	image(m, axes=FALSE, col=grey(seq(0,1,length=256)))	#recreate pixels as image
	dev.off()
}

N = 3537/2	#total number of observations per set

IN		<- "identity_testset"
dataset	<- matrix(scan(IN, n=N*(P+1), what=""), N, (P+1), byrow=TRUE)
y		<- dataset[,1]
x		<- gsub("^.*:","", dataset[,1:P+1], perl=TRUE)
x		<- matrix(as.numeric(x), N, P, byrow=FALSE)

for(i in 1:N){
	m	<- matrix(rev(x[i,]), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/ide_test/img", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar=rep(0, 4))
	image(m, axes=FALSE, col=grey(seq(0,1,length=256)))	#recreate pixels as image
	dev.off()
}