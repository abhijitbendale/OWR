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


close all; clear; clc;
disp('---------------------------------------------------------------');
disp('Code written by Abhijit Bendale (abendale@vast.uccs.edu)');
disp('Producing results/plots related to work:');
disp('A Bendale, T Boult Towards Open World Recognition, CVPR 2015');
disp('---------------------------------------------------------------');

% Features used for evaluation are SIFT features on ImageNet 2010
% quantized into 1000 Bag of Visual Words. These features were obtained
% from ImageNet 2010 website orginally 

% Initialize Model Parameters for Metric Learning
% Significance of these parameters can be found in [2], [3]
NrD = 1000;                 % No of feature dimensions
NrP = 512;                  % No of projected dimensions ( NrD gets projected to --> NrP)
NrNi = 100;                 % Total Number of Negative Images
eta = 0.001;                
iterations = 1000;          % No of iterations performed by SGD for Metric Learning
ops = struct('iter2', iterations,'Eta',eta, 'NrNi', NrNi);


% Initializing training classes
trainingClassList = [1:1:10];           % Metric Learning Performed on Initial 50 classes
incrementClassList = [51:1:100; 101:1:150; 151:1:200]; % Classes for Incremental Learning
unknownClassList{1} = [201:1:300]; % 100 Unknown Classes for Open Set Testing
unknownClassList{2} = [201:1:400]; % 200 Unknown Classes for Open Set Testing
unknownClassList{3} = [201:1:700]; % 500 Unknown Classes for Open Set Testing

% Initial Parameter Learning
disp('Performing Initial Parameter Learning');
disp('---------------------------------------------------------------');
disp('Reading Training Data Now..');

[trainX, trainY, learnedModel] = OW_train_NCM_classifier(trainingClassList, NrP, ops);
% Cross Class Validation to estimate Open World Recognition threshold
% trainingClassList is divided into 3 splits of known and unknown
disp('Cross Class Validation to estimate Open World Recognition threshold');
disp('---------------------------------------------------------------');
OW_Thresh = OW_CrossClass_Validation(trainingClassList, learnedModel, ...
                                      trainX, trainY);
learnedModel.OW_Thresh = OW_Thresh;                         



% Using Data from Val Split

% Open World Evaluation: Performing Closed Set and Open Set Testing
disp('Open World Evaluation: Performing Closed Set and Open Set Testing');
disp('---------------------------------------------------------------');

% Evaluate on incremental classes and unknown classes
for incr_idx = 1:size(incrementClassList, 1)
    currentIncrementalClasses = incrementClassList(incr_idx, :);
    
    % Update model with incremental classes (without re-learning metric)
    disp(sprintf('Adding %d incremental classes...', length(currentIncrementalClasses)));
    [newX, newY, newM, ~, ~] = OW_readImageNetTrainData(currentIncrementalClasses, length(currentIncrementalClasses), 'train');
    
    % Normalize using original training statistics
    newX = bsxfun(@minus, newX, learnedModel.train_mean');
    newX = bsxfun(@rdivide, newX, learnedModel.train_std');
    
    % Add new class means to the model
    learnedModel.M = [learnedModel.M, newM];
    
    % Test on different unknown class scenarios
    for unk_idx = 1:length(unknownClassList)
        disp(sprintf('Testing with %d unknown classes...', length(unknownClassList{unk_idx})));
        
        % This is where you would load and test on validation/test data
        % Performance evaluation would be done here
        % Note: Requires actual test data to be present
        
        disp('Test data evaluation would be performed here when data is available.');
    end
end

disp('---------------------------------------------------------------');
disp('Demo completed successfully!');
disp('Note: Full evaluation requires ImageNet SIFT features dataset.');
disp('Download from: http://vast.uccs.edu/~abendale/imagenet/imagenet_sift_features.tar');
disp('---------------------------------------------------------------');
