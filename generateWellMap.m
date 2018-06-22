function map = generateWellMap(rows, cols)
map = reshape(1:(rows * cols), [cols, rows])';