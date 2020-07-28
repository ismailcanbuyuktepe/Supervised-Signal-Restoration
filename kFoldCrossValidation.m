function [PSNR,cell_x_map_estimation] = kFoldCrossValidation(dataSet_x,dataSet_y,filterLength,k)

[feature , sample] = size(dataSet_x);
[~ ,sample2] = size(dataSet_y);

PSNR=zeros(1,k);
cell_x_map_estimation = cell(1,10);

if(sample ~= sample2)
    msg = "Number of sample of dataSet_x and dataSet_y is not equal. ";
    error(msg);
end

lastIndexVector = zeros(1,k);
Nb_pre= 0;

% Boundary Index is calculated for each kth value
if (mod(sample , k) ~= 0)
   Nb = floor(sample/k);
   remainingValue = mod(sample , k);
   for i=1: k
       if i <= k-remainingValue
          lastIndexVector(1,i) =Nb+Nb_pre;
       else
          lastIndexVector(1,i) = (Nb+1)+Nb_pre;
       end
       Nb_pre = lastIndexVector(1,i);
   end 
else
    Nb_pre=0;
    Nb = sample/k ;   
    for i=1: k
        lastIndexVector(1,i) = Nb+Nb_pre;
        Nb_pre = lastIndexVector(1,i);       
    end    
end
%----------------------------------------------------------
% 
for i=1:k
    % This If block adjust dataset for each kth fold as trainset and
    % testset.
    if(i == 1)  % region en baþta ise
       testX = dataSet_x(:,1:lastIndexVector(1,i)); 
       testY = dataSet_y(:,1:lastIndexVector(1,i));
       trainX = dataSet_x(:,lastIndexVector(1,i)+1:sample);
       trainY = dataSet_y(:,lastIndexVector(1,i)+1:sample);
    elseif (i == k) % region en sonda ise 
       testX = dataSet_x(:,lastIndexVector(1,i-1)+1:lastIndexVector(1,i)); 
       testY = dataSet_y(:,lastIndexVector(1,i-1)+1:lastIndexVector(1,i));
       trainX = dataSet_x(:,1:lastIndexVector(1,i-1));
       trainY = dataSet_y(:,1:lastIndexVector(1,i-1));
    else       % region arada ise
       testX = dataSet_x(:,lastIndexVector(1,i-1)+1:lastIndexVector(1,i)); 
       testY = dataSet_y(:,lastIndexVector(1,i-1)+1:lastIndexVector(1,i));
       trainX = [dataSet_x(:,1:lastIndexVector(1,i-1)) , dataSet_x(:,lastIndexVector(1,i)+1:sample)];
       trainY = [dataSet_y(:,1:lastIndexVector(1,i-1)) , dataSet_y(:,lastIndexVector(1,i)+1:sample)];   
    end
  % Mean Learning Function  
  [estimatedMean_x] = estimationMean(trainX);
  %Covariance Learning Function
  [estimatedCovariance_x] = estimationCovariance(trainX,estimatedMean_x);
  % Filter coefficient Learning Function
  [estimated_h] = estimatefilterCoeff(trainX,trainY,filterLength);
  % Construct H_estimate using h_estimate
  row_H = [estimated_h(1,1) zeros(1,feature-1)];
  col_H = [estimated_h(:,1);zeros(feature-5,1)];
  H_estimated= toeplitz(col_H,row_H);
  % Variance Learning Function
  estimated_Variance = estimationVariance (trainX,trainY,H_estimated);
 
  %Input signal was estimated by using learning parameter set
  [x_map_estimation] = mapEstimation(testY,H_estimated,estimatedCovariance_x,...
                                        estimatedMean_x,estimated_Variance);
  %Total estimation matrix is assigned to Cell array
  cell_x_map_estimation(1,i) = {x_map_estimation};
  
  [psnr] = calcPSNR(x_map_estimation , testX);  
  % psnr value is stored in PSNR vector
  PSNR(1,i) = psnr;
end

end

