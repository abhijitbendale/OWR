function [X, Y, model] = OW_train_NCM_classifier(classlist, NrP, ops)

% Wrapper function to perform training given training data and 
% parameters for metric learning.
%
% [1] Abhijit Bendale, Terrance Boult "Towards Open World Recognition"
% Computer Vision and Pattern Recognition Conference (CVPR) 2015
% 
% If you use this code, please cite the above paper [1]. 
% 
% Author: Abhijit Bendale (abendale@vast.uccs.edu)
% Vision and Security Technology Lab
% University of Colorado at Colorado Springs
% Code Available at: http://vast.uccs.edu/OpenWorld]


% Read training data. Perform normalization with the given subset
% of the training data. Store mean and standard deviation over the
% entire training subset for normalization of test data
[X, Y, M, train_mean, train_std] = OW_readImageNetTrainData(classlist, size(classlist, 2), 'train');


% Call NCM train SGD function to learn the metric.
[W,obj,W0] = NCM_train_sgd(X,Y,M,NrP,[],ops);


% Store the class means, learned metric
model.M = M;    % class means
model.W = W;    % learned metric
model.train_mean = train_mean;  % mean over training subset
model.train_std = train_std;    % std deviation over traning subset

