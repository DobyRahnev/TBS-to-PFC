function out = type2_SDT_SSE(input1, input2, input3, input4, input5, input6)

% out = type2_SDT(input)
%
% Given data from an experiment where an observer discriminates between two
% stimulus alternatives on every trial and provides confidence ratings,
% provides a type 2 SDT analysis of the data.
%
% The function does a standard type 1 SDT analysis on the raw behavioral
% data and then does a type 2 SDT analysis using the function fit_meta_d 
% with d_min = -5, d_grain = .01, d_max = 5
% 
% INPUTS
%
% format of the input may be either:
%
% 1) stimID, response, rating, nRatings, (cellpadding), (equalVariance)
%    where each of the first 3 inputs is a 1xN vector describing the outcome 
%    of N trials. Contents of input should be as follows.
%
%    stimID   : 0=S1 stimulus presented, 1=S2 stimulus presented 
%    response : 0=subject responded S1, 1=subject responded S2
%    rating   : values ranges from 1 to m where 1 is the lowest rating
%               and m is the highest.
% 
%               All trials where any of these prescribed ranges of values
%               are violated are omitted from analysis.
%
%    nRatings : the number of ratings available to the subject (e.g. for a 
%               confidence scale of 1-4, nRatings=4).
%    cellpadding : if any data cells (e.g. high confidence "S2" responses)
%               are empty, then the value of cellpadding will be added
%               to every data cell. If not specified, default = 1/(2*nRatings)
%    equalVariance : if 1, force analysis to use the equal variance SDT
%               model. If 0, use an estimate of s = sd(S1) / sd(S2) where 
%               s is the slope of the least-squares linear fit to zROC data. 
%               If not specified, default = 0. 
%    
% 2) S1_nR, S2_nR, (cellpadding), (equalVariance)
%    where these are vectors containing the total number of responses in
%    each response category, conditional on presentation of S1 and S2.
%    size of each array is 2*nRatings, where each element corresponds to a
%    count of responses in each response category. Response categories are
%    ordered as follows:
%    highest conf "S1" ... lowest conf "S1", lowest conf "S2", ... highest conf "S2"
%
%    e.g. if S1_nR = [100 50 20 10 5 1], then when stimulus S1 was
%    presented, the subject had the following response counts:
%    responded S1, rating=3 : 100 times
%    responded S1, rating=2 : 50 times
%    responded S1, rating=1 : 20 times
%    responded S2, rating=1 : 10 times
%    responded S2, rating=2 : 5 times
%    responded S2, rating=3 : 1 time
%
%    cellpadding and equalVariance are defined as above.
%
%
% 
%
% OUTPUTS
%
% out.d_a       : d_a for input data. If s=1, d_a = d'
% out.meta_d_a  : meta_d_a for input data
% out.M_ratio   : meta_d_a / d_a; measure of metacognitive efficiency
% out.M_diff    : meta_d_a - d_a; measure of metacognitive efficiency
% out.s         : ratio of evidence distribution standard deviations assumed for the analysis. 
% out.type2_fit : output of fit_meta_d_SSE for the type 2 SDT fit.

% 9/7/10 - bm - wrote it

%% parse inputs

if nargin >= 4 && length(input3) == length(input2) && length(input2)==length(input1)
    % input format = 
    % stimID, response, rating, nRatings, cellpadding, equalVariance
    stimID   = input1;
    response = input2;
    rating   = input3;
    nRatings = input4;
    
    if ~exist('input5','var') || isempty(input5)
        cellpadding = 1 / (2*nRatings);
    else
        cellpadding = input5;
    end
    
    if ~exist('input6','var') || isempty(input6)
        equalVariance = 0;
    else
        equalVariance = input6;
    end    
    
    % filter bad trials
    f = (stimID==0|stimID==1) & (response==0|response==1) & (rating>=1&rating<=nRatings);
    stimID   = stimID(f);
    response = response(f);
    rating   = rating(f);
    
    % convert to trial count format...    
    S1_nR = [];
    S2_nR = [];
    
    % get tallies of "S1" rating responses for S1 and S2 stim
    for i = 1:nRatings
        S1_nR(i) = sum(stimID==0 & response==0 & rating==nRatings+1-i);
        S2_nR(i) = sum(stimID==1 & response==0 & rating==nRatings+1-i);
    end
    
    % get tallies of "S2" rating responses for S1 and S2 stim
    for i = 1:nRatings
        S1_nR(i+nRatings) = sum(stimID==0 & response==1 & rating==i);
        S2_nR(i+nRatings) = sum(stimID==1 & response==1 & rating==i);
    end
    

elseif length(input1) == length(input2) && mod(length(input1),2) == 0
    % input format = 
    % S1_nR, S2_nR, cellpadding, equalVariance
    S1_nR = input1;
    S2_nR = input2;
    
    if ~exist('input3','var') || isempty(input3)
        cellpadding = 1 / (2*nRatings);
    else
        cellpadding = input3;
    end
    
    if ~exist('input4','var') || isempty(input4)
        equalVariance = 1;
    else
        equalVariance = input4;
    end    
    
    nRatings = length(S1_nR) / 2;
    
else
    % bad input
    fprintf('\n\n\nBad input! See help type2_SDT.\n\n');
    fit = [];
    return;
    
end


if any(S1_nR==0) || any(S2_nR==0)
    S1_nR = S1_nR + cellpadding;
    S2_nR = S2_nR + cellpadding;
end


%% standard SDT analysis

HR1  = sum(S2_nR(nRatings+1:end)) / sum(S2_nR);
FAR1 = sum(S1_nR(nRatings+1:end)) / sum(S1_nR);

for i=2:2*nRatings
    ratingHRs(i-1)  = sum(S2_nR(i:end)) / sum(S2_nR);
    ratingFARs(i-1) = sum(S1_nR(i:end)) / sum(S1_nR);
end

if equalVariance
    s = 1;
else
    p = polyfit(norminv(ratingFARs), norminv(ratingHRs), 1);
    s = p(1);    
end

% d' and c in terms of S1 distribution standard deviation units
d_1 = (1/s)*norminv(HR1) - norminv(FAR1);
c_1 = (-1/(1+s)) * (norminv(HR1)+norminv(FAR1));
cprime = c_1 / d_1;


%% type 2 SDT analysis

% get type 2 HR and FAR for S1 responses
for i = 1 : nRatings-1
    HR2_rS1(i)  = sum(S1_nR(1:i)) / sum(S1_nR(1:nRatings));
    FAR2_rS1(i) = sum(S2_nR(1:i)) / sum(S2_nR(1:nRatings));
end

% get type 2 HR and FAR for S2 responses
for i = nRatings+2 : 2*nRatings
    HR2_rS2(i - (nRatings+2) + 1)  = sum(S2_nR(i:end)) / sum(S2_nR(nRatings+1:end));
    FAR2_rS2(i - (nRatings+2) + 1) = sum(S1_nR(i:end)) / sum(S1_nR(nRatings+1:end));
end

d_min = -5;
d_grain = .01;
d_max = 5;

fit = fit_meta_d_SSE(HR2_rS1, FAR2_rS1, HR2_rS2, FAR2_rS2, cprime, s, d_min, d_max, d_grain);

%% package output
out.da        = d_1 * s * sqrt(2/(1+s^2));
out.meta_da   = fit.meta_d1 * s * sqrt(2/(1+s^2));
out.M_ratio   = out.meta_da / out.da;
out.M_diff    = out.meta_da - out.da;
out.s         = s;
out.type2_fit = fit;