% This function reads in an experiment file and returns metadata for the
% experiment. This experiment spreadsheet is created using the experiment template.

% Inputs:
% experiment path: path to where the experiment templates
% file: filename of the experiment template

% Returns:
% experiment_plate: a struct that is the size of the plate containing the
% metadata for each well
% function [metadata, plate_meta] = experiment_reader(experiment_path, file)                            
% experiment_path = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';
% file = 'IPTG_Experiment_1.xlsx';
function [metadata, plate_meta] = experiment_reader(experiment_path, file)
% File I/O, query user if datapath is left blank or invalid
while exist(experiment_path, 'file') ~= 7
    prompt = 'Enter path to experiment files (include single quotes '') > ';
    experiment_path = input(prompt) % do not supress with ; since this is user input
    if exist(experiment_path, 'file') ~= 7
        disp('Invalid path, enter new path')
    end
end
addpath(experiment_path)
[~,~,raw] = xlsread(file, 'MAP');
[~,~,raw2] = xlsread(file, 'EDIT');
[rows, cols] = size(raw);

% make the empty structure with wellMap indexing
% fields:
% index: the wellmap index of the well
% strain: the strain of cell in the well, as a string
% ratio: the mixutre ratio of strains
% inducer: what inducer is added, as a string
% conc: the concentration of inducer (in mM), as a double
% dil: the dilution factor (or starting OD) of the well, as a double
% fp: expected color of fluorsence of the well
% blank: whether or not the well is an OD blank or not as a boolean
% white: whether or not the well is a fluoresence blank or not as a boolean
plate_meta = struct('strain', cell(size(raw)), 'ratio', cell(size(raw)), 'inducer', cell(size(raw)), 'conc', cell(size(raw)), 'dil', cell(size(raw)), 'fp', cell(size(raw)),'blank', cell(size(raw)),'white', cell(size(raw)));
% metadata holds information that's global to the plate
% fields:
% nvar: number of variables measured (including OD, if 1 is supplied OD is
% assumed)
% ntime: number of timepoints
% tspace: interval of timepoints in minutes
metadata = struct('nvar', raw2{16, 2}, 'ntime', raw2{17, 2}, 'tspace', raw2{18, 2}); % this is hardcoded


% first make all wells false for blank and white
for i = 1:(rows*cols)
    plate_meta(i).blank = false;
    plate_meta(i).white = false;
end

% find blank wells and mark them in the plate_meta structure
blank_wells = find(strcmp(raw, 'BLANK'));
% set flag for blank
for i = 1:length(blank_wells)
    plate_meta(blank_wells(i)).blank = true;
end

% find white wells and mark them in the plate_meta structure
white_wells = find(contains(raw, 'W'));
% set flag for white
for i = 1:length(white_wells)
    plate_meta(white_wells(i)).white = true;
end

% use regex (or just string find) to find unique conditions, if the condition isn't found then
% the field is left blank
% find strains (if any)
DZ_wells = find(contains(raw, 'DZ'));
CN_wells = find(contains(raw, 'CN'));
DZpat = '(DZ)\w+';
for i = 1:length(DZ_wells)
    current_string = raw(induced_wells(i));
    [starti,endi] = regexp(current_string{1}, concpat);
    extracted = current_string{1}(starti:endi);
    plate_meta(DZ_wells(i)).strain = extracted;
end
CNpat = '(CN)\w+';
for i = 1:length(CN_wells)
    current_string = raw(induced_wells(i));
    [starti,endi] = regexp(current_string{1}, CNpat);
    extracted = current_string{1}(starti:endi);
    plate_meta(CN_wells(i)).strain = extracted;
end
if isempty(DZ_wells) && isempty(CN_wells)
    plate_meta = rmfield(plate_meta, 'strain');
end

% find ratios (if any)
ratio_wells = find(contains(raw, '/'));
ratiopat = '\d*\/\d*';
for i = 1:length(ratio_wells)
    current_string = raw(ratio_wells(i));
    [starti,endi] = regexp(current_string{1}, ratiopat);
    extracted = current_string{1}(starti:endi);
    plate_meta(ratio_wells(i)).ratio = extracted;
end
if isempty(ratio_wells)
    plate_meta = rmfield(plate_meta, 'ratio');
end

% find inducer (if any)
iptg_wells = find(contains(raw, 'IPTG'));
c14_wells = find(contains(raw, 'C14'));
c4_wells = find(contains(raw, 'C4'));
for i = 1:length(iptg_wells)
    plate_meta(iptg_wells(i)).inducer = 'IPTG';
end
for i = 1:length(c14_wells)
    plate_meta(c14_wells(i)).inducer = 'C14';
end
for i = 1:length(c4_wells)
    plate_meta(c4_wells(i)).inducer = 'C4';
end
if isempty(iptg_wells) && isempty(c14_wells) && isempty(c4_wells)
    plate_meta = rmfield(plate_meta, 'inducer');
end

% find conc (if any)
induced_wells = find(contains(raw, 'mM'));
concpat = '(\d*\.\d* mM)|(\d* mM)';
for i = 1:length(induced_wells)
    current_string = raw(induced_wells(i));
    [starti,endi] = regexp(current_string{1}, concpat);
    extracted = current_string{1}(starti:endi-3); % cut off the mM
    plate_meta(induced_wells(i)).conc = str2double(extracted);
end
if isempty(induced_wells)
    plate_meta = rmfield(plate_meta, 'conc');
end

% find dilutions (if any)
defined_od_wells = find(contains(raw, 'OD'));
defined_dil_wells = find(contains(raw, '1:'));
dilpat = '(1:\d*)|(0\.\d*)';
for i = 1:length(defined_od_wells)
    current_string = raw(defined_od_wells(i));
    [starti,endi] = regexp(current_string{1}, dilpat);
    extracted = current_string{1}(starti:endi);
    plate_meta(defined_od_wells(i)).dil = str2double(extracted);
end
for i = 1:length(defined_dil_wells)
    current_string = raw(defined_dil_wells(i));
    [starti,endi] = regexp(current_string{1}, dilpat);
    extracted = current_string{1}(starti:endi);
    plate_meta(defined_dil_wells(i)).dil = str2double(extracted(3:end)); % removes the 1: part
end
if isempty(defined_od_wells) && isempty(defined_dil_wells)
    plate_meta = rmfield(plate_meta, 'dil');
end

% find expected fp (if any)
red_wells = find(contains(raw, 'Red'));
cyan_wells = find(contains(raw, 'Cyan'));
yellow_wells = find(contains(raw, 'Yellow'));
for i = 1:length(red_wells)
    plate_meta(red_wells(i)).fp = 'Red';
end
for i = 1:length(cyan_wells)
    plate_meta(cyan_wells(i)).fp = 'Cyan';
end
for i = 1:length(yellow_wells)
    plate_meta(yellow_wells(i)).fp = 'Yellow';
end
if isempty(red_wells) && isempty(cyan_wells) && isempty(yellow_wells)
    plate_meta = rmfield(plate_meta, 'fp');
end

% list replicate wells, struct with name of condidtion and wells the
% condition is found in. using wellMap indexing
% a well is considered a rep if all the fields in it's plate_meta is
% exactly the same
all_wells = 1:(rows*cols);
exp_wells = setdiff(setdiff(all_wells, white_wells), blank_wells);
unique_experiments = {}; % cell array that holds unique experiments
unique_experiments_i = []; % a row here corresponds with the same index in unique experiments, but holds the plate index in columns
unique_experiments_counts = [];
found = false;
for i = 1:length(exp_wells)
    % get the current experiment
    found = false;
    current = plate_meta(exp_wells(i));
    % check if the current experiment is in the list of experiments
    for j = 1:length(unique_experiments)
        % if the experiment is found, add the index
        if isequaln(unique_experiments{j}, current)
            unique_experiments_counts(j) = unique_experiments_counts(j) + 1;
            unique_experiments_i(j, unique_experiments_counts(j)) = exp_wells(i);
            found = true;
        end
    end
    % experiment wasn't found so add it and record the index
    if ~found
        unique_experiments{end+1} = current;
        unique_experiments_i(end+1, 1) = exp_wells(i); 
        unique_experiments_counts(end+1) = 1;
    end
end
% convert index to wellmap indexes
unique_experiments_i_spark = convert_index(unique_experiments_i, rows, cols, 'Spark');
% add indexing
map = num2cell(generateWellMap(rows, cols));
[plate_meta(:,:).index] = deal(map{:,:});

metadata.replicate_wells = unique_experiments_i_spark;
metadata.experiments = unique_experiments;
