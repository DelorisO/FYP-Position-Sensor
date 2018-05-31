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
%cen = 0; leave this out for now
%PSD = 0;
peak = 0;
power1 = []; %signal power in different frequency bands
power2 = [];
power3 = [];
power4 = []; 

bound1 = ceil(length(AXFFT)/3);
bound2 = ceil(2*length(AXFFT)/3);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,1) = pwelch(AXFFT');
peak(:,1) = max(abs(AXFFT));
power1(:,1) = abs(AXFFT).^2;
power2(:,1) = mean(abs(AXFFT(1:bound1)).^2);
power3(:,1) = mean(abs(AXFFT(bound1:bound2)).^2);
power4(:,1) = mean(abs(AXFFT(bound2:end)).^2);

%cen(:,2) = centroid(Accelerometer(:,2),fs);
%PSD(:,2) = pwelch(Accelerometer(:,2));
peak(:,2) = max(abs(AYFFT));
power1(:,2) = abs(AYFFT).^2;
power2(:,2) = mean(abs(AYFFT(1:bound1)).^2);
power3(:,2) = mean(abs(AYFFT(bound1:bound2)).^2);
power4(:,2) = mean(abs(AYFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,3) = pwelch(Accelerometer(:,3));
peak(:,3) = max(abs(AZFFT));
power1(:,3) = abs(AZFFT).^2;
power2(:,3) = mean(abs(AZFFT(1:bound1)).^2);
power3(:,3) = mean(abs(AZFFT(bound1:bound2)).^2);
power4(:,3) = mean(abs(AZFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,4) = pwelch(Gyroscope(:,1));
peak(:,4) = max(abs(GXFFT));
power1(:,4) = abs(GXFFT).^2;
power2(:,4) = mean(abs(GXFFT(1:bound1)).^2);
power3(:,4) = mean(abs(GXFFT(bound1:bound2)).^2);
power4(:,4) = mean(abs(GXFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,5) = pwelch(Gyroscope(:,2));
peak(:,5) = max(abs(GYFFT));
power1(:,5) = abs(GYFFT).^2;
power2(:,5) = mean(abs(GYFFT(1:bound1)).^2);
power3(:,5) = mean(abs(GYFFT(bound1:bound2)).^2);
power4(:,5) = mean(abs(GYFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,6) = pwelch(Gyroscope(:,3));
peak(:,6) = max(abs(GZFFT));
power1(:,6) = abs(GZFFT).^2;
power2(:,6) = mean(abs(GZFFT(1:bound1)).^2);
power3(:,6) = mean(abs(GZFFT(bound1:bound2)).^2);
power4(:,6) = mean(abs(GZFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,7) = pwelch(Magnetometer(:,1));
peak(:,7) = max(abs(MXFFT));
power1(:,7) = abs(MXFFT).^2;
power2(:,7) = mean(abs(MXFFT(1:bound1)).^2);
power3(:,7) = mean(abs(MXFFT(bound1:bound2)).^2);
power4(:,7) = mean(abs(MXFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,8) = pwelch(Magnetometer(:,2));
peak(:,8) = max(abs(MYFFT));
power1(:,8) = abs(MYFFT).^2;
power2(:,8) = mean(abs(MYFFT(1:bound1)).^2);
power3(:,8) = mean(abs(MYFFT(bound1:bound2)).^2);
power4(:,8) = mean(abs(MYFFT(bound2:end)).^2);

%cen(:,1) = centroid(Accelerometer(:,1),fs);
%PSD(:,9) = pwelch(Magnetometer(:,3));
peak(:,9) = max(abs(MZFFT));
power1(:,9) = abs(MZFFT).^2;
power2(:,9) = mean(abs(MZFFT(1:bound1)).^2);
power3(:,9) = mean(abs(MZFFT(bound1:bound2)).^2);
power4(:,9) = mean(abs(MZFFT(bound2:end)).^2);

%need to pad all arrays so they can go out as 1 ... 

[padsize,~] = size(AXFFT);

peakpad = padarray(peak',(padsize-length(peak)),'post');
power1pad = padarray(power1,(padsize-length(power1)),'post')/padsize;
power2pad = 3*padarray(power2',(padsize-length(power2)),'post')/padsize;
power3pad = 3*padarray(power3',(padsize-length(power3)),'post')/padsize;
power4pad = 3*padarray(power4',(padsize-length(power4)),'post')/padsize;

FDT = [peakpad,power1pad,power2pad,power3pad,power4pad];

end