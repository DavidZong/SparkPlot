white = 8;
blank = 9;
file = '180110_XYZ_timecourse_xylose.xlsx';

red = zeros(24, 4);
cfp = zeros(24, 4);
yfp = zeros(24, 4);
for i = 1:4
    datawell = 5:9:33;
    [od, flu] = preprocesswell(file, datawell(i), white, blank);
    flu = flu ./ od;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
t = 0:10:230;

subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('0 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('0 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('0 mM', '0.05 mM', '0.5 mM', '5 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])