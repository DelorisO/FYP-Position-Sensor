%doing the fft ??

%a and f are the coresponding frequency points 
%drawing frequency response of the filters need filters 
%that have a cut off frequency at 0.5 Hz this is comes
% from the forester paper and also estimates of human 
%frequency this will of course be adjusted
b1 = %first coefficent vector 
b2 = %second coefficent vector
b3 = %thrid coefficent vector

%these coefficent vectors are to make the overlap and
%add algorithm, i don't think they are for anything else

% need values on frequency of magnetometer movements

%Once i obtain the data can place into matlab and see 
%which frequency each movements exhibit 
load('ExampleData.mat');
AFFT = fft(Accelerometer(1,:),b1);
GFFT = fft(Gyroscope(1,:),b2);
MFFT = fft(Magnetometer(1,:),b3);

%which testing data can do it manually looking at the frequency
%of each change in position

%--------------------------------------------------------------------------

%Frequency Domain Features
centroid = 0;
spread = 0;
peak = 0;
power1 = 0;
power2 = 0;
power3 = 0;
