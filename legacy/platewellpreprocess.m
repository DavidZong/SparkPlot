% does routine preprocessing on the well
% subtracts autofluoresence from well using white cell well
% requires the number of fluoresences it's looking for and the number of
% timepoints
% put a negative number or 0 for blank if the plate has no OD blank
% a fluoresence blank is mandatory, because unlike OD blank, it can change
% much more
function [od, fluor] = platewellpreprocess(plate, ntime, nvar, datawell, white, blank)
[od, fluor] = slice_OD_flu(plate, ntime, nvar, datawell);
[~, wfluor] = slice_OD_flu(plate, ntime, nvar, white);

% if the plate has no blank, we assume a blank of 0.1 which is typical for
% M9 media at 200 uL in the Tecan Spark
if blank < 1
    od_b = ones(size(od)) * 0.1;
else
    [od_b, ~] = slice_OD_flu(plate, ntime, nvar, blank);
end

od = od - od_b;
fluor = fluor - wfluor;
