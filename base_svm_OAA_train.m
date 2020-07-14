function svmStruct = base_svm_OAA_train( trdata,type,ker,kerp,C )
% trdata                Training data
% type                  SVM type (C-SVM)
% ker                   Kernel type (rbf gaussian kernel)
% kerp                  Kernel parameter (Gamma, not Sigma)
% C                     Penalty term

    classLabel          = unique(trdata(:,end));
    numClass            = length(classLabel);
    
    xtr                 = cell(1,numClass);
    ytr                 = cell(1,numClass);
    svmStruct           = cell(1,numClass);
    
    for i = 1:numClass
        fprintf('%d th class and the rest classes\n',i);
        xtr{1,i}                                    = trdata(:,1:end-1);
        ytr{1,i}                                    = -ones(size(trdata,1),1);
        ytr{1,i}(trdata(:,end)==classLabel(i),1)    = 1;
        svmStruct{1,i} = svmtrain( ytr{1,i}, xtr{1,i}, ['-s ',num2str(type),' -t ',num2str(ker),' -g ',num2str(kerp),' -c ',num2str(C)] );
    end
    
end

