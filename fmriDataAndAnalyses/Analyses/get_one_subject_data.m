function data = get_one_subject_data(subject)

%Navigate to the folder with the results
current_folder = pwd;
cd ..

%% Variables of interest
% p.stim_type %1: left tilt, 2: right tilt
% p.speed_accuracy_trial %1: speed, 2: accuracy
% p.cue_validity %0: invalid, 1: valid
% p.cue_direction %1:cue left, 2: cue right
% p.stim_direction %1:stim left, 2: stim right
% response -> p.answers(:,1) %1: left tilt, 2: right tilt
% confidence -> p.answers(:,2) %1:lowest, 4:highest
% correct -> p.answers(:,3) %0:error, 1:correct
% rt -> p.response_time(:,1)-p.presentation_time(:,3)
data.stimulus = [];
data.speed_accuracy = [];
data.cue_validity = [];
data.cue_direction = [];
data.stim_direction = [];
data.response = [];
data.confidence = [];
data.correct = [];
data.rt = [];
data.rt2 = [];

%% Go through all 4 runs of the fMRI experiment
for run=1:4
    
    %Load the relevant file
    file_name = ['S' num2str(subject) '/results_s' num2str(subject) '_run' num2str(run)];
    eval(['load ' file_name '']);
    
    data.stimulus = [data.stimulus, p.stim_type];
    data.speed_accuracy = [data.speed_accuracy, p.speed_accuracy_trial];
    data.cue_validity = [data.cue_validity, p.cue_validity];
    data.cue_direction = [data.cue_direction, p.cue_direction];
    data.stim_direction = [data.stim_direction, p.stim_direction];
    data.response = [data.response, p.answers(:,1)'];
    data.confidence = [data.confidence, p.answers(:,2)'];
    data.correct = [data.correct, p.answers(:,3)'];
    data.rt = [data.rt, p.response_time(:,1)'-p.presentation_time(:,5)'];
    data.rt2 = [data.rt2, p.response_time(:,2)'-p.presentation_time(:,5)'];
end

cd(current_folder)