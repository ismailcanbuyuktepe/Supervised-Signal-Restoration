function [estimated_Variance] = estimationVariance (inputPoint,observation,estimated_H)
%UNTÝTLED Summary of this function goes here
%   Detailed explanation goes here

[feature,sample] = size(inputPoint);

sumValue = 0 ;

for i=1:sample
    sumValue = sumValue + ((observation(:,i) - estimated_H*inputPoint(:,i)).' ...
                                * (observation(:,i) - estimated_H*inputPoint(:,i)));
end

estimated_Variance = (1/(feature*sample)) * sumValue ;


end

