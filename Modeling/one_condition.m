function [RT, type2AUC] = one_condition(N, drift_rate, drift_rate_var, bound, conf_noise)

% Initialize the variables
choice = zeros(1,N);
conf = zeros(1,N);
RT = zeros(1,N);

% Simulate N trials
for trial=1:N
    
    % Initialize trial-specific variables
    time = 0;
    continue_accumulating = 1;
    process{1} = 0; process{2} = 0;
    
    % Accumulate evidence until one of the accumulators reaches the bound
    while continue_accumulating
        
        time = time + 1;
        trial_drift = drift_rate + drift_rate_var * randn; %evidence on current trial
        
        % Update accumulators
        if trial_drift > 0
            process{1} = process{1} + trial_drift;
            if process{1} >= bound
                continue_accumulating = 0;
                choice(trial) = 1;
            end
        else
            process{2} = process{2} - trial_drift;
            if process{2} >= bound
                continue_accumulating = 0;
                choice(trial) = 0;
            end
        end

        % If bound is reached, determine RT and confidence
        if continue_accumulating == 0
            RT(trial) = time;
            conf(trial) = abs(process{1}-process{2}) + conf_noise * randn; %continuous
        end
        
    end
end

% Transform confidence
criteria = [8 16 24];
conf4 = conf;
conf4(conf<=criteria(1)) = 1;
conf4(conf>criteria(1) & conf<=criteria(2)) = 2;
conf4(conf>criteria(2) & conf<=criteria(3)) = 3;
conf4(conf>criteria(3)) = 4;

% Compute RT and type2AUC
RT = mean(RT);
[nR_S1 nR_S2] = trials2counts([zeros(1,N/2), ones(1,N/2)], [1-choice(1:N/2), choice(N/2+1:N)], conf4, 4);
type2AUC = type2ag(nR_S1, nR_S2, 1);