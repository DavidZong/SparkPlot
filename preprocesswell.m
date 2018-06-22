% does routine preprocessing on the well
% subtracts blank well od from the od
% subtracts autofluoresence from well using white cell well
function [od, fluor] = preprocesswell(file, datawell, white, blank)
[od, fluor] = getwelldata(file, datawell);
[~, wfluor] = getwelldata(file, white);
[bod, ~] = getwelldata(file, blank);
fluor = fluor - wfluor;
%od = od - bod;
