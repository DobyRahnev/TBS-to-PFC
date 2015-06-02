function out = type2_SDT_MLE(input1, input2, input3, input4, input5, input6)

% out = type2_SDT(input)
%
% Given data from an experiment where an observer discriminates between two
% stimulus alternatives on every trial and provides confidence ratings,
% provides a type 2 SDT analysis of the data.
%
% The function estimates the parameters of the unequal variance SDT model,
% and uses those estimates to find a maximum likelihood estimate of
% meta-da.
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
%               s is the slope of the zROC data (estimated using MLE). 
%               If not specified, default = 0. 
%    
% 2) nR_S1, nR_S2, (cellpadding), (equalVariance)
%    where these are vectors containing the total number of responses in
%    each response category, conditional on presentation of S1 and S2.
%    size of each array is 2*nRatings, where each element corresponds to a
%    count of responses in each response category. Response categories are
%    ordered as follows:
%    highest conf "S1" ... lowest conf "S1", lowest conf "S2", ... highest conf "S2"
%
%    e.g. if nR_S1 = [100 50 20 10 5 1], then when stimulus S1 was
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
% out.c_a       : criterion c_a for input data. If s=1, c_a = c.
% out.cprime    : relative criterion used for type 2 estimates. c' = c_a / d_a
% out.s         : ratio of evidence distribution standard deviations assumed for the analysis. 
% out.type2_fit : output of fit_meta_d_MLE for the type 2 SDT fit.

% 9/24/10 - bm - fixed program-crashing bug for (nR_S1, nR_S2) input
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
    nR_S1 = [];
    nR_S2 = [];
    
    % get tallies of "S1" rating responses for S1 and S2 stim
    for i = 1:nRatings
        nR_S1(i) = sum(stimID==0 & response==0 & rating==nRatings+1-i);
        nR_S2(i) = sum(stimID==1 & response==0 & rating==nRatings+1-i);
    end
    
    % get tallies of "S2" rating responses for S1 and S2 stim
    for i = 1:nRatings
        nR_S1(i+nRatings) = sum(stimID==0 & response==1 & rating==i);
        nR_S2(i+nRatings) = sum(stimID==1 & response==1 & rating==i);
    end
    

elseif length(input1) == length(input2) && mod(length(input1),2) == 0
    % input format = 
    % nR_S1, nR_S2, cellpadding, equalVariance
    nR_S1 = input1;
    nR_S2 = input2;
    
    nRatings = length(nR_S1) / 2;
    
    if ~exist('input3','var') || isempty(input3)
        cellpadding = 1 / (2*nRatings);
    else
        cellpadding = input3;
    end
    
    if ~exist('input4','var') || isempty(input4)
        equalVariance = 0;
    else
        equalVariance = input4;
    end    
    

    
else
    % bad input
    fprintf('\n\n\nBad input! See help type2_SDT.\n\n');
    fit = [];
    return;
    
end


if any(nR_S1==0) || any(nR_S2==0)
    nR_S1 = nR_S1 + cellpadding;
    nR_S2 = nR_S2 + cellpadding;
end


%% standard SDT analysis

if equalVariance
    s = 1;
else
    [analysis params] = SDT_MLE_fit(nR_S1,nR_S2);
    s = params.s;
end


%% type 2 SDT analysis

fit = fit_meta_d_MLE(nR_S1, nR_S2, s);

%% package output
out.da        = fit.da;
out.meta_da   = fit.meta_da;
out.M_ratio   = fit.M_ratio;
out.M_diff    = fit.M_diff;
out.s         = fit.s;
out.type2_fit = fit;