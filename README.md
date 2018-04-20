# OWR

Readme writing is in progress



# Dependent code

The code builds on top of parts of code written by Prof. Thomas Mensink from University of Amsterdam as part of paper "Metric Learning for Large Scale Image Classification: Generalizing to New Classes at near-zero cost" - ECCV 2012

The code is available for non-commercial use. If you use the code, please cite following 2 papers

```
"Towards Open World Recongnition" Abhijit Bendale, Terrance Boult CVPR 2015
"Distance based Image Classification: Generalizing to new classes at near zero cost" Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka, IEEE Transactions on Pattern Analysis and Machine Intelligence (PAMI) | 2013
"Metric Learning for Large Scale Image Classification: Generalizing to New Classes at near-zero cost"
Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka ECCV 2012
```

Special thanks for help with Data to Dr. Marko Ristin (ETH Zurich) from his work
```
"Incremental learning of NCM forests for large-scale image classification" M Ristin, M Guillaumin, J Gall, Luc Van Gool CVPR 2014
```

# Data
You can download SIFT features extracted from IMAGENET Dataset from following link. The features were generously provided by Marko Ristin (ETH Zurich) and Prof. Thomas Mensink (University of Amsterdam, formerly INRIA)
```
http://vast.uccs.edu/~abendale/imagenet/imagenet_sift_features.tar
```
Mapping of class names with WorNet IDs can be found in: imagenet_sift_features/wnetids.txt

e.g. The first entry in wnetids.txt is 1, n01641391 

Thus {train/test/val}/class_1.txt corresponds to n01641391 category. Details of wnetids to category mapping can be found from ImageNet 2010 website 
