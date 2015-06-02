function plot_3_bars(data_original, basic_weights, additional_weight, ylabel_string)

%Compute new means and SDs using the weights
for i=1:3
    data(:,i) = (data_original(:,i+1) - data_original(:,1)) .* basic_weights(:,i) / ...
        mean(basic_weights(:,i)) .* additional_weight / mean(additional_weight);
    [t p(i) df stdev(i)] = weighted_t_test(data_original(:,1) - data_original(:,i+1), ...
        basic_weights(:,i) .* additional_weight);
end
p
  

number_subjects = size(data_original,1);
figure
ax = axes;
bar(1, mean(data(:,1)), 'r');
hold
bar(2, mean(data(:,2)), 'b');
bar(3, mean(data(:,3)), 'g');

%Plot confidence intervals
for i=1:size(data,2)
    plot([i,i], [mean(data(:,i))-stdev(i)/sqrt(number_subjects), ...
        mean(data(:,i))+stdev(i)/sqrt(number_subjects)], 'k', 'LineWidth',2);
%     plot([i-.05,i+.05], [mean(data(:,i))-stdev(i)/sqrt(number_subjects), ...
%         mean(data(:,i))-stdev(i)/sqrt(number_subjects)], 'k', 'LineWidth',2);
%     plot([i-.05,i+.05], [mean(data(:,i))+stdev(i)/sqrt(number_subjects), ...
%         mean(data(:,i))+stdev(i)/sqrt(number_subjects)], 'k', 'LineWidth',2);
end

%title('effect of TMS','FontSize',30)
ylabel(ylabel_string,'FontSize',30);
xlim([.5, 3.5]);
set(ax,'XTick',1:3);
set(gca,'XTickLabel',{'FEF','DLPFC','aPFC'})
xlabel('TBS Site','FontSize',30);