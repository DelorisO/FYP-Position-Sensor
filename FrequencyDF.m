function FDT = FrequencyDF(Accelerometer, Gyroscope, Magnetometer)
%a and f are the coresponding frequency points 
%drawing frequency response of the filters need filters 
%that have a cut off frequency at 0.5 Hz this is comes
% from the forester paper and also estimates of human 
%frequency this will of course be adjusted

%these coefficent vectors are to make the overlap and
%add algorithm, i don't think they are for anything else

% need values on frequency of magnetometer movements

%Once i obtain the data can place into matlab and see 
%which frequency each movements exhibit 

AXFFT = fft(Accelerometer(:,1));
AYFFT = fft(Accelerometer(:,2));
AZFFT = fft(Accelerometer(:,3));
GXFFT = fft(Gyroscope(:,1));
GYFFT = fft(Gyroscope(:,2));
GZFFT = fft(Gyroscope(:,3));
MXFFT = fft(Magnetometer(:,1));
MYFFT = fft(Magnetometer(:,2));
MZFFT = fft(Magnetometer(:,3));

%which testing data can do it manually looking at the frequency
%of each change in position

%--------------------------------------------------------------------------

%Frequency Domain Features
%cen = 0; 
peak = 0;
power1 = []; %signal power in different frequency bands
power2 = [];
power3 = [];
power4 = [];
sskew = [];
skur = [];

bound1 = ceil(length(AXFFT)/3);
bound2 = ceil(2*length(AXFFT)/3);
fs =25;

%cen(:,1) = centroid(abs(AXFFT),fs);
peak(:,1) = max(abs(AXFFT));
power1(:,1) = mean(abs(AXFFT).^2);
power2(:,1) = mean(abs(AXFFT(1:bound1)).^2);
power3(:,1) = mean(abs(AXFFT(bound1:bound2)).^2);
power4(:,1) = mean(abs(AXFFT(bound2:end)).^2);
sskew(:,1) = skewness(abs(AXFFT));
skur(:,1) = kurtosis(abs(AXFFT));

%cen(:,2) = centroid(abs(AYFFT),fs);
peak(:,2) = max(abs(AYFFT));
power1(:,2) = mean(abs(AYFFT).^2);
power2(:,2) = mean(abs(AYFFT(1:bound1)).^2);
power3(:,2) = mean(abs(AYFFT(bound1:bound2)).^2);
power4(:,2) = mean(abs(AYFFT(bound2:end)).^2);
sskew(:,2) = skewness(abs(AYFFT));
skur(:,2) = kurtosis(abs(AYFFT));

%cen(:,3) = centroid(abs(AZFFT),fs);
peak(:,3) = max(abs(AZFFT));
power1(:,3) = mean(abs(AZFFT).^2);
power2(:,3) = mean(abs(AZFFT(1:bound1)).^2);
power3(:,3) = mean(abs(AZFFT(bound1:bound2)).^2);
power4(:,3) = mean(abs(AZFFT(bound2:end)).^2);
sskew(:,3) = skewness(abs(AZFFT));
skur(:,3) = kurtosis(abs(AZFFT));

%cen(:,4) = centroid(abs(GXFFT),fs);
peak(:,4) = max(abs(GXFFT));
power1(:,4) = mean(abs(GXFFT).^2);
power2(:,4) = mean(abs(GXFFT(1:bound1)).^2);
power3(:,4) = mean(abs(GXFFT(bound1:bound2)).^2);
power4(:,4) = mean(abs(GXFFT(bound2:end)).^2);
sskew(:,4) = skewness(abs(GXFFT));
skur(:,4) = kurtosis(abs(GXFFT));

%cen(:,5) = centroid(abs(GYFFT),fs);
peak(:,5) = max(abs(GYFFT));
power1(:,5) = mean(abs(GYFFT).^2);
power2(:,5) = mean(abs(GYFFT(1:bound1)).^2);
power3(:,5) = mean(abs(GYFFT(bound1:bound2)).^2);
power4(:,5) = mean(abs(GYFFT(bound2:end)).^2);
sskew(:,5) = skewness(abs(GYFFT));
skur(:,5) = kurtosis(abs(GYFFT));

%cen(:,6) = centroid(abs(GZFFT),fs);
peak(:,6) = max(abs(GZFFT));
power1(:,6) = mean(abs(GZFFT).^2);
power2(:,6) = mean(abs(GZFFT(1:bound1)).^2);
power3(:,6) = mean(abs(GZFFT(bound1:bound2)).^2);
power4(:,6) = mean(abs(GZFFT(bound2:end)).^2);
sskew(:,6) = skewness(abs(GZFFT));
skur(:,6) = kurtosis(abs(GZFFT));

%cen(:,7) = centroid(abs(MXFFT),fs);
peak(:,7) = max(abs(MXFFT));
power1(:,7) = mean(abs(MXFFT).^2);
power2(:,7) = mean(abs(MXFFT(1:bound1)).^2);
power3(:,7) = mean(abs(MXFFT(bound1:bound2)).^2);
power4(:,7) = mean(abs(MXFFT(bound2:end)).^2);
sskew(:,7) = skewness(abs(MXFFT));
skur(:,7) = kurtosis(abs(MXFFT));

%cen(:,8) = centroid(abs(MYFFT),fs);
peak(:,8) = max(abs(MYFFT));
power1(:,8) = mean(abs(MYFFT).^2);
power2(:,8) = mean(abs(MYFFT(1:bound1)).^2);
power3(:,8) = mean(abs(MYFFT(bound1:bound2)).^2);
power4(:,8) = mean(abs(MYFFT(bound2:end)).^2);
sskew(:,8) = skewness(abs(MYFFT));
skur(:,8) = kurtosis(abs(MYFFT));

%cen(:,9) = centroid(abs(MZFFT),fs);
peak(:,9) = max(abs(MZFFT));
power1(:,9) = mean(abs(MZFFT).^2);
power2(:,9) = mean(abs(MZFFT(1:bound1)).^2);
power3(:,9) = mean(abs(MZFFT(bound1:bound2)).^2);
power4(:,9) = mean(abs(MZFFT(bound2:end)).^2);
sskew(:,9) = skewness(abs(MZFFT));
skur(:,9) = kurtosis(abs(MZFFT));

%need to pad all arrays so they can go out as 1 ... 

[N,~] = size(AXFFT);

peakpad = peak'/N;
power1pad = power1'/N;
power2pad = 3*power2'/N;
power3pad = 3*power3'/N;
power4pad = 3*power4'/N;
%cen = cen'/N;
sskew = sskew'/N;
skur = skur'/N;

FDT = [peakpad,power1pad,power2pad,power3pad,power4pad,sskew,skur];

end