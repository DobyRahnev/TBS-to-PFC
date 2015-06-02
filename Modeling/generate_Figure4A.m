%generate_Figure4A

clear

% Parameters
drift_rate = [.3 .1];
drift_rate_var = 1;
bound = 100;

% Initialize trial-specific variables
time = 1;
continue_accumulating = 1;
for i=1:2
    for j=1:2
        process{i,j} = 0;
    end
end


% Accumulate evidence until one of the accumulators reaches the bound
while process{1,1}(time) < 100
    
    time = time + 1;
    trial_drift = drift_rate + drift_rate_var * randn(1,2); %evidence on current trial
    
    % Update accumulators
    for i=1:2
        if trial_drift(i) > 0
            process{i,1}(time) = process{i,1}(time-1) + trial_drift(i);
            process{i,2}(time) = process{i,2}(time-1);
        else
            process{i,1}(time) = process{i,1}(time-1);
            process{i,2}(time) = process{i,2}(time-1) - trial_drift(i);
        end
    end
end

figure
plot(1:time, process{1,1}, 'r', 'LineWidth', 3)
hold
plot(1:time, process{1,2}, 'k', 'LineWidth', 3)
plot(1:time, process{2,1}, 'r', 'LineWidth', 1)
plot(1:time, process{2,2}, 'k', 'LineWidth', 1)
plot([0, time], [100, 100], 'b', 'LineWidth', 3)
plot([0, time], [80, 80], 'b--', 'LineWidth', 2)
ylabel('Evidence (a.u.)')
xlabel('Time (a.u.)')
ylim([0, 100])
