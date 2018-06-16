% The Statistical Analysis part, this extracts the time domain features,
% from this i will see which ones are actually useful

%clear;                              % clear all variables

%--------------------------------------------------------------------------
function TDF = TimeDF(Accelerometer, Gyroscope, Magnetometer)
%Time Domain features

average = 0;
variance = 0;
medi = 0;
skew = 0;
kurto = 0;
per25 = 0;
per75 = 0;
%load('ExampleData.mat');

%since data will be moving implement either an overlap and add or an
%overlap and save to be able to process the moving data, this should be
%implemented in C

average(:,1) = mean(Accelerometer(:,1));
variance(:,1) = var(Accelerometer(:,1));
medi(:,1) = median(Accelerometer(:,1));
skew(:,1) = skewness(Accelerometer(:,1));
kurto(:,1) = kurtosis(Accelerometer(:,1));
per25(:,1) = prctile(Accelerometer(:,1),25);
per75(:,1) = prctile(Accelerometer(:,1),75);

average(:,2) = mean(Accelerometer(:,2));
variance(:,2) = var(Accelerometer(:,2));
medi(:,2) = median(Accelerometer(:,2));
skew(:,2) = skewness(Accelerometer(:,2));
kurto(:,2) = kurtosis(Accelerometer(:,2));
per25(:,2) = prctile(Accelerometer(:,2),25);
per75(:,2) = prctile(Accelerometer(:,2),75);

average(:,3) = mean(Accelerometer(:,3));
variance(:,3) = var(Accelerometer(:,3));
medi(:,3) = median(Accelerometer(:,3));
skew(:,3) = skewness(Accelerometer(:,3));
kurto(:,3) = kurtosis(Accelerometer(:,3));
per25(:,3) = prctile(Accelerometer(:,3),25);
per75(:,3) = prctile(Accelerometer(:,3),75);

average(:,4) = mean(Gyroscope(:,1));
variance(:,4) = var(Gyroscope(:,1));
medi(:,4) = median(Gyroscope(:,1));
skew(:,4) = skewness(Gyroscope(:,1));
kurto(:,4) = kurtosis(Gyroscope(:,1));
per25(:,4) = prctile(Gyroscope(:,1),25);
per75(:,4) = prctile(Gyroscope(:,1),75);

average(:,5) = mean(Gyroscope(:,2));
variance(:,5) = var(Gyroscope(:,2));
medi(:,5) = median(Gyroscope(:,2));
skew(:,5) = skewness(Gyroscope(:,2));
kurto(:,5) = kurtosis(Gyroscope(:,2));
per25(:,5) = prctile(Gyroscope(:,2),25);
per75(:,5) = prctile(Gyroscope(:,2),75);

average(:,6) = mean(Gyroscope(:,3));
variance(:,6) = var(Gyroscope(:,3));
medi(:,6) = median(Gyroscope(:,3));
skew(:,6) = skewness(Gyroscope(:,3));
kurto(:,6) = kurtosis(Gyroscope(:,3));
per25(:,6) = prctile(Gyroscope(:,3),25);
per75(:,6) = prctile(Gyroscope(:,3),75);

average(:,7) = mean(Magnetometer(:,1));
variance(:,7) = var(Magnetometer(:,1));
medi(:,7) = median(Magnetometer(:,1));
skew(:,7) = skewness(Magnetometer(:,1));
kurto(:,7) = kurtosis(Magnetometer(:,1));
per25(:,7) = prctile(Magnetometer(:,1),25);
per75(:,7) = prctile(Magnetometer(:,1),75);

average(:,8) = mean(Magnetometer(:,2));
variance(:,8) = var(Magnetometer(:,2));
medi(:,8) = median(Magnetometer(:,2));
skew(:,8) = skewness(Magnetometer(:,2));
kurto(:,8) = kurtosis(Magnetometer(:,2));
per25(:,8) = prctile(Magnetometer(:,2),25);
per75(:,8) = prctile(Magnetometer(:,2),75);

average(:,9) = mean(Magnetometer(:,3));
variance(:,9) = var(Magnetometer(:,3));
medi(:,9) = median(Magnetometer(:,3));
skew(:,9) = skewness(Magnetometer(:,3));
kurto(:,9) = kurtosis(Magnetometer(:,3));
per25(:,9) = prctile(Magnetometer(:,3),25);
per75(:,9) = prctile(Magnetometer(:,3),75);

TDF = [average',variance',medi',skew',kurto',per25',per75'];

end