function OW_Thresh = OW_CrossClass_Validation(trainingClassList, ...
                                                learnedModel, trainX, trainY)

% Input:
% trainingClassList = list of tranining classes
% learnedModel = structure that contains learned metric, class means,
%                 mean over training data and std over training data
% trainX = training Data
% trainY = training labels
% 
% Output:
% OW_Thresh = Openset threshold obtained following Cross Class Validation procedure 
% 
% 
% 
% Cross Class Validation is a process used to convert NCM Algorithm into
% Nearest Non-Outlier Algorithm. Once the metric learning phase is completed
% Cross Class Validation is performed. Cross Class Validation is performed
% to estimate openset threshold. This threshold is then used to balance
% open space risk. Openset Threshold is used for novelty detection/
% determining if the incoming test sample is far away from known training
% data.
% 
% The procedure for estimating Open Set Threshold is as follows:
%     Given list of training classes, split the classes into known and 
%     unknown clasess. Unknown classes are used to balance openspace risk
%     by optimizing the F1 measure between known and unknown classes,
%     while retaining 90% recall in a fold.
%     This process is repeated three times and average openset threshold
%     is used during testing. 
%     
% This script illustrates the working of Nearest Non-Outlier Algorithm
% and Open World Recognition Protocol as discussed in 
% 
% [1] Abhijit Bendale, Terrance Boult "Towards Open World Recognition"
% Computer Vision and Pattern Recognition Conference (CVPR) 2015
% 
% If you use this code, please cite the above paper [1]. 
% 
% Author: Abhijit Bendale (abendale@vast.uccs.edu)
% Vision and Security Technology Lab
% University of Colorado at Colorado Springs
% Code Available at: http://vast.uccs.edu/OpenWorld
% 
% 
% The script depends in parts on Nearest Class Mean Algorithm
% developed by Thomas Mensink in 
% 
% [2]   Distance-Based Image Classification: Generalizing to New Classes at Near Zero Cost
%       Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka
%       In Transactions on Pattern Analysis and Machine Intelligence (PAMI) 2013.
%     
% [3]   Metric Learning for Large Scale Image Classification: Generalizing to New Classes at Near-Zero Cost,
%       Thomas Mensink, Jakob Verbeek, Florent Perronnin, Gabriela Csurka
%       In European Conference on Computer Vision (ECCV), 2012.
%       
% If you use code for either NCM or Metric Learning please cite
% works of Thomas Mensink [2],[3]

% Create three splits of known and unknown classes
% Repeat process 3 times
splitsize = ceil(size(trainingClassList, 2) * 0.66); % Get 2/3rd clasess as known classes
classSplits = mat2cell(trainingClassList, 1, [splitsize, size(trainingClassList, 2) - splitsize]);
knownClassList_CCV = classSplits{1,1};
unknownClassList_CCV = classSplits{1,2};

% Grab means of the known classes. Only these means are used for
% classification
knownClass_M =  learnedModel.M(1:end, knownClassList_CCV);

% known trainX, trainY
% divide the training set into known and unknown splits
[knowntrainX, knowntrainY] = extractClassData(trainX, trainY, ...
                                                knownClassList_CCV);

% unknown trainX, trainY
[unknowntrainX, unknowntrainY] = extractClassData(trainX, trainY, ...
                                                unknownClassList_CCV);


% Compute distances for examples from known and unknown classes

 % distances of known classes from known means
 NrTop   = 1;
 W_Kx      = learnedModel.W * knowntrainX;
 Wm      = learnedModel.W * knownClass_M;
 d_known = NCM_sqdist(Wm, W_Kx);
 d_known_min = min(d_known, [], NrTop);

 % distances of unknown classes from known means
 W_UKx      = learnedModel.W * unknowntrainX;
 Wm      = learnedModel.W * knownClass_M;
 d_unknown = NCM_sqdist(Wm, W_UKx);
 d_unknown_min = min(d_unknown, [], NrTop);

 total_knowns = size(d_known_min, 2);
 total_unknowns = size(d_unknown_min, 2);
 
% Get min and max distance range
for openset_distance_th = [min(d_known_min):1000:max(d_known_min)]
       
    for i = 1:size(distances_min,2)
      if d_known_min(i) >= openset_distance_th
        unknown_predictions(i) = 1;
      else
         unknown_predictions(i) = 0;
      end
    end
  
    
end

% Loop through all the examples and perform N+1 way classification
% where N =  number of known classes. Examples from all unknown classes
% are treated to belong to one unknown class





                                            
    