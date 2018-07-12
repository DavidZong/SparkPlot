% This function reads in an experiment file and returns metadata for the
% experiment. This experiment spreadsheet is created using the experiment template.

% Inputs:
% experiment path: path to where the experiment templates
% file: filename of the experiment template

% Returns:
% experiment_plate: a struct that is the size of the plate containing the
% metadata for each well
% function [metadata, plate_meta] = experiment_reader(experiment_path, file)                            
experiment_path = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';
file = 'IPTG_Experiment_1.xlsx';
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
plate_meta = struct('index', num2cell(generateWellMap(rows, cols)), 'strain', cell(size(raw)), 'ratio', cell(size(raw)), 'inducer', cell(size(raw)), 'conc', cell(size(raw)), 'dil', cell(size(raw)), 'fp', cell(size(raw)),'blank', cell(size(raw)),'white', cell(size(raw)));
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
% find ratios (if any)
% find inducer (if any)
% find conc (if any)
induced_wells = find(contains(raw, 'mM'));
concpat = '(\d*)+\s+(?:mM)';
for i = 1:length(induced_wells)
    plate_meta(induced_wells(i)).conc = 100;
end
% find dilutions (if any)
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
% list replicate wells, struct with name of condidtion and wells the
% condition is found in. using wellMap indexing
