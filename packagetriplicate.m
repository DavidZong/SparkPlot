function packagetriplicate(plate1, plate2, plate3, foldername)
mkdir(foldername)
for i=1:9
    [odall, redall, cfpall, yfpall] = get18traces(plate1, plate2, plate3, i, 10);
    filename = int2str(i);
    save(strcat(foldername,'/',filename,'.mat'), 'odall', 'redall', 'cfpall', 'yfpall');
end