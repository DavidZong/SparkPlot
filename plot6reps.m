file = '180214_cascade_invert_IPTG_timecourse.xlsx';
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

figure(3)
plot(t, ods, 'Linewidth', 2)
%legend('0.1 mM', '1 mM', '10 mM', '0.1 mM + xyl', '1 mM + xyl', '10 mM + xyl', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])