function [jEntropy,jointProbsNonZeroNum] = jointEntropy( targets, tempLabelset )
    
	jointProbs                  = zeros(1,2^length(tempLabelset));
    targets_temp                = targets(:,tempLabelset);
    numSamples                  = size(targets,1);
    
	for i = 0:2^length(tempLabelset)-1
        tempIndex               = double( dec2bin(i,length(tempLabelset)) ) - '0';
        tempIndexMatrix         = repmat( tempIndex, numSamples, 1 );
        jointProbs(1,i+1)   	= sum((sum( (targets_temp+1)/2 == tempIndexMatrix , 2) == length(tempLabelset))) / numSamples;
	end
	jointProbsNonZero           = jointProbs(1, jointProbs(1,:)~=0);
    jointProbsNonZeroNum        = length(jointProbsNonZero);
	jEntropy                    = -sum(jointProbsNonZero .* log2(jointProbsNonZero)) / log2(length(jointProbsNonZero));
    
end
