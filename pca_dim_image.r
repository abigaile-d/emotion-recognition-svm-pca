dir.create(file.path(BASEDIR, "images", "emo_reduced"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_reduced"), showWarnings = FALSE)

Neigen	<- 100				#number of principal components to be considered
Eigen	<- PCA$rotation[,1:Neigen]
xhat	<- c()
xhat	<- sweep(xdim,2,PCA$center,"-") %*% Eigen	#transform data into the lower dimension

for(i in 1:N){
	p	<- (xhat[i,]) %*% t(Eigen)	#recreate image = linear combination or principal eigenfaces
	p	<- p + PCA$center
	m	<- matrix(rev(p), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/",CURR,"_reduced/img_dim100_", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}

Neigen	<- 1000				#number of principal components to be considered
Eigen	<- PCA$rotation[,1:Neigen]
xhat	<- c()
xhat	<- sweep(xdim,2,PCA$center,"-") %*% Eigen	#transform data into the lower dimension

for(i in 1:N){
	p	<- (xhat[i,]) %*% t(Eigen)	#recreate image = linear combination or principal eigenfaces
	p	<- p + PCA$center
	m	<- matrix(rev(p), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/",CURR,"_reduced/img_dim1000_", y[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}