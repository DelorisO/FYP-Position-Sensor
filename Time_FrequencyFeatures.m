% The Statistical Analysis part, this extracts the time domain features,
% from this i will see which ones are actually useful

clear;                              % clear all variables

%--------------------------------------------------------------------------

%Time Domain features

average = 0;
variance = 0;
medi = 0;
skew = 0;
kurto = 0;
per25 = 0;
per75 = 0;

%Frequency Domain featurers 

centroid = 0;
spread = 0;
peak = 0;
power1 = 0;
power2 = 0;
power3 = 0;

load('ExampleData.mat');

%since data will be moving implement either an overlap and add or an
%overlap and save to be able to process the moving data, this should be
%implemented in C

AX = Accelerometer(:,1);
average(:,1) = mean(AX);
variance(:,1) = var(AX);
medi(:,1) = median(AX);
skew(:,1) = skewness(AX);
kurto(:,1) = kurtosis(AX);
per25(:,1) = prctile(AX,25);
per75(:,1) = prctile(AX,75);

AY = Accelerometer(:,2);
average(:,2) = mean(AY);
variance(:,2) = var(AY);
medi(:,2) = median(AY);
skew(:,2) = skewness(AY);
kurto(:,2) = kurtosis(AY);
per25(:,2) = prctile(AY,25);
per75(:,2) = prctile(AY,75);

AZ = Accelerometer(:,3);
average(:,3) = mean(AZ);
variance(:,3) = var(AZ);
medi(:,3) = median(AZ);
skew(:,3) = skewness(AZ);
kurto(:,3) = kurtosis(AZ);
per25(:,3) = prctile(AZ,25);
per75(:,3) = prctile(AZ,75);

GX = Gyroscope(:,1);
average(:,4) = mean(GX);
variance(:,4) = var(GX);
medi(:,4) = median(GX);
skew(:,4) = skewness(GX);
kurto(:,4) = kurtosis(GX);
per25(:,4) = prctile(GX,25);
per75(:,4) = prctile(GX,75);

GY = Gyroscope(:,2);
average(:,5) = mean(GY);
variance(:,5) = var(GY);
medi(:,5) = median(GY);
skew(:,5) = skewness(GY);
kurto(:,5) = kurtosis(GY);
per25(:,5) = prctile(GY,25);
per75(:,5) = prctile(GY,75);

GZ = Gyroscope(:,3);
average(:,6) = mean(GZ);
variance(:,6) = var(GZ);
medi(:,6) = median(GZ);
skew(:,6) = skewness(GZ);
kurto(:,6) = kurtosis(GZ);
per25(:,6) = prctile(GZ,25);
per75(:,6) = prctile(GZ,75);

MX = Magnetometer(:,1);
average(:,7) = mean(MX);
variance(:,7) = var(MX);
medi(:,7) = median(MX);
skew(:,7) = skewness(MX);
kurto(:,7) = kurtosis(MX);
per25(:,7) = prctile(MX,25);
per75(:,7) = prctile(MX,75);

MY = Magnetometer(:,2);
average(:,8) = mean(MY);
variance(:,8) = var(MY);
medi(:,8) = median(MY);
skew(:,8) = skewness(MY);
kurto(:,8) = kurtosis(MY);
per25(:,8) = prctile(MY,25);
per75(:,8) = prctile(MY,75);

MZ = Magnetometer(:,3);
average(:,9) = mean(MZ);
variance(:,9) = var(MZ);
medi(:,9) = median(MZ);
skew(:,9) = skewness(MZ);
kurto(:,9) = kurtosis(MZ);
per25(:,9) = prctile(MZ,25);
per75(:,9) = prctile(MZ,75);

figure();
axis(1) = subplot(3,1,1);
plot(average, 'c*')
hold off;
axis(2) = subplot(3,1,2);
hold on;
plot(variance,'c*');
hold off;

%--------------------------------------------------------------------------

%Frequency Domain Features