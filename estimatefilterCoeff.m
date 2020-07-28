function [estimated_h] = estimatefilterCoeff(trainInputData,trainObservationData,filterLength)

[feature,sample] = size(trainInputData);
term_1 = zeros(filterLength,filterLength);
term_2 = zeros(filterLength,1);

for i=1: sample
    row = [trainInputData(1,i)' zeros(1,filterLength-1)];
    col = [trainInputData(:,i)'];
    X = toeplitz(col,row);
    
    term_1 = term_1 + (X.'*X);
    term_2 = term_2 + (X).' * trainObservationData(:,i); 
end

estimated_h = inv(term_1) * term_2 ;

end

