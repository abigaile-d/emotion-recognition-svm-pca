#NOTE: SHOULD RUN pca_train.r BEFORE RUNNING THIS SCRIPT

# create dirs if missing
dir.create(file.path(BASEDIR, "images"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "emo_eigenfaces"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "emo_class"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_eigenfaces"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_class"), showWarnings = FALSE)

#save average face as image
m <- matrix(rev(PCA$center), nrow=48)
IMGFILE	<- paste0(BASEDIR, "/images/", CURR, "_eigenfaces/_img_mean.jpg")
jpeg(IMGFILE)
par(mar = rep(0, 4))
image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
dev.off()

#save eigenfaces as image
for(i in 1:N){
	m <- matrix(rev(PCA$rotation[,i]), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/", CURR, "_eigenfaces/img_", i ,".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}

#save average face per class as image: eigenface 
for(i in 1:Nclass){
	p	<- Wclass[i,] %*% t(Eigen)	#recreate image = linear combination or principal eigenfaces
	m	<- matrix(rev(p), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/", CURR, "_class/img_eigenversion_", classes[i] ,".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}

#save average face per class as image: eigenface + average face
for(i in 1:Nclass){
	p	<- Wclass[i,] %*% t(Eigen)	#recreate image = linear combination or principal eigenfaces
	p	<- p + PCA$center
	m	<- matrix(rev(p), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/", CURR, "_class/img_", classes[i] ,".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}