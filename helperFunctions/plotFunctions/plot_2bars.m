function plot_2bars(data, SD, ylabel_string, ylimit)

number_subjects = size(data,1);

figure
ax = axes;
bar(1, mean(data(:,1)), 'k');
hold
bar(2, mean(data(:,2)), 'r');

%Plot confidence intervals
for i=1:2
    plot([i,i], [mean(data(:,i))-SD/sqrt(number_subjects), ...
        mean(data(:,i))+SD/sqrt(number_subjects)], 'k', 'LineWidth',2);
end

ylabel(ylabel_string,'FontSize',30);
xlabel('TMS site', 'FontSize', 30);
if exist('ylimit')
    ylim(ylimit);
end

xlim([.5, 2.5]);
set(ax,'XTick',[1,2]);
set(gca,'XTickLabel',{'S1','FEF'})