% does routine preprocessing on the well
% subtracts autofluoresence from well using white cell well
function [od, fluor] = platewellpreprocess(plate, datawell, white, blank)
data = plate(:, datawell);
whitedata = plate(:, white);
blankdata = plate(:, blank);
od = data(1:25) -  blankdata(1:25); % assumes 25 timepoints
fluor = data(26:length(data));
wfluor = whitedata(26:length(whitedata));
fluor = fluor - wfluor;
fluor = reshape(fluor, [25, 3]); % again, assumes 25 timepoints

