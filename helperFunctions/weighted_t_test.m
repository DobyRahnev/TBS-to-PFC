function [t_value, p_value, df, weightedSD] = weighted_t_test(x, w)

%-------------------------------------------------------------------------
% The functions computes weighted t test. For a similar function in R, see
% http://www.r-bloggers.com/weighted-t-test-in-r/
%-------------------------------------------------------------------------

df = length(x) - 1;
weightedMean = sum(x.*w)/sum(w);
weightedVar = ( sum(w.*x.*x) * sum(w) - (sum(w.*x))^2 ) / ...
    ( (sum(w))^2 - sum(w.*w) ); %apply correction similar to N-1 in t-tests (see https://en.wikipedia.org/wiki/Weighted_arithmetic_mean#Weighted_sample_variance)
weightedSE = sqrt(weightedVar / length(x));

t_value = weightedMean / weightedSE;
p_value = 2*tcdf(-abs(t_value), df);
weightedSD = sqrt(weightedVar);

