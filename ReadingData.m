%% Processing Data Script
%Here is where the AHRS Algorithm takes place amongst other things

clear;

%% Reading Data

fs1 = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f ';
fs2 = '%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f';
fs = strcat(fs1,fs2);

A1 = []; %make empty array A to keep data in
A2 = []; %make empty array A to keep data in
A3 = []; %make empty array A to keep data in
A4 = []; %make empty array A to keep data in

%another for loop for each person
for j=1:8
    
    pnumber = num2str(j);
    pn = strcat('p',pnumber);
    
    %for loop because each segment is kept in different text files :|
    for i=1:60
        fnumber = num2str(i);%convert the number to string
            %then depending on what number it is make that number the filename .txt
        if i<10
            fn = strcat('s0',fnumber,'.txt');
        else
            fn = strcat('s',fnumber,'.txt');
        end
        %a01-sitting a02-standing a03-lying on back a04-lying on right side
        filename = fullfile('data','a01',pn,fn);
        fid = fopen(filename,'r');
        datacell = textscan(fid, fs, 'Delimiter', ',');
        fclose(fid);
        B = cell2mat(datacell); %convert cell format to array format
        A1 = [A1;B]; %everytime you read from a new text file 
    end

    for i=1:60
        fnumber = num2str(i);%convert the number to string
            %then depending on what number it is make that number the filename .txt
        if i<10
            fn = strcat('s0',fnumber,'.txt');
        else
            fn = strcat('s',fnumber,'.txt');
        end
        %a01-sitting a02-standing a03-lying on back a04-lying on right side
        filename = fullfile('data','a02',pn,fn);
        fid = fopen(filename,'r');
        datacell = textscan(fid, fs, 'Delimiter', ',');
        fclose(fid);
        B = cell2mat(datacell); %convert cell format to array format
        A2 = [A2;B]; %everytime you read from a new text file 
    end

    for i=1:60
        fnumber = num2str(i);%convert the number to string
            %then depending on what number it is make that number the filename .txt
        if i<10
            fn = strcat('s0',fnumber,'.txt');
        else
            fn = strcat('s',fnumber,'.txt');
        end
        %a01-sitting a02-standing a03-lying on back a04-lying on right side
        filename = fullfile('data','a03',pn,fn);
        fid = fopen(filename,'r');
        datacell = textscan(fid, fs, 'Delimiter', ',');
        fclose(fid);
        B = cell2mat(datacell); %convert cell format to array format
        A3 = [A3;B]; %everytime you read from a new text file 
    end

    for i=1:60
        fnumber = num2str(i);%convert the number to string
            %then depending on what number it is make that number the filename .txt
        if i<10
            fn = strcat('s0',fnumber,'.txt');
        else
            fn = strcat('s',fnumber,'.txt');
        end
        %a01-sitting a02-standing a03-lying on back a04-lying on right side
        filename = fullfile('data','a04',pn,fn);
        fid = fopen(filename,'r');
        datacell = textscan(fid, fs, 'Delimiter', ',');
        fclose(fid);
        B = cell2mat(datacell); %convert cell format to array format
        A4 = [A4;B]; %everytime you read from a new text file 
    end

end

%from here put who thing into a sliding window

%empty all but the first 9 columns of A
A1(:,10:end) = [];
A2(:,10:end) = [];
A3(:,10:end) = [];
A4(:,10:end) = [];

%Add Time component just for plotting.
%For this particular peice of data the time numbers are 
%25Hz Sampling Frequency therefore each sample happens at 0.04 seconds
timevector = linspace(0,2400,60001);
timevector(end) = [];

%make features vectors
Average = [];
Variance = [];
Median = [];
Skewness = [];
Kurtosis = [];
Per25 = [];
Per75 = [];

Peak = [];
TPowerAX = [];
TPowerAY = [];
TPowerAZ = [];
TPowerGX = [];
TPowerGY = [];
TPowerGZ = [];
TPowerMX = [];
TPowerMY = [];
TPowerMZ = [];
MeanP1 = [];
MeanP2 = [];
MeanP3 = [];

%empty test data
Average_t = [];
Variance_t = [];
Median_t = [];
Skewness_t = [];
Kurtosis_t = [];
Per25_t = [];
Per75_t = [];

Peak_t = [];
TPowerAX_t = [];
TPowerAY_t = [];
TPowerAZ_t = [];
TPowerGX_t = [];
TPowerGY_t = [];
TPowerGZ_t = [];
TPowerMX_t = [];
TPowerMY_t = [];
TPowerMZ_t = [];
MeanP1_t = [];  
MeanP2_t = [];
MeanP3_t = [];

%create an big Activities vector to hold activities and use this in the

%Better to show each person seperately?

for Activity=1:4
    
    if Activity == 1
        A = A1;
    elseif Activity == 2
        A = A2;
    elseif Activity == 3
        A = A3;
    else 
        A = A4;
    end  
    
    %clear vectors from before
    Accelerometer = [];
    Gyroscope = [];
    Magnetometer = [];
    TDF = [];
    FDF =[];
        
    Accelerometer = A(:,1:3);
    Gyroscope = A(:,4:6)*180/pi; %may be given in radians instead of degrees

    %think you multiply gyroscope data by 100 because
    %it sampling frequency is 100Hz therefore it may be measuring in degrees
    %per 10 microsecond instead of degree per second ???

    Magnetometer = A(:,7:9);

    %Have no idea about the units of the magnetometer but assuming it is in
    %micro Tesla since thats what i found in the paper but i doubt this
    %therefore just keep it as it is, might be in Guass or mGuass

    % Begin to do ARHS by adding the quaternion library
    addpath('quaternion_library');

    %% Process sensor data through algorithm

    %Because my sampling period is ony 25Hz
    AHRS = MadgwickAHRS('SamplePeriod', 1/25, 'Beta', 0.1);
    % AHRS = MahonyAHRS('SamplePeriod', 1/25, 'Kp', 0.5);

    %seperate into training and test data with a 75:25 ratio respectively
    %TRAINING
    quaternion = zeros(length(timevector(1:45000)), 4);
    for t = 1:length(timevector(1:45000))
        AHRS.Update(Gyroscope(t,:) * (pi/180), Accelerometer(t,:), Magnetometer(t,:));	
        % gyroscope units must be radians
        quaternion(t, :) = AHRS.Quaternion;
    end
    
    %TEST
    quaternion_test = zeros(length(timevector(45001:end)), 4);
    for t_t = 45001:length(timevector)
        AHRS.Update(Gyroscope(t_t,:) * (pi/180), Accelerometer(t_t,:), Magnetometer(t_t,:));	
        % gyroscope units must be radians
        quaternion_test((t_t-45000), :) = AHRS.Quaternion;
    end
    
    %may need to make TDF and FDT empty at each loop iteration
    
    %Now get Time domain features
    TDF = TimeDF(Accelerometer(1:45000,:),Gyroscope(1:45000,:),Magnetometer(1:45000,:));
    TDF_test = TimeDF(Accelerometer(45001:end,:),Gyroscope(45001:end,:),Magnetometer(45001:end,:));
    TimeNames = categorical({'Average', 'Variance', 'Median', 'Skewness', ...
        'Kurtosis' , '25 Percentile', '75 Percentile'});

    %Now get Frequency domain features
    FDF = FrequencyDF(Accelerometer(1:45000,:), Gyroscope(1:45000,:), Magnetometer(1:45000,:));
    FDF_test = FrequencyDF(Accelerometer(45001:end,:), Gyroscope(45001:end,:), Magnetometer(45001:end,:));
    FrequencyNames = ["Peak ","Total Power AX","Total Power AY", ...
        "Total Power AZ","Total Power GX","Total Power GY","Total Power GZ",...
        "Total Power MX","Total Power MY","Total Power MZ"];

    %% Get Algorithm in terms of Euler Angles

    euler = quatern2euler(quaternConj(quaternion)) * (180/pi);	% use conjugate 
    %for sensor frame relative to Earth and convert to degrees.
    euler_test = quatern2euler(quaternConj(quaternion_test)) * (180/pi);

    %% Plot All Figures
%{
    %Plot the accelerometer, gyroscope and magnetometer data
    figure('Name', 'Sensor Data');
    axis(1) = subplot(3,1,1);
    hold on;
    plot(timevector, Gyroscope(:,1), 'r');
    plot(timevector, Gyroscope(:,2), 'g');
    plot(timevector, Gyroscope(:,3), 'b');
    legend('X', 'Y', 'Z');
    xlabel('Time (s)');
    ylabel('Angular rate (deg/s)');
    title('Gyroscope');
    hold off;
    axis(2) = subplot(3,1,2);
    hold on;
    plot(timevector, Accelerometer(:,1), 'r');
    plot(timevector, Accelerometer(:,2), 'g');
    plot(timevector, Accelerometer(:,3), 'b');
    legend('X', 'Y', 'Z');
    xlabel('Time (s)');
    ylabel('Acceleration (g)');
    title('Accelerometer');
    hold off;
    axis(3) = subplot(3,1,3);
    hold on;
    plot(timevector, Magnetometer(:,1), 'r');
    plot(timevector, Magnetometer(:,2), 'g');
    plot(timevector, Magnetometer(:,3), 'b');
    legend('X', 'Y', 'Z');
    xlabel('Time (s)');
    ylabel('Flux (G)');
    title('Magnetometer');
    hold off;
    linkaxes(axis, 'x');

    %Plot Euler Angles
    figure('Name', 'Euler Angles');
    hold on;
    plot(timevector, euler(:,1), 'r');
    plot(timevector, euler(:,2), 'g');
    plot(timevector, euler(:,3), 'b');
    title('Euler angles');
    xlabel('Time (s)');
    ylabel('Angle (deg)');
    legend('\phi', '\theta', '\psi');
    hold off;
%}
    %Plot Time Domain and Frequency Domain Features 
    %Here you want to compare the different activities therefore this 
    %is the part that you put it all in a loop
    
    Average = [Average,TDF(:,1)];
    Variance = [Variance,TDF(:,2)];
    Median = [Median,TDF(:,3)];
    Skewness = [Skewness,TDF(:,4)];
    Kurtosis = [Kurtosis,TDF(:,5)];
    Per25 = [Per25,TDF(:,6)];
    Per75 = [Per75,TDF(:,7)];
    
    Peak = [Peak,FDF(1:9,1)];
    TPowerAX = [TPowerAX,FDF(:,2)];
    TPowerAY = [TPowerAY,FDF(:,3)];
    TPowerAZ = [TPowerAZ,FDF(:,4)];
    TPowerGX = [TPowerGX,FDF(:,5)];
    TPowerGY = [TPowerGY,FDF(:,6)];
    TPowerGZ = [TPowerGZ,FDF(:,7)];
    TPowerMX = [TPowerMX,FDF(:,8)];
    TPowerMY = [TPowerMY,FDF(:,9)];
    TPowerMZ = [TPowerMZ,FDF(:,10)];
    MeanP1 = [MeanP1,FDF(1:9,11)];  
    MeanP2 = [MeanP2,FDF(1:9,12)];
    MeanP3 = [MeanP3,FDF(1:9,13)];
    
    %test data
    
    Average_t = [Average_t,TDF_test(:,1)];
    Variance_t = [Variance_t,TDF_test(:,2)];
    Median_t = [Median_t,TDF_test(:,3)];
    Skewness_t = [Skewness_t,TDF_test(:,4)];
    Kurtosis_t = [Kurtosis_t,TDF_test(:,5)];
    Per25_t = [Per25_t,TDF_test(:,6)];
    Per75_t = [Per75_t,TDF_test(:,7)];
    
    Peak_t = [Peak_t,FDF_test(1:9,1)];
    TPowerAX_t = [TPowerAX_t,FDF_test(:,2)];
    TPowerAY_t = [TPowerAY_t,FDF_test(:,3)];
    TPowerAZ_t = [TPowerAZ_t,FDF_test(:,4)];
    TPowerGX_t = [TPowerGX_t,FDF_test(:,5)];
    TPowerGY_t = [TPowerGY_t,FDF_test(:,6)];
    TPowerGZ_t = [TPowerGZ_t,FDF_test(:,7)];
    TPowerMX_t = [TPowerMX_t,FDF_test(:,8)];
    TPowerMY_t = [TPowerMY_t,FDF_test(:,9)];
    TPowerMZ_t = [TPowerMZ_t,FDF_test(:,10)];
    MeanP1_t = [MeanP1_t,FDF_test(1:9,11)];  
    MeanP2_t = [MeanP2_t,FDF_test(1:9,12)];
    MeanP3_t = [MeanP3_t,FDF_test(1:9,13)];
    
end

%Activities = categorical({'Sitting', 'Standing', 'Lying on Back', ...
%    'Lying on Right'});

%{
figure('Name', 'Average Comparision');
axis(1) = subplot(3,3,1);
hold on;
bar(Activities,Average(1,:));
xlabel('Activites');
ylabel('Acceleration in m/s^2');
title('Accelerometer X Axis');
hold off;
axis(2) = subplot(3,3,2);
hold on;
bar(Activities,Average(2,:));
xlabel('Activites');
ylabel('Acceleration in m/s^2');
title('Accelerometer Y Axis');
hold off;
axis(3) = subplot(3,3,3);
hold on;
bar(Activities,Average(3,:));
xlabel('Activites');
ylabel('Acceleration in m/s^2');
title('Acceleromter Z Axis');
hold off;
axis(4) = subplot(3,3,4);
hold on;
bar(Activities,Average(4,:));
xlabel('Activites');
ylabel('Gyroscope in rad/s');
title('Gyroscope X Axis');
hold off;
axis(5) = subplot(3,3,5);
hold on;
bar(Activities,Average(5,:));
xlabel('Activites');
ylabel('Gyroscope in rad/s');
title('Gyroscope Y Axis');
hold off;
axis(6) = subplot(3,3,6);
hold on;
bar(Activities,Average(6,:));
xlabel('Activites');
ylabel('Gyroscope in rad/s');
title('Gyroscope Z Axis');
hold off;
axis(7) = subplot(3,3,7);
hold on;
bar(Activities,Average(7,:));
xlabel('Activites');
ylabel('Magnetometer in G');
title('Magnetometer X Axis');
hold off;
axis(8) = subplot(3,3,8);
hold on;
bar(Activities,Average(8,:));
xlabel('Activites');
ylabel('Magnetometer in G');
title('Magnetometer Y Axis');
hold off;
axis(9) = subplot(3,3,9);
hold on;
bar(Activities,Average(9,:));
xlabel('Activites');
ylabel('Magnetometer in G');
title('Magnetometer Z Axis');
hold off;
linkaxes(axis, 'x');

%Frequency

figure('Name', 'Power Spectrum');
semilogy(TPowerAX);
title('Accelerometer X Axis');
xlabel('Frequency Components');
ylabel('Power');
legend('Sitting', 'Standing', 'Lying on Back','Lying on Right');
%}

    
%% Putting Features together

%Features Vector made up of all the frequency domain features 
FeaturesVector = [Average; Variance; Median; Skewness; Kurtosis; Per25; ...
Per75; Peak; MeanP1; MeanP2; MeanP3]';
FeaturesVector_test = [Average_t; Variance_t; Median_t; Skewness_t; Kurtosis_t;...
    Per25_t; Per75_t; Peak_t; MeanP1_t; MeanP2_t; MeanP3_t]';

%% Feature Reduction/Selection

[coeff,score,latent,tsquared,explained,mu] = pca(FeaturesVector');
[coeff_t,score_t,latent_t,tsquared_t,explained_t,mu_t] = pca(FeaturesVector_test');

%% Machine Learning Algorithm

%seperate into training and test data with a 75:25 ratio respectively
%all processing has already been done on training data

%create labels

label = [1;-1];
label_t = [1;-1];

addpath(genpath('libsvm'))

model_linear = svmtrain(label, FeaturesVector(1:2,:), '-t 0');

%right now just comparing standing and sitting so a1,a2

%classifier = fitcsvm();
%libsvmread

[predict_label_L, accuracy_L, dec_values_L] = svmpredict(label_t, FeaturesVector_test(1:2,:), model_linear);
