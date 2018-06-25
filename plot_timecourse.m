% This script takes in a plate of data and plots a timecourse from a
% specified well from that plate. The inputs are the plate data file,
% number of things to plot, length of the time course, and the well number.

% file: name or path to the xlsx file
% nvar: number of different things measured, it is assumed that all are
% measured at all time points
% ntime: number of timepoints
% tspace: time interval of the timepoints, in minutes
% datawell: the well to plot
% white: the white well
% blank: the blank well, use a negative number or 0 if there's no blank

% File I/O
% Add filepath to all data (change as needed)
addpath('C:\Users\david\Dropbox\Rice\Bennett Lab\Data\Consortia Networks\Plate Reader')
file = '180623_YFP_const_timecourse_MS.xlsx';
plate = getplatedata(file);

nvar = 2;
ntime = 109;
tspace = 10;
datawell = 1;
white = 37;
blank = -1;

% calculate the x axis
t = (0:(ntime-1)) * tspace;

% process the well, subtract background OD, and white cells from
% fluoresence, then normalize the fluorescence to the OD
[od, fluor] = platewellpreprocess(plate, ntime, nvar, datawell, white, blank);

% normalize fluorescence to OD
nfluor = fluor ./ od;

% plot fluorescences
figure(1)
plot(t, nfluor, 'Linewidth', 2)
xlabel('Time (min)')
ylabel('Fluorescence / OD (au)')
xticks(0:40:t(end))
xlim([0, t(end)])

% plot OD
figure(2)
plot(t, od, 'Linewidth', 2)
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:t(end))
xlim([0, t(end)])
