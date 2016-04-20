%analyze_results_fmri

clear

%TBS subjects
subjects = [3,4,5,6,7,10,12,16,22,23,24,25,30,35,36,37,41];
number_subjects = length(subjects);

%Parameters
sub_num = 0;
computeMetaDprime = 0; %don't compute if you want to save time (in this case previous results are loaded)

for subject=subjects
    sub_num = sub_num + 1;
    data{sub_num} = get_one_subject_data(subject);
    
    % Overall performance
    rt(sub_num) = mean(data{sub_num}.rt);
    rt2(sub_num) = mean(data{sub_num}.rt2);
    acc(sub_num) = mean(data{sub_num}.correct);
    conf(sub_num) = mean(data{sub_num}.confidence);    
    
    % Attention analyses
    for spat_cue=0:1
        attention_effect(sub_num,spat_cue+1) = mean(data{sub_num}.rt(data{sub_num}.cue_validity==spat_cue & ...
            data{sub_num}.speed_accuracy==2));
    end
    
    % Speed/accuracy analyses
    for SAT=1:2 %1: speed instruction, 2: accuracy instruction
        SAT_effect(sub_num,SAT) = mean(data{sub_num}.rt(data{sub_num}.speed_accuracy==SAT & ...
            data{sub_num}.cue_validity==1));
    end
    
    % Type 2 AUC
    [nR_S1 nR_S2] = trials2counts(data{sub_num}.stimulus-1, ...
        data{sub_num}.response-1,...
        data{sub_num}.confidence, 4);
    type2AUC(sub_num) = type2ag(nR_S1, nR_S2, 1);
    
    % Other metacognitive measures
    if computeMetaDprime
        output_M_MLE = type2_SDT_MLE(data{sub_num}.stimulus-1, ...
            data{sub_num}.response-1,...
            data{sub_num}.confidence, 4, [], 0);
        metaDprime(sub_num) = output_M_MLE.meta_da;
    else
        load metaDprime_fmri
    end
    phi(sub_num) = corr(data{sub_num}.correct', data{sub_num}.confidence');
    conf_forCorrect(sub_num) = mean(data{sub_num}.confidence(data{sub_num}.correct == 1));
    conf_forError(sub_num) = mean(data{sub_num}.confidence(data{sub_num}.correct == 0));    
    
    % Confidence leak
    confidence = data{sub_num}.confidence;
    prev=[]; next=[];
    for run=1:4
        for block=1:4
            first_trial = (run-1)*120 + (block-1)*30 + 1;
            prev = [prev, confidence(first_trial:first_trial+28)];
            next = [next, confidence(first_trial+1:first_trial+29)];
        end
    end
    conf_leak(sub_num) = abs(r2z(corr(prev',next')));
end


%% OVERALL PERFORMANCE
mean_conf = mean(conf)
mean_acc = mean(acc)
mean_rt = mean(rt)


%% ATTENTION ANALYSES: VALID VS. INVALID CUES
mean_attention_effect = mean(attention_effect)
[H P ci stats] = ttest(attention_effect(:,1), attention_effect(:,2))


%% SPEED/ACCURACY
mean_SAT_effect = mean(SAT_effect)
[H P ci stats] = ttest(SAT_effect(:,2), SAT_effect(:,1))


%% METACOGNITION
mean_type2AUC = mean(type2AUC)
mean_metaDprime = mean(metaDprime)
mean_phi = mean(phi)
conf_diff = conf_forCorrect' - conf_forError';
mean_conf_diff = mean(conf_diff)


%% Save weights
fmri_attention_effect = attention_effect(:,1) - attention_effect(:,2); %has one negative value
fmri_attention_effect(fmri_attention_effect<0)=0; %make negative value 0
fmri_SAT_effect = SAT_effect(:,2) - SAT_effect(:,1);
fmri_type2AUC = type2AUC';
fmri_phi = phi';
fmri_metaDprime = metaDprime';
fmri_conf_diff = conf_diff;
fmri_conf_leak = conf_leak';
save fmri_weights fmri_attention_effect fmri_SAT_effect fmri_type2AUC fmri_phi fmri_metaDprime fmri_conf_diff fmri_conf_leak