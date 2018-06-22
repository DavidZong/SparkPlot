% Given an excel file from the Spark and well, extract one well's data
% assumes 25 time points
% assumes OD, mCh, CFP, YFP reads in that order
% returns od and fluorescence
function [od, fluor] = getwelldata(file, well)
well_index = well * 2; %data is on even numbered columns
num = xlsread(file, 'Result sheet');
data_idx = ~isnan(num(:, 1));
wells = num(data_idx, :);
well_data = wells(:, well_index);
od = well_data(1:25); %24 can be changed to whatever number of steps
fluor = reshape(well_data((26:length(well_data))), [25, 3]); %change 3 to 