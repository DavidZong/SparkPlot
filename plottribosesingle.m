white = 34;
blank = 9;
file = '180131_IFFL1_ribose_xylose_subset_Yi_Zi_ribose_test.xlsx';

levels = 4;
[ods, red, cfp, yfp] = deal(zeros(25, levels));

for i = 1:levels
    datawell = [7,8,12,13];
    [od, flu] = preprocesswell(file, datawell(i), white, blank);
    flu = flu ./ od;
    ods(:, i) = od;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
t = 0:10:240;

figure(1)
plot(t, yfp, 'Linewidth', 2)
legend('0 mM', '0.1 mM', '1 mM', '10 mM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfYFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])

