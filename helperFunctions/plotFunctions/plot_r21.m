function plot_r21(rtData,diffData)

% rtData: 5 subjects X S1/DLPFC X speed/accuracy
% diffData: 5 subjects X S1/DLPFC X speed/accuracy
number_subjects = size(rtData,1);
figure

%% 1: Mean RTs
subplot(2,2,1)
bar(1, mean(rtData(:,2,2)), 'b', 'BarWidth', 1);
hold
bar(4, mean(rtData(:,2,1)), 'r', 'BarWidth', 1);
bar(2, mean(rtData(:,1,2)), 'b', 'BarWidth', 1);
bar(5, mean(rtData(:,1,1)), 'r', 'BarWidth', 1);
plot([1,1], [mean(rtData(:,2,2))-std(rtData(:,2,2))/sqrt(number_subjects), ...
    mean(rtData(:,2,2))+std(rtData(:,2,2))/sqrt(number_subjects)], 'k', 'LineWidth',1.5);
plot([4,4], [mean(rtData(:,2,1))-std(rtData(:,2,1))/sqrt(number_subjects), ...
    mean(rtData(:,2,1))+std(rtData(:,2,1))/sqrt(number_subjects)], 'k', 'LineWidth',1.5);
plot([2,2], [mean(rtData(:,1,2))-std(rtData(:,1,2))/sqrt(number_subjects), ...
    mean(rtData(:,1,2))+std(rtData(:,1,2))/sqrt(number_subjects)], 'k', 'LineWidth',1.5);
plot([5,5], [mean(rtData(:,1,1))-std(rtData(:,1,1))/sqrt(number_subjects), ...
    mean(rtData(:,1,1))+std(rtData(:,1,1))/sqrt(number_subjects)], 'k', 'LineWidth',1.5);
title('Average RT');
ylabel('RT in sec');
legend('"Accuracy" focus', '"Speed" focus');
%legend('TMS to S1', 'TMS to PFC');
ylim([0 2]);

%% 2: Individual RT differences
subplot(2,2,2)
bar(1,rtData(1,2,2)-rtData(1,1,2), 'b', 'BarWidth', 1);
hold
bar(2, rtData(1,2,1)-rtData(1,1,1), 'r', 'BarWidth', 1);

for i=2:number_subjects
    bar(3*(i-1)+1, rtData(i,2,2)-rtData(i,1,2), 'b', 'BarWidth', 1);
    bar(3*(i-1)+2, rtData(i,2,1)-rtData(i,1,1), 'r', 'BarWidth', 1);
end
title('TMS effect on RT in each subject');
ylabel('RT difference in sec');
legend('"Accuracy" focus', '"Speed" focus');
ylim([-.4 .3]);

%% 3: Diffusion graph with 4 boundaries
subplot(2,2,3)
span = [0 5];
plot(span, repmat(mean(diffData(:,2,2))+.03,1,2), 'b--', 'LineWidth', 2);
hold
plot(span, repmat(mean(diffData(:,2,1)),1,2), 'r--', 'LineWidth', 2);
plot(span, repmat(mean(diffData(:,1,2)),1,2), 'b-', 'LineWidth', 2);
plot(span, repmat(mean(diffData(:,1,1)),1,2), 'r-', 'LineWidth', 2);

title('Average diffusion boundaries');
ylabel('Boundary height');
%legend('"Accuracy" focus', '"Speed" focus');
%legend('TMS to S1', 'TMS to PFC');
xlim(span);
ylim([1 2]);

%% 4: Individual diffusion differences
subplot(2,2,4)
bar(1,diffData(1,2,2)-diffData(1,1,2), 'b', 'BarWidth', 1);
hold
bar(2, diffData(1,2,1)-diffData(1,1,1), 'r', 'BarWidth', 1);

for i=2:number_subjects
    bar(3*(i-1)+1, diffData(i,2,2)-diffData(i,1,2), 'b', 'BarWidth', 1);
    bar(3*(i-1)+2, diffData(i,2,1)-diffData(i,1,1), 'r', 'BarWidth', 1);
end
title('TMS effect on boundary in each subject');
ylabel('Boundary difference');
legend('"Accuracy" focus', '"Speed" focus');
ylim([-.4 .2]);