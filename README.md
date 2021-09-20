# Emotion and Identity Recognition using Support Vector Machines and Principal Components Analysis

<h2>Dataset</h2>

The dataset used in this experiment came from the Kaggle in-class competition named “Emotion and Identity Detection from Face Images” (https://www.kaggle.com/c/facial-keypoints-detector). Since the competition already ended by the time this experiment was performed, only the training set was used as the main dataset on this experiment. The dataset is then split into two sets, the training and test sets, having 50-50 ratio.

The competition was originally intended to perform emotion recognition. To further increase the scope of our study, we also performed identity recognition experiments.

The training set contains the person ID or emotion category, and the pixel feature containing 48x48 gray pixel values (between 0 and 255) of the image. 

The emotion category consists of integers between 0 and 6: anger = 0, disgust = 1, fear = 2, happy = 3, sad = 4, surprise = 5, neutral = 6. While for identity recognition, there are over 600 different identities or classes. Some of the class has only 2 image given, so this adds to the challenge.

<h2>Experiments</h2>

Three techniques were used for the emotion and identity recognition problems: (1) SVM, (2) combination of PCA and SVM, and (3) combination of PCA and Minimum Distance Classifiers.

<h4>Support Vector Machines</h4>

For the SVM classification, libSVM was used (http://www.csie.ntu.edu.tw/~cjlin/libsvm/). The procedure can be summarized as follows: data conversion to libSVM format, parameter estimation, training, and prediction.

For the first procedure, the dataset was converted to the following format: \<label\> \<index1\>:\<value1\> \<index2\>:\<value2\>, etc. Since there are two tasks, emotion recognition and identity recognition, there were two sets of files generated, one for each task. The first column in libSVM format is always the label, which is either: the emotion (ranging from 0 to 6) for emotion recognition or the person’s identity for the identity recognition. The rest of the columns correspond to the 48*48 or 2304 gray scale values of each pixels in the image which ranges from 0 to 255. Then the data are divided into training set and test set.
  
After preparing the data, the next step is parameter estimation or identifying the best parameters to use in the classification. The first parameter to be considered is the kernel type. In this experiment, Polynomial kernels, and Radial Basis Function (RBF) kernel were used. For the Polynomial kernels, the important parameters are the degree of the polynomial, the parameter c (cost) which controls the trade-off between the margin and the number of mistakes on the training data, and γ (gamma) which defines how far the influence of a single training example reaches. The important parameters for RBF kernel are c and γ.
  
To identify the best combination of parameters previously mentioned, Cross-validation and Grid-search approach were used on the training dataset. 5-fold cross validation was used, which amounts to approximately 400 data points per fold. Cross-validation also helps prevent over-fitting. For the Grid-search, coarse grid search was used first, then when the best accuracy was reported, fine grid search was done on the surrounding area.
  
Following are the parameters and values used in SVM Coarse Grid- search:
<table>
  <tr>
    <th></th>
    <th>Levels</th>
    <th>#</th>
    <th>Levels</th>
    <th>#</th>
  </tr>
  <tr>
    <th>Kernel Type</th>
    <td>RBF</td>
    <td></td>
    <td>POLY</td>
    <td></td>
  </tr>
  <tr>
    <th>Degree</th>
    <td>-</td>
    <td></td>
    <td>1, 2, 3</td>
    <td>3</td>
  </tr>
  <tr>
    <th>C</th>
    <td>2<sup>-6</sup>, 2<sup>-4</sup>... 2<sup>12</sup></td>
    <td>10</td>
    <td>2<sup>-6</sup>, 2<sup>-4</sup>... 2<sup>12</td>
    <td>10</td>
  </tr>
  <tr>
    <th>γ</th>
    <td>2<sup>-14</sup>, 2<sup>-12</sup>... 2<sup>4</sup></td>
    <td>10</td>
    <td>2<sup>-14</sup>, 2<sup>-12</sup>... 2<sup>4</sup></td>
    <td>10</td>
  </tr>
  <tr>
    <th># Parameter Combinations</th>
    <td></td>
    <td>100</td>
    <td></td>
    <td>300</td>
  </tr>
</table>

<h4>Principal Component Analysis and Support Vector Machines</h4>

Principal Components Analysis is used for dimensionality reduction. PCA achieves dimensionality reduction by linearly transforming a higher dimensional data into a space with lower dimensions without losing key information. In this experiment, each image originally has 48*48 (or 2304) dimensions and the goal is to reduce them into lower dimensional space (e.g. 100 to 1000) to reduce the training time, while retaining, if not improving, the accuracy.

For PCA, prcomp() function in R was used which is available in the standard R package. The calculation is done by a singular value decomposition of the centered data matrix. This function returns the square root of the eigenvalues (a.k.a. the standard deviations), the rotated data matrix, the eigenvectors, and the centering vector, among others.

The plot of the eigenvalues or variances can be found below. The first graph are limited to the first 10 variances, while the second is for the entire list of variances. As can be seen, in the first component, the variance is huge, then dropped significantly. For the later values, the variances are very low that the plot appeared flat after the first few variances. For instance, in the 300th principal component, the cumulative variance is already at 98.79% (which means the total sum of the remaining 1700+ variances is only 1.21% which is very small), at 500th 99.51%, at 800th 99.85% and at 1000th 99.93%. This, even if we only retain the first 300 from the original 2000+ components, we will only lose a small amount of information about the data.

<img src="https://user-images.githubusercontent.com/90839613/133997700-dd1cf0b9-ff74-436b-9834-5214a84992df.png" width=300>

In face images, the eigenvectors are called eigenfaces. The average face from the training dataset and the top and bottom eigenfaces are shown in the below figures. As can be seen, the bottom eigenfaces show more noise than directions, and therefore, can be discarded.

<img src="https://user-images.githubusercontent.com/90839613/133997932-630a5da3-2481-48d6-86ce-6a9b79d88d2f.png" width=450>

To perform dimensionality reduction, we select top K eigenfaces. Then, each image in the dataset are transformed into a subspace of eigenfaces.

An image can be expressed as linear combination of eigenfaces, which makes it easier to match any two images and thus perform face recognition. Eigenvectors are weighted, and when combined together, will form the original image. This is illustrated in Figure 4.

<img src="https://user-images.githubusercontent.com/90839613/133998357-c114d6ff-1bd7-48d3-b60f-d1b3a19ca794.png" width=450>

After the dimensions have been reduced, the transformed features were run into SVM classifier similar to the procedure mentioned in the SVM section. The number of dimensions considered are from from 100 to 1000, incrementally adding 100.

<h4> Principal Component Analysis and Minimum Distance Classifiers </h4>

The procedure for principal component analysis for this experiment is the same as the procedure in previous section. However, instead of using SVM for classification, minimum distance classifiers are used. There are two types used in this experiment: Euclidean distance and Mahalanobis distance.

To predict a new image, it should first be transformed into face vector Ω by using the PCA formula. Then the distance will be computed between Ω and Ω<sub>C</sub>, which is the average of all the transformed face vectors within class c. The class that has the minimum distance, or closest to the face Ω, is its classification.

<h2>Results</h2>

<h2>Support Vector Machines</h2>

For emotion recognition, the overall best model identified is Polynomial kernel of degree 1 (or linear kernel), with c=2<sup>-2.25</sup> and γ=2<sup>-13.50</sup>. For identity recognition, the best model identified is Polynomial kernel of degree 1 (or linear kernel), with c=2<sup>-6</sup> and γ=2<sup>-11.75</sup>. Below are the results.

<table>
  <tr>
    <th>Task</th>
    <th>Kernel Type</th>
    <th>Best (log<sub>2</sub>C, log<sub>2</sub>γ)</th>
    <th>Accuracy</th>
  </tr>
  <tr>
    <th>Emotion Recognition</th>
    <td>POLY d=1</td>
    <td>(-2.25, -13.50), etc.</td>
    <td>72.81%</td>
  </tr>
  <tr>
    <th>Identity Recognition</th>
    <td>POLY d=1</td>
    <td>(-6.0, -11.75), etc.</td>
    <td>61.53%</td>
   </tr>
</table>
  
It can be observed that on both tasks, the linear kernel outperforms both the higher degree polynomial and radial basis function kernels. One reason may be due to the large number of features in the image data, as for large number of features, nonlinear mapping does not improve the performance, and thus the data does not need to be mapped into a higher dimensional space.

<h4>Principal Component Analysis and Support Vector Machines</h4>

For emotion recognition, the best results from parameter estimation experiments is when the # of features are 700 or 900. For identity recognition, it is when dimension is reduced to 500. 

Results after Dimensionality Reduction:

<table>
  <tr>
    <th>Task</th>
    <th># Eigenfaces</th>
    <th>Best (log<sub>2</sub>C, log<sub>2</sub>γ)</th>
    <th>Accuracy</th>
  </tr>
  <tr>
    <th rowspan=2>Emotion Recognition</th>
    <td>700</td>
    <td>(-6, -14)</td>
    <td>72.4749%</td>
  </tr>
  <tr>
    <td>900</td>
    <td>(-4, -14)</td>
    <td>72.7621%</td>
  </tr>
  <tr>
    <th>Identity Recognition</th>
    <td>500</td>
    <td>(-6, -14)</td>
    <th>61.7081%</th>
  </tr>
</table>

<h4>Principal Component Analysis and Minimum Distance Classifiers</h4>

Below is the comparison of PCA accuracy results on two distance classifiers.

<table>
  <tr>
    <th>Task</th>
    <th>Euclidean Distance</th>
    <th>Mahalanobis Distance</th>
  </tr>
  <tr>
    <th>Emotion Recognition</th>
    <td>32.12%</td>
    <td>70.56%</td>
  </tr>
  <tr>
    <th>Identity Recognition</th>
    <td>49.42%</td>
    <td>49.42%</td>
  </tr>
</table>

<h4>Comparison of Results</h4>

The accuracy results of (1) SVM, (2) PCA with SVM, and (3) PCA with distance classifiers can be seen in the chart below. For emotion recognition, the best result is on SVM without pre-processing. However, the next other two techniques are not falling far behind. Even though the best result is from SVM without dimensionality reduction, it might still be worth it do dimensionality reduction for the purpose of reducing the training time, as there accuracies are comparable.

For identity recognition, the best result is when SVM is used with dimensionality reduction. Plain SVM follows closely, while PCA with distance classifier lagged behind.

<img src="https://user-images.githubusercontent.com/90839613/134003540-8a476750-bdd5-4aed-b8c9-2a3cfc9afaec.png" width=450>

<h2>Scripts / Usage</h2>

<ol>
<li>csv2libsvm.r
  <ul>
  <li>converts train.csv to libsvm format
  <li>output is emotion_dataset and identity_dataset
  </ul>
<li>pix2img.r
  <ul>
  <li>converts the pixels given in train.csv to jpeg format for visualization
  <li>created in 4 directories: emo_train, emo_test, ide_train, ide_test
  </ul>
<li>pca_train.r
  <ul>
  <li>applies Principal Components Analysis on the training dataset
  <li>also selects top K=300 eigenfaces and creates average Ω per class (the average
transformed image per class) : will be used for distance classification
  <li>! NOTE: there is a “CURR” variable defined in the first line of the script.
Possible values are “emo” and “ide”. The value of this variable should be changed
when training for emotion recognition and identity recognition, respectively.
  </ul>
<li>pca_train_image.r
  <ul>
  <li>recreates the following as jpeg images for visualization: a) average face of the training set, b) all eigenfaces, c) average class faces recreated in terms of top K-300 eigenfaces
  <li>created in 4 directories: emo_eigenfaces, emo_class, ide_eigenfaces, ide_class (depends on the value of CURR)
  <li>! NOTE: this should be run only after running pca_train.r since this script is dependent on the variables of the previous script
  </ul>
<li>pca_dim.r
  <ul>
  <li>creates new libsvm files with features in reduced dimensions (dim = 100 to 1000, 10 files per set)
  <li>! NOTE: there is a “CURRSET” variable defined in the first line of the script.
Possible values are “train” and “test”. Change to create reduced trainset file and reduced testset file respectively
  <li>! NOTE: this should be run only after running pca_train.r for creating training set, or pca_predict.r for creating reduced testing set, since is dependent on the variables of the previous script
  </ul>
<li>pca_dim_image.r
  <ul>
  <li>recreates reduced images of 100 and 1000 dimensions for comparison and visualization
  <li>created in directories: emo_reduced, ide_reduced
  <li>! NOTE: this should be run only after running pca_dim.r reduced this script
  </ul>
<li>pca_predict.r
  <ul>
  <li>predicts new images (from test set) based on distance classifiers
  <li>output are emotion_prediction.csv and identity_prediction.csv
  <li>! NOTE: this should be run only when pca_train.r has been previously executed
  </ul>
<li>pca_predict_image.r
  <ul>
  <li>recreates image prediction of the test image for visualization
  <li>! NOTE: this should be run only after running pca_predict.
  </ul>
</ol>

Third-party scripts used:

<ol>
<li>subset.py from libSVM tools
  <ul>
  <li>used to divide dataset into 50% training set and 50% test set
  </ul>
<li>grid.py from libSVM tools
  <ul>
  <li>used to run grid-search with cross-validation
  </ul>
</ol>
