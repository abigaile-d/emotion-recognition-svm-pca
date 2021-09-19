# Emotion and Identity Recognition using Support Vector Machines and Principal Components Analysis

<h2>Dataset</h2>

The dataset used in our experiment came from the Kaggle in-class competition named “Emotion and Identity Detection from Face Images”. The files provided on their website is a training set, test set, and auxiliary file that contains the person ID of a specific example. Since the competition already ended by the time this experiment was performed, we have used the training set as the main dataset on this experiment. The dataset is then split into two sets, the training and test sets, having 50-50 ratio.

The competition was originally intended to perform emotion recognition. To further increase the scope of our study, we have applied the identity recognition in our experiment.

The training sets contain the person ID or emotion category (depending on the experiment), and the pixel feature containing 48x48 gray pixel values (between 0 and 255) of the image. The emotion category consists of integers between 0 and 6: anger = 0, disgust = 1, fear = 2, happy = 3, sad = 4, surprise = 5, neutral = 6.

<h2>Experiments</h2>

Three techniques were used for the emotion and identity recognition problems: (1) SVM, (2) combination of PCA and SVM, and (3) combination of PCA and Minimum Distance Classifiers.

<h4>Support Vector Machines</h4>

For the SVM classification, libSVM was used (http://www.csie.ntu.edu.tw/~cjlin/libsvm/). The procedure can be summarized as follows: data conversion to libSVM format, parameter estimation, training, and prediction.

For the first procedure, the dataset was converted to the following format: \<label\> \<index1\>:\<value1\> \<index2\>:\<value2\>, etc. Since there are two tasks, emotion recognition and identity recognition, there were two sets of files generated, one for each task. The first column in libSVM format is always the label, which are: the emotions (ranging from 0 to 6) and the person’s identity. The rest of the columns correspond to the 48*48 or 2304 gray scale values of each pixels in the image which ranges from 0 to 255. Then the data are divided into training set and test set.
  
After preparing the data, the next step is parameter estimation or identifying the best parameters to use in the classification. The first parameter to be considered is the kernel type. In this experiment, Polynomial kernels, and Radial Basis Function (RBF) kernel were used. For the Polynomial kernels, the important parameters are the degree of the polynomial, the parameter c (cost) which controls the trade-off between the margin and the number of mistakes on the training data, and γ (gamma) which defines how far the influence of a single training example reaches. The important parameters for RBF kernel are c and γ.
  
To identify the best combination of parameters previously mentioned, Cross-validation and Grid-search approach were used on the training dataset. 5-fold cross validation was used, which amounts to approximately 400 data points per fold. Cross-validation also helps to prevent over-fitting. For the Grid-search, coarse grid search was used first, then when the best accuracy were reported, fine grid search was done on the surrounding area.
  
Following are the parameters and values used in SVM Coarse Grid- search:
<table>
  <tr>
    <th></th>
    <th>Levels</th>
    <th>#</th>
    <th></th>
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
    <td></td>
    <td>1, 2, 3</td>
    <td>3</td>
  </tr>
</table>
