file = '180429_Y_Yi_C14_timecourse.xlsx';
plate = getplatedata(file);

[ods,red,cfp,yfp,cfpsd] = deal(zeros(25, 9));
for i = 1:9
    column = i;
    wcolumn = 10;
    [means, sd, mins, maxs] = get3stats_dualOD(plate, column, wcolumn, 0, 1);
    ods(:, i) = means(:, 1);
    red(:, i) = means(:, 2);
    cfp(:, i) = means(:, 3);
    yfp(:, i) = means(:, 4);
    
    cfpsd(:, i) = sd(:, 3);
end

t = 0:10:240;
co = parula(9);
figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('0', '10^-2', '10^-4/3', '10^-1', '10^-2/3', '10^-1/3', '10^0', '10^1/3', '10^1', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('0', '10^-2', '10^-4/3', '10^-1', '10^-2/3', '10^-1/3', '10^0', '10^1/3', '10^1', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('0', '10^-2', '10^-4/3', '10^-1', '10^-2/3', '10^-1/3', '10^0', '10^1/3', '10^1', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)

% plot(t, cfp, 'Linewidth', 2)
% legend('0', '10^-2', '10^-4/3', '10^-1', '10^-2/3', '10^-1/3', '10^0', '10^1/3', '10^1', 'Location', 'northwest')
% xlabel('Time (min)')
% ylabel('sfCFP Fluorescence / OD (au)')
% xticks(0:40:240)
% xlim([0, 240])

% slice at time x and make an induction plot
fluor = cfp;
time = 13;
figure(2)
xval = [1e-3, 1e-2, 10^(-4/3), 1e-1, 10^-(2/3), 10^-(1/3), 1e0, 10^(1/3), 1e1]; %1e-3 is acutally 0
yval = fluor(time, :);
err = cfpsd(time, :);
errorbar(xval, yval, err, 'o', 'Linewidth', 2)
axis = gca;
set(axis, 'XScale', 'log')
xlabel('[C14] (uM)')
ylabel('sfCFP Fluorescence / OD (au)')


figure(3)
plot(t, ods, 'Linewidth', 2)
legend('0', '10^-2', '10^-4/3', '10^-1', '10^-2/3', '10^-1/3', '10^0', '10^1/3', '10^1', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])