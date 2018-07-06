% This function takes a single or several timecourse data for OD, fluorescence, or both for
% normalized fluoresence and generates one plot.

% od: the OD, is required if normalize is true
% fluor: the fluoresence, also required if normalize is true
% tspace: the time in minutes that the timepoints are spaced apart
% normalize: if this is true, the program will force normalization

function plot_timecourse(od, fluor, tspace, normalize)
% normalize fluorescence to OD if normalize is true
ntime = length(od(:,1));
if normalize
    nfluor = fluor ./ od;
    fluoresence_label = 'Fluoresence / OD600 (au)';
elseif any(fluor)
    nfluor = fluor;
    fluoresence_label = 'Fluoresence (au)';
    ntime = length(nfluor(:,1)); % since od might be empty in this case
end


% calculate the x axis
t = (0:(ntime-1)) * tspace;
t = t';
% calculate the number of ticks to display and the interval
if mod(t(end), 6) == 0
    tickspace = t(end) / 6;
elseif mod(t(end), 4) == 0
    tickspace = t(end) / 4;
end

% plot fluorescence or OD, depending on var. 
if any(fluor)
    plot(t, nfluor, 'Linewidth', 2);
    xlabel('Time (min)')
    ylabel(fluoresence_label)
    xticks(0:tickspace:t(end))
    xlim([0, t(end)])
else
    plot(t, od, 'Linewidth', 2);
    xlabel('Time (min)')
    ylabel('OD600 (au)')
    xticks(0:tickspace:t(end))
    xlim([0, t(end)])
end

