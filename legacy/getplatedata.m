% gets all of the data out of the file, doesn't assume anything about the
% data, just gets the data out
% will not extract temperature or time metadata from the sheet, just OD and
% fluorescence data
function wells = getplatedata(file)
num = xlsread(file, 'Result sheet');
data_idx = ~isnan(num(:, 1));
wells = num(data_idx, 2:2:length(num(1, :)));