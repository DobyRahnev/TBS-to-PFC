function sequence = scanning_sequence()

% The order of stimulation for each subject
%1:	S1
%2:	FEF
%3:	DLPFC
%4:	aPFC
sequence{3} = [4	1	3	2];%S3
sequence{4} = [4	1	2	3];%S4
sequence{5} = [1	4	2	3];%S5
sequence{6} = [1	2	4	3];%S6
sequence{7} = [1	4	3	2];%S7
sequence{10} = [1	2	3	4];%S10
sequence{12} = [2	1	4	3];%S12
sequence{14} = [3	2	1	4];%S14
sequence{16} = [2	3	1	4];%S16
sequence{20} = [2	1	3	4];%S20
sequence{21} = [3	4	2	1];%S21
sequence{22} = [4	2	1	3];%S22
sequence{23} = [4	3	1	2];%S23
sequence{24} = [2	4	3	1];%S24
sequence{25} = [4	3	2	1];%S25
sequence{30} = [3	4	1	2];%S30
sequence{35} = [1	3	4	2];%S35
sequence{36} = [2	3	4	1];%S36
sequence{37} = [3	1	2	4];%S37
sequence{40} = [1	3	2	4];%S40
sequence{41} = [2	4	1	3];%S41