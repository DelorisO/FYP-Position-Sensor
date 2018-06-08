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

%empty all but the first 9 columns of A
A1(:,10:end) = [];
A2(:,10:end) = [];
A3(:,10:end) = [];
A4(:,10:end) = [];

% Begin to do ARHS by adding the quaternion library
addpath('quaternion_library');

FeaturesVector = [];
FeaturesVector_test = [];
%place in a sliding window at a frequency of 2Hz
humanrate = 25;
counter = 1;
[numsamp,~] = size(A1);
traindata = ceil(3*numsamp/4);



for k=1:traindata
    if  mod(k,humanrate) == 0
        FeaturesVector = [FeaturesVector;ProcessData(A1(k+1-humanrate:k,:),...
            A2(k+1-humanrate:k,:),A3(k+1-humanrate:k,:),A4(k+1-humanrate:k,:))];
        counter = counter +1;
    end
end

for k_t=(traindata+1):numsamp
    if mod(k_t,humanrate) == 0
        FeaturesVector_test = [FeaturesVector_test;ProcessData(A1(k_t+1-humanrate:k_t,:)...
            ,A2(k_t+1-humanrate:k_t,:),A3(k_t+1-humanrate:k_t,:),A4(k_t+1-humanrate:k_t,:))];
    end
end
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
