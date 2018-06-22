white = 24;
blank = 18;
file = '180118_XYiZ_xylose_timecourse.xlsx';

ods = zeros(24, 6);
red = zeros(24, 6);
cfp = zeros(24, 6);
yfp = zeros(24, 6);
for i = 1:6
    datawell = 3:4:23;
    [od, flu] = preprocesswell(file, datawell(i), white, blank);
    flu = flu ./ od;
    ods(:, i) = od;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
t = 0:10:230;

figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('0 mM', '0.0005 mM', '0.005 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('0 mM', '0.0005 mM', '0.005 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northeast')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('0 mM', '0.0005 mM', '0.005 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(3)
plot(t, ods, 'Linewidth', 2)
legend('0 mM', '0.0005 mM', '0.005 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])