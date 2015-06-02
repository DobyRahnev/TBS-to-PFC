function plot_paired_graphs(data, ylabel_string, ylimit)

number_subjects = size(data,1);

%data = data(:,2:end) - repmat(data(:,1),1,size(data,2)-1);

figure
ax = axes;
bar(1, mean(data(:,1,1)), 'BarWidth', 1);
hold
bar(2, mean(data(:,1,2)), 'BarWidth', 1);

for i=2:size(data,2)
    bar(3*(i-1)+1, mean(data(:,i,1)), 'BarWidth', 1);
    bar(3*(i-1)+2, mean(data(:,i,2)), 'BarWidth', 1);
end

%Plot confidence intervals
for i=1:size(data,2)
    for j=1:2
        plot([3*(i-1)+j,3*(i-1)+j], [mean(data(:,i,j))-std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects), ...
            mean(data(:,i,j))+std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects)], 'k');
        plot([3*(i-1)+j-.05,3*(i-1)+j+.05], [mean(data(:,i,j))-std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects), ...
            mean(data(:,i,j))-std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects)], 'k');
        plot([3*(i-1)+j-.05,3*(i-1)+j+.05], [mean(data(:,i,j))+std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects), ...
            mean(data(:,i,j))+std(data(:,i,1)-data(:,i,2))/sqrt(number_subjects)], 'k');
    end
end

ylabel(ylabel_string);
%xlim([-1, 4.5]);
if exist('ylimit')
    ylim(ylimit);
end
set(ax,'XTick',[1.5:3:1.5+3*size(data,2)]);
set(gca,'XTickLabel',{'S1','FEF','DLPFC','aPFC'})
xlabel('TBS Site');
% %set(ax,'YTick',[0 .5 1]);
% %legend('2 patches', '4 patches');