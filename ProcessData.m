%make this a function :/
function Features = ProcessData(A1,A2,A3,A4)

%size of all activities should be the same
[samples,~] = size(A1);

%Add Time component just for plotting.
%For this particular peice of data the time numbers are 
%25Hz Sampling Frequency therefore each sample happens at 0.04 seconds
%CHANGE THIS IF USING A DIFFERENT DATA SET with a different sampling rate

timevector = linspace(0,(samples/25),(samples+1));
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

    %% Process sensor data through algorithm

    %Because my sampling period is ony 25Hz
    AHRS = MadgwickAHRS('SamplePeriod', 1/25, 'Beta', 0.1);
    % AHRS = MahonyAHRS('SamplePeriod', 1/25, 'Kp', 0.5);

    quaternion = zeros(length(timevector), 4);
    for t = 1:length(timevector)
        AHRS.Update(Gyroscope(t,:) * (pi/180), Accelerometer(t,:), Magnetometer(t,:));	
        % gyroscope units must be radians
        quaternion(t, :) = AHRS.Quaternion;
    end
    
    %may need to make TDF and FDT empty at each loop iteration
    
    %Now get Time domain features
    TDF = TimeDF(Accelerometer,Gyroscope,Magnetometer);
    TimeNames = categorical({'Average', 'Variance', 'Median', 'Skewness', ...
        'Kurtosis' , '25 Percentile', '75 Percentile'});

    %Now get Frequency domain features
    FDF = FrequencyDF(Accelerometer, Gyroscope, Magnetometer);
    FrequencyNames = ["Peak ","Total Power AX","Total Power AY", ...
        "Total Power AZ","Total Power GX","Total Power GY","Total Power GZ",...
        "Total Power MX","Total Power MY","Total Power MZ"];

    %% Get Algorithm in terms of Euler Angles

    euler = quatern2euler(quaternConj(quaternion)) * (180/pi);	% use conjugate 
    %for sensor frame relative to Earth and convert to degrees.
   
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
Features = [Average; Variance; Median; Skewness; Kurtosis; Per25; ...
Per75; Peak; MeanP1; MeanP2; MeanP3]';

end
