ml_data  = sourcesBBC_data;
targets  = sourcesBBC_targets;

type                = 0;
% kerp                = [2^-23 2^-21 2^-19 2^-17 2^-15 2^-13 2^-11 2^-9 2^-7 2^-5 2^-3 2^-1 2 2^3 2^5];
% C                   = [2^-2 2^-1 2^0 2^1 2^2 2^3 2^4 2^5 2^6 2^7];
% beta                = [0.1 0.3 0.5 0.7 0.9];
ker                 = 2;
kerp                = 2^-7;
C                   = 1;
beta                = 0.7;
labelNum            = 3;
repeat              = 5;
ensembleNum         = 3;
pruningPara         = 5;
CVfold              = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ml_data                 = mapminmax(ml_data',0,1)';
[numSamples,numClasses] = size(targets);
classifierNum        	= numClasses;
exampleMetrics1         = cell(repeat,CVfold);
labelMetrics1           = cell(repeat,CVfold);
exampleMetrics2         = cell(repeat,CVfold);
labelMetrics2          	= cell(repeat,CVfold);


for RE = 1:repeat   
        fprintf('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ \n');
        fprintf('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  K-fold Cross Validation: %d th run for the dataset \n',RE);
     	Indices                     = crossvalind('Kfold', numSamples, CVfold); 
      	for CV = 1:CVfold
            fprintf('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ \n');
            fprintf('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  K-fold Cross Validation: %d th fold \n',CV);
         	train_data              = ml_data(Indices~=CV,:);
            train_targets           = targets(Indices~=CV,:);
           	test_data               = ml_data(Indices==CV,:);
          	test_targets            = targets(Indices==CV,:);
            % disjoint mode
          	[outputStruct,KLabelsetsSelected,classLabel]    = ml_KLabelset_active_disjoint_Train( train_data,train_targets,type,ker,kerp,C,labelNum,beta );
            [exampleMetrics1{RE,CV},labelMetrics1{RE,CV}] 	= ml_KLabelset_Test( test_data,test_targets,outputStruct,KLabelsetsSelected,classLabel,0.5 );   
            % overlapping mode
            [outputStruct,KLabelsetsSelected,classLabel,threshold,coverage]     = ml_KLabelset_active_overlap_Train( train_data,train_targets,type,ker,kerp,C,labelNum,classifierNum,beta );
            [exampleMetrics2{RE,CV},labelMetrics2{RE,CV}]                    	= ml_KLabelset_Test( test_data,test_targets,outputStruct,KLabelsetsSelected,classLabel,threshold );
        end
end
