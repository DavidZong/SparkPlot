file = '180221_Y_variants_timecourse.xlsx';
plate = getplatedata(file);

[ods,cfp] = deal(zeros(25, 8));
idx = 1;
for j = [5, 10]
    for i = 1:4
        column = i;
        if j == 10
            column = i + 5;
        end
        wcolumn = j;
        [means, sd, mins, maxs] = get6stats(plate, column, wcolumn);
        ods(:, idx) = means(:, 1);
        cfp(:, idx) = means(:, 3);
        idx = idx + 1;
    end
end

t = 0:10:240;

figure(1)
ax1=subplot(1, 4, 1);
plot(t, cfp(:, [1, 5]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax2=subplot(1, 4, 2);
plot(t, cfp(:, [2, 6]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax3=subplot(1, 4, 3);
plot(t, cfp(:, [3, 7]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax4=subplot(1, 4, 4);
plot(t, cfp(:, [4, 8]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('sfCFP Fluorescence / OD (au)')
xticks(0:40:240)
xlim([0, 240])
linkaxes([ax1,ax2,ax3,ax4],'xy')

figure(2)
ax1=subplot(1, 4, 1);
plot(t, ods(:, [1, 5]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax2=subplot(1, 4, 2);
plot(t, ods(:, [2, 6]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax3=subplot(1, 4, 3);
plot(t, ods(:, [3, 7]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD (au)')
xticks(0:40:240)
xlim([0, 240])
ax4=subplot(1, 4, 4);
plot(t, ods(:, [4, 8]), 'Linewidth', 2)
legend('0 uM', '10 uM', 'Location', 'northwest')
xlabel('Time (min)')
ylabel('OD (au)')
xticks(0:40:240)
xlim([0, 240])

linkaxes([ax1,ax2,ax3,ax4],'xy')