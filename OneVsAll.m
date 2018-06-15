%function SVMModel = OneVsAll(Features,Features_test)
addpath(genpath('libsvm'))

[numdata,~] = size(FeaturesVector);
[numdata_t,~] = size(FeaturesVector_test);
%scale the vectors using zscore
features_scale = FeaturesVector;%zscore();
features_t_scale = FeaturesVector_test;%zscore();
%make train data equal to a sparse vector which is the form needed for
%libsvm
traindata=sparse(features_scale);
testdata=sparse(features_t_scale);
for i=4:4
    
    %training labels
    labels=[];
    for j=1:numdata
        if i==(mod(j,4))
            labels = [labels;1];
        elseif i==4 && mod(j,4) ==0
            labels = [labels;1];
        else
            labels = [labels;-1];
        end
    end
    
    %testing labels
    labels_t=[];
    for j=1:numdata_t
        if i==(mod(j,4))
            labels_t = [labels_t;1];
        elseif i==4 && mod(j,4) ==0
            labels_t = [labels_t;1];
        else
            labels_t = [labels_t;-1];
        end
    end
    %at this point you have assigned the labels in the correct mannner and
    %got the traindata in the correct manner.
    
    %here you do cross validation:
    
    %then train classifier with input
    %model_linear = svmtrain(labels, traindata, '-t 0');
    %[predict_label_L, accuracy_L, dec_values_L] = svmpredict(labels_t, ...
    %    testdata, model_linear);
    
    Cpw = linspace(-5,9,8);
    gpw = linspace(-10,4,8);
    counter = 1;
    Cgvalues=[];
    %CVAccuracy = [];
    for k=1:8
        for j=1:8
            CVarg = sprintf('-t 2 -c %d -g %d -v 10',2^Cpw(k),2^gpw(j));
            CVAccuracy(k,j) = svmtrain(labels, traindata, CVarg);
            Cgvalues(counter,:) = [2^(Cpw(k)),2^(gpw(j))];
            counter=counter+1;
        end
    end
    save('CVAccA4vsRest.mat',CVAccuracy);
    
    [~,maxInd] = max(CVAccuracy(:));
    maxIndOverall(i) = maxInd;
    [I_row,I_col]=ind2sub(size(CVAccuracy),maxInd);
    svmarg = sprintf('-t 2 -c %d -g %d',2^Cpw(I_row),2^gpw(I_col));
    model_rbf = svmtrain(labels, traindata, svmarg);
    [predict_label_R, accuracy_R, dec_values_R] = ...
        svmpredict(labels_t,testdata, model_rbf);
    %acc(i)=accuracy_R;
end
%end