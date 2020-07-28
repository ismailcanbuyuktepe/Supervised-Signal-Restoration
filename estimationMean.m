function [estimatedMean] = estimationMean(dataSet)

[feature,sample] = size(dataSet);
estimatedMean = zeros(feature,1);             %initial Value of mean
sumValue = 0;

for i=1:feature
   for j=1:sample
       sumValue = sumValue + dataSet(i,j);
   end   
   estimatedMean(i,1) = (1/sample) * sumValue;
   sumValue =0;   
end


end

