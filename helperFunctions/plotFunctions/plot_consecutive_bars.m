function plot_consecutive_bars(data, ylabel_string, ylimit)

number_subjects = size(data,1);

figure
ax = axes;
bar(1, mean(data(:,1)), 'k');
hold
bar(2, mean(data(:,2)), 'r');
bar(3, mean(data(:,3)), 'b');
bar(4, mean(data(:,4)), 'g');

%Plot confidence intervals
for i=1:size(data,2)
    plot([i,i], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
        mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
%     plot([i-.05,i+.05], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
%         mean(data(:,i))-std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
%     plot([i-.05,i+.05], [mean(data(:,i))+std(data(:,i))/sqrt(number_subjects), ...
%         mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
end

%title('effect of TMS','FontSize',30)
ylabel(ylabel_string,'FontSize',30);
xlim([.5, 4.5]);
if exist('ylimit')
    ylim(ylimit);
end
set(ax,'XTick',[1:size(data,2)]);
set(gca,'XTickLabel',{'S1','FEF','DLPFC','aPFC'})
xlabel('TMS Site', 'FontSize',30);