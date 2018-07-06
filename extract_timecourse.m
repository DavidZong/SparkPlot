% This function takes in a file and extracts out the timecourse data of a
% single well, returning it as a vector of ODs and a vector/matrix of
% fluoresence depending on if there is more than one fluoresence. Has
% multiple options for how the data is to be preprocessed:

% Required arguments:
% plate: an unformatted plate matrix output by spark_timecourse_IO.m
% nvar: number of different things measured, it is assumed that all are
% measured at all time points
% ntime: number of timepoints
% datawell: the well to plot, enter an array for multiple
% white: the white well, enter an array for multiple


% Optional Arguments:
% blank: the blank well if there isn't one then it defaults to 0.1
% var (optional): which variable to plot, as an integer. 1 for OD, 2 onwards for the
% various fluorescences. can be a vector if multiple fluorescences are
% desired, but the y-axis might get weird. defaults to OD var=1 if left
% unset
function [od, fluor] = extract_timecourse(plate, nvar, ntime, datawell, white, varargin)
narginchk(5, 10)
switch nargin
    case 5
        blank = zeros(size(datawell));
        [subtractBL, subtractBG, avgblank, avgwhite] = deal(1);
    case 6
        blank = varargin{1};
        [subtractBL, subtractBG, avgblank, avgwhite] = deal(1);
    case 7
        blank = varargin{1};
        subtractBL = varargin{2};
        [subtractBG, avgblank, avgwhite] = deal(1);
    case 8
        blank = varargin{1};
        subtractBL = varargin{2};
        subtractBG = varargin{3};
        [avgblank, avgwhite] = deal(1);
    case 9
        blank = varargin{1};
        subtractBL = varargin{2};
        subtractBG = varargin{3};
        avgblank = varargin{4};
        avgwhite = 1;
    case 10
        blank = varargin{1};
        subtractBL = varargin{2};
        subtractBG = varargin{3};
        avgblank = varargin{4};
        avgwhite = varargin{5};
end


% process the well, subtract background OD, and white cells from
% fluoresence, then normalize the fluorescence to the OD
nwells = length(datawell);
od = zeros(ntime, nwells);
fluor = zeros(ntime, nwells);
for i = 1:nwells
    [od(:, i), fluor(:, i)] = platewellpreprocess(plate, ntime, nvar, datawell(i), white(i), blank(i), subtractBL, subtractBG, avgblank, avgwhite);
end


