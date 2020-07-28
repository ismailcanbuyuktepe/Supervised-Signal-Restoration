function [PSNR] = calcPSNR(x_est , test_x)

[~,sample] = size(test_x);

sumValue =0;

for i=1: sample
    sumValue = sumValue + norm((test_x(:,i)-x_est(:,i)));
end

MSE = (1/(256*sample)) * sumValue;
PSNR = 20 *log10(max(max(test_x))/(MSE^0.5));
end

