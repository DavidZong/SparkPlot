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

% returns:
% od_fig: the figure handle to the figure that graphed OD
% flu_fig: the figure handle to the figure that graphed fluoresence

function [od_fig, flu_fig] = plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank)
% calculate the x axis
t = (0:(ntime-1)) * tspace;

% process the well, subtract background OD, and white cells from
% fluoresence, then normalize the fluorescence to the OD
traces = length(datawell);
od = zeros(ntime, traces);
fluor = zeros(ntime, traces);
for i = 1:traces
    [od(:, i), fluor(:, i)] = platewellpreprocess(plate, ntime, nvar, datawell(i), white(i), blank(i));
end

% normalize fluorescence to OD
nfluor = fluor ./ od;

% calculate the number of ticks to display and the interval
if mod(t(end), 6) == 0
    tickspace = t(end) / 6;
elseif mod(t(end), 4) == 0
    tickspace = t(end) / 4;
end

% plot fluorescences, if there is more than one fluorescence, it will plot
% subfigures
flu_fig = figure;
numfluor = nvar - 1;
if numfluor > 1
    for i = 1:numfluor
        subplot(1, 3, i)
        plot(t, nfluor(:, i), 'Linewidth', 2)
        xlabel('Time (min)')
        ylabel('Fluorescence / OD (au)')
        xticks(0:tickspace:t(end))
        xlim([0, t(end)])
    end
end
plot(t, nfluor, 'Linewidth', 2)
xlabel('Time (min)')
ylabel('Fluorescence / OD (au)')
xticks(0:tickspace:t(end))
xlim([0, t(end)])

% plot OD
od_fig = figure;
plot(t, od, 'Linewidth', 2)
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:tickspace:t(end))
xlim([0, t(end)])
