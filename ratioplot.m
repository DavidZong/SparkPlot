file = '180406_XYZ_IPTG_timecourse.xlsx';
plate = getplatedata(file);

[ods,red,cfp,yfp] = deal(zeros(25, 9));
for i = 1:9
    column = i;
    wcolumn = 10;
    [means, sd, mins, maxs] = get6stats(plate, column, wcolumn);
    ods(:, i) = means(:, 1);
    red(:, i) = means(:, 2);
    cfp(:, i) = means(:, 3);
    yfp(:, i) = means(:, 4);
end

t = 0:10:240;
co = parula(9);
figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('10/90', '20/80', '30/70', '40/60', '50/50', '60/40', '70/30', '80/20', '90/10', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('10/90', '20/80', '30/70', '40/60', '50/50', '60/40', '70/30', '80/20', '90/10', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('10/90', '20/80', '30/70', '40/60', '50/50', '60/40', '70/30', '80/20', '90/10', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
set(groot,'defaultAxesColorOrder',co)