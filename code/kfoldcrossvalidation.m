function [confusion_m] = kfoldcrossvalidation(trainFeature,trainLabel,num_p,k,prop)
    confusion_m = zeros(2,2);
    n = size(trainLabel,1); % size of train
    n_train_p = ceil(num_p*prop);
    n_train_n = ceil((n-num_p)*prop);
    for i = 1:k
        r_perm_p = randperm(num_p);
        r_perm_n = num_p+randperm(n-num_p);
        
        train_feature = [trainFeature(r_perm_p(1:n_train_p),:); ...
                         trainFeature(r_perm_n(1:n_train_n),:)];
             
        test_feature =  [trainFeature(r_perm_p(n_train_p+1:end),:); ...
                         trainFeature(r_perm_n(n_train_n+1:end),:)];   
                     
        train_label =   [trainLabel(r_perm_p(1:n_train_p)); ...
                         trainLabel(r_perm_n(1:n_train_n))];
        
        test_label =    [trainLabel(r_perm_p(n_train_p+1:end)); ...
                         trainLabel(r_perm_n(n_train_n+1:end))];

        predictor = fitcsvm(train_feature,train_label,'ClassName',[-1,1]);
        
        y = predict(predictor,test_feature);
        for j = 1:size(y,1)
           if y(j) == test_label(j)
               if y(j) == 1 % true positive
                confusion_m(1,1) = confusion_m(1,1) + 1;
               else % true negative
                confusion_m(2,2) = confusion_m(2,2) + 1;
               end
           elseif y(j) > test_label(j) % false positive
               confusion_m(2,1) = confusion_m(2,1) + 1;
           else % false negative
               confusion_m(1,2) = confusion_m(1,2) + 1;
           end
        end
    end
end

