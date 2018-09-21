% This function uses the metadata file to plot out every experiment from a
% plate experiment file directly off the spark.

% Inputs:
% files: name of the Excel files with the data, must be passed as a cell
% array, even if it's just one file
% experiment: name of the Excel experiment file (must be formatted
% correctly), there can be only one of these since you can't graph multiple
% experiments using this method
% datapath: full path to the file
% experimentpath: full path to the experiment

% function spark_quickplot(files, experiment, datapath, experimentpath)
files = {'180920_All_12h.xlsx'};% '180907_X_12h.xlsx', '180908_X_12h.xlsx'};
datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
experiment = 'All_experiment.xlsx';
experimentpath = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';

[metadata, ~] = experiment_reader(experimentpath, experiment);

nexperiments = length(metadata.experiments);
nreps = length(metadata.replicate_wells(1,:));

% display some useful information to the user:
disp(['There are ' num2str(nexperiments) ' unique experiments on each plate.'])
disp(['Each experiment is repeated ' num2str(nreps) ' times.'])

% optional flags
normalize = 0;
subtractBL = 1;
subtractBG = 0;
bio_triplicate = 1;

% determine best arrangement
nwide = ceil(sqrt(nexperiments));
ntall = nexperiments/nwide; % might not be an integer

figures = gobjects(metadata.nvar,1);
% TODO: determine the window size in a smart way
for var = 1:metadata.nvar
    %figures(var) = figure('position', [0,0,1920,1080]);
    figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
end

all_avg_od = zeros(metadata.ntime, nexperiments, length(files));
all_avg_flu = zeros(metadata.ntime, nexperiments, (var-1), length(files));

for f = 1:length(files)
    file = files{f};
    plate = spark_timecourse_IO(datapath, file);

    for i = 1:nexperiments
        datawell = metadata.replicate_wells(i, :);
        white = metadata.whites;
        blank = metadata.blanks;
        [od, fluor] = extract_timecourse(plate, metadata.nvar, metadata.ntime, datawell, white, blank, subtractBL, subtractBG);
        for var = 1:metadata.nvar
            if var == 1
                set(0, 'currentfigure', figure(1));
                subplot(ntall, nwide, i)
                plot_timecourse(od, 0, metadata.tspace, 0)
                all_avg_od(:, i, f) = mean(od, 2);
            else
                fluor_current = squeeze(fluor(:, var-1, :));
                set(0, 'currentfigure', figure(var));
                subplot(ntall, nwide, i)
                plot_timecourse(od, fluor_current, metadata.tspace, normalize)
                all_avg_flu(:, i, var-1, f) = mean(fluor_current, 2);
            end
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
            if normalize
                xlim([120, Inf]);
            end
        end
    end
end

select_pairs = [3,4;5,6;7,8];
for i =1:3
    select = select_pairs(i, :);
    figure
    od_triplicate = squeeze(all_avg_od());
    select_od = od_triplicate(:, select);
    plot_timecourse(select_od, 0, metadata.tspace, 0)
    legend('induced', 'uninduced', 'Location', 'northwest')
    figure
    for var = 1:(metadata.nvar - 1)
        subplot(3, 1, var)
        current_fluor = squeeze(all_avg_flu(:, select, var, :));
        plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
        legend('induced', 'uninduced', 'Location', 'northwest')
    end
end

select = [1, 9, 11];
figure
od_triplicate = squeeze(all_avg_od());
select_od = od_triplicate(:, select);
plot_timecourse(select_od, 0, metadata.tspace, 0)
legend('cascade', 'IFFL', 'Fanout','Location', 'northwest')
figure
for var = 1:(metadata.nvar - 1)
    subplot(3, 1, var)
    current_fluor = squeeze(all_avg_flu(:, select, var, :));
    plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
    legend('cascade', 'IFFL', 'Fanout','Location', 'northwest')
end
