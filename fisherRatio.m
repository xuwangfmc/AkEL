function fRatio = fisherRatio( data, targets, tempLabelset, sigma )
    
    numSamples              = zeros(2^length(tempLabelset),1);
	mark                    = zeros(2^length(tempLabelset),1);
    
    kernelMatrices          = cell(2^length(tempLabelset),2^length(tempLabelset));
    tempData                = cell(2^length(tempLabelset),1);
    targets_temp            = targets(:,tempLabelset);
	for i = 0:2^length(tempLabelset)-1
     	tempIndex         	= double( dec2bin(i,length(tempLabelset)) ) - '0';
     	tempIndexMatrix  	= repmat( tempIndex, size(data,1), 1 );
     	flags            	= sum( (targets_temp+1)/2 == tempIndexMatrix , 2 ) == length(tempLabelset);
        if sum(flags~=0)
            tempData{i+1,1}    	= data(flags,:);
            numSamples(i+1,1) 	= size(tempData{i+1,1},1);
            mark(i+1,1)         = 1;
        end
	end
    
    withinScatter                   = 0;
	for i = 1:2^length(tempLabelset)
        if mark(i,1) == 0
            continue;
        else
            kernelMatrices{i,i}     = rbf_kernel(tempData{i,1},tempData{i,1},sigma);
            withinScatter           = withinScatter +  1 - sum(kernelMatrices{i,i}(:))/(numSamples(i,1)^2);
        end
    end
            
    betweenScatter                  = 0;
	for i = 1:2^length(tempLabelset)
        if mark(i,1) == 0
            continue;
        else
            for j = i+1:2^length(tempLabelset)
                if mark(j,1) == 0
                     continue;
                else
                    kernelMatrices{i,j}     = rbf_kernel(tempData{i,1},tempData{j,1},sigma);
                    betweenScatter          = betweenScatter + sum(kernelMatrices{i,i}(:))/(numSamples(i,1)^2) + ...
                        sum(kernelMatrices{j,j}(:))/(numSamples(j,1)^2) - 2*sum(kernelMatrices{i,j}(:))/(numSamples(i,1)*numSamples(j,1));
                end
            end
        end
	end

    fRatio              = betweenScatter / withinScatter;
    
end

