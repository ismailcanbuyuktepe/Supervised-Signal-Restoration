%% Content
%Autor : Ýsmail Can BÜYÜKTEPE
%Number: 1850024008
%Date: 11.04.2020
%Course: ELEC 642 Machine Learning for Signal Processing
%Instructor: Assoc. Prof. Koray KAYABOL

%% 
clc;
clear all;
close all;

%% Part A : Learning Parameter set Step
data = load('hw2.mat');
data_x = data.x;
data_y = data.y;

[feature,sample] = size(data_x);
lenghtOfFilter = 5;

testData_x = data_x(:,1:25);
trainning_x = data_x(:,26:sample);

testData_y = data_y(:,1:25);
trainning_y = data_y(:,26:sample);

% Mean Learning Function 
[estimatedMean_x] = estimationMean(trainning_x);      
%Covariance Learning Function
[estimatedCovariance_x] = estimationCovariance(trainning_x,estimatedMean_x);
% Filter coefficient Learning Function
[estimated_h] =estimatefilterCoeff(trainning_x,trainning_y,lenghtOfFilter);

% Construct H_estimate using h_estimate
row_H = [estimated_h(1,1) zeros(1,feature-1)];
col_H = [estimated_h(:,1);zeros(feature-5,1)];
H_estimated= toeplitz(col_H,row_H);
% Variance Learning Function
estimated_Variance = estimationVariance (trainning_x,trainning_y,H_estimated);

%% Part-B : PSNR value and estimation of input signal are calculated for k=1
%Input signal was estimated by using learning parameter set
[x_map_estimation] = mapEstimation(testData_y,H_estimated,estimatedCovariance_x,...
                                        estimatedMean_x,estimated_Variance);
[PSNR] = calcPSNR(x_map_estimation , testData_x);
fprintf ('Part-B : PSNR value is :%3.4f\n\n' ,PSNR );
fprintf ('-----------------------------------\n');

%% Part-C : Part A and B do 10 times. Because to apply 10-fold cross validation
%kFoldCrossValidation function is do it. It calculate learning parameter
%set and PSNR value for 10 times.

[psnrVector,cell_x_map_estimation] = kFoldCrossValidation(data_x,data_y,lenghtOfFilter,10);
psnr_mean = mean(psnrVector);
fprintf ('Part-C: Total PSNR value was writed below:\n') 
for i=1:10
   fprintf ('PSNR value is %3.4f for k=%d  \n',psnrVector(1,i),i); 
end
fprintf ('-----------------------------------\n');
fprintf ('Mean value of PSNR is :%3.4f\n' ,psnr_mean );

%% Part-D :Plotting estimation , groundtruth and observation
estimation_x = cell_x_map_estimation{3};    % estimation_x matrisi aslýnda 
figure(1),
plot(data_x(:,55),'b');
hold on,
plot(estimation_x(:,5),'r');
hold on,
plot(data_y(:,55),'g');
legend('GroundTruth' , 'Estimated Signal', 'Observation Signal');
