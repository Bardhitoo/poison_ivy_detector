# poison_ivy_detector
Seasoned hikers and children alike often have a hard time recognizing poison ivy in their environment. Our group has devised a semi-supervised image recognition algorithm in matlab to inform users if there is a poison ivy in a given picture. We used a combination of feature detection methods like CNN, corners and blob detection for classification. In this paper, we explain our process and detail the problems we faced along with suggesting improvements in our approach in order to perfect the detection methodology.

# Introduction
We have grown up being taught phrases such as, "Leaves of three, let it be," to help us identify whether a given plant was poison ivy or not. However, a lot of harmless plants such as raspberry and virginia creeper plants have three leaves, and are often mistaken for poison ivy. In this paper, we explain the semi-supervised algorithm we devised using matlab that detects the presence of poison ivy in an image. This algorithm assumes that the plant of interest will always be placed in the center of the image. The algorithm utilizes K-means for segmentation, morphological operations for noise reduction, watershed segmentation for leaf separation, convolutional neural networks (CNN) and automatic corner detectors for classification

MATLAB Version - 9.12

The following toolbox is required to run the program
- Deep Learning Toolbox

The code has the following structure:-

- MAIN.m
- Kmeans.m
- extractCircle.m
- edgesExploration.m
- watershed_exploration.m
- Show_Color_Separations_hsv.m
- Show_Color_Separations_Lab.m
- Show_Color_Separations_rgb.m
- resnet50\final_network_params.mat

The entrypoint for the program is "MAIN.m"

How to run the program. 
- Make sure the leaf image to be tested is in same folder as 'MAIN.m' file
- Open the MAIN.m file in Matalb
- Run the following command in console MAIN(<Leaf Image File Path>)


The program prints the steps and result in console.

The contributors of this project are:
	* Bardh Rushiti
	* Mohd Junaid Shaikh
	* Saksham Bansal