%analyze_ROI_effects

%--------------------------------------------------------------------------
% This file analyzes the fMRI ROI data. The beta values for each task epoch
% are already saved in the file betaValues.mat. Each variable in that file
% indicates the beta value for the respective epoch for a given subject.
% The columns indicate the ROIs: 
% Column 1:FEF
% Column 2:DLPFC
% Column 3:aPFC
%--------------------------------------------------------------------------

clear

load betaValues_3GLMs
%load betaValues_singleGLM
n_sub = size(decision,1);


%% Perform t-tests
for site = 1:3
    mean_activity = mean([instruction(:,site), decision(:,site), confidence(:,site)])
    [H(site,1) P(site,1) ci(site,1,:) stats(site,1)] = ttest(instruction(:,site), decision(:,site));
    effectSize(site,1) = mean(instruction(:,site)-decision(:,site)) / std(instruction(:,site)-decision(:,site));
    [H(site,2) P(site,2) ci(site,2,:) stats(site,2)] = ttest(instruction(:,site), confidence(:,site));
    effectSize(site,2) = mean(instruction(:,site)-confidence(:,site)) / std(instruction(:,site)-confidence(:,site));
    [H(site,3) P(site,3) ci(site,3,:) stats(site,3)] = ttest(decision(:,site), confidence(:,site));
    effectSize(site,3) = mean(decision(:,site)-confidence(:,site)) / std(decision(:,site)-confidence(:,site));
end


%% Perform a repeated measures ANOVA
y = [reshape(instruction,[],1); reshape(decision,[],1); reshape(confidence,[],1)];
region = repmat([ones(n_sub,1); 2*ones(n_sub,1); 3*ones(n_sub,1)], 3, 1);
epoch = [ones(3*n_sub,1); 2*ones(3*n_sub,1); 3*ones(3*n_sub,1)];
subject = repmat([1:n_sub]',9,1);
x = {region,epoch,subject};
anovan(y,x,'model','full','random',3); %look at interaction between X1 and X2


%% Display t statistics
disp('============ Stats FEF ==============')
stats(1,:).tstat
P_FEF_epochComparison = P(1,:)
effectSizes = effectSize(1,:)
disp('============ Stats DLPFC ==============')
stats(2,:).tstat
P_DLPFC_epochComparison = P(2,:)
effectSizes = effectSize(2,:)
disp('============ Stats aPFC ==============')
stats(3,:).tstat
P_aPFC_epochComparison = P(3,:)
effectSizes = effectSize(3,:)


%% Plot figure (Figure 4B in paper)
figure
bar(1, mean(instruction(:,1)), 1, 'r');
hold
bar(2, mean(decision(:,1)), 1, 'b');
bar(3, mean(confidence(:,1)), 1, 'g');
data = {instruction, decision, confidence};
for i=1:3
    bar((i-1)*4+1, mean(instruction(:,i)), 1, 'r');
    bar((i-1)*4+2, mean(decision(:,i)), 1, 'b');
    bar((i-1)*4+3, mean(confidence(:,i)), 1, 'g');
    
    for j=1:3
        plot([(i-1)*4+j,(i-1)*4+j], [mean(data{j}(:,i))-std(data{j}(:,i))/sqrt(n_sub), ...
            mean(data{j}(:,i))+std(data{j}(:,i))/sqrt(n_sub)], 'k', 'LineWidth', 2);
        plot([(i-1)*4+j-.1,(i-1)*4+j+.1], [mean(data{j}(:,i))-std(data{j}(:,i))/sqrt(n_sub), ...
            mean(data{j}(:,i))-std(data{j}(:,i))/sqrt(n_sub)], 'k', 'LineWidth', 2);
        plot([(i-1)*4+j-.1,(i-1)*4+j+.1], [mean(data{j}(:,i))+std(data{j}(:,i))/sqrt(n_sub), ...
            mean(data{j}(:,i))+std(data{j}(:,i))/sqrt(n_sub)], 'k', 'LineWidth', 2);
    end
end
legend('instruction epoch', 'stimulus/perceptual judgment epoch', 'confidence epoch');
ylabel('Contrast estimate', 'FontSize', 30)
xlabel('FEF         DLPFC         aPFC', 'FontSize', 30);