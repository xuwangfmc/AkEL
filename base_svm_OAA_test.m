function [finallabel,decisionvalue] = base_svm_OAA_test( svmStruct,tedata,classLabel )
% trdata                Training data
% tedata                Testing data
% type                  SVM type (C-SVM)
% ker                   Kernel type (rbf gaussian kernel)
% kerp                  Kernel parameter (Gamma, not Sigma)
% C                     Penalty term

    [row,~]             = size(tedata);
    numClass            = length(classLabel);

    decisionlabel       = zeros(row,numClass);
    decisionvalue       = zeros(row,numClass);
    
    if numClass == 1
        decisionlabel 	= ones(row,1)*classLabel;    
        decisionvalue  	= decisionlabel;
        finallabel      = decisionlabel';        
    else
        for i = 1:numClass
            [decisionlabel(:,i),~,decisionvalue(:,i)]   = svmpredict( zeros(row,1),tedata,svmStruct{1,i} );
            if (sign(decisionvalue(1,i)) ~= sign(decisionlabel(1,i)))
                decisionvalue(:,i)                      = -decisionvalue(:,i);
            end
        end       
        [~,index]       = max(decisionvalue,[],2);
        finallabel      = classLabel(index);        
    end
    
% 	accuracy        = sum( truelabel==finallabel ) / row *100;

end

