function export_to_xls(diff_attention_effect, diff_SAT_effect, type2AUC, fmri_attention_effect, fmri_SAT_effect, fmri_type2AUC)

number_subjects = size(diff_attention_effect,1);


%% EACH OF THE 3 MEASURES SEPARATELY (4 REGIONS)
%File name
output_path = pwd;
file_name_separateMeasures = fullfile(output_path,'R mixed-effects analysis','LMM_separateMeasures_4regions.xls');

%Delete previous version of the file and open new file
if exist(file_name_separateMeasures)
    delete(file_name_separateMeasures)
end
fid = fopen(file_name_separateMeasures,'a');

%Print first line
fprintf(fid,'Subject\ttms_site\tAttention\tattFMRI\tSAT\tsatFMRI\tConf\tconfFMRI\n');

%Print the data
tmsNames = {'S1','FEF','DLPFC','aPFC'};
for tms_site=1:4
    for subj=1:number_subjects
        fprintf(fid,'%d\t%s\t%d\t%d\t%d\t%d\t%d\t%d\n', subj, tmsNames{tms_site}, ...
            diff_attention_effect(subj,tms_site), fmri_attention_effect(subj), ...
            diff_SAT_effect(subj,tms_site), fmri_SAT_effect(subj), ...
            type2AUC(subj,tms_site), fmri_type2AUC(subj));
    end
end

%Close the file where we were recording
fclose(fid);


%% INTERACTION BETWEEN THE THREE EFFECTS (4 REGIONS)
y = [normalize(diff_attention_effect),...
    normalize(diff_SAT_effect),...
    normalize(type2AUC)];
file_name_allMeasures = fullfile(output_path,'R mixed-effects analysis','LMM_allMeasures.xls');

%Delete previous version of the file and open new file
if exist(file_name_allMeasures)
    delete(file_name_allMeasures)
end
fid = fopen(file_name_allMeasures,'a');

%Print first line
fprintf(fid,'Subject\ty\ttms_site\tmeasure\n');

%Print the data
tmsNames = {'S1','FEF','DLPFC','aPFC'};
measureName = {'att','SAT','conf'};
for measure=1:3
    for tms_site=1:4
        for subject=1:number_subjects
            index = (tms_site-1)*number_subjects + subject;
            fprintf(fid,'%d\t%d\t%s\t%s\n',subject,y(index,measure),tmsNames{tms_site},measureName{measure});
        end
    end
end

%Close the file where we were recording
fclose(fid);