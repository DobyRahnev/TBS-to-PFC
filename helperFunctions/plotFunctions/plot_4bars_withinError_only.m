function plot_4bars_withinError_only(data, t_values, reference, ylabel_string, ylimit)

figure

for effect=1:3
    number_subjects = size(data{effect},1);
    for i=1:4
        if i~=reference(effect)
            SD(i)=compute_sd_from_t(mean(data{effect}(:,reference(effect)) - data{effect}(:,i)), t_values{effect}(i), 17);
        else
            SD(reference(effect)) = SD(1);
        end
    end
    
    subplot(1,3,effect)
    %ax = axes;
    bar(1, mean(data{effect}(:,1)), 'k');
    hold
    bar(2, mean(data{effect}(:,2)), 'r');
    bar(3, mean(data{effect}(:,3)), 'b');
    bar(4, mean(data{effect}(:,4)), 'g');
    
    %Plot confidence intervals
    shift=0;
    for i=1:size(data{effect},2)
        plot([i-shift,i-shift], [mean(data{effect}(:,i))-SD(i)/sqrt(17), ...
            mean(data{effect}(:,i))+SD(i)/sqrt(17)], 'k', 'LineWidth',2);
        plot([i-shift-.05,i-shift+.05], [mean(data{effect}(:,i))-SD(i)/sqrt(17), ...
            mean(data{effect}(:,i))-SD(i)/sqrt(17)], 'k', 'LineWidth',2);
        plot([i-shift-.05,i-shift+.05], [mean(data{effect}(:,i))+SD(i)/sqrt(17), ...
            mean(data{effect}(:,i))+SD(i)/sqrt(17)], 'k', 'LineWidth',2);
    end
    
    %title('effect of TMS','FontSize',30)
    ylabel(ylabel_string{effect},'FontSize',30);
    xlim([.5, 4.5]);
    if exist('ylimit')
        ylim(ylimit{effect});
    end
    %set(ax,'XTick',[1:size(data{effect},2)]);
    %set(gca,'XTickLabel',{'S1','FEF','DLPFC','aPFC'})
    xlabel('TMS Site', 'FontSize',30);
end
