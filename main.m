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
    %figures(var) = figure('position', [0,0,1920,1080]);
    figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
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
                set(0, 'currentfigure', figure(1));
                subplot(3, 10, i)
                plot_timecourse(od, 0, tspace, 0)
            else
                fluor_current = squeeze(fluor(:, var-1, :));
                set(0, 'currentfigure', figure(var));
                subplot(3, 10, i)
                plot_timecourse(od, fluor_current, tspace, normalize)
            end
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
        end
        i = i + 1;
    end
end

%%
% Plot the induction of 1st round of IPTG induction experiments, running from July 4th
% to July 6th
file = '180705_IPTG_experiment_1_DZ.xlsx';
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
plate = spark_timecourse_IO(datapath, file);
wellmap = generateWellMap(8, 12);
nvar = 4;
ntime = 109;
tspace = 10;
x = horzcat(0, 10.^(-1:0.25:1));
timeslice = 41; % 41 is 400 minutes
blank = wellmap(:, [1, 12]);
white = wellmap([1,8], (2:11));
flucolor = {'mCherry2 ', 'sfCFP ', 'sfYFP '};

realtime = (timeslice-1) * tspace;
for i = 1:3
    datawell = wellmap(i+1, (2:11));
    [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank);
    nfluor = normalize_flu(od, fluor);
    fluor = squeeze(nfluor(:, i, :));
    figure;
    plot_induction(x, fluor, timeslice, 1)
    title(strcat('t = ', num2str(realtime), ' (min) (', num2str(realtime - 240), ' minutes after induction)'))
    xlabel('[IPTG] (mM)')
    ylabel(strcat(flucolor{i}, 'Fluoresence / OD600 (au)'))
end

%%
% Plot the induction of 1st round of IPTG induction experiments, running from July 4th
% to July 6th
% As a video
file = '180705_IPTG_experiment_1_DZ.xlsx';
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
plate = spark_timecourse_IO(datapath, file);
wellmap = generateWellMap(8, 12);
nvar = 4;
ntime = 109;
tspace = 10;
x = horzcat(0, 10.^(-1:0.25:1));
timeslices = 1:ntime;
blank = wellmap(:, [1, 12]);
white = wellmap([1,8], (2:11));
flucolor = {'mCherry2 ', 'sfCFP ', 'sfYFP '};
outpath = 'output/180705_IPTG_experiment_1/';
realtime = (timeslices-1) .* tspace;
videos = {VideoWriter(strcat(outpath,'mCherry2.avi')), VideoWriter(strcat(outpath,'sfcfp.avi')), VideoWriter(strcat(outpath,'sfyfp.avi'))}; 
for i = 1:3
    v = videos{i};
    v.FrameRate = 7;
    open(v)
    datawell = wellmap(i+1, (2:11));
    [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank);
    nfluor = normalize_flu(od, fluor);
    fluor = squeeze(nfluor(:, i, :));
    figure('position', [200,200,1600,720])
    for t = timeslices
        subplot(1, 2, 1)
        plot_induction(x, fluor, t, 1)
        if t == 1
            axis tight manual
            ylim([0, max(max(fluor(30:50,:)))])
            set(gca,'nextplot','replacechildren');
        end
        title(strcat('t = ', num2str(realtime(t)), ' (min) (', num2str(realtime(t) - 240), ' minutes after induction)'))
        xlabel('[IPTG] (mM)')
        ylabel(strcat(flucolor{i}, 'Fluoresence / OD600 (au)'))
        subplot(1, 2, 2)
        if t == 1
            axis tight manual
            set(gca,'nextplot','replacechildren');
            ylim([0, 1])
        end
        plot_timecourse(od, 0, tspace, 0)
        legend('0 mM', '10e-1 mM', '10e-.75 mM','10e-0.5 mM', '10e-.25 mM','10e0 mM', '10e.25 mM','10e.5 mM', '10e.75 mM', '10e1 mM', 'Location', 'southeast')
        hold on
        plot(realtime(t), od(t, :), 'Marker', 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'LineStyle', 'none', 'HandleVisibility','off')
        hold off
        frame = getframe(gcf);
        writeVideo(v, frame);
    end
    close(v);
end

%%
% Plot the 2nd round of IPTG induction experiments

file = '180712_IPTG_experiment_3.xlsx';

datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

% define constant variables
nvar = 4;
ntime = 49;
tspace = 10;

% optional flags
normalize = 1;
subtractBL = 1;
subtractBG = 1;
wellmap = generateWellMap(8, 12);

% loop through all files in the experiment and plot everything

plate = spark_timecourse_IO(datapath, file);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen

figures = gobjects(nvar,1);
for var = 1:nvar
    %figures(var) = figure('position', [0,0,1920,1080]);
    figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
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
                set(0, 'currentfigure', figure(1));
                subplot(3, 10, i)
                plot_timecourse(od, 0, tspace, 0)
            else
                fluor_current = squeeze(fluor(:, var-1, :));
                set(0, 'currentfigure', figure(var));
                subplot(3, 10, i)
                plot_timecourse(od, fluor_current, tspace, normalize)
            end
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
        end
        i = i + 1;
    end
end


%%
% Plot the diagnostic run from July 16th

file = '180717_IPTG_diagnostic.xlsx';

datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

% define constant variables
nvar = 4;
ntime = 49;
tspace = 10;

% optional flags
normalize = 1;
subtractBL = 1;
subtractBG = 1;
wellmap = generateWellMap(8, 12);

% loop through all files in the experiment and plot everything

plate = spark_timecourse_IO(datapath, file);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen

figures = gobjects(nvar,1);
for var = 1:nvar
    %figures(var) = figure('position', [0,0,1920,1080]);
    figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
end
i = 1;

for x = 1:12
    datawell = reshape(wellmap(2:7, x), [], 1);
    white = reshape(wellmap([1, 8], 2:11), [], 1);
    blank = reshape(wellmap([1, 8], [1, 12]), [], 1);
    [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank, subtractBL, subtractBG);
    for var = 1:nvar
        if var == 1
            set(0, 'currentfigure', figure(1));
            subplot(4, 3, i)
            plot_timecourse(od, 0, tspace, 0)
        else
            fluor_current = squeeze(fluor(:, var-1, :));
            set(0, 'currentfigure', figure(var));
            subplot(4, 3, i)
            plot_timecourse(od, fluor_current, tspace, normalize)
        end
        ylim([0 inf])
        legend(wells_to_letters(datawell), 'Location', 'southeast')
    end
    i = i + 1;
end

%%
% Plot the diagnostic run from July 16th OD only

file = '180717_IPTG_diagnostic.xlsx';

datapath = 'C:\Users\david\OneDrive\Plate Reader Data';

% define constant variables
nvar = 1;
ntime = 49;
tspace = 10;

% optional flags
normalize = 0;
subtractBL = 1;
subtractBG = 0;
wellmap = generateWellMap(8, 12);

% loop through all files in the experiment and plot everything

plate = spark_timecourse_IO(datapath, file);
% loop through the plate and plot each quadrant's equivlant well in a
% subplot. figure best viewed fullscreen

figures = gobjects(nvar,1);
for var = 1:nvar
    %figures(var) = figure('position', [0,0,1920,1080]);
    figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
end
i = 1;

for x = 1:12
    datawell = reshape(wellmap(1:8, x), [], 1);
    white = reshape(wellmap([1, 8], 2:11), [], 1);
    blank = reshape(wellmap([1, 8], [1, 12]), [], 1);
    [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, blank, subtractBL, subtractBG);
    for var = 1:nvar
        if var == 1
            set(0, 'currentfigure', figure(1));
            subplot(4, 3, i)
            plot_timecourse(od, 0, tspace, 0)
        else
            fluor_current = squeeze(fluor(:, var-1, :));
            set(0, 'currentfigure', figure(var));
            subplot(4, 3, i)
            plot_timecourse(od, fluor_current, tspace, normalize)
        end
        ylim([0 inf])
        legend(wells_to_letters(datawell), 'Location', 'southeast')
    end
    i = i + 1;
end
%%
% Testing out the new plotter
files = {'180705_IPTG_experiment_1_DZ.xlsx'};
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
experiment = 'IPTG_Experiment_1.xlsx';
experimentpath = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';
spark_quickplot(files, experiment, datapath, experimentpath)

%%
files = {'180906_X_12h.xlsx'};
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
experiment = 'IPTG_Experiment_Control_12h.xlsx';
experimentpath = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';
spark_quickplot(files, experiment, datapath, experimentpath)

























