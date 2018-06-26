% get the well's data, data variable will vary in size based on how many
% timepoints and the number of variables that were collected
function [od, fluor] = slice_OD_flu(plate, ntime, nvar, datawell)
data = zeros(ntime, nvar);
for i = 1:nvar
    % disp([ntime, datawell]) % for debugging
    data(:, i) = plate(((i-1)*ntime) + (1:ntime), datawell);
end
od = data(:, 1);
fluor = data(:, 2:end);