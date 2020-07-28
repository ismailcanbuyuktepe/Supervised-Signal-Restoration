function [x_map_estimation] = mapEstimation(testObservationData,H_est,Cov_est,mean_est,var_est)

 term1 = H_est.' * H_est;
 term2 = var_est * inv(Cov_est);
 
 term3 = H_est.' * testObservationData;
 term4 = var_est * inv(Cov_est) * mean_est;
 
 
x_map_estimation = inv((term1 + term2)) * (term3 + term4);

end

