clc
experiment_path = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';
file = 'IPTG_Experiment_1.xlsx';
% File I/O, query user if datapath is left blank or invalid
while exist(experiment_path, 'file') ~= 7
    prompt = 'Enter path to .xlsx files (include single quotes '') > ';
    experiment_path = input(prompt) % do not supress with ; since this is user input
    if exist(experiment_path, 'file') ~= 7
        disp('Invalid path, enter new path')
    end
end
addpath(experiment_path)
[~,~,raw] = xlsread(file, 'MAP');

% find blank wells
blank_wells = find(strcmp(raw, 'BLANK'));
% convert to wellMap indexing
