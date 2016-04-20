function create_supp_table1(rt, accuracy, conf, fileName)

%File name
output_path = pwd;
file = fullfile(output_path,[fileName '.xls']);

%Delete previous version of the file and open new file
if exist(file)
    delete(file)
end
fid = fopen(file,'a');

%% RT
% Print first line
fprintf(fid,'RT\nCondition\tS1\tFEF\tDLPFC\taPFC\n');

%Print the data
condNames = {'invalid, fast','invalid, accurate','valid, fast','valid, accurate'};
for condition=1:length(condNames)
    fprintf(fid,'%s\t', condNames{condition});
    for tmsSite=1:4
        fprintf(fid,'%3.0f (%3.0f)\t', mean(rt(:,tmsSite, 1+(condition>2), 2-rem(condition,2))), std(rt(:,tmsSite, 2-rem(condition,2), 2-rem(condition,2))));
    end
    fprintf(fid,'\n');
end


%% Accuracy
% Print first line
fprintf(fid,'\n\nAccuracy\nCondition\tS1\tFEF\tDLPFC\taPFC\n');

%Print the data
condNames = {'invalid, fast','invalid, accurate','valid, fast','valid, accurate'};
for condition=1:length(condNames)
    fprintf(fid,'%s\t', condNames{condition});
    for tmsSite=1:4
        fprintf(fid,'%1.2f (%1.2f)\t', mean(accuracy(:,tmsSite, 1+(condition>2), 2-rem(condition,2))), std(accuracy(:,tmsSite, 2-rem(condition,2), 2-rem(condition,2))));
    end
    fprintf(fid,'\n');
end

%% Confidence
% Print first line
fprintf(fid,'\n\nConfidence\nCondition\tS1\tFEF\tDLPFC\taPFC\n');

%Print the data
condNames = {'invalid, fast','invalid, accurate','valid, fast','valid, accurate'};
for condition=1:length(condNames)
    fprintf(fid,'%s\t', condNames{condition});
    for tmsSite=1:4
        fprintf(fid,'%1.2f (%1.2f)\t', mean(conf(:,tmsSite, 1+(condition>2), 2-rem(condition,2))), std(conf(:,tmsSite, 2-rem(condition,2), 2-rem(condition,2))));
    end
    fprintf(fid,'\n');
end

%Close the file where we were recording
fclose(fid);