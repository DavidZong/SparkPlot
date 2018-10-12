% does routine preprocessing on the well
% subtracts autofluoresence from well using white cell well
% requires the number of fluoresences it's looking for and the number of
% timepoints

% put a negative number or 0 for blank if the plate has no OD blank
% a fluoresence blank is mandatory, because unlike OD blank, it can change
% much more

% subtractBL and subtractBG are boolean flags. if these are true, then the 
% blank and background fluorescence will be subtracted from the OD and the
% fluorescent channels respectively

% avgblank and avgwhite are boolean flags. if these are true then the white
% and blank wells indicated by white and blank will be averaged and the average
% will be subtracted OD and the fluorescences respectively

function [od, fluor] = platewellpreprocess(plate, ntime, nvar, datawell, white, blank, subtractBL, subtractBG, avgblank, avgwhite)
[od, fluor] = slice_OD_flu(plate, ntime, nvar, datawell);
[~, wfluor] = slice_OD_flu(plate, ntime, nvar, white);

% if the plate has no blank, we assume a blank of 0.1 which is typical for
% M9 media at 200 uL in the Tecan Spark
if blank < 1
    od_b = ones(size(od)) * 0.1;
else
    [od_b, ~] = slice_OD_flu(plate, ntime, nvar, blank);
end

if subtractBL
    if avgblank
        od_b = ones(size(od_b)) .* mean(od_b, 2);
    end
    od = od - od_b;
    od = max(0.0025,od);
end

if subtractBG
    if avgwhite
        wfluor = ones(size(wfluor)) .* mean(wfluor, 2);
    end
    fluor = fluor-wfluor;
    fluor = max(0,fluor);

end
