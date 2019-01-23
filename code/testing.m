function [recall,precision] = testing(trainfeature,trainlabel,num,k,prop,type)
    cm = kfoldcrossvalidation(trainfeature,trainlabel,num,k,prop);

    figure
    confusionchart(cm,['T';'F'],'Title',type);

    tp = cm(1,1);
    fp = cm(2,1);
    fn = cm(1,2);

    recall = tp/(tp+fn);
    precision = tp/(tp+fp);
end

