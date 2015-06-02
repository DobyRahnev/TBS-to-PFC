function [obs_Ag, exp_Ag, ROCpoints] = type2ag(nR_S1, nR_S2, eqvar, doPlot)
% [obs_Ag, exp_Ag, ROCpoints] = type2ag(nR_S1, nR_S2, eqvar, doPlot)
%
% input
% nR_S1, nR_S2 : response counts for S1 and S2 stimuli
% eqvar  : 1 if assuming equal variance SDT model, 0 otherwise (requires
% SDT_MLE_fit)
% doPlot : Plots observed type 2 ROC points vs SDT-expected type 2 ROC
% curve if set to 1. Does not plot if set to 0 or input is not specified.
%
% output = observed Ag, expected Ag, expected f/h, observed f/h
%
% Area under the empirical type 2 ROC curve is computed using Ag.
%
% We can derive an expected type 2 ROC curve with arbitrarily many ROC 
% points from the SDT fit to the empirical data. However, Ag underestimates
% area under the ROC curve when there are only several ROC points
% available. Therefore, there is a danger that comparing observed Ag with
% expected Ag will not be a fair comparison, since we can derive many more
% ROC points for the expected curve than we have available for the observed
% curve. Additionally, when only several ROC points are sampled, type 2
% response bias can also skew the data. (For instance, imagine Ag computed
% from 1 type 2 ROC point with an almost-zero FAR. Ag almost certainly
% underestimates the "true" area under this curve more severely than it
% would if the FAR were closer to 0.5)
%
% To compensate for these issues, expected type 2 Ag is computed with the 
% following procedure:
%
% - Suppose there are N ROC points on the empirical type 2 ROC. Then we
% find the N points on the SDT-expected type 2 ROC that have the same type
% 2 FAR as the empirical data, and compute Ag from these N points.
% - We repeat the above procedure, this time sampling the N ROC points from
% the SDT-expected type 2 ROC curve that best match the type 2 HRs from the
% N empirical type 2 ROC points. Ag is computed from these N points.
% - The above procedure gives us two estimates of the SDT-expected Ag that
% are roughly matched to the empirical type 2 ROC curve in terms of number
% of ROC points and degree of response bias.
% - We average the two SDT-expected Ag values to arrive at a single number
% we can compare to the empirical Ag.
%
% The output struct ROCpoints lists empirical type 2 ROC points, as well as
% the ROC points sampled from the SDT-expected type 2 ROC curve by matching
% the empirical type 2 FARs and HRs. ROCpoints.full_exp gives the
% SDT-expected type 2 ROC curve with 501 ROC points.

if ~exist('eqvar','var') || isempty(eqvar)
    eqvar = 0;
end

if ~exist('doPlot','var') || isempty(doPlot)
    doPlot = 0;
end

fncdf = @normcdf;

nRatings = length(nR_S1) / 2;


%% get observed type 2 FAR and HR

% I_nR and C_nR are rating trial counts for incorrect and correct trials
% element i corresponds to # (in)correct w/ rating i
I_nR = nR_S1(nRatings+1:end) + nR_S2(nRatings:-1:1);
C_nR = nR_S2(nRatings+1:end) + nR_S1(nRatings:-1:1);

for i = 2:nRatings
    obs_FAR2(i-1) = sum( I_nR(i:end) ) / sum(I_nR);
    obs_HR2(i-1)  = sum( C_nR(i:end) ) / sum(C_nR);
end



% % I_nR and C_nR are rating trial counts for incorrect and correct trials
% % element i corresponds to # (in)correct w/ rating i
% I_nR_rS2 = nR_S1(nRatings+1:end);
% I_nR_rS1 = nR_S2(nRatings:-1:1);
% 
% C_nR_rS2 = nR_S2(nRatings+1:end);
% C_nR_rS1 = nR_S1(nRatings:-1:1);
% 
% for i = 2:nRatings
%     obs_FAR2_rS2(i-1) = sum( I_nR_rS2(i:end) ) / sum(I_nR_rS2);
%     obs_HR2_rS2(i-1)  = sum( C_nR_rS2(i:end) ) / sum(C_nR_rS2);
%     
%     obs_FAR2_rS1(i-1) = sum( I_nR_rS1(i:end) ) / sum(I_nR_rS1);
%     obs_HR2_rS1(i-1)  = sum( C_nR_rS1(i:end) ) / sum(C_nR_rS1);    
% end


%% get SDT parameter fits

if eqvar
    h1 = sum(nR_S2(nRatings+1:end)) / sum(nR_S2);
    f1 = sum(nR_S1(nRatings+1:end)) / sum(nR_S1);
    
    d1 = norminv(h1) - norminv(f1);
    c1 = -0.5 * (norminv(h1) + norminv(f1));
    s  = 1;
    
else
    [analysis params] = SDT_MLE_fit(nR_S1, nR_S2);
    
    d1 = params.d1;
    c1 = params.c1;
    s  = params.s;
end


%% get continuous expected type 2 FAR / HR from d'/c/s

S1mu = -d1/2; S2mu = d1/2;
S1sd = 1; S2sd = 1/s;

if eqvar
    t1c = c1;
else
    t1c = c1(nRatings);
end

x1 = t1c-5 : +.01 : t1c;
x2 = t1c+5 : -.01 : t1c;
% x2 = c1 : .01 : c1+5;

expc_FAR2 = ( fncdf(x1,S2mu,S2sd) + (1-fncdf(x2,S1mu,S1sd)) ) ...
            / ( fncdf(t1c,S2mu,S2sd) + (1-fncdf(t1c,S1mu,S1sd)) );

expc_HR2 = ( fncdf(x1,S1mu,S1sd) + (1-fncdf(x2,S2mu,S2sd)) ) ...
           / ( fncdf(t1c,S1mu,S1sd) + (1-fncdf(t1c,S2mu,S2sd)) );


% S1mu = -d1/2; S2mu = d1/2;
% S1sd = 1; S2sd = 1/s;
% 
% x1 = c1-5 : .01 : c1;
% x2 = c1 : .01 : c1+5;
% 
% exp_FAR2_rS1 = fncdf(x1,S2mu,S2sd) / fncdf(c1,S2mu,S2sd);
% exp_HR2_rS1 = fncdf(x1,S1mu,S1sd) / fncdf(c1,S1mu,S1sd);
% 
% exp_FAR2_rS2 = (1-fncdf(x2,S1mu,S1sd)) / (1-fncdf(c1,S1mu,S1sd));
% exp_HR2_rS2 = (1-fncdf(x2,S2mu,S2sd)) / (1-fncdf(c1,S2mu,S2sd));



%% sample from continuous expected type 2 FAR / HR at the discrete F/H points in the observed data

for k = 1:nRatings-1
    % expected type 2 FAR/HR, matched for observed type 2 FAR
    [m ind] = min(abs( expc_FAR2 - obs_FAR2(k) ));
    exp_FAR2_matched_F(k) = expc_FAR2(ind);
    exp_HR2_matched_F(k)  = expc_HR2(ind);
    
    % expected type 2 FAR/HR, matched for observed type 2 HR
    [m ind] = min(abs( expc_HR2 - obs_HR2(k) ));
    exp_FAR2_matched_H(k) = expc_FAR2(ind);
    exp_HR2_matched_H(k)  = expc_HR2(ind);
end

    
%% get Ag for each of these and average
obs_Ag = Ag(obs_FAR2, obs_HR2);

exp_Ag_matched_F = Ag(exp_FAR2_matched_F, exp_HR2_matched_F);
exp_Ag_matched_H = Ag(exp_FAR2_matched_H, exp_HR2_matched_H);

exp_Ag = mean([ exp_Ag_matched_F  exp_Ag_matched_H ]);


%% package ROC point data
ROCpoints.obs_FAR2 = obs_FAR2;
ROCpoints.obs_HR2  = obs_HR2;

ROCpoints.exp_FAR2_matched_F = exp_FAR2_matched_F;
ROCpoints.exp_HR2_matched_F  = exp_HR2_matched_F;

ROCpoints.exp_FAR2_matched_H = exp_FAR2_matched_H;
ROCpoints.exp_HR2_matched_H  = exp_HR2_matched_H;

ROCpoints.full_exp.expc_FAR2 = expc_FAR2;
ROCpoints.full_exp.expc_HR2  = expc_HR2;

%% plot

if doPlot
    
    figure; 
    hold on;
    
    plot(obs_FAR2, obs_HR2, 'ko');
    plot(expc_FAR2, expc_HR2, 'k--');
    plot([0 1],[0 1],'k-');
    
    legend('observed','expected','Location','SouthEast');
    xlabel('type 2 FAR');
    ylabel('type 2 HR');
    
    axis([0 1 0 1]);
    axis square;
    hold off;
    
end

end

function AUC = Ag(f,h)
% AUC = Ag(f,h)

[f ind] = sort(f);
h = h(ind);

AUC = 0;
F = [0 f 1];
H = [0 h 1];
for i=1:length(F)-1
    AUC = AUC + (F(i+1) - F(i)) * (H(i+1) + H(i));
end

AUC = 0.5*AUC;

end