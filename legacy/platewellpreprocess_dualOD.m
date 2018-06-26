% does routine preprocessing on the well
% subtracts autofluoresence from well using white cell well
% subtracts blank from OD
% assumes 2 OD measurments are made instead of one, OD600 and OD700
function [od1, od2, fluor] = platewellpreprocess_dualOD(plate, datawell, white, blank)
data = plate(:, datawell);
whitedata = plate(:, white);
blankdata = plate(:, blank);
od1 = data(1:25) -  blankdata(1:25); % assumes 25 timepoints
od2 = data(26:50) -  blankdata(26:50);
fluor = data(51:length(data));
wfluor = whitedata(51:length(whitedata));
fluor = fluor - wfluor;
fluor = reshape(fluor, [25, 3]); % again, assumes 25 timepoints

