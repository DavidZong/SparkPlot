file1 = '180211_XYZ_IPTG_timecourse.xlsx';
file2 = '180210_XYZ_IPTG_timecourse.xlsx';
file3 = '180212_XYZ_IPTG_timecourse.xlsx';
plate1 = getplatedata(file1);
plate2 = getplatedata(file2);
plate3 = getplatedata(file3);

[ods, red, cfp, yfp, minred, mincfp, minyfp, maxred, maxcfp, maxyfp, sdod, sdred, sdcfp, sdyfp] = deal(zeros(25, 9));

for i = 1:9
    column = i;
    wcolumn = 10;
    [means, sd, mins, maxs] = get18stats(plate1, plate2, plate3, column, wcolumn);
    ods(:, i) = means(:, 1);
    red(:, i) = means(:, 2);
    cfp(:, i) = means(:, 3);
    yfp(:, i) = means(:, 4);
    

    minred(:, i) = mins(:, 2);
    mincfp(:, i) = mins(:, 3);
    minyfp(:, i) = mins(:, 4);
    

    maxred(:, i) = maxs(:, 2);
    maxcfp(:, i) = maxs(:, 3);
    maxyfp(:, i) = maxs(:, 4);
    
    sdod(:, i) = sd(:, 1);
    sdred(:, i) = sd(:, 2);
    sdcfp(:, i) = sd(:, 3);
    sdyfp(:, i) = sd(:, 4);
end

t = 0:10:240;

figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('0.1 mM', '0.2 mM', '0.3 mM', '0.4 mM', '0.5 mM', '0.6 mM', '0.7 mM', '0.8 mM', '0.9 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('0.1 mM', '0.2 mM', '0.3 mM', '0.4 mM', '0.5 mM', '0.6 mM', '0.7 mM', '0.8 mM', '0.9 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('0.1 mM', '0.2 mM', '0.3 mM', '0.4 mM', '0.5 mM', '0.6 mM', '0.7 mM', '0.8 mM', '0.9 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(2)
hold on
box on
plot(t, cfp(:, [1, 2, 9]), 'Linewidth', 2)
patch([t, fliplr(t)], [mincfp(:,1)', flipud(maxcfp(:,1))'], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [mincfp(:,2)', flipud(maxcfp(:,2))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [mincfp(:,9)', flipud(maxcfp(:,9))'], 'y', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
% plot(t, cfp(:, [1, 2, 9]), 'Linewidth', 2)
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
legend('0.1 mM', '0.2 mM', '0.9 mM', 'Location', 'northwest')
xticks(0:40:240)
xlim([0, 240])

redupper = red + sdred; 
redlower = red - sdred;
cfpupper = cfp + sdcfp; 
cfplower = cfp - sdcfp;
yfpupper = yfp + sdyfp; 
yfplower = yfp - sdyfp;
figure(3)
subplot(1, 3, 1)
hold on
box on
plot(t, red(:, [1, 9]), 'Linewidth', 2)
patch([t, fliplr(t)], [redlower(:,1)', flipud(redupper(:,1))'], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [redlower(:,9)', flipud(redupper(:,9))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
legend('0.1 mM', '0.9 mM', 'Location', 'northwest')
xticks(0:40:240)
xlim([0, 240])
hold off
subplot(1, 3, 2)
hold on
box on
plot(t, cfp(:, [1, 9]), 'Linewidth', 2)
patch([t, fliplr(t)], [cfplower(:,1)', flipud(cfpupper(:,1))'], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [cfplower(:,9)', flipud(cfpupper(:,9))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
legend('0.1 mM', '0.9 mM', 'Location', 'northwest')
xticks(0:40:240)
xlim([0, 240])
hold off
subplot(1, 3, 3)
hold on
box on
plot(t, yfp(:, [1, 9]), 'Linewidth', 2)
patch([t, fliplr(t)], [yfplower(:,1)', flipud(yfpupper(:,1))'], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [yfplower(:,9)', flipud(yfpupper(:,9))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('sfyFP Fluorescence / OD (au)')
legend('0.1 mM', '0.9 mM', 'Location', 'northwest')
xticks(0:40:240)
xlim([0, 240])
hold off

odlower = ods - sdod;
odupper = ods + sdod;
figure(4)
plot(t, ods(:, [1, 9]), 'Linewidth', 2)
patch([t, fliplr(t)], [odlower(:,1)', flipud(odupper(:,1))'], 'b', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
patch([t, fliplr(t)], [odlower(:,9)', flipud(odupper(:,9))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
legend('0.1 mM', '0.9 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])

figure(5)
column = 1; % change this to choose which column to use
[odall, redall, cfpall, yfpall] = get18traces(plate1, plate2, plate3, column, wcolumn);
lg = [220,220,220] ./ 255;
subplot(1, 3, 1)
hold on
box on
plot(t, redall, 'Color', lg, 'Linewidth', 0.5)
plot(t, red(:, column), 'Linewidth', 2)
patch([t, fliplr(t)], [redlower(:,column)', flipud(redupper(:,column))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
hold off
subplot(1, 3, 2)
hold on
box on
plot(t, cfpall, 'Color', lg, 'Linewidth', 0.5)
plot(t, cfp(:, column), 'Linewidth', 2)
patch([t, fliplr(t)], [cfplower(:,column)', flipud(cfpupper(:,column))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
hold off
subplot(1, 3, 3)
hold on
box on
plot(t, yfpall, 'Color', lg, 'Linewidth', 0.5)
plot(t, yfp(:, column), 'Linewidth', 2)
patch([t, fliplr(t)], [yfplower(:,column)', flipud(yfpupper(:,column))'], 'r', 'FaceAlpha', 0.1, 'EdgeColor', 'none')
xlabel('Time (min)')
ylabel('sfyFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
hold off