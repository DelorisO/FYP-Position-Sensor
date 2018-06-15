%function SVMModel = OneVsOne(Features,Features_test)%,A1,A2,A3,A4)
%A1 and A2 are the two activities which are chosen, out of 1,2,3,4
[numdata,~] = size(FeaturesVector);
%[~,numact] = size(A1);
traindata = [];
labels = [];
%FeaturesVector = FeaturesVector();
%A=[A1;A2;A3;A4];
%remember to do zscore of features vector' outside function
%seperate into respective activities
%A1-A2, A1-A3, A1-A4, A2-A3, A3-A4
for i=1:3
    for j = (i+1):4
        %A(((i-1)*numact +1):numact*j);
        traindata = [];
        labels = [];
        for k=1:numdata/4
            traindata = [traindata;FeaturesVector((k-1)*4+i,:)...
                ;FeaturesVector((k-1)*4+j,:)];
            labels = [labels;[1;-1]];
            model_linear = svmtrain(labels, traindata, '-t 0');
            [predict_label_L, accuracy_L, dec_values_L] = svmpredict(label_t, FeaturesVector_test(1:2,:), model_linear);
        end    
    end
end
SVMModel = 1;
%end