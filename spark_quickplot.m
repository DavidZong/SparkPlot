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
files = {'DZ_OD600_RCY_12h_timecourse_20181019_network1.xlsx'};

datapath = '/Users/meidi/Desktop/rice/bennettlab/plate reader data';
experiment = 'network-well1.xlsx';

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

% induced/uninduced for tag-untag
ave_od_induced = [ave_od_group(:,1:3) ave_od_group(:,7:9)];
ave_flu_induced = [ave_flu_group(:,1:3) ave_flu_group(:,7:9)];
ave_od_uninduced = [ave_od_group(:,4:6) ave_od_group(:,10:12)];
ave_flu_uninduced = [ave_flu_group(:,4:6) ave_flu_group(:,10:12)];

figure(3)
subplot(2,1,1)
plot_timecourse(ave_od_group(:,1:6), 0, metadata.tspace, 0)
legend('2%','1%','0.4%','0.08%','0.016%','0%','Location','northwest')
title('induced')
subplot(2,1,2)
plot_timecourse(ave_od_group(:,1:6), ave_flu_group(:,1:6), metadata.tspace, normalize)
legend('2%','1%','0.4%','0.08%','0.016%','0%','Location','northwest')


figure(10)
p1 =  plot(0:10:720,ave_od_induced,'r')
hold on
p2 = plot(0:10:720,ave_od_uninduced,'k')
legend([p1(1) p2(1)],{'induced','uninduced'},'Location','northwest')
xlabel('time')
axis([0 720 0 0.8])
ylabel('OD600')
title('growth curve of induced/uninduced')

% visualize replicates
figure,
for i = 1:6
    subplot(2,3,i)
    plot_timecourse(od(:,i+24), 0, metadata.tspace, normalize)
end

test_flu = ave_flu_induced(1:40,1);
test_od = ave_od_induced(1:40,1);


N0         = 0.002;
lambda_max = 0.016;
L          = 300;
r          = 5;
alpha      = 3000;
q          = 0.5;
Vmax       = 4;
K          = 1;

allpars(1) = N0 ;
allpars(2) = lambda_max;
allpars(3) = L;
allpars(4) = r;
allpars(5) = alpha;
allpars(6) = q;
allpars(7) = Vmax;
allpars(8) = K;


% define the parameters want to fit
% example: L and r
prior = [allpars(3),allpars(4)];
t = 390;
likeli_sigma = 100;
randpars = [300,5;100,10];
accept_prob = 0.5;
chainlength = 10000;

testpost = metrosampler(test,t,prior,allpars,likeli_sigma,randpars,accept_prob,chainlength)









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