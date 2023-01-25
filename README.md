# poison_ivy_detector
This project aims to tackle poison ivy detection with classical and non-classical computer vision in a semi-supervised manner.

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
- Run the following command in console MAIN(<Leaf Image File>)


The program prints the steps and result in console.


The contributors of this project are:
	* Bardh Rushiti
	* Mohd Junaid Shaikh
	* Saksham Bansal