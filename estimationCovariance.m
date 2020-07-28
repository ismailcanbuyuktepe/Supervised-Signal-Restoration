function [estimatedCovariance] = estimationCovariance(dataset,meanVec)

[feature , sample] = size(dataset);

addVariance = 10^-4 * eye(feature);

sumMatrix=zeros(feature,feature);

for i=1:sample
    sumMatrix = sumMatrix + (dataset(:,i)-meanVec(:,1))*(dataset(:,i)-meanVec(:,1)).';
end
sumMatrix = (1/sample)*sumMatrix;

estimatedCovariance = addVariance+sumMatrix;

sumMatrix=zeros(feature,feature);

end

