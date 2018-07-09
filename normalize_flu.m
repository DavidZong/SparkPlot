% This function accepts input from extract_timecourse.m and normalizes the
% fluoresence data to the OD data

function nfluor = normalize_flu(od, fluor)
f_stacks = length(fluor(1, :, 1));
nfluor = zeros(size(fluor));
for i = 1:f_stacks
    nfluor(:, i, :) = squeeze(fluor(:, i, :)) ./ od; 
end