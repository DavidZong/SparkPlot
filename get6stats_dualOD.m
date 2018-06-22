function [means, sd, mins, maxs] = get6stats_dualOD(file, column, wcolumn, use700)
wellmap = generateWellMap(8, 12);
datawells = wellmap(2:7, column + 1); 
whitewells = wellmap(2:7, wcolumn + 1);
blankwells = wellmap(2:7, wcolumn + 2);
ods = zeros(25, 6);
red = zeros(25, 6);
cfp = zeros(25, 6);
yfp = zeros(25, 6);
for i = 1:6
    [od1, od2, flu] = platewellpreprocess_dualOD(file, datawells(i), whitewells(i), blankwells(i));
    if use700
        od = od1;
    else
        od = od2;
    end
    flu = flu ./ od;
    ods(:, i) = od1;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
means = [mean(ods, 2), mean(red, 2), mean(cfp, 2), mean(yfp, 2)];
sd = [std(ods, 0, 2), std(red, 0, 2), std(cfp, 0, 2), std(yfp, 0, 2)];
mins = [min(ods, [], 2), min(red, [], 2), min(cfp, [], 2), min(yfp, [], 2)];
maxs = [max(ods, [], 2), max(red, [], 2), max(cfp, [], 2), max(yfp, [], 2)];