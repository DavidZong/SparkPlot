% Main function that calls all of the other functions.

file = '180623_YFP_const_timecourse_MS.xlsx';
nvar = 2;
ntime = 109;
tspace = 10;
datawell = 5;
white = 42;
blank = -1;
datapath = 'C:\Users\david\Dropbox\Rice\Bennett Lab\Data\Consortia Networks\Plate Reader';

plot_timecourse(file, datapath, nvar, ntime, tspace, datawell, white, blank)