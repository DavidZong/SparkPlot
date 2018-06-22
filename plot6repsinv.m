file = '180215_cascade_invert_IPTG_timecourse.xlsx';
plate = getplatedata(file);

[ods, red, cfp, yfp] = deal(zeros(25, 9));
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

figure(1)
subplot(1, 3, 1)
plot(t, red(:, 1:3), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp(:, 1:3), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp(:, 1:3), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(2)
subplot(1, 3, 1)
plot(t, red(:, 4:6), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp(:, 4:6), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp(:, 4:6), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(3)
subplot(1, 3, 1)
plot(t, red(:, 7:9), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp(:, 7:9), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp(:, 7:9), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(4)
ax1 = subplot(1,3,1);
plot(t, ods(:, 1:3), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])
ax2 = subplot(1,3,2);
plot(t, ods(:, 4:6), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])
ax3 = subplot(1,3,3);
plot(t, ods(:, 7:9), 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])

linkaxes([ax1,ax2,ax3],'xy')