function [means, sd, mins, maxs] = get18stats(file1, file2, file3, column, wcolumn)
wellmap = generateWellMap(8, 12);
datawells = wellmap(2:7, column + 1); 
whitewells = wellmap(2:7, wcolumn + 1);
[ods, red, cfp, yfp] = deal(zeros(25, 18));

for i = 1:6
    [od, flu] = platewellpreprocess(file1, datawells(i), whitewells(i));
    flu = flu ./ od;
    id = i;
    ods(:, id) = od;
    red(:, i) = flu(:, 1);
    cfp(:, i) = flu(:, 2);
    yfp(:, i) = flu(:, 3);
end
for i = 1:6
    [od, flu] = platewellpreprocess(file2, datawells(i), whitewells(i));
    flu = flu ./ od;
    id = 7:12;
    ods(:, id(i)) = od;
    red(:, id(i)) = flu(:, 1);
    cfp(:, id(i)) = flu(:, 2);
    yfp(:, id(i)) = flu(:, 3);
end
for i = 1:6
    [od, flu] = platewellpreprocess(file3, datawells(i), whitewells(i));
    flu = flu ./ od;
    id = 13:18;
    ods(:, id(i)) = od;
    red(:, id(i)) = flu(:, 1);
    cfp(:, id(i)) = flu(:, 2);
    yfp(:, id(i)) = flu(:, 3);
end
means = [mean(ods, 2), mean(red, 2), mean(cfp, 2), mean(yfp, 2)];
sd = [std(ods, 0, 2), std(red, 0, 2), std(cfp, 0, 2), std(yfp, 0, 2)];
mins = [min(ods, [], 2), min(red, [], 2), min(cfp, [], 2), min(yfp, [], 2)];
maxs = [max(ods, [], 2), max(red, [], 2), max(cfp, [], 2), max(yfp, [], 2)];