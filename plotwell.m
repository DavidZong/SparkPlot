datawell = 28;
white = 35;
blank = 36;
file = '180110_XYZ_timecourse_xylose.xlsx';
normalize = false;
[od, flu] = preprocesswell(file, datawell, white, blank);
t = 0:10:230;
flu = flu ./ od;

if normalize
    red = flu(:,1) / max(flu(:,1));
    cfp = flu(:,2) / max(flu(:,2));
    yfp = flu(:,3) / max(flu(:,3));
else
    red = flu(:,1);
    cfp = flu(:,2);
    yfp = flu(:,3);
end

hold on
r = plot(t, red);
c = plot(t, cfp);
y = plot(t, yfp);

box on

set(r, 'LineWidth', 2, 'Color', [255, 51, 51]./255)
set(c, 'LineWidth', 2, 'Color', [0, 204, 204]./255)
set(y, 'LineWidth', 2, 'Color', [204, 204, 0]./255)

legend('mCherry', 'sfCFP', 'sfYFP', 'Location', 'northwest')

xlabel('Time (min)')
ylabel('Normalized Fluorescence / OD (au)')


xticks(0:40:240)