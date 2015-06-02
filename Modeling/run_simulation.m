%run_simulation

%=============================
% Simulation of TMS results using dynamic decision model. The simulation
% uses the same parameters as Kepecs et al. (2008) Science, and De Martino
% et al. (2013) Nat Neuro. It simulates a default race model for
% attended/unattended X speed/accuracy, and examines how changing 3
% parameters - relative drift rate, relative boundary, and confidence noise
% - affects the RT and metacognition scores reported in the paper.
%=============================

clear

%% Default parameters (for S1)
N=100000;
drift_rate = [.02 .1]; %invalid and valid cuing
drift_rate_var = 1;
bound = [89 100]; %speed and accuracy instructions
conf_noise = 8;


%% Parameters capturing the TMS effects
drift_rate_FEF = [.042 .072];
bound_DLPFC = [90 99];
conf_noise_aPFC = 4;


%% Perform simulations
for validity=1:2
    for sat=1:2
        for site=1:4
            %[validity sat site]
            switch site
                case 1
                    [RT(validity,sat,site), auc(validity,sat,site)] = ...
                        one_condition(N, drift_rate(validity), drift_rate_var, bound(sat), conf_noise);
                case 2
                    [RT(validity,sat,site), auc(validity,sat,site)] = ...
                        one_condition(N, drift_rate_FEF(validity), drift_rate_var, bound(sat), conf_noise);
                case 3
                    [RT(validity,sat,site), auc(validity,sat,site)] = ...
                        one_condition(N, drift_rate(validity), drift_rate_var, bound_DLPFC(sat), conf_noise);
                case 4
                    [RT(validity,sat,site), auc(validity,sat,site)] = ...
                        one_condition(N, drift_rate(validity), drift_rate_var, bound(sat), conf_noise_aPFC);
            end
        end
    end
end


%% Display the means
attention_effect = squeeze(RT(1,2,:)-RT(2,2,:))'
SAT_effect = squeeze(RT(2,2,:)-RT(2,1,:))'
type2AUC = reshape(mean(mean(auc,2),1),1,4)


%% Plot figure
figure
data = {attention_effect, SAT_effect, type2AUC};
ylabel_string = {'RT_{invalid} - RT_{valid} (a.u.)', 'RT_{accuracy} - RT_{speed} (a.u.)', 'Metacognitive score'};
ylimit = {[0 20], [0 35], [.64 .76]};
for effect=1:3    
    subplot(1,3,effect)
    bar(1, mean(data{effect}(1)), 'k');
    hold
    bar(2, mean(data{effect}(2)), 'r');
    bar(3, mean(data{effect}(3)), 'b');
    bar(4, mean(data{effect}(4)), 'g');
    
    %title('effect of TMS','FontSize',30)
    ylabel(ylabel_string{effect},'FontSize',30);
    xlim([.5, 4.5]);
    ylim(ylimit{effect});
    xlabel('Parameter changes', 'FontSize',30);
end