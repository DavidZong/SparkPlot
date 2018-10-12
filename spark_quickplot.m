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
files = {'DZ_OD600_YFP_12h_timecourse_20181010-induction2.xlsx'};

datapath = '/Users/meidi/Desktop/rice/bennettlab/plate reader data';
experiment = 'IPTG-induction-well.xlsx';

experimentpath = '/Users/meidi/Desktop/rice/bennettlab/plate reader data';

[metadata, ~] = experiment_reader(experimentpath, experiment);

nexperiments = length(metadata.experiments);
nreps = length(metadata.replicate_wells(1,:));

% display some useful information to the user:
disp(['There are ' num2str(nexperiments) ' unique experiments on each plate.'])
disp(['Each experiment is repeated ' num2str(nreps) ' times.'])

% optional flags
normalize = 0;
subtractBL = 1;
subtractBG = 1;
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

for m = 1:12
    ave_od_group(:,m) = mean(od(:,6*m-5:6*m),2);
    ave_flu_group(:,m) = mean(fluor_current(:,6*m-5:6*m),2); 
end

figure(3)
subplot(2,1,1)
plot_timecourse(ave_od_group(:,1:6), 0, metadata.tspace, 0)
legend('2%','1%','0.4%','0.08%','0.016%','0%','Location','northwest')
title('induced')
subplot(2,1,2)
plot_timecourse(ave_od_group(:,1:6), ave_flu_group(:,1:6), metadata.tspace, normalize)
legend('2%','1%','0.4%','0.08%','0.016%','0%','Location','northwest')

ave_od_induced = [ave_od_group(:,1:3) ave_od_group(:,7:9)];
ave_flu_induced = [ave_flu_group(:,1:3) ave_flu_group(:,7:9)];
ave_od_uninduced = [ave_od_group(:,4:6) ave_od_group(:,10:12)];
ave_flu_uninduced = [ave_flu_group(:,4:6) ave_flu_group(:,10:12)];

figure(3)
subplot(2,1,1)
p1 = plot(0:10:720, ave_od_induced)
hold on 
p2 = plot(0:10:720,ave_od_uninduced,'k','Linewidth',0.5)
hold off
legend({'0.05-tag','0.005-tag','0.0025-tag','0.05-notag',...
    '0.005-notag','0.0025-notag'},'Location','northwest')
title('tag/notag induced')
subplot(2,1,2)
plot_timecourse(ave_od_induced, ave_flu_induced, metadata.tspace, normalize)
hold on
plot(0:10:720,ave_flu_uninduced./ave_od_uninduced,'k','Linewidth',0.5)
legend({'0.05-tag','0.005-tag','0.0025-tag','0.05-notag',...
    '0.005-notag','0.0025-notag'},'Location','northwest')

figure(4)
subplot(2,1,1)
plot_timecourse(ave_od_uninduced, 0, metadata.tspace, 0)
legend({'0.05-tag','0.005-tag','0.0025-tag','0.05-notag',...
    '0.005-notag','0.0025-notag'},'Location','northwest')
title('tag/notag un-induced')
subplot(2,1,2)
plot_timecourse(ave_od_uninduced, ave_flu_uninduced, metadata.tspace, normalize)
legend({'0.05-tag','0.005-tag','0.0025-tag','0.05-notag',...
    '0.005-notag','0.0025-notag'},'Location','northwest')

figure
plot_timecourse(ave_od_group, ave_flu_group, metadata.tspace, normalize)


figure(10)
for i = 1:12
    


plot(0:10:720,ave_od_group(:,1:3:10),'k')
hold on
plot(0:10:720,ave_od_group(:,2:3:11),'b')
plot(0:10:720,ave_od_group(:,3:3:12),'r')

figure(4)
subplot(2,1,1)
plot_timecourse(od(:,1:18), fluor_current(:,1:18), metadata.tspace, normalize)

subplot(2,1,2)
plot_timecourse(od(:,1:18), 0, metadata.tspace, 0)




% select_pairs = [3,4;5,6;7,8];
% for i =1:3
%     select = select_pairs(i, :);
%     figure
%     select_od_3d = all_avg_od(:, select, :);
%     dims = size(select_od_3d);
%     select_od = reshape(select_od_3d, [dims(1), dims(2)*dims(3)]);
%     plot_timecourse(select_od, 0, metadata.tspace, 0)
%     legend('induced day 1', 'uninduced day 1', 'induced day 2', 'uninduced day 2', 'induced day 3', 'uninduced day 3', 'Location', 'northwest')
%     figure
%     for var = 1:(metadata.nvar - 1)
%         subplot(3, 1, var)
%         current_fluor_3d = squeeze(all_avg_flu(:, select, var, :));
%         current_fluor = reshape(current_fluor_3d, [dims(1), dims(2)*dims(3)]);
%         plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
%         legend('induced day 1', 'uninduced day 1', 'induced day 2', 'uninduced day 2', 'induced day 3', 'uninduced day 3', 'Location', 'northwest')
%     end
% end
% 
% select = [1, 9, 11];
% figure
% select_od_3d = all_avg_od(:, select, :);
% dims = size(select_od_3d);
% select_od = reshape(select_od_3d, [dims(1), dims(2)*dims(3)]);
% plot_timecourse(select_od, 0, metadata.tspace, 0)
% legend('cascade day 1', 'IFFL day 1', 'Fanout day 1', 'cascade day 2', 'IFFL day 2', 'Fanout day 2','cascade day 3', 'IFFL day 3', 'Fanout day 3', 'Location', 'northwest')
% figure
% for var = 1:(metadata.nvar - 1)
%     subplot(3, 1, var)
%     current_fluor_3d = squeeze(all_avg_flu(:, select, var, :));
%     current_fluor = reshape(current_fluor_3d, [dims(1), dims(2)*dims(3)]);
%     plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
%     legend('cascade day 1', 'IFFL day 1', 'Fanout day 1', 'cascade day 2', 'IFFL day 2', 'Fanout day 2','cascade day 3', 'IFFL day 3', 'Fanout day 3', 'Location', 'northwest')
% end
% 
% all_avg_od = mean(all_avg_od, 3);
% all_avg_flu= mean(all_avg_flu, 4);
% 
% select_pairs = [3,4;5,6;7,8];
% for i =1:3
%     select = select_pairs(i, :);
%     figure
%     od_triplicate = squeeze(all_avg_od());
%     select_od = od_triplicate(:, select);
%     plot_timecourse(select_od, 0, metadata.tspace, 0)
%     legend('induced', 'uninduced', 'Location', 'northwest')
%     figure
%     for var = 1:(metadata.nvar - 1)
%         subplot(3, 1, var)
%         current_fluor = squeeze(all_avg_flu(:, select, var, :));
%         plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
%         legend('induced', 'uninduced', 'Location', 'northwest')
%     end
% end
% 
% select = [9, 11];
% figure
% od_triplicate = squeeze(all_avg_od());
% select_od = od_triplicate(:, select);
% plot_timecourse(select_od, 0, metadata.tspace, 0)
% legend('cascade', 'IFFL', 'Fanout','Location', 'northwest')
% figure
% for var = 1:(metadata.nvar - 1)
%     subplot(3, 1, var)
%     current_fluor = squeeze(all_avg_flu(:, select, var, :));
%     plot_timecourse(select_od, current_fluor, metadata.tspace, 0)
%     legend('cascade', 'IFFL', 'Fanout','Location', 'northwest')
% end