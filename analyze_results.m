%analyze_results

%--------------------------------------------------------------------------
% Analysis file for the data from manuscript "Causal evidence for frontal 
% cortex organization related to perceptual decision-making"
%
% The file runs all TMS analyses reported in the paper.
%
% Written by: Doby Rahnev
% Last edit: June 2, 2015
%--------------------------------------------------------------------------

clear

%% Subjects
subjects = [3,4,5,6,7,10,12,16,22,23,24,25,30,35,36,37,41];
number_subjects = length(subjects);


%% Define some useful variables
addpath(genpath(fullfile(pwd, 'helperFunctions')));
sequence = scanning_sequence();
sub_num = 0;
computeMetaDprime = 0; %don't compute if you want to save time (in this case previous results are loaded)


%% Go through all subjects
for subject=subjects
    sub_num = sub_num + 1;
    data{sub_num} = get_one_subject_data(subject, sequence{subject});
    
    % Go through all sessions
    for sess=1:4
        
        % Overall performance
        rt(sub_num,sess) = mean(data{sub_num}.rt(data{sub_num}.session==sess));
        acc(sub_num,sess) = mean(data{sub_num}.correct(data{sub_num}.session==sess));
        conf(sub_num,sess) = mean(data{sub_num}.confidence(data{sub_num}.session==sess));
        
        % Attention analyses
        for spat_cue=0:1 %0: invalid, 1: valid
            attention_effect(sub_num,sess,spat_cue+1) = mean(data{sub_num}.rt(data{sub_num}.cue_validity==spat_cue & ...
                data{sub_num}.session==sess & data{sub_num}.speed_accuracy==2));
        end
        
        % Speed/accuracy analyses
        for SAT=1:2 %1: speed instruction, 2: accuracy instruction            
            SAT_effect(sub_num,sess,SAT) = mean(data{sub_num}.rt(data{sub_num}.speed_accuracy==SAT & ...
                data{sub_num}.session==sess & data{sub_num}.cue_validity==1));
        end
        
        % Type 2 AUC
        [nR_S1, nR_S2] = trials2counts(data{sub_num}.stimulus(data{sub_num}.session==sess)-1, ...
            data{sub_num}.response(data{sub_num}.session==sess)-1,...
            data{sub_num}.confidence(data{sub_num}.session==sess), 4);
        type2AUC(sub_num,sess) = type2ag(nR_S1, nR_S2, 1);
        
        % Other metacognitive measures
        if computeMetaDprime
            output_M_MLE = type2_SDT_MLE(data{sub_num}.stimulus(data{sub_num}.session==sess)-1, ...
                data{sub_num}.response(data{sub_num}.session==sess)-1,...
                data{sub_num}.confidence(data{sub_num}.session==sess), 4, [], 1);
            metaDprime(sub_num,sess) = output_M_MLE.meta_da;
        end
        phi(sub_num,sess) = corr(data{sub_num}.correct(data{sub_num}.session==sess)', data{sub_num}.confidence(data{sub_num}.session==sess)');
        conf_forCorrect(sub_num,sess) = mean(data{sub_num}.confidence(data{sub_num}.session==sess & data{sub_num}.correct == 1));
        conf_forError(sub_num,sess) = mean(data{sub_num}.confidence(data{sub_num}.session==sess & data{sub_num}.correct == 0));
        
        
        % Confidence leak
        prev=[]; next=[];
        confidence_regr = data{sub_num}.confidence(data{sub_num}.session==sess);
        for run=1:4
            for block=1:4
                first_trial = (run-1)*120 + (block-1)*30 + 1;
                prev = [prev, confidence_regr(first_trial:first_trial+28)];
                next = [next, confidence_regr(first_trial+1:first_trial+29)];
            end
        end
        conf_leak(sub_num,sess) = abs(r2z(corr(prev',next')));

    end    
end


%% OVERALL PERFORMANCE
for i=1:4
    for j=1:4
        [H_rt(i,j), P_rt(i,j)] = ttest(rt(:,i), rt(:,j));
        [H_acc(i,j), P_acc(i,j)] = ttest(acc(:,i), acc(:,j));
        [H_conf(i,j), P_conf(i,j)] = ttest(conf(:,i), conf(:,j));
    end
end

% Display the p values for all pairwise comparisons
P_rt        %all pairwise RT comparisons
P_acc       %all pairwise accuracy comparisons
P_conf      %all pairwise confidence comparisons


%% Weights for T tests
load fmriDataAndAnalyses/Analyses/fmri_weights


%% ATTENTION ANALYSES: VALID VS. INVALID CUES

% Compute differences between INVALID and VALID cues
diff_attention_effect = attention_effect(:,:,1) - attention_effect(:,:,2);

% Test the validity effects after TMS to each region
for i=1:4
    for j=1:4
        [t_att(i,j), p_att(i,j)] = weighted_t_test(diff_attention_effect(:,i) - diff_attention_effect(:,j), fmri_attention_effect);
    end
end

% Display means, as well as the t and p values for all pairwise comparisons
mean(diff_attention_effect)
t_att
p_att


%% SPEED/ACCURACY ANALYSES

% Compute differences between ACCURACY and SPEED instructions
diff_SAT_effect = SAT_effect(:,:,2) - SAT_effect(:,:,1);

% Test the validity effects after TMS to each region
for i=1:4
    for j=1:4
        [t_sat(i,j), p_sat(i,j)] = weighted_t_test(diff_SAT_effect(:,i) - diff_SAT_effect(:,j), fmri_SAT_effect);
    end
end

% Display means, as well as the t and p values for all pairwise comparisons
mean(diff_SAT_effect)
t_sat
p_sat


%% METACOGNITION ANALYSES

% Type 2 AUC
mean_type2AUC = mean(type2AUC); %aPFC is highest (significant, see below)
for i=1:4
    for j=1:4
        [t_type2AUC(i,j), p_type2AUC(i,j)] = weighted_t_test(type2AUC(:,i) - type2AUC(:,j), fmri_type2AUC);
    end
end

% Meta-d'
if ~computeMetaDprime
    load Data/metaDprime
end
mean_metaDprime = mean(metaDprime);
for i=1:4
    for j=1:4
        [t_metaDprime(i,j), p_metaDprime(i,j)] = weighted_t_test(metaDprime(:,i) - metaDprime(:,j), fmri_metaDprime);
    end
end

% Phi
mean_phi = mean(phi);   %aPFC is highest (significant, see below)
for i=1:4
    for j=1:4
        [t_phi(i,j), p_phi(i,j)] = weighted_t_test(phi(:,i) - phi(:,j), fmri_phi);
    end
end

% Confidence for correct and error trials
conf_diff = conf_forCorrect - conf_forError;
mean_conf_diff = mean(conf_diff);
for i=1:4
    for j=1:4
        [t_conf_diff(i,j), p_conf_diff(i,j)] = weighted_t_test(conf_diff(:,i) - conf_diff(:,j), fmri_conf_diff);
    end
end

% Display means and p values for all pairwise comparisons
mean_type2AUC
mean_metaDprime
mean_phi
mean_conf_diff
p_type2AUC
p_metaDprime
p_phi
p_conf_diff


%% Metacognitive scores for posterior and anterior DLPFC
load Data/coordinates
[r p] = corr(type2AUC(:,3), dlpfc_sites(:,2))
median_yCoord_dlpfc = median(dlpfc_sites(:,2))
mean_yCoord_dlpfc = mean(dlpfc_sites(:,2))
mean_type2AUC_posteriorHalf = mean(type2AUC(dlpfc_sites(:,2)<35,3))
mean_type2AUC_anteriorHalf = mean(type2AUC(dlpfc_sites(:,2)>35,3))


%% Plot means in a bar graph (Figure 2)
data = {1000*diff_attention_effect, 1000*diff_SAT_effect, type2AUC};
t_values = {t_att(:,2), t_sat(:,3), t_type2AUC(:,4)};
reference = [2, 3, 4];
ylabel_string = {'RT_{invalid} - RT_{valid} (ms)', 'RT_{accuracy} - RT_{speed} (ms)', 'Metacognitive score'};
ylimit = {[0 250], [0 400], [.64 .76]};
plot_4bars_withinError_3subplots(data, t_values, reference, ylabel_string, ylimit)


%% Export data for mixed-effects models in R
export_to_xls(diff_attention_effect, diff_SAT_effect, type2AUC, fmri_attention_effect, fmri_SAT_effect, fmri_type2AUC);


%% CONFIDENCE LEAK: compared aPFC with S1
[t_conf_leak, p_conf_leak] = weighted_t_test(conf_leak(:,1) - conf_leak(:,4), fmri_conf_leak); 
t_conf_leak
p_conf_leak