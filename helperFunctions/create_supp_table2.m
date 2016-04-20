function create_supp_table2(type2AUC, metaDprime, phi, conf_diff, fileName)

data = {type2AUC, metaDprime, phi, conf_diff};

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
fprintf(fid,'Measure\tS1\tFEF\tDLPFC\taPFC\n');

%Print the data
measureNames = {'Type 2 AUC','meta-d''', 'phi', 'confidence difference'};
for measure=1:length(measureNames)
    fprintf(fid,'%s\t', measureNames{measure});
    for tmsSite=1:4
        fprintf(fid,'%1.2f (%1.2f)\t', mean(data{measure}(:,tmsSite)), std(data{measure}(:,tmsSite)));
    end
    fprintf(fid,'\n');
end

%Close the file where we were recording
fclose(fid);