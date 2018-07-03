% Main function that calls all of the other functions.
% Divide main.m up into sections and run the sections instead of the whole
% thing. Use each section as a subroutine. Save snippits as new code if the
% routine is being used a lot.

%%
% Plot the constiutive YFP experiments.

% comment out the one that you don't want to plot
file = '180623_YFP_const_timecourse_MS.xlsx';
%file = '180624_YFP_const_timecourse_DZ.xlsx';

% adjust filepath as needed
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

nvar = 2;
ntime = 109;
tspace = 10;
plate = spark_timecourse_IO(datapath, file);

% optional flags
normalize = 1;
subtractBL = 0;
subtractBG = 0;

wellmap = generateWellMap(8, 12);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen
for var = [1, 2]
    i = 1;
    figure('position', [0,0,1920,1080])
    for y = 1:3
        for x = 1:6
            subplot(3, 6, i)
            datawell = reshape(wellmap([y, y+4], [x, x+6]), [], 1);
            white = reshape(wellmap([4, 8], [x, x+6]), [], 1);
            blank = -1*ones(size(white));
            plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank, var, normalize, subtractBL, subtractBG);
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
            i = i + 1;
        end
    end
end

%%
% Plot the 2nd version of the YFP experiments, the ones with blanks on the
% top and bottom row June 27 - July 3

% load up all the files in a cell array
files = {'180627_YFP_const_timecourse_DZ.xlsx',...
    '180628_YFP_const_timecourse_MS.xlsx',...
    '180629_YFP_const_timecourse_DZ.xlsx',...
    '180703_YFP_const_timecourse_DZ.xlsx'};

datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

% define constant variables
nvar = 2;
ntime = 109;
tspace = 10;

% optional flags
normalize = 1;
subtractBL = 0;
subtractBG = 0;

plate = spark_timecourse_IO(datapath, file);

wellmap = generateWellMap(8, 12);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen
% loop OD then YFP
for var = 1:2
    i = 1;
    figure('position', [0,0,1920,1080])
    for y = 1:3
        for x = 1:6
            subplot(3, 6, i)
            datawell = reshape(wellmap([y, y+4], [x, x+6]), [], 1);
            white = reshape(wellmap([4, 8], [x, x+6]), [], 1);
            blank = -1*ones(size(white));
            plot_timecourse(plate, nvar, ntime, tspace, datawell, white, blank, var, normalize, subtractBL, subtractBG);
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
            i = i + 1;
        end
    end
end