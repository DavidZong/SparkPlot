% File I/O
% Add filepath to all data
addpath('C:\Users\david\Dropbox\Rice\Bennett Lab\Data\Consortia Networks\Plate Reader')
file = '180623_YFP_const_timecourse_MS.xlsx';
plate = getplatedata(file);

[ods,red,cfp,yfp] = deal(zeros(25, 9));
for i = 1:9
    column = i;
    wcolumn = 10;
    [means, sd, mins, maxs] = get6stats_dualOD(plate, column, wcolumn, 0);
    ods(:, i) = means(:, 1);
    red(:, i) = means(:, 2);
    cfp(:, i) = means(:, 3);
    yfp(:, i) = means(:, 4);
end

t = 0:10:240;
co = redblue(9);
co(5,:) = 0.75*ones(1,3);
figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
% legend('X', 'X no A', 'X2', 'X2 no A', 'XY', 'XY no A', 'X2Y', 'X2Y no A', 'W', 'Location', 'northwest')
legend('1', '2', '3', '4', '5', '6', '7', '8', '9', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
% legend('10/90', '20/80', '30/70', '40/60', '50/50', '60/40', '70/30', '80/20', '90/10', 'Location', 'northwest')
xlabel('Time (min)')
% ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
% legend('10/90', '20/80', '30/70', '40/60', '50/50', '60/40', '70/30', '80/20', '90/10', 'Location', 'northwest')
xlabel('Time (min)')
% ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
set(findall(gcf,'-property','FontSize'),'FontSize',16)

figure(3)
plot(t, ods, 'Linewidth', 2)
legend('X', 'X no A', 'X2', 'X2 no A', 'XY', 'XY no A', 'X2Y', 'X2Y no A', 'W', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])