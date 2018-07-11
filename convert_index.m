% This function takes in wells that are MATLAB cell array objects. The
% indexing for MATLAB cell arrays are different than the wellMap.m indexing
% that the Spark uses. This converts between the 2 standards

% Inputs:
% wells: a vector of integers of wells that need to be converted
% rows: number of rows in the plate
% cols: number of columns in the plate
% direction: a string that is either 'Spark' or 'Matlab' indicating whether
% you want to convert to Spark or Matlab indexing respectivly

function out = convert_index(wells, rows, cols, direction)
sparkmap = generateWellMap(rows, cols);
matlabmap = reshape(1:(rows * cols), [rows, cols]);
if strcmp(direction, 'Matlab')
    map = sparkmap;
elseif strcmp(direction, 'Spark')
    map = matlabmap;
else
    error('must indicate either "Spark" or "Matlab" for conversion')
end

% generate logical matrix by looping
locations = zeros(rows, cols);
for i = 1:length(wells)
    locations = locations + (map == wells(i));
end

% get the conversion
if strcmp(direction, 'Matlab')
    out = matlabmap(logical(locations));
elseif strcmp(direction, 'Spark')
    out = sparkmap(logical(locations));
end