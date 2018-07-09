% This function takes in a time slice and an induction series to make an
% induction curve

% Inputs:
% xrange: a vector of the x points to be used
% fluor: a vector of the fluoresence data, use extract_timecourse to get
% timepoint: an int for which timepoint to use when plotting, or an array
% of ints if multiple timepoints are desired on the same plot

% Optional:
% xlog: a boolean flag, will make a log plot if true, defaults to true
% normalize: normalize to the OD, will do if true % TODO: decide if this is
% needed

function plot_induction(xrange, fluor, timepoint, xlog)
% sanitize xrange for 0 and negative numbers if log is true
if xlog
    if any(xrange == 0)
        % find a suitable replacement in log space for 0
        % basically just go down 1 order of magnitude from the lowest nonzero value
        new_zero = min(xrange(xrange>0)) / 10;
        xrange(xrange == 0) = new_zero;
    end
    if any(xrange(xrange < 0))
        % negative numbers aren't allowed
        error('negative numbers not allowed if log is set to true')
    end
end

% slice fluor to timepoint
f_slice = fluor(timepoint, :);

% plot
if xlog
    semilogx(xrange, f_slice, 'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'b', 'Linewidth', 2);
    xlim([xrange(1), xrange(end)*10])
else
    plot(xrange, f_slice, 'Marker', 'o', 'MarkerSize', 3, 'MarkerFaceColor', 'b', 'Linewidth', 2);
end