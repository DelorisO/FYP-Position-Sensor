        tic
        [predict_label_R1, accuracy_R1, dec_values_R1] = ...
            svmpredict(labels_t,testdata, model_rbf1);
        toc