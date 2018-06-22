%Program to read my data to then feed in one vs all 

%first subtract orientation, the orientation of the sensor is different
%that was probably in their study therefore need to subtract the to make it
%level with theirs, just what it was after you turned it at the begginning
%ish

%then do TDF and FDF of the data I have, once that has been done you can
%just pass it through one vs all GOOD LUCK!!!!!!
fileID = fopen('sensordata.txt');
mysensordata = textscan(fileID,'%f %f %f');
fclose(fileID);
XAxis = cell2mat(mysensordata(1,1));
YAxis = cell2mat(mysensordata(1,2));
ZAxis = cell2mat(mysensordata(1,3));
nummds= length(ZAxis)-1;
MyDataAccelerometer = [];
MyDataGyroscope = [];
MyDataMagnetometer = [];
countera =1;
counterg =1;
counterm = 1;


for i = 1:nummds
    if mod(i,3) == 1
        MyDataAccelerometer(countera,1) = XAxis(i) +8.03;
        MyDataAccelerometer(countera,2) = YAxis(i) - 6.28;
        MyDataAccelerometer(countera,3) = ZAxis(i) - 2.54;
        countera = countera + 1;
    elseif mod(i,3) == 2
        MyDataGyroscope(counterg,1) = XAxis(i) +7.45;
        MyDataGyroscope(counterg,2) = YAxis(i) +0.53;
        MyDataGyroscope(counterg,3) = ZAxis(i) +3.68;
        counterg= counterg+1;
    elseif mod(i,3) == 0
        MyDataMagnetometer(counterm,1) = XAxis(i) -0.21;
        MyDataMagnetometer(counterm,2) = YAxis(i) + 0.49;
        MyDataMagnetometer(counterm,3) = ZAxis(i) +0.05;
        counterm = counterm +1;
    end
    
end

addpath('quaternion_library');

%%{
Average = [];
Variance = [];
Median = [];
Skewness = [];
Kurtosis = [];
Per25 = [];
Per75 = [];

Peak = [];
TPower = [];
MeanP1 = [];
MeanP2 = [];
MeanP3 = [];
SSkew = [];
SKur = [];
euler_avg = [];

timevector = linspace(0.5,645,430);
timevector(end) = [];

for k=1:floor(nummds/5)-1
    %(k_t+1-humanrate:k_t,:)

    %Because my sampling period is ony 25Hz
    AHRS = MadgwickAHRS('SamplePeriod', 1/2, 'Beta', 0.1);
    % AHRS = MahonyAHRS('SamplePeriod', 1/25, 'Kp', 0.5);

    quaternion = zeros(length(timevector), 4);
    for t = 1:length(timevector)
        AHRS.Update(MyDataGyroscope(t,:) * (pi/180), MyDataAccelerometer(t,:), MyDataMagnetometer(t,:));	
        % gyroscope units must be radians
        quaternion(t, :) = AHRS.Quaternion;
    end
    
    %may need to make TDF and FDT empty at each loop iteration
    
    %Now get Time domain features
    TDF = TimeDF(MyDataAccelerometer(k:k+5,:),MyDataGyroscope(k:k+5,:),MyDataMagnetometer(k:k+5,:));

    %Now get Frequency domain features
    FDF = FrequencyDF(MyDataAccelerometer(k:k+5,:),MyDataGyroscope(k:k+5,:),MyDataMagnetometer(k:k+5,:));
    
    euler = quatern2euler(quaternConj(quaternion)) * (180/pi);	% use conjugate 
    euler_avg = [euler_avg;(mean(euler))];
    
    Average = [Average,TDF(:,1)];
    Variance = [Variance,TDF(:,2)];
    Median = [Median,TDF(:,3)];
    Skewness = [Skewness,TDF(:,4)];
    Kurtosis = [Kurtosis,TDF(:,5)];
    Per25 = [Per25,TDF(:,6)];
    Per75 = [Per75,TDF(:,7)];
    
    Peak = [Peak,FDF(1:9,1)];
    TPower = [TPower,FDF(:,2)];
    MeanP1 = [MeanP1,FDF(1:9,3)];  
    MeanP2 = [MeanP2,FDF(1:9,4)];
    MeanP3 = [MeanP3,FDF(1:9,5)];
    SSkew = [SSkew,FDF(1:9,6)];
    SKur = [SKur,FDF(1:9,7)];

end

Featuresmydata = [Average; Variance; Median; Skewness; Kurtosis; Per25; ...
Per75; Peak; MeanP1; MeanP2; MeanP3;SSkew;SKur]';

Featuresmydata = [Featuresmydata,euler_avg];
%}