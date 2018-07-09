% Main function that calls all of the other functions.
% Divide main.m up into sections and run the sections instead of the whole
% thing. Use each section as a subroutine. Save snippits as new code if the
% routine is being used a lot.

%%
% Plot the constiutive YFP experiments.
% PROBABLY OUTDATED

% comment out the one that you don't want to plot
%file = '180623_YFP_const_timecourse_MS.xlsx';
file = '180624_YFP_const_timecourse_DZ.xlsx';

% adjust filepath as needed
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

nvar = 2;
ntime = 109;
tspace = 10;
plate = spark_timecourse_IO(datapath, file);

% optional flags
normalize = 1;
subtractBL = 1;
subtractBG = 1;

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
normalize = 0;
subtractBL = 1;
subtractBG = 1;
wellmap = generateWellMap(8, 12);

% loop through all files in the experiment and plot everything
for f = 1:length(files)
    file = files{f};
    plate = spark_timecourse_IO(datapath, file);
    % loop through the plate and plot each quadrant's equivlant well in a
    % subplot. figure best viewed fullscreen
    % loop OD then YFP
    for var = 1:nvar
        i = 1;
        figure('position', [0,0,1920,1080])
        for y = 1:3
            for x = 1:4
                subplot(3, 4, i)
                datawell = reshape(wellmap([y+1, y+4], [x, x+4, x+8]), [], 1);
                white = reshape(wellmap([y+1, y+4], [4, 8, 12]), [], 1);
                blank = reshape(wellmap([1, 8], [x, x+4, x+8]), [], 1);
                [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank, subtractBL, subtractBG);
                if var == 1
                    plot_timecourse(od, 0, tspace, 0)
                else
                    plot_timecourse(od, fluor, tspace, normalize)
                end
                ylim([0 inf])
                legend(wells_to_letters(datawell), 'Location', 'southeast')
                i = i + 1;
            end
        end
    end
end

%%
% Plot the 1st round of IPTG induction experiments, running from July 4th
% to July 6th

file = '180705_IPTG_experiment_1_DZ.xlsx';

datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

% define constant variables
nvar = 4;
ntime = 109;
tspace = 10;

% optional flags
normalize = 0;
subtractBL = 1;
subtractBG = 1;
wellmap = generateWellMap(8, 12);

% loop through all files in the experiment and plot everything

plate = spark_timecourse_IO(datapath, file);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen

figures = gobjects(nvar,1);
for var = 1:nvar
    figures(var) = figure('position', [0,0,1920,1080]);
end
i = 1;
for y = 1:3
    for x = 1:10
        datawell = reshape(wellmap([y+1, y+4], x+1), [], 1);
        white = reshape(wellmap([1, 8], x+1), [], 1);
        blank = reshape(wellmap([y+1, y+4], 1), [], 1);
        [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank, subtractBL, subtractBG);
        for var = 1:nvar
            if var == 1
                figures(1);
                subplot(3, 10, i)
                plot_timecourse(od, 0, tspace, 0)
            else
                fluor_current = squeeze(fluor(:, var-1, :));
                figures(var);
                subplot(3, 10, i)
                plot_timecourse(od, fluor_current, tspace, normalize)
            end
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
        end
        i = i + 1;
    end
end

