function [data_X, label_Y] = extractClassData(features, labels, ...
                                                classlist)
                                            
    data_X = zeros(1000, 1)'; 
    label_Y = zeros(1,1);
    for i = 1:size(classlist, 2)        
        labelindices = find(labels == classlist(i));
        data_X = [data_X; features(1:end, labelindices)'];
        label_Y = [label_Y; labels(labelindices)];
    end
    data_X = data_X';
    data_X = data_X(:, 2:end);
    label_Y = label_Y(2:end);