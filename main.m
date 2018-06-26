% Main function that calls all of the other functions.
% Divide main.m up into sections and run the sections instead of the whole
% thing. Use each section as a subroutine. Save snippits as new code if the
% routine is being used a lot.

%%
% Plot the constiutive YFP experiments.

file = '180624_YFP_const_timecourse_DZ.xlsx';
nvar = 2;
ntime = 109;
tspace = 10;
datapath = 'C:\Users\david\Dropbox\Rice\Bennett Lab\Data\Consortia Networks\Plate Reader';
plate = spark_timecourse_IO(datapath, file);

wellmap = generateWellMap(8, 12);

datawell = reshape(wellmap([1, 5], [1, 7]), [], 1);
white = reshape(wellmap([4, 8], [1, 7]), [], 1);
blank = -1*ones(size(white));


for i = 1:1
    [fig1, fig2] = plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank);
    fig1;
    legend('A1', 'E1', 'A7', 'E7', 'Location', 'northwest')
    fig2;
    legend('A1', 'E1', 'A7', 'E7', 'Location', 'northwest')
end
