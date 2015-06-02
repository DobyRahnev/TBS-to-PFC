function plot_4bars_withinError(data, t_values, reference, ylabel_string, ylimit)

number_subjects = size(data,1);
for i=1:4
    if i~=reference
        SD(i)=compute_sd_from_t(mean(data(:,reference) - data(:,i)), t_values(i), 17);
    else
        SD(reference) = SD(1);
    end
end

figure
ax = axes;
bar(1, mean(data(:,1)), 'k');
hold
bar(2, mean(data(:,2)), 'r');
bar(3, mean(data(:,3)), 'b');
bar(4, mean(data(:,4)), 'g');

%Plot confidence intervals
shift=.15;
for i=1:size(data,2)
    plot([i-shift,i-shift], [mean(data(:,i))-SD(i)/sqrt(17), ...
        mean(data(:,i))+SD(i)/sqrt(17)], 'k', 'LineWidth',2);
    plot([i-shift-.05,i-shift+.05], [mean(data(:,i))-SD(i)/sqrt(17), ...
        mean(data(:,i))-SD(i)/sqrt(17)], 'k', 'LineWidth',2);
    plot([i-shift-.05,i-shift+.05], [mean(data(:,i))+SD(i)/sqrt(17), ...
        mean(data(:,i))+SD(i)/sqrt(17)], 'k', 'LineWidth',2);
    
    plot([i+shift,i+shift], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
        mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
    plot([i+shift-.05,i+shift+.05], [mean(data(:,i))-std(data(:,i))/sqrt(number_subjects), ...
        mean(data(:,i))-std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
    plot([i+shift-.05,i+shift+.05], [mean(data(:,i))+std(data(:,i))/sqrt(number_subjects), ...
        mean(data(:,i))+std(data(:,i))/sqrt(number_subjects)], 'k', 'LineWidth',2);
end

%title('effect of TMS','FontSize',30)
ylabel(ylabel_string,'FontSize',40);
xlim([.5, 4.5]);
if exist('ylimit')
    ylim(ylimit);
end
set(ax,'XTick',[1:size(data,2)]);
set(gca,'XTickLabel',{'S1','FEF','DLPFC','aPFC'})
xlabel('TMS Site', 'FontSize',40);