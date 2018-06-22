function overall_accuracy = OneVsAll(Features,Features_test)
addpath(genpath('libsvm'))

[numdata,~] = size(FeaturesVector);
[numdata_t,~] = size(FeaturesVector_test);
%scale the vectors
features_scale = scalefeatures(FeaturesVector);
features_t_scale = scalefeatures(FeaturesVector_test);%FeaturesVector_test
%make train data equal to a sparse vector which is the form needed for
%libsvm

%PCA HERE
%[coeff,score,latent,tsquared,explained,mu] = pca(features_scale');
%[coeff_t,score_t,latent_t,tsquared_t,explained_t,mu_t] = pca(features_t_scale');
%coeff(:,119:end) = [];
%coeff_t(:,119:end) = [];

traindata=sparse(features_scale);
testdata=sparse(features_t_scale);

for i=1:4
    
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
    
    %Uncomment for cross validation
    %{
    Cpw = linspace(-3,9,13);
    gpw = linspace(-8,0,9);
    counter = 1;
    Cgvalues=[];
    CVAccuracy = zeros(13,9);
    trainerror = zeros(13,9);
    for k=1:13
        for j=1:9
            CVarg = sprintf('-t 2 -c %d -g %d -v 10',2^Cpw(k),2^gpw(j));
            CVAccuracy(k,j) = svmtrain(labels, traindata, CVarg);
            svmarg = sprintf('-t 2 -c %d -g %d',2^Cpw(k),2^gpw(j));
            model_rbf = svmtrain(labels, traindata, svmarg);
            %Cgvalues(counter,:) = [2^(Cpw(k)),2^(gpw(j))];
            [~,trainerroracc,~] = svmpredict(labels,traindata, model_rbf);
            trainerror(k,j) = trainerroracc(1);
            counter=counter+1;
        end
    end
    %save('CVAccA4vsRest.mat',CVAccuracy);    
    [~,maxInd] = max(CVAccuracy(:));
    maxIndOverall(i) = maxInd;
    [I_row,I_col]=ind2sub(size(CVAccuracy),maxInd);
    %}
    if i == 1
        %model_linear1 = svmtrain(labels, traindata, '-t 0');
        %[predict_label_L1, accuracy_L1, dec_values_R1] = ...
        %    svmpredict(labels_t, testdata, model_linear1);
        svmarg = sprintf('-t 2 -c %d -g %d',2^1,2^(-8));
        model_rbf1 = svmtrain(labels, traindata, svmarg);
        [predict_label_R1, accuracy_R1, dec_values_R1] = ...
            svmpredict(labels_t,testdata, model_rbf1);
    elseif i == 2
        %model_linear2 = svmtrain(labels, traindata, '-t 0');
        %[predict_label_L2, accuracy_L2, dec_values_R2] = ...
        %    svmpredict(labels_t, testdata, model_linear2);
        svmarg = sprintf('-t 2 -c %d -g %d',2^1,2^(-8));
        model_rbf2 = svmtrain(labels, traindata, svmarg);
        [predict_label_R2, accuracy_R2, dec_values_R2] = ...
            svmpredict(labels_t,testdata, model_rbf2);
    elseif i == 3
        %model_linear3 = svmtrain(labels, traindata, '-t 0');
        %[predict_label_L3, accuracy_L3, dec_values_R3] = ...
        %    svmpredict(labels_t, testdata, model_linear3);
        svmarg = sprintf('-t 2 -c %d -g %d',2^(1),2^(-8));
        model_rbf3 = svmtrain(labels, traindata, svmarg);
        [predict_label_R3, accuracy_R3, dec_values_R3] = ...
            svmpredict(labels_t,testdata, model_rbf3);
    elseif i == 4
        %model_linear4 = svmtrain(labels, traindata, '-t 0');
        %[predict_label_L4, accuracy_L4, dec_values_R4] = ...
        %    svmpredict(labels_t, testdata, model_linear4);
        svmarg = sprintf('-t 2 -c %d -g %d',2^(1),2^(-8));
        model_rbf4 = svmtrain(labels, traindata, svmarg);
        [predict_label_R4, accuracy_R4, dec_values_R4] = ...
            svmpredict(labels_t,testdata, model_rbf4);
    else
        fprintf("Something is wrong");
    end
    
    
end

dec_values_R1 = scalefeatures(dec_values_R1);
dec_values_R2 = scalefeatures(dec_values_R2);
dec_values_R3 = scalefeatures(dec_values_R3);
dec_values_R4 = scalefeatures(dec_values_R4);

final_pred_labels = [];
temp = [];
temp2 = [];
counter =0;
countones = 0;
decval1=0;
decval2=0;
decval3=0;
decval4=0;

for i=1:numdata_t
    
    fulllabel = mod(i,4);
    
    if fulllabel == 1
        new_tl(i) = 1;
    elseif fulllabel == 2
        new_tl(i) = 2;
    elseif fulllabel == 3
        new_tl(i) = 3;
    else 
        new_tl(i) = 4;
    end
    
    temp(i,:) = [dec_values_R1(i) dec_values_R2(i) dec_values_R3(i) dec_values_R4(i)];
    [temp2(i),maxInd] = max(temp(i,:));
    if maxInd == 1
        final_pred_labels(i) = 1;
    elseif maxInd == 2
        final_pred_labels(i) = 2;
    elseif maxInd == 3
        final_pred_labels(i) = 3;
    elseif maxInd == 4
        final_pred_labels(i) = 4;
    else 
        fprintf("Something is wrong");
    end
    
    
    if final_pred_labels(i) == new_tl(i)
        counter = counter + 1;
    end
    if final_pred_labels(i) == 1
        countones = countones +1;
    end
    
    if dec_values_R1(i) > 0.6
        decval1=decval1+1;
    end
    if dec_values_R2(i) > 0.6
        decval2=decval2+1;
    end
    if dec_values_R3(i) > 0.6
        decval3=decval3+1;
    end
    if dec_values_R4(i) > 0.6
        decval4=decval4+1;
    end
end

overall_accuracy = counter/numdata_t;
%Confusion = confusionmat(final_pred_labels',new_tl');

end