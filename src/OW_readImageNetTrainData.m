function [X, Y, M, traindata_mean, traindata_std] = readImageNetTrainData(classlist, totalNclasses, datasetsplit)

% Input
% ----------
% classlist = list of classes to read
% totalNclasses = total no of classes
% datasetsplit = train, test or val


% Output
% -----------
% X       [D x N]             Feature matrix D dimensional feature, N images
% Y       [1 x N]             Ground Truth Class Labels for N images
% M       [D x C]             Means matrix, D dimensional, C classes
% traindata_mean  [1 x D]     Mean over all the training samples from all categories
% traindata_std   [1 x D]     Std Dev over all the training samples from
% all categories


NrD = 1000;
labels = zeros(1,1);
traindata = zeros(1, NrD);

fprintf('-----------------------------------------------------\n');
fprintf('Working on %s data ...\n', datasetsplit);
fprintf('-----------------------------------------------------\n');

% Read the Raw training data.

for classname = classlist    
    
    clear trainfname
    
    trainfname = sprintf('separated_classes/train/class_%d.txt', classname);            
    classdata = load(trainfname);
    labels = [labels;classname.*ones(size(classdata, 1),1)];
    traindata = [traindata;classdata];       
    %fprintf('Completed reading of %d ..\n', classname);

end
fprintf('Completed Reading %s data... \n', datasetsplit);
fprintf('-----------------------------------------------------\n');


traindata = traindata(2:end, :);
labels = labels(2:end, :);

% Now whiten the features using training dataset wide mean and std dev
traindata_mean = mean(traindata);
traindata_std = std(traindata);

for i = 1:size(traindata, 1)
    traindata(i,:) = (traindata(i, :) - traindata_mean)./traindata_std;    
end


% Now compute means for each class

count = 1;
for classname = classlist
    M(count, :) = mean(traindata(find(labels == classname), :));
    count = count + 1;
end


% Take transposes to make sure that the data is according to requirements
% of train SGD function

M = M';
X = traindata';
Y = labels;


clear traindata;
clear labels;