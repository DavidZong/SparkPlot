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

function spark_quickplot(files, experiment, datapath, experimentpath)
% files = {'180627_YFP_const_timecourse_DZ.xlsx'};
% datapath = 'C:\Users\david\OneDrive\Plate Reader Data';
% experiment = 'YFP_const_timecourse_v2.xlsx';
% experimentpath = 'C:\Users\david\OneDrive\Plate Reader Data\Experiment Well Maps';

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

% determine best arrangement
nwide = ceil(sqrt(nexperiments));
ntall = nexperiments/nwide; % might not be an integer

for f = 1:length(files)
    file = files{f};
    plate = spark_timecourse_IO(datapath, file);
    figures = gobjects(metadata.nvar,1);
    
    % TODO: determine the window size in a smart way
    for var = 1:metadata.nvar
        %figures(var) = figure('position', [0,0,1920,1080]);
        figures(var) = figure('position', [1920,0,2560,1080]); % plot on the big monitor
    end

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
            else
                fluor_current = squeeze(fluor(:, var-1, :));
                set(0, 'currentfigure', figure(var));
                subplot(ntall, nwide, i)
                plot_timecourse(od, fluor_current, metadata.tspace, normalize)
            end
            ylim([0 inf])
            legend(wells_to_letters(datawell), 'Location', 'southeast')
        end
    end
end