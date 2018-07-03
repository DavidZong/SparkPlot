% This script takes in a plate of data and plots a timecourse from a
% specified well from that plate. The inputs are the plate data file,
% number fluorescences in the file, length of the time course, and the well number(s).

% When this script is run, it will ask the user for the datapath. If you
% don't want this to happen a valid path must be supplied as a variable.

% plate: an unformatted plate matrix output by spark_timecourse_IO.m
% nvar: number of different things measured, it is assumed that all are
% measured at all time points
% ntime: number of timepoints
% tspace: time interval of the timepoints, in minutes

% for well numbers use the generateWellMap.m to figure out what number it
% is

% datawell: the well to plot, enter an array for multiple
% white: the white well, enter an arry for multiple
% blank: the blank well, use a negative number or 0 if there's no blank,
% enter an array if multiple

% var (optional): which variable to plot, as an integer. 1 for OD, 2 onwards for the
% various fluorescences. can be a vector if multiple fluorescences are
% desired, but the y-axis might get weird. defaults to OD var=1 if left
% unset
% normalize (optional): if this is true then the fluorescence will be
% normalized, but if set to false or 0, then there will be no
% normalization. the default value is true or 1

function plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank, var, normalize, subtractBL, subtractBG, avgblank, avgwhite)
% Check number of inputs.
if nargin > 13
    errorStruct.message = 'Too many inputs.';
    errorStruct.identifier = 'plot_timecourse:TooManyInputs';
    error(errorStruct);
elseif narging < 7
    errorStruct.message = 'Too few inputs.';
    errorStruct.identifier = 'plot_timecourse:notEnoughInputs';
    error(errorStruct);
end

% Fill in unset optional values.
switch nargin
    case 7
        var = 1;
        normalize = 1;
        subtractBL = 1;
        subtractBG = 1;
    case 8
        normalize = 1;
        subtractBL = 1;
        subtractBG = 1;
    case 9
        subtractBL = 1;
        subtractBG = 1;
    case 10
        subtractBG = 1;
        avgblank = 0;
        avgwhite = 0;
    case 11
        avgblank = 0;
        avgwhite = 0;
    case 12
        avgwhite = 0;
end

% TODO: check if var is valid

% calculate the x axis
t = (0:(ntime-1)) * tspace;

% process the well, subtract background OD, and white cells from
% fluoresence, then normalize the fluorescence to the OD
traces = length(datawell);
od = zeros(ntime, traces);
fluor = zeros(ntime, traces);
for i = 1:traces
    [od(:, i), fluor(:, i)] = platewellpreprocess(plate, ntime, nvar, datawell(i), white(i), blank(i), subtractBL, subtractBG, avgblank, avgwhite);
end

% normalize fluorescence to OD if normalize is true
if normalize
    nfluor = fluor ./ od;
    fluoresence_label = 'Fluoresence / OD600 (au)';
else
    nfluor = fluor;
    fluoresence_label = 'Fluoresence (au)';
end

% calculate the number of ticks to display and the interval
if mod(t(end), 6) == 0
    tickspace = t(end) / 6;
elseif mod(t(end), 4) == 0
    tickspace = t(end) / 4;
end

% plot fluorescence or OD, depending on var. 
if all(var > 1)
    plot(t, nfluor, 'Linewidth', 2);
    xlabel('Time (min)')
    ylabel(fluoresence_label)
    xticks(0:tickspace:t(end))
    xlim([0, t(end)])
else
    plot(t, od, 'Linewidth', 2);
    xlabel('Time (min)')
    ylabel('OD600 (au)')
    xticks(0:tickspace:t(end))
    xlim([0, t(end)])
end

