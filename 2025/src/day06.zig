const std = @import("std");
const parseInt = std.fmt.parseInt;

const DATA = @embedFile("inputs/day06.txt");

pub fn Solution() !void {
    try Solution1();
    try Solution2();
}

fn Solution1() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, "\n");

    var numbers: [5][1000]usize = undefined;
    var numbers_len: usize = 0;
    var num_per_lin: usize = 0;

    var ops: [1000]u8 = undefined;

    while (lines.next()) |line| {
        if (line[0] == '+' or line[0] == '*') {
            var ops_it = std.mem.tokenizeAny(u8, line, " ");
            while (ops_it.next()) |op| {
                ops[num_per_lin] = op[0];
                num_per_lin += 1;
            }
            break;
        }

        var nums = std.mem.tokenizeAny(u8, line, " ");

        var num_per_line: usize = 0;
        while (nums.next()) |num_str| {
            numbers[numbers_len][num_per_line] = try std.fmt.parseInt(usize, num_str, 10);
            num_per_line += 1;
        }

        numbers_len += 1;
    }

    var results: [1000]usize = undefined;
    @memset(&results, 0);

    for (0..num_per_lin) |i| {
        switch (ops[i]) {
            '+' => {
                for (0..numbers_len) |j| results[i] += numbers[j][i];
            },
            '*' => {
                for (0..numbers_len) |j| {
                    if (results[i] == 0) results[i] = 1;
                    results[i] *= numbers[j][i];
                }
            },

            else => unreachable,
        }
    }

    var total: usize = 0;
    for (0..num_per_lin) |i| {
        total += results[i];
    }

    std.debug.print("Day 6 - Solution 1: {d}\n", .{total});
}

fn Solution2() !void {
    var lines = std.mem.tokenizeAny(u8, DATA, "\n");

    var numbers: [5][1000][4]isize = undefined;
    var numbers_len: usize = 0;

    var ops: [1000]u8 = undefined;
    var ops_len: usize = 0;

    var column_spacing: [1000]usize = undefined;
    @memset(&column_spacing, 0);

    var i: usize = 0;
    while (lines.next()) |line| : (i += 1) {
        if (line[0] == '+' or line[0] == '*') {
            var ops_it = std.mem.tokenizeAny(u8, line, " ");
            var spaces = std.mem.tokenizeAny(u8, line, "+*");

            while (ops_it.next()) |op| : (ops_len += 1) {
                ops[ops_len] = op[0];
                column_spacing[ops_len] = spaces.next().?.len;
            }

            column_spacing[ops_len - 1] += 1;

            numbers_len = i;
        }
    }

    lines.reset();

    i = 0;

    while (lines.next()) |line| : (i += 1) {
        if (line[0] == '+' or line[0] == '*') break;
        var str_idx: usize = 0;
        for (column_spacing, 0..) |spacing, j| {
            @memset(&numbers[i][j], -1);
            for (str_idx..str_idx + spacing, 0..) |k, k2| {
                numbers[i][j][k2] = if (line[k] == ' ') -1 else line[k] - '0';
            }

            str_idx += spacing + 1;
        }
    }

    var results: [1000]usize = undefined;
    @memset(&results, 0);

    for (0..ops_len) |j| {
        for (0..4) |k| {
            var num: usize = 0;
            for (0..numbers_len) |i_1| {
                if (numbers[i_1][j][k] == -1) continue;
                num *= 10;
                num += @intCast(numbers[i_1][j][k]);
            }

            if (num == 0) continue;

            switch (ops[j]) {
                '+' => results[j] += num,
                '*' => {
                    if (results[j] == 0) results[j] = 1;
                    results[j] *= num;
                },

                else => unreachable,
            }
        }
    }

    var total: usize = 0;
    for (0..ops_len) |j| {
        total += results[j];
    }

    std.debug.print("Day 6 - Solution 2: {d}\n", .{total});
}
