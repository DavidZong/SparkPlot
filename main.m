% Main function that calls all of the other functions.

file = '180623_YFP_const_timecourse_MS.xlsx';
nvar = 2;
ntime = 109;
tspace = 10;
datawell = 1:6;
white = 37:42;
blank = -1*ones(size(white));

% datawell = 1;
% white = 37;
% blank = -1;

datapath = 'C:\Users\david\Dropbox\Rice\Bennett Lab\Data\Consortia Networks\Plate Reader';

plate = spark_timecourse_IO(datapath, file);
plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank)