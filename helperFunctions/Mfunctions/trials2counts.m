function [nR_S1 nR_S2] = trials2counts(stimID,response,rating,nRatings,cellpad)

nR_S1 = [];
nR_S2 = [];

% S1 responses
for r = nRatings : -1 : 1
    nR_S1(end+1) = sum(stimID==0 & response==0 & rating==r);
    nR_S2(end+1) = sum(stimID==1 & response==0 & rating==r);
end

% S2 responses
for r = 1 : nRatings
    nR_S1(end+1) = sum(stimID==0 & response==1 & rating==r);
    nR_S2(end+1) = sum(stimID==1 & response==1 & rating==r);
end

% cell pad
if ~exist('cellpad','var') || isempty(cellpad), cellpad = 1; end

if cellpad
    
    padFactor = 1/(2*nRatings);
    
%     if any(nR_S1(1:nRatings) == 0) % FAR = 1
%         nR_S1(nRatings+1:end) = nR_S1(nRatings+1:end) + padFactor;
%     end
% 
%     if any(nR_S1(nRatings+1:end) == 0) % FAR = 0
%         nR_S1(nRatings+1:end) = nR_S1(nRatings+1:end) - padFactor;
%     end
    
    % need to change N("S"&S) without changing N(S)
    
    
    if any(nR_S1==0) || any(nR_S2==0)
        nR_S1 = nR_S1 + padFactor;
        nR_S2 = nR_S2 + padFactor;
    end

    
    
%     if any(nR_S1==0)
%         nR_S1 = nR_S1 + padFactor;
%     end
% 
%     if any(nR_S2==0)
%         nR_S2 = nR_S2 + padFactor;
%     end   
    
end