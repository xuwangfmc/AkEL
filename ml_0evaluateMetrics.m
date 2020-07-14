function [exampleMetrics,labelMetrics] = ml_0evaluateMetrics( testLabels,test_targets,numClasses,numSamples )
%EVALUATEMETRICS Summary of this function goes here
%   Detailed explanation goes here

    subsetAccuracy  = sum(sum(testLabels == test_targets, 2) == numClasses) / numSamples;
    hammingLoss     = mean(1 - sum(testLabels == test_targets, 2) ./ numClasses);
    examAccuracy    = mean(sum(testLabels == 1 & test_targets == 1, 2) ./ (sum(testLabels == 1 | test_targets == 1, 2) + eps));
    examPrecision   = mean(sum(testLabels == 1 & test_targets == 1, 2) ./ (sum(testLabels == 1, 2) + eps));
    examRecall      = mean(sum(testLabels == 1 & test_targets == 1, 2) ./ (sum(test_targets == 1, 2) + eps));
    examF           = (2 * examPrecision * examRecall) / (examPrecision + examRecall + eps);
    
    exampleMetrics    	= [subsetAccuracy hammingLoss examAccuracy examPrecision examRecall examF];
    
    TruePos         = sum(testLabels == 1 & test_targets == 1, 1);
    FalsePos     	= sum(testLabels == 1 & test_targets ~= 1, 1);
    TrueNeg         = sum(testLabels ~= 1 & test_targets ~= 1, 1);
    FalseNeg       	= sum(testLabels ~= 1 & test_targets == 1, 1);  
    microAccuracy   = (sum(TruePos) + sum(TrueNeg)) / (numSamples * numClasses);
    macroAccuracy   = mean((TruePos + TrueNeg) / (numSamples));
    microPrecision  = sum(TruePos) ./ (sum(TruePos) + sum(FalseNeg) + eps);
    macroPrecision  = mean(TruePos ./ (TruePos + FalseNeg + eps));
    microRecall     = sum(TruePos) ./ (sum(TruePos) + sum(FalsePos) + eps);   
    macroRecall     = mean(TruePos ./ (TruePos + FalsePos + eps));
    microF          = mean( (2 * TruePos) ./ (2 * TruePos + FalsePos + FalseNeg + eps) );
    macroF          = (2 * sum(TruePos)) ./ (2 * sum(TruePos) + sum(FalsePos) + sum(FalseNeg) + eps);
    
    labelMetrics        = [microAccuracy macroAccuracy microPrecision macroPrecision microRecall macroRecall microF macroF];

end

