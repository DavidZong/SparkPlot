% This function converts numbers from the wellmap to a letter number format.

% Currently only supports 96 well plates

% input: array of well positions as integers, as generated by
% generateWellMap.m
% output: array of strings of the corresponding wells

% Ex: input 1, output "A1"
% Ex: input 37, output "D1"
% Ex: input [1, 2, 3], output ["A1", "A2", "A3"]
% This function is handy to make figure legends or just attatch a well
% number a sample.

function output = wells_to_letters(input)
letterlist = ["A", "B", "C", "D", "E", "F", "G", "H"];
for i = 1:length(input)
    if mod(input(i), 12) == 0
        col = 12;
        row = floor(input(i) / 12);
    else
        col = mod(input(i), 12);
        row = floor(input(i) / 12) + 1;
    end
    letter = letterlist(row);
    output(i) = strcat(letter, num2str(col));
end
