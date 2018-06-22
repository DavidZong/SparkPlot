white = 48;
blank = 9;
file = '180206_XYZ_variant_IPTG_screen_timecourse.xlsx';

ods = zeros(25, 6);
red = zeros(25, 6);
cfp = zeros(25, 6);
yfp = zeros(25, 6);
for i = 1:6
    datawell = [30, 37, 44, 32, 39, 46]+1;
    [od, flu] = preprocesswell(file, datawell(i), white, blank);
    flu = flu ./ od;
    ods(:, i) = od;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
t = 0:10:240;

figure(1)
subplot(1, 3, 1)
plot(t, red, 'Linewidth', 2)
legend('+aTc R1', '+aTc R2', '+aTc R3', '-aTc R1', '-aTc R2', '-aTc R3', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('mCherry Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 2)
plot(t, cfp, 'Linewidth', 2)
legend('+aTc R1', '+aTc R2', '+aTc R3', '-aTc R1', '-aTc R2', '-aTc R3', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
subplot(1, 3, 3)
plot(t, yfp, 'Linewidth', 2)
legend('+aTc R1', '+aTc R2', '+aTc R3', '-aTc R1', '-aTc R2', '-aTc R3', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

figure(3)
plot(t, ods, 'Linewidth', 2)
legend('+aTc R1', '+aTc R2', '+aTc R3', '-aTc R1', '-aTc R2', '-aTc R3', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD600 (au)')
xticks(0:40:240)
xlim([0, 240])