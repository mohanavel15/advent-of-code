const std = @import("std");
const parseInt = std.fmt.parseInt;

pub fn Solution() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        switch (gpa.deinit()) {
            .leak => std.log.err("Memory Leak!", .{}),
            .ok => {},
        }
    }

    var allocator = gpa.allocator();

    const content = try std.fs.cwd().readFileAlloc(allocator, "inputs/day04.txt", std.math.maxInt(u16));
    defer allocator.free(content);


    var values = std.ArrayList(u8).init(allocator);
    defer values.deinit();

    var mat_len: usize = 0;

    var rows = std.mem.tokenizeAny(u8, content, "\n");
    while (rows.next()) |row| {
        try values.appendSlice(row);
        mat_len += 1;
    }

    var xmasCount: usize = 0;
    var XShapeMasCount: usize = 0;

    for (0..mat_len) |row| {
        for (0..mat_len) |col| {
            xmasCount += findXmas(values.items, mat_len, row, col);
            if (findXShapeMas(values.items, mat_len, row, col)) {
                XShapeMasCount += 1;
            }
        }
    }

    std.log.info("Solution 1: XMAS Count: {}", .{xmasCount});
    std.log.info("Solution 2: X Shape MAS Count: {}", .{XShapeMasCount});
}

// Part 1:
fn findXmas(values: []u8, mat_len: usize, row: usize, col: usize) usize {
    const idx = midx(mat_len, row, col);
    var xmasCount: usize = 0;

    if (values[idx] != 'X') {
        return xmasCount;
    }

    if (col + 4 <= mat_len and checkForward(values, idx)) {
        xmasCount += 1;
    }

    if (col >= 3 and checkBackword(values, idx)) {
        xmasCount += 1;
    }

    if (row >= 3 and checkVertUp(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    if (row + 4 <= mat_len and checkVertDown(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    if (row + 4 <= mat_len and col + 4 <= mat_len and rightDiagonalDown(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    if (row + 4 <= mat_len and col >= 3 and leftDiagonalDown(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    if (row >= 3 and col + 4 <= mat_len and rightDiagonalUp(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    if (row >= 3 and col >= 3 and leftDiagonalUp(values, mat_len, row, col)) {
        xmasCount += 1;
    }

    return xmasCount;
}

// Part 2
fn findXShapeMas(values: []u8, mat_len: usize, row: usize, col: usize) bool {
    const idx = midx(mat_len, row, col);

    if (values[idx] != 'A') {
        return false;
    }

    var word_1 = [_]u8{ 0, 'A', 0 };
    var word_2 = [_]u8{ 0, 'A', 0 };

    if ((row >= 1 and col >= 1) and (row + 1 < mat_len and col + 1 < mat_len)) {
        word_1[0] = values[midx(mat_len, row - 1, col - 1)];
        word_1[2] = values[midx(mat_len, row + 1, col + 1)];
    }

    if ((row + 1 < mat_len and col >= 1) and (row >= 1 and col + 1 < mat_len)) {
        word_2[0] = values[midx(mat_len, row + 1, col - 1)];
        word_2[2] = values[midx(mat_len, row - 1, col + 1)];
    }

    const word_1_check = (std.mem.eql(u8, &word_1, "MAS") or std.mem.eql(u8, &word_1, "SAM"));
    const word_2_check = (std.mem.eql(u8, &word_2, "MAS") or std.mem.eql(u8, &word_2, "SAM"));

    return (word_1_check and word_2_check);
}

fn midx(cols: usize, row: usize, col: usize) usize {
    return (row * cols) + col;
}

fn checkForward(values: []u8, idx: usize) bool {
    return std.mem.eql(u8, values[idx .. idx + 4], "XMAS");
}

fn checkBackword(values: []u8, idx: usize) bool {
    return std.mem.eql(u8, values[idx - 3 .. idx + 1], "SAMX");
}

fn checkVertUp(values: []u8, mat_len: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(mat_len, row - i, col)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}

fn checkVertDown(values: []u8, mat_len: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(mat_len, row + i, col)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}

fn rightDiagonalDown(values: []u8, mat_len: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(mat_len, row + i, col + i)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}

fn leftDiagonalDown(values: []u8, mat_len: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(mat_len, row + i, col - i)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}

fn rightDiagonalUp(values: []u8, cols: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(cols, row - i, col + i)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}

fn leftDiagonalUp(values: []u8, cols: usize, row: usize, col: usize) bool {
    var word = [_]u8{ 0, 0, 0, 0 };
    for (0..4) |i| {
        word[i] = values[midx(cols, row - i, col - i)];
    }
    return std.mem.eql(u8, &word, "XMAS");
}
