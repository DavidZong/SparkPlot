% This function performs basic file IO and returns the plate as an
% unformatted matrix file

% This operation seems to take a while so it's best not to loop this
% operation. Open the files needed for the session and keep it as a MATLAB
% matrix and things should go faster.

% If the datapath is invalid then it will ask you for a valid one
function plate = spark_timecourse_IO(datapath, file)
% File I/O, query user if datapath is left blank or invalid
while exist(datapath, 'file') ~= 7
    prompt = 'Enter path to .xlsx files (include single quotes '') > ';
    datapath = input(prompt) % do not supress with ; since this is user input
    if exist(datapath, 'file') ~= 7
        disp('Invalid path, enter new path')
    end
end
addpath(datapath)
plate = getplatedata(file);
