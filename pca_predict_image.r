#NOTE: SHOULD RUN pca_predict.r BEFORE RUNNING THIS SCRIPT

dir.create(file.path(BASEDIR, "images"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "emo_predicted"), showWarnings = FALSE)
dir.create(file.path(BASEDIR, "images", "ide_predicted"), showWarnings = FALSE)

for(i in 1:N){
	p <- (Wtest[i,]) %*% t(Eigen)	#recreate image = linear combination or principal eigenfaces
	p <- p + PCA$center				#add back the average face
	m <- matrix(rev(p), nrow=48)
	IMGFILE	<- paste0(BASEDIR, "/images/", CURR, "_predicted/img_", ytest[i], "_", prediction_mah[i], "_", i, ".jpg")
	jpeg(IMGFILE)
	par(mar = rep(0, 4))
	image(m, axes = FALSE, col = grey(seq(0,1,length=256)))
	dev.off()
}