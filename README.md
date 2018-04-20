# OWR

Readme writing is in progress



# Dependent code

The code builds on top of parts of code written by Prof. Thomas Mensink from University of Amsterdam as part of paper "METRIC LEARNING FOR LARGE SCALE IMAGE CLASSIFICATION: GENERALIZING TO NEW CLASSES AT NEAR-ZERO COST" - ECCV 2012

The code is available for non-commercial use
If you use the code, please cite following 2 papers

"Towards Open World Recongnition" Abhijit Bendale, Terrance Boult CVPR 2015
"DISTANCE-BASED IMAGE CLASSIFICATION: GENERALIZING TO NEW CLASSES AT NEAR ZERO COST" Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka, IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI) | 2013
"METRIC LEARNING FOR LARGE SCALE IMAGE CLASSIFICATION: GENERALIZING TO NEW CLASSES AT NEAR-ZERO COST"
Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka ECCV 2012

# Data
You can download SIFT features extracted from IMAGENET Dataset from following link. The features were generously provided by Marko Ristin (ETH Zurich) and Prof. Thomas Mensink (University of Amsterdam, formerly INRIA)

http://vast.uccs.edu/~abendale/imagenet/imagenet_sift_features.tar

Mapping of class names with WorNet IDs can be found in: imagenet_sift_features/wnetids.txt

e.g. The first entry in wnetids.txt is 1, n01641391 

Thus {train/test/val}/class_1.txt corresponds to n01641391 category. Details of wnetids to category mapping can be found from ImageNet 2010 website 
